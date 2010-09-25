Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188Ab0IYXe5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 19:34:57 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:59272 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295Ab0IYXe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 19:34:56 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hugh@veritas.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>
References: <m1sk0x9z62.fsf@fess.ebiederm.org>
Date: Sat, 25 Sep 2010 16:34:51 -0700
In-Reply-To: <m1sk0x9z62.fsf@fess.ebiederm.org> (Eric W. Biederman's message
	of "Sat, 25 Sep 2010 16:33:09 -0700")
Message-ID: <m1d3s19z38.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [PATCH 3/3] mm: Cause revoke_mappings to wait until all close methods have completed.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 include/linux/fs.h |    2 ++
 mm/mmap.c          |   13 ++++++++++++-
 mm/revoke.c        |   18 +++++++++++++++---
 3 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 76041b6..5d3d6b8 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -633,6 +633,8 @@ struct address_space {
 	const struct address_space_operations *a_ops;	/* methods */
 	unsigned long		flags;		/* error bits/gfp mask */
 	struct backing_dev_info *backing_dev_info; /* device readahead, etc */
+	struct task_struct	*revoke_task;	/* Who to wake up when all vmas are closed */
+	unsigned int		close_count;	/* Cover race conditions with revoke_mappings */
 	spinlock_t		private_lock;	/* for use by the address_space */
 	struct list_head	private_list;	/* ditto */
 	struct address_space	*assoc_mapping;	/* ditto */
diff --git a/mm/mmap.c b/mm/mmap.c
index 17dd003..3df3193 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -218,6 +218,7 @@ void unlink_file_vma(struct vm_area_struct *vma)
 		struct address_space *mapping = file->f_mapping;
 		spin_lock(&mapping->i_mmap_lock);
 		__remove_shared_vm_struct(vma, file, mapping);
+		mapping->close_count++;
 		spin_unlock(&mapping->i_mmap_lock);
 	}
 }
@@ -233,9 +234,19 @@ static struct vm_area_struct *remove_vma(struct vm_area_struct *vma)
 	if (vma->vm_ops && vma->vm_ops->close)
 		vma->vm_ops->close(vma);
 	if (vma->vm_file) {
-		fput(vma->vm_file);
+		struct address_space *mapping = vma->vm_file->f_mapping;
 		if (vma->vm_flags & VM_EXECUTABLE)
 			removed_exe_file_vma(vma->vm_mm);
+
+		/* Decrement the close count and wake up a revoker if present */
+		spin_lock(&mapping->i_mmap_lock);
+		mapping->close_count--;
+		if ((mapping->close_count == 0) && mapping->revoke_task)
+			/* Is wake_up_process the right variant of try_to_wake_up? */
+			wake_up_process(mapping->revoke_task);
+		spin_unlock(&mapping->i_mmap_lock);
+
+		fput(vma->vm_file);
 	}
 	mpol_put(vma_policy(vma));
 	kmem_cache_free(vm_area_cachep, vma);
diff --git a/mm/revoke.c b/mm/revoke.c
index a76cd1a..e19f7df 100644
--- a/mm/revoke.c
+++ b/mm/revoke.c
@@ -143,15 +143,17 @@ void revoke_mappings(struct address_space *mapping)
 	/* Make any access to previously mapped pages trigger a SIGBUS,
 	 * and stop calling vm_ops methods.
 	 *
-	 * When revoke_mappings returns invocations of vm_ops->close
-	 * may still be in progress, but no invocations of any other
-	 * vm_ops methods will be.
+	 * When revoke_mappings no invocations of any method will be
+	 * in progress.
 	 */
 	struct vm_area_struct *vma;
 	struct prio_tree_iter iter;
 
 	spin_lock(&mapping->i_mmap_lock);
 
+	WARN_ON(mapping->revoke_task);
+	mapping->revoke_task = current;
+
 restart_tree:
 	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, 0, ULONG_MAX) {
 		if (revoke_mapping(mapping, vma->vm_mm, vma->vm_start))
@@ -164,6 +166,16 @@ restart_list:
 			goto restart_list;
 	}
 
+	while (!list_empty(&mapping->i_mmap_nonlinear) ||
+	       !prio_tree_empty(&mapping->i_mmap) ||
+	       mapping->close_count)
+	{
+		__set_current_state(TASK_UNINTERRUPTIBLE);
+		spin_unlock(&mapping->i_mmap_lock);
+		schedule();
+		spin_lock(&mapping->i_mmap_lock);
+	}
+	mapping->revoke_task = NULL;
 	spin_unlock(&mapping->i_mmap_lock);
 }
 EXPORT_SYMBOL_GPL(revoke_mappings);
-- 
1.7.2.3


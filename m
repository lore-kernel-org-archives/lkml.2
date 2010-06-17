Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760076Ab0FQNxb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 09:53:31 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55817 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab0FQNxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 09:53:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=sSMiuUwIkKIvwsxbr9GXr6X+k4xYky6y22bWQdW9luYEoadCp+qQc2pUNnIPVPWH6D
         BOjjM8r9WEh2/LlMPGthed10gXYnS/QPMCtwf1SpiOuW4NbcfQGZ0Ie3/yDa2yrJnhKz
         bryVSt0wz0W3/4GO7iLFFS6SZ+ja9FKeDv0IM=
Date: Thu, 17 Jun 2010 15:45:59 +0200
From: Dan Carpenter <error27@gmail.com>
To: Xiaotian Feng <dfeng@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Jack Steiner <steiner@sgi.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org
Subject: [patch] x86, pat: freeing invalid memtype messages
Message-ID: <20100617134559.GA29824@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Xiaotian Feng <dfeng@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
	Jack Steiner <steiner@sgi.com>,
	Suresh Siddha <suresh.b.siddha@intel.com>,
	Marcin Slusarz <marcin.slusarz@gmail.com>,
	linux-kernel@vger.kernel.org, x86@kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 20413f27163 "x86, pat: Fix memory leak in free_memtype" added an
error message in free_memtype() if rbt_memtype_erase() returns NULL.  
The problem is that if CONFIG_X86_PAT is enabled, we use a different
implimentation of rbt_memtype_erase() that always returns NULL.

I've modified rbt_memtype_erase() to return an ERR_PTR() on errors and 
made free_memtype() check for that instead.

Addresses:  https://bugzilla.kernel.org/show_bug.cgi?id=16205

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index acc15b2..81b7735 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -359,10 +359,10 @@ int free_memtype(u64 start, u64 end)
 	entry = rbt_memtype_erase(start, end);
 	spin_unlock(&memtype_lock);
 
-	if (!entry) {
+	if (IS_ERR(entry)) {
 		printk(KERN_INFO "%s:%d freeing invalid memtype %Lx-%Lx\n",
 			current->comm, current->pid, start, end);
-		return -EINVAL;
+		return PTR_ERR(entry);
 	}
 
 	kfree(entry);
diff --git a/arch/x86/mm/pat_rbtree.c b/arch/x86/mm/pat_rbtree.c
index f537087..90e5cbe 100644
--- a/arch/x86/mm/pat_rbtree.c
+++ b/arch/x86/mm/pat_rbtree.c
@@ -236,8 +236,10 @@ struct memtype *rbt_memtype_erase(u64 start, u64 end)
 	struct memtype *data;
 
 	data = memtype_rb_exact_match(&memtype_rbroot, start, end);
-	if (!data)
+	if (!data) {
+		data = ERR_PTR(-EINVAL);
 		goto out;
+	}
 
 	rb_erase(&data->rb, &memtype_rbroot);
 out:



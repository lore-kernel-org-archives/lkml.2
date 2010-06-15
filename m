Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185Ab0FORrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 13:47:21 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:21044 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758182Ab0FORrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 13:47:20 -0400
Subject: [PATCH] mempolicy:  fix dangling reference to tmpfs superblock mpol
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: Dan Carpenter <error27@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       David Rientjes <rientjes@google.com>,
       Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain
Organization: HP/LKTT
Date: Tue, 15 Jun 2010 13:47:17 -0400
Message-Id: <1276624037.5044.47.camel@useless.americas.hpqcorp.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Against 2.6.35-rc1+

My patch to "Factor out duplicate put/frees in mpol_shared_policy_init()
to a common return path"; and Dan Carpenter's fix thereto both left a
dangling reference to the incoming tmpfs superblock mempolicy structure.
A similar leak was introduced earlier when the nodemask was moved offstack
to the scratch area despite the note in the comment block regarding the
incoming ref.

Move the remaining 'put of the incoming "mpol" to the common exit path to
drop the reference.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>

 mm/mempolicy.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

Index: linux-2.6.35-rc2-mmotm-100611-1640/mm/mempolicy.c
===================================================================
--- linux-2.6.35-rc2-mmotm-100611-1640.orig/mm/mempolicy.c
+++ linux-2.6.35-rc2-mmotm-100611-1640/mm/mempolicy.c
@@ -2138,7 +2138,7 @@ void mpol_shared_policy_init(struct shar
 		NODEMASK_SCRATCH(scratch);
 
 		if (!scratch)
-			return;
+			goto put_mpol;
 		/* contextualize the tmpfs mount point mempolicy */
 		new = mpol_new(mpol->mode, mpol->flags, &mpol->w.user_nodemask);
 		if (IS_ERR(new))
@@ -2147,19 +2147,20 @@ void mpol_shared_policy_init(struct shar
 		task_lock(current);
 		ret = mpol_set_nodemask(new, &mpol->w.user_nodemask, scratch);
 		task_unlock(current);
-		mpol_put(mpol);	/* drop our ref on sb mpol */
 		if (ret)
-			goto put_free;
+			goto put_new;
 
 		/* Create pseudo-vma that contains just the policy */
 		memset(&pvma, 0, sizeof(struct vm_area_struct));
 		pvma.vm_end = TASK_SIZE;	/* policy covers entire file */
 		mpol_set_shared_policy(sp, &pvma, new); /* adds ref */
 
-put_free:
+put_new:
 		mpol_put(new);			/* drop initial ref */
 free_scratch:
 		NODEMASK_SCRATCH_FREE(scratch);
+put_mpol:
+		mpol_put(mpol);	/* drop our incoming ref on sb mpol */
 	}
 }
 



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760624Ab0FKWBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 18:01:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:52663 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307Ab0FKWBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 18:01:19 -0400
Date: Fri, 11 Jun 2010 22:00:45 GMT
From: tip-bot for Venkatesh Pallipadi <venki@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com,
       casteyde.christian@free.fr, venki@google.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com,
       casteyde.christian@free.fr, venki@google.com
In-Reply-To: <1276217101-11515-1-git-send-email-venki@google.com>
References: <1276217101-11515-1-git-send-email-venki@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, pat: Proper init of memtype subtree_max_end
Message-ID: <tip-6a4f3b523779b67e7d560ed42652f8a59f2f9782@git.kernel.org>
Git-Commit-ID: 6a4f3b523779b67e7d560ed42652f8a59f2f9782
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 11 Jun 2010 22:00:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6a4f3b523779b67e7d560ed42652f8a59f2f9782
Gitweb:     http://git.kernel.org/tip/6a4f3b523779b67e7d560ed42652f8a59f2f9782
Author:     Venkatesh Pallipadi <venki@google.com>
AuthorDate: Thu, 10 Jun 2010 17:45:01 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 11 Jun 2010 14:12:22 -0700

x86, pat: Proper init of memtype subtree_max_end

subtree_max_end that was recently added to struct memtype was not getting
properly initialized resulting in

WARNING: kmemcheck: Caught 64-bit read from uninitialized memory
in memtype_rb_augment_cb()
reported here
https://bugzilla.kernel.org/show_bug.cgi?id=16092

This change fixes the problem.

Reported-by: Christian Casteyde <casteyde.christian@free.fr>
Tested-by: Christian Casteyde <casteyde.christian@free.fr>
Signed-off-by: Venkatesh Pallipadi <venki@google.com>
LKML-Reference: <1276217101-11515-1-git-send-email-venki@google.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/mm/pat.c        |    2 +-
 arch/x86/mm/pat_rbtree.c |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index acc15b2..64121a1 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -302,7 +302,7 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 		return -EINVAL;
 	}
 
-	new  = kmalloc(sizeof(struct memtype), GFP_KERNEL);
+	new  = kzalloc(sizeof(struct memtype), GFP_KERNEL);
 	if (!new)
 		return -ENOMEM;
 
diff --git a/arch/x86/mm/pat_rbtree.c b/arch/x86/mm/pat_rbtree.c
index f537087..f20eeec 100644
--- a/arch/x86/mm/pat_rbtree.c
+++ b/arch/x86/mm/pat_rbtree.c
@@ -226,6 +226,7 @@ int rbt_memtype_check_insert(struct memtype *new, unsigned long *ret_type)
 		if (ret_type)
 			new->type = *ret_type;
 
+		new->subtree_max_end = new->end;
 		memtype_rb_insert(&memtype_rbroot, new);
 	}
 	return err;

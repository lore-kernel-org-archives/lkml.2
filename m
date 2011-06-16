Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203Ab1FPHc7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:32:59 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:44621 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752813Ab1FPHBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:01:23 -0400
X-Sasl-enc: GgegLdH2FeQcZhElznJndhb+s8YrNpA9rNIsP//KNuH6 1308207681
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:35 2011
Message-Id: <20110616000235.278552337@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:00:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        John Johansen <john.johansen@canonical.com>,
        James Morris <jmorris@namei.org>
Subject: [64/89] AppArmor: Fix sleep in invalid context from task_setrlimit
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: John Johansen <john.johansen@canonical.com>

commit 1780f2d3839a0d3eb85ee014a708f9e2c8f8ba0e upstream.

Affected kernels 2.6.36 - 3.0

AppArmor may do a GFP_KERNEL memory allocation with task_lock(tsk->group_leader);
held when called from security_task_setrlimit.  This will only occur when the
task's current policy has been replaced, and the task's creds have not been
updated before entering the LSM security_task_setrlimit() hook.

BUG: sleeping function called from invalid context at mm/slub.c:847
 in_atomic(): 1, irqs_disabled(): 0, pid: 1583, name: cupsd
 2 locks held by cupsd/1583:
  #0:  (tasklist_lock){.+.+.+}, at: [<ffffffff8104dafa>] do_prlimit+0x61/0x189
  #1:  (&(&p->alloc_lock)->rlock){+.+.+.}, at: [<ffffffff8104db2d>]
do_prlimit+0x94/0x189
 Pid: 1583, comm: cupsd Not tainted 3.0.0-rc2-git1 #7
 Call Trace:
  [<ffffffff8102ebf2>] __might_sleep+0x10d/0x112
  [<ffffffff810e6f46>] slab_pre_alloc_hook.isra.49+0x2d/0x33
  [<ffffffff810e7bc4>] kmem_cache_alloc+0x22/0x132
  [<ffffffff8105b6e6>] prepare_creds+0x35/0xe4
  [<ffffffff811c0675>] aa_replace_current_profile+0x35/0xb2
  [<ffffffff811c4d2d>] aa_current_profile+0x45/0x4c
  [<ffffffff811c4d4d>] apparmor_task_setrlimit+0x19/0x3a
  [<ffffffff811beaa5>] security_task_setrlimit+0x11/0x13
  [<ffffffff8104db6b>] do_prlimit+0xd2/0x189
  [<ffffffff8104dea9>] sys_setrlimit+0x3b/0x48
  [<ffffffff814062bb>] system_call_fastpath+0x16/0x1b

Signed-off-by: John Johansen <john.johansen@canonical.com>
Reported-by: Miles Lane <miles.lane@gmail.com>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 security/apparmor/lsm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -612,7 +612,7 @@ static int apparmor_setprocattr(struct t
 static int apparmor_task_setrlimit(struct task_struct *task,
 		unsigned int resource, struct rlimit *new_rlim)
 {
-	struct aa_profile *profile = aa_current_profile();
+	struct aa_profile *profile = __aa_current_profile();
 	int error = 0;
 
 	if (!unconfined(profile))



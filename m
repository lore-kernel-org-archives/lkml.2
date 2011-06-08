Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab1FHWH7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 18:07:59 -0400
Received: from adelie.canonical.com ([91.189.90.139]:46204 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab1FHWH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 18:07:56 -0400
Message-ID: <4DEFF2B3.7080202@canonical.com>
Date: Wed, 08 Jun 2011 15:07:47 -0700
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Thunderbird/3.1.10
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        stable@kernel.org,
        "jmorris@namei.org >> James Morris" <jmorris@namei.org>
Subject: Re: 3.0.0-rc2-git1 -- BUG: sleeping function called from invalid
 context at mm/slub.c:847
References: <BANLkTimq+h+WyboMbPGVH1uJuj64YuRLdw@mail.gmail.com> <alpine.DEB.2.00.1106081305430.10320@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1106081305430.10320@chino.kir.corp.google.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2011 01:09 PM, David Rientjes wrote:
> On Wed, 8 Jun 2011, Miles Lane wrote:
> 
>> BUG: sleeping function called from invalid context at mm/slub.c:847
>>  in_atomic(): 1, irqs_disabled(): 0, pid: 1583, name: cupsd
>>  2 locks held by cupsd/1583:
>>   #0:  (tasklist_lock){.+.+.+}, at: [<ffffffff8104dafa>] do_prlimit+0x61/0x189
>>   #1:  (&(&p->alloc_lock)->rlock){+.+.+.}, at: [<ffffffff8104db2d>]
>> do_prlimit+0x94/0x189
>>  Pid: 1583, comm: cupsd Not tainted 3.0.0-rc2-git1 #7
>>  Call Trace:
>>   [<ffffffff8102ebf2>] __might_sleep+0x10d/0x112
>>   [<ffffffff810e6f46>] slab_pre_alloc_hook.isra.49+0x2d/0x33
>>   [<ffffffff810e7bc4>] kmem_cache_alloc+0x22/0x132
>>   [<ffffffff8105b6e6>] prepare_creds+0x35/0xe4
>>   [<ffffffff811c0675>] aa_replace_current_profile+0x35/0xb2
>>   [<ffffffff811c4d2d>] aa_current_profile+0x45/0x4c
>>   [<ffffffff811c4d4d>] apparmor_task_setrlimit+0x19/0x3a
>>   [<ffffffff811beaa5>] security_task_setrlimit+0x11/0x13
>>   [<ffffffff8104db6b>] do_prlimit+0xd2/0x189
>>   [<ffffffff8104dea9>] sys_setrlimit+0x3b/0x48
>>   [<ffffffff814062bb>] system_call_fastpath+0x16/0x1b
>>
> 
> Not sure why this ever actually worked with apparmor if prepare_creds() 
> does an unconditional GFP_KERNEL allocation since this codepath hasn't 
> changed in at least a year and we're holding a spinlock from setrlimit.  
> John?

Hrmm, I am assuming it was missed because the profile replacement that
causes the prepare_creds() to be called is a rare condition when apparmor
is in use.  It will only occur when policy has been replaced and only if
the task doing the task_setrlimit() hasn't already updated its cred else
where.  It is clearly wrong, patch included below.

---

>From 99710968923ddc1f89029d98b2eb7d45b11323dc Mon Sep 17 00:00:00 2001
From: John Johansen <john.johansen@canonical.com>
Date: Wed, 8 Jun 2011 15:03:58 -0700
Subject: [PATCH] AppArmor: Fix sleep in invalid context from task_setrlimit

Affected kernels 2.6.36 - 3.0

AppArmor may do a GFP_KERNEL memory allocation with task_lock(tsk->group_leader);
held when called from security_task_setrlimit.  This will only occur when the
task's current policy has been replaced, and the task's creds have not been
updated before entering the LSM security_task_setrlimit() hook.

As reported by Miles Lane

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
---
 security/apparmor/lsm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index ec1bcec..3d2fd14 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -612,7 +612,7 @@ static int apparmor_setprocattr(struct task_struct *task, char *name,
 static int apparmor_task_setrlimit(struct task_struct *task,
                unsigned int resource, struct rlimit *new_rlim)
 {
-       struct aa_profile *profile = aa_current_profile();
+       struct aa_profile *profile = __aa_current_profile();
        int error = 0;
 
        if (!unconfined(profile))
-- 
1.7.4.1


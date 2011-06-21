Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab1FULos (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 07:44:48 -0400
Received: from adelie.canonical.com ([91.189.90.139]:58618 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab1FULoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 07:44:46 -0400
Message-ID: <4E00841F.6000202@canonical.com>
Date: Tue, 21 Jun 2011 04:44:31 -0700
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Thunderbird/3.1.10
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        hch@infradead.org, Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH 7/7] ptrace: s/tracehook_tracer_task()/ptrace_parent()/
References: <1308322240-8247-1-git-send-email-tj@kernel.org> <1308322240-8247-8-git-send-email-tj@kernel.org> <20110620201603.GA17157@redhat.com>
In-Reply-To: <20110620201603.GA17157@redhat.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2011 01:16 PM, Oleg Nesterov wrote:
> On 06/17, Tejun Heo wrote:
>>
>> tracehook.h is on the way out.  Rename tracehook_tracer_task() to
>> ptrace_parent() and move it from tracehook.h to ptrace.h.
> 
> I am a bit surpised you decided to keep this helper. Can't we simply
> kill it?
> 
> OK, we will see. I guess this change is mostly needed to remove yet
> another function from tracehook.h.
> 
>> @@ -216,7 +216,7 @@ static struct mm_struct *__check_mem_permission(struct task_struct *task)
>>  	if (task_is_stopped_or_traced(task)) {
>>  		int match;
>>  		rcu_read_lock();
>> -		match = (tracehook_tracer_task(task) == current);
>> +		match = (ptrace_parent(task) == current);
>>  		rcu_read_unlock();
>>  		if (match && ptrace_may_access(task, PTRACE_MODE_ATTACH))
> 
> All we need
> 
> 	if (task_is_traced(task) && task->parent == current) {
> 		if (ptrace_may_access()
> 			return mm;
> 	}
> 
> Of course I do not blame this patch, my only point is that this helper
> only adds more confusion imho.
> 
> 
> 
> 
>> @@ -67,7 +67,7 @@ static int may_change_ptraced_domain(struct task_struct *task,
>>  	int error = 0;
>>
>>  	rcu_read_lock();
>> -	tracer = tracehook_tracer_task(task);
>> +	tracer = ptrace_parent(task);
>>  	if (tracer) {
>>  		/* released below */
>>  		cred = get_task_cred(tracer);
> 
> Hmm. And then this task_struct is used after we dropped rcu_read_lock().
> 
> John, is this correct?
> 
nope this use is wrong.  The following patch should fix this

===

AppArmor: Fix reference to rcu protected pointer outside of rcu_read_lock

The pointer returned from tracehook_tracer_task() is only valid inside
the rcu_read_lock.  However the tracer pointer obtained is being passed
to aa_may_ptrace outside of the rcu_read_lock critical section.

Mover the aa_may_ptrace test into the rcu_read_lock critical section, to
fix this.

Signed-off-by: John Johansen <john.johansen@canonical.com>
---
 security/apparmor/domain.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/security/apparmor/domain.c b/security/apparmor/domain.c
index c825c6e..78adc43 100644
--- a/security/apparmor/domain.c
+++ b/security/apparmor/domain.c
@@ -73,7 +73,6 @@ static int may_change_ptraced_domain(struct task_struct *task,
 		cred = get_task_cred(tracer);
 		tracerp = aa_cred_profile(cred);
 	}
-	rcu_read_unlock();
 
 	/* not ptraced */
 	if (!tracer || unconfined(tracerp))
@@ -82,6 +81,7 @@ static int may_change_ptraced_domain(struct task_struct *task,
 	error = aa_may_ptrace(tracer, tracerp, to_profile, PTRACE_MODE_ATTACH);
 
 out:
+	rcu_read_unlock();
 	if (cred)
 		put_cred(cred);
 
-- 
1.7.4.1



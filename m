Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab2FSCja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 22:39:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:4912 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752009Ab2FSCj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 22:39:28 -0400
X-IronPort-AV: E=Sophos;i="4.77,434,1336320000"; 
   d="scan'208";a="5219863"
Message-ID: <4FDFE4B1.80500@cn.fujitsu.com>
Date: Tue, 19 Jun 2012 10:32:17 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: Fujitsu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Serge Hallyn <serge.hallyn@canonical.com>
CC: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dvhart@linux.intel.com, a.p.zijlstra@chello.nl, jkosina@suse.cz,
        ebiederm@xmission.com, dhowells@redhat.com, keescook@chromium.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/locking] futex: Do not leak robust list to unprivileged
 process
References: <20120319231253.GA20893@www.outflux.net> <tip-bdbb776f882f5ad431aa1e694c69c1c3d6a4a5b8@git.kernel.org> <4FDFD8AF.6030209@cn.fujitsu.com> <20120619022456.GA2949@sergelap>
In-Reply-To: <20120619022456.GA2949@sergelap>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/19 10:34:15,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/19 10:34:41,
	Serialize complete at 2012/06/19 10:34:41
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2012 10:24 AM, Serge Hallyn wrote:
> Quoting Wanlong Gao (gaowanlong@cn.fujitsu.com):
>> On 03/29/2012 05:55 PM, tip-bot for Kees Cook wrote:
>>> Commit-ID:  bdbb776f882f5ad431aa1e694c69c1c3d6a4a5b8
>>> Gitweb:     http://git.kernel.org/tip/bdbb776f882f5ad431aa1e694c69c1c3d6a4a5b8
>>> Author:     Kees Cook <keescook@chromium.org>
>>> AuthorDate: Mon, 19 Mar 2012 16:12:53 -0700
>>> Committer:  Thomas Gleixner <tglx@linutronix.de>
>>> CommitDate: Thu, 29 Mar 2012 11:37:17 +0200
>>>
>>> futex: Do not leak robust list to unprivileged process
>>>
>>> It was possible to extract the robust list head address from a setuid
>>> process if it had used set_robust_list(), allowing an ASLR info leak. This
>>> changes the permission checks to be the same as those used for similar
>>> info that comes out of /proc.
>>>
>>> Running a setuid program that uses robust futexes would have had:
>>>   cred->euid != pcred->euid
>>>   cred->euid == pcred->uid
>>> so the old permissions check would allow it. I'm not aware of any setuid
>>> programs that use robust futexes, so this is just a preventative measure.
>>>
>>
>> I'm not sure this change prevents the unprivileged process.
>> Please refer to LTP test, recently I saw that this change broke
>> the following test.
>>
>> https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/syscalls/get_robust_list/get_robust_list01.c#L155
>> 		if (seteuid(1) == -1)
>> 			tst_brkm(TBROK|TERRNO, cleanup, "seteuid(1) failed");
>>
>> 		TEST(retval = syscall(__NR_get_robust_list, 1,
>> 				      (struct robust_list_head *)&head,
>> 				      &len_ptr));
>>
>> We set the euid to an unprivileged user, and expect to FAIL with EPERM,
>> without this patch, it FAIL as we expected, but with it, this call succeed.
> 
> This relates to a question I asked - I believe in this thread, maybe in
> another thread - about ptrace_may_access.  That code goes back further than
> our git history, and for so long has used current->uid and ->gid, not
> euid and gid, for permission checks.  I asked if that's what we really
> want, but at the same am not sure we want to change something that's
> been like that for so long.
> 
> But that's why it succeeded - you changed your euid, not your uid.

Yeah, I known what I'm doing. I just wonder which is the right thing.
Should we check euid or uid ? You mean that checking uid instead of
checking euid for a long time, right?

Thanks,
Wanlong Gao


> 
>> Seems that we leaked the check of (cred->euid == pcred->euid && cred->euid == pcred->uid),
>> I'm not sure which one is right, can you please give an explanation?
>>
>>
>> Thanks in advance,
>> Wanlong Gao
>>
>>> (This patch is based on changes from grsecurity.)
>>>
>>> Signed-off-by: Kees Cook <keescook@chromium.org>
>>> Cc: Darren Hart <dvhart@linux.intel.com>
>>> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
>>> Cc: Jiri Kosina <jkosina@suse.cz>
>>> Cc: Eric W. Biederman <ebiederm@xmission.com>
>>> Cc: David Howells <dhowells@redhat.com>
>>> Cc: Serge E. Hallyn <serge.hallyn@canonical.com>
>>> Cc: kernel-hardening@lists.openwall.com
>>> Cc: spender@grsecurity.net
>>> Link: http://lkml.kernel.org/r/20120319231253.GA20893@www.outflux.net
>>> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>>> ---
>>>  kernel/futex.c        |   36 +++++++++++++-----------------------
>>>  kernel/futex_compat.c |   36 +++++++++++++-----------------------
>>>  2 files changed, 26 insertions(+), 46 deletions(-)
>>>
>>> diff --git a/kernel/futex.c b/kernel/futex.c
>>> index 72efa1e..d701be5 100644
>>> --- a/kernel/futex.c
>>> +++ b/kernel/futex.c
>>> @@ -59,6 +59,7 @@
>>>  #include <linux/magic.h>
>>>  #include <linux/pid.h>
>>>  #include <linux/nsproxy.h>
>>> +#include <linux/ptrace.h>
>>>  
>>>  #include <asm/futex.h>
>>>  
>>> @@ -2443,40 +2444,29 @@ SYSCALL_DEFINE3(get_robust_list, int, pid,
>>>  {
>>>  	struct robust_list_head __user *head;
>>>  	unsigned long ret;
>>> -	const struct cred *cred = current_cred(), *pcred;
>>> +	struct task_struct *p;
>>>  
>>>  	if (!futex_cmpxchg_enabled)
>>>  		return -ENOSYS;
>>>  
>>> +	rcu_read_lock();
>>> +
>>> +	ret = -ESRCH;
>>>  	if (!pid)
>>> -		head = current->robust_list;
>>> +		p = current;
>>>  	else {
>>> -		struct task_struct *p;
>>> -
>>> -		ret = -ESRCH;
>>> -		rcu_read_lock();
>>>  		p = find_task_by_vpid(pid);
>>>  		if (!p)
>>>  			goto err_unlock;
>>> -		ret = -EPERM;
>>> -		pcred = __task_cred(p);
>>> -		/* If victim is in different user_ns, then uids are not
>>> -		   comparable, so we must have CAP_SYS_PTRACE */
>>> -		if (cred->user->user_ns != pcred->user->user_ns) {
>>> -			if (!ns_capable(pcred->user->user_ns, CAP_SYS_PTRACE))
>>> -				goto err_unlock;
>>> -			goto ok;
>>> -		}
>>> -		/* If victim is in same user_ns, then uids are comparable */
>>> -		if (cred->euid != pcred->euid &&
>>> -		    cred->euid != pcred->uid &&
>>> -		    !ns_capable(pcred->user->user_ns, CAP_SYS_PTRACE))
>>> -			goto err_unlock;
>>> -ok:
>>> -		head = p->robust_list;
>>> -		rcu_read_unlock();
>>>  	}
>>>  
>>> +	ret = -EPERM;
>>> +	if (!ptrace_may_access(p, PTRACE_MODE_READ))
>>> +		goto err_unlock;
>>> +
>>> +	head = p->robust_list;
>>> +	rcu_read_unlock();
>>> +
>>>  	if (put_user(sizeof(*head), len_ptr))
>>>  		return -EFAULT;
>>>  	return put_user(head, head_ptr);
>>> diff --git a/kernel/futex_compat.c b/kernel/futex_compat.c
>>> index 5f9e689..a9642d5 100644
>>> --- a/kernel/futex_compat.c
>>> +++ b/kernel/futex_compat.c
>>> @@ -10,6 +10,7 @@
>>>  #include <linux/compat.h>
>>>  #include <linux/nsproxy.h>
>>>  #include <linux/futex.h>
>>> +#include <linux/ptrace.h>
>>>  
>>>  #include <asm/uaccess.h>
>>>  
>>> @@ -136,40 +137,29 @@ compat_sys_get_robust_list(int pid, compat_uptr_t __user *head_ptr,
>>>  {
>>>  	struct compat_robust_list_head __user *head;
>>>  	unsigned long ret;
>>> -	const struct cred *cred = current_cred(), *pcred;
>>> +	struct task_struct *p;
>>>  
>>>  	if (!futex_cmpxchg_enabled)
>>>  		return -ENOSYS;
>>>  
>>> +	rcu_read_lock();
>>> +
>>> +	ret = -ESRCH;
>>>  	if (!pid)
>>> -		head = current->compat_robust_list;
>>> +		p = current;
>>>  	else {
>>> -		struct task_struct *p;
>>> -
>>> -		ret = -ESRCH;
>>> -		rcu_read_lock();
>>>  		p = find_task_by_vpid(pid);
>>>  		if (!p)
>>>  			goto err_unlock;
>>> -		ret = -EPERM;
>>> -		pcred = __task_cred(p);
>>> -		/* If victim is in different user_ns, then uids are not
>>> -		   comparable, so we must have CAP_SYS_PTRACE */
>>> -		if (cred->user->user_ns != pcred->user->user_ns) {
>>> -			if (!ns_capable(pcred->user->user_ns, CAP_SYS_PTRACE))
>>> -				goto err_unlock;
>>> -			goto ok;
>>> -		}
>>> -		/* If victim is in same user_ns, then uids are comparable */
>>> -		if (cred->euid != pcred->euid &&
>>> -		    cred->euid != pcred->uid &&
>>> -		    !ns_capable(pcred->user->user_ns, CAP_SYS_PTRACE))
>>> -			goto err_unlock;
>>> -ok:
>>> -		head = p->compat_robust_list;
>>> -		rcu_read_unlock();
>>>  	}
>>>  
>>> +	ret = -EPERM;
>>> +	if (!ptrace_may_access(p, PTRACE_MODE_READ))
>>> +		goto err_unlock;
>>> +
>>> +	head = p->compat_robust_list;
>>> +	rcu_read_unlock();
>>> +
>>>  	if (put_user(sizeof(*head), len_ptr))
>>>  		return -EFAULT;
>>>  	return put_user(ptr_to_compat(head), head_ptr);
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>
>>
>>
> 



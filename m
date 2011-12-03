Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456Ab1LCXBy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 18:01:54 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:49051 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650Ab1LCXBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 18:01:53 -0500
Message-ID: <4EDAAA4F.7060206@free.fr>
Date: Sun, 04 Dec 2011 00:01:35 +0100
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: akpm@linux-foundation.org, serge.hallyn@canonical.com,
        containers@lists.linux-foundation.org, gkurz@fr.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add reboot_pid_ns to handle the reboot syscall
References: <1322905364-29538-1-git-send-email-daniel.lezcano@free.fr> <20111203164950.GA32004@redhat.com>
In-Reply-To: <20111203164950.GA32004@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2011 05:49 PM, Oleg Nesterov wrote:
> On 12/03, Daniel Lezcano wrote:
>> This patch propose to store the reboot value in the 16 upper bits of the
>> exit code from the processes belonging to a pid namespace which has
>> rebooted. When the reboot syscall is called and we are not in the initial
>> pid namespace, we kill the pid namespace.
> OK, this is close to what we discussed before.
>
> But why does this patch uglify wait_task_zombie() ?

Right, see below :)

>> @@ -1192,6 +1192,7 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
>>  	pid_t pid = task_pid_vnr(p);
>>  	uid_t uid = __task_cred(p)->uid;
>>  	struct siginfo __user *infop;
>> +	struct pid_namespace *pid_ns = task_active_pid_ns(p);
>>
>>  	if (!likely(wo->wo_flags & WEXITED))
>>  		return 0;
>> @@ -1291,8 +1292,10 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
>>  		? getrusage(p, RUSAGE_BOTH, wo->wo_rusage) : 0;
>>  	status = (p->signal->flags & SIGNAL_GROUP_EXIT)
>>  		? p->signal->group_exit_code : p->exit_code;
>> -	if (!retval && wo->wo_stat)
>> +	if (!retval && wo->wo_stat) {
>> +		status |= (pid_ns->reboot & ~0xffff);
>>  		retval = put_user(status, wo->wo_stat);
>> +	}
> This doesn't cover WNOWAIT.
>
> But I think this change is not needed at all.
> Instead, can't you
> add something like
>
> 	if (pid_ns->reboot)
> 		current->signal->group_exit_code = pid_ns->reboot;
>
> into zap_pid_ns_processes() ? IIRC this was discussed too, I do
> not understand why do you think we should hack do_wait()...

Gah ! Right ! I puzzled myself, I will change that.

>> +int reboot_pid_ns(struct pid_namespace *pid_ns, int cmd)
>> +{
>> +	switch(cmd) {
>> +	case LINUX_REBOOT_CMD_RESTART2:
>> +	case LINUX_REBOOT_CMD_RESTART:
>> +		pid_ns->reboot = SYSTEM_RESTART << 16;
>> +		break;
>> +
>> +	case LINUX_REBOOT_CMD_HALT:
>> +		pid_ns->reboot = SYSTEM_HALT << 16;
>> +		break;
>> +
>> +	case LINUX_REBOOT_CMD_POWER_OFF:
>> +		pid_ns->reboot = SYSTEM_POWER_OFF << 16;
>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +
>> +	force_sig(SIGKILL, pid_ns->child_reaper);
> In theory this is racy. Nothing protects ->child_reaper if it is
> multi-threaded. read_lock(tasklist) should help.

Ok.

>> +
>> +	return 0;
>> +}
> I am not sure "return 0" is really correct. Perhaps HALT/POWER_OFF
> should do do_exit() like the the "normal" sys_reboot() does ?

Yes.

>>  static __init int pid_namespaces_init(void)
>>  {
>>  	pid_ns_cachep = KMEM_CACHE(pid_namespace, SLAB_PANIC);
>> diff --git a/kernel/sys.c b/kernel/sys.c
>> index ddf8155..02d9645 100644
>> --- a/kernel/sys.c
>> +++ b/kernel/sys.c
>> @@ -429,6 +429,7 @@ static DEFINE_MUTEX(reboot_mutex);
>>  SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
>>  		void __user *, arg)
>>  {
>> +	struct pid_namespace *pid_ns = current->nsproxy->pid_ns;
>>  	char buffer[256];
>>  	int ret = 0;
>>
>> @@ -450,6 +451,9 @@ SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
>>  	if ((cmd == LINUX_REBOOT_CMD_POWER_OFF) && !pm_power_off)
>>  		cmd = LINUX_REBOOT_CMD_HALT;
>>
>> +	if (pid_ns != &init_pid_ns)
>> +		return reboot_pid_ns(pid_ns, cmd);
> Cosmetic nit,
>
> 	if (task_active_pid_ns(current) != &init_pid_ns)
> 		return reboot_pid_ns(cmd);
>
> this way we do not need the new variable.
>
> Also. I do not know if this is important, but perhaps it makes
> sense to move this code up, before the !pm_power_off check which
> can transform POWER_OFF into HALT?

Yes.

Thanks Oleg for your comments and your help. I will send a new patch.

  -- Daniel

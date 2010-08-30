Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab0H3TvN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 15:51:13 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41630 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab0H3TvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 15:51:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=jWZBU7est91TlpIBq8kVNezwqjwyWLtFd1CEdMV0aDnYw0sKGDoVZVNsR6CHY9rstA
         TR5BtPu6u1ng5hia8M5eEoBr7QNQOgw/2nK1dvIuxP9H1FVjovTd1xuoUp47B4M2bWqD
         E6RvARbERKEfQhgTt04xcmVd/T2I2kyTVaY6w=
Message-ID: <4C7C0BAB.3000709@suse.cz>
Date: Mon, 30 Aug 2010 21:51:07 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, jmorris@namei.org,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH RFC] pid: make setpgid() system call use RCU read-side
 critical section
References: <20100830172631.GA11868@linux.vnet.ibm.com>
In-Reply-To: <20100830172631.GA11868@linux.vnet.ibm.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ccing Oleg.

On 08/30/2010 07:26 PM, Paul E. McKenney wrote:
> [   23.584720] ===================================================
> [   23.585059] [ INFO: suspicious rcu_dereference_check() usage. ]
> [   23.585176] ---------------------------------------------------
> [   23.585176] kernel/pid.c:419 invoked rcu_dereference_check() without protection!
> [   23.585176]
> [   23.585176] other info that might help us debug this:
> [   23.585176]
> [   23.585176]
> [   23.585176] rcu_scheduler_active = 1, debug_locks = 1
> [   23.585176] 1 lock held by rc.sysinit/728:
> [   23.585176]  #0:  (tasklist_lock){.+.+..}, at: [<ffffffff8104771f>] sys_setpgid+0x5f/0x193
> [   23.585176]
> [   23.585176] stack backtrace:
> [   23.585176] Pid: 728, comm: rc.sysinit Not tainted 2.6.36-rc2 #2
> [   23.585176] Call Trace:
> [   23.585176]  [<ffffffff8105b436>] lockdep_rcu_dereference+0x99/0xa2
> [   23.585176]  [<ffffffff8104c324>] find_task_by_pid_ns+0x50/0x6a
> [   23.585176]  [<ffffffff8104c35b>] find_task_by_vpid+0x1d/0x1f
> [   23.585176]  [<ffffffff81047727>] sys_setpgid+0x67/0x193
> [   23.585176]  [<ffffffff810029eb>] system_call_fastpath+0x16/0x1b
> [   24.959669] type=1400 audit(1282938522.956:4): avc:  denied  { module_request } for  pid=766 comm="hwclock" kmod="char-major-10-135" scontext=system_u:system_r:hwclock_t:s0 tcontext=system_u:system_r:kernel_t:s0 tclas
> 
> It turns out that the setpgid() system call fails to enter an RCU
> read-side critical section before doing a PID-to-task_struct translation.
> This commit therefore does rcu_read_lock() before the translation, and
> also does rcu_read_unlock() after the last use of the returned pointer.
> 
> Located-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
> 
>  sys.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/kernel/sys.c b/kernel/sys.c
> index e9ad444..05a4b0c 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -938,6 +938,7 @@ SYSCALL_DEFINE2(setpgid, pid_t, pid, pid_t, pgid)
>  	write_lock_irq(&tasklist_lock);
>  
>  	err = -ESRCH;
> +	rcu_read_lock();
>  	p = find_task_by_vpid(pid);

AFAICT the missing lock doesn't harm due to the write_lock of tasklist
above. But is probably a good thing to do anyway.

regards,
-- 
js
suse labs

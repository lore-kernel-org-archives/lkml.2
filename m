Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394Ab1G0OeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 10:34:20 -0400
Received: from mail-ey0-f171.google.com ([209.85.215.171]:54422 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564Ab1G0OeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 10:34:18 -0400
Message-ID: <4E3021E6.30409@gmail.com>
Date: Wed, 27 Jul 2011 16:34:14 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Darren Hart <dvhart@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: rt_mutex: restore wait_lock init in __rt_mutex_init
References: <1311754711-19577-1-git-send-email-dvhart@linux.intel.com> <alpine.LFD.2.02.1107271130280.2660@ionos>
In-Reply-To: <alpine.LFD.2.02.1107271130280.2660@ionos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2011 11:37 AM, Thomas Gleixner wrote:
> On Wed, 27 Jul 2011, Darren Hart wrote:
>
>> Without the raw_spin_lock_init(), the wait_lock does not get properly
>> initialized with CONFIG_DEBUG_SPINLOCK. This can manifest in a BUG() in the
>> futex requeue_pi path when the pi_state->pi_mutex->wait_lock fails the magic
>> test in rt_mutex_start_proxy_lock()->raw_spin_lock(&lock->wait_lock).
> That's actively wrong. You reinitialize the lock for all other cases
> which call this via rt_mutex_init(). There is a reason why I moved the
> spin lock initializer out of __rt_mutex_init() into
> rt_mutex_init(). The lock name stuff for lockdep ends up to be
> "lock->wait_lock" for all rt_mutexes, which is pretty useless when you
> have to analyze a lockdep splat. Thanks for finding it nevertheless.
>
> So the correct fix is:
>
> Index: linux-2.6/kernel/rtmutex.c
> ===================================================================
> --- linux-2.6.orig/kernel/rtmutex.c
> +++ linux-2.6/kernel/rtmutex.c
> @@ -1296,7 +1296,7 @@ EXPORT_SYMBOL_GPL(__rt_mutex_init);
>  void rt_mutex_init_proxy_locked(struct rt_mutex *lock,
>  				struct task_struct *proxy_owner)
>  {
> -	__rt_mutex_init(lock, NULL);
> +	rt_mutex_init(lock);
>  	debug_rt_mutex_proxy_lock(lock, proxy_owner);
>  	rt_mutex_set_owner(lock, proxy_owner);
>  	rt_mutex_deadlock_account_lock(lock, proxy_owner);
>
>  
Seems to work. I no longer get a warning from pulseaudio either.
Also darren, at least on fedora 15 glibc supports requeue_pi.
support for that is in nptl/sysdeps/unix/sysv/linux/x86_64/pthread_cond_*.S

Cheers,
Maarten

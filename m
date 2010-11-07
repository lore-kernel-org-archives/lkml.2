Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab0KGWJQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 17:09:16 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49265 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab0KGWJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 17:09:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DPsXHh5sU/2GCAg1mx7TZmXSJges0CGSybLqWMN3G+EF6p+i509DFcI78rVHl3QLvu
         3ScyxTR9bo8gIoF0w9Rk9mwomd30CQ+qw14UwBlbMjGS5D8qcTsm/BA51Xdi3Jhkkl90
         GW+udVd3XvivryW/uX8/ztz4qyRShc3I1YGtw=
Date: Sun, 7 Nov 2010 23:09:11 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
        sergey.senozhatsky@gmail.com
Subject: Re: [PATCH] watchdog:  touch_nmi_watchdog should only touch local
	cpu not every one
Message-ID: <20101107220909.GF11134@nowhere>
References: <1288919932-1857-1-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288919932-1857-1-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 04, 2010 at 09:18:52PM -0400, Don Zickus wrote:
> I ran into a scenario where while one cpu was stuck and should have panic'd
> because of the NMI watchdog, it didn't.  The reason was another cpu was spewing
> stack dumps on to the console.  Upon investigation, I noticed that when writing
> to the console and also when dumping the stack, the watchdog is touched.
> 
> This causes all the cpus to reset their NMI watchdog flags and the 'stuck' cpu
> just spins forever.
> 
> This change causes the semantics of touch_nmi_watchdog to be changed slightly.
> Previously, I accidentally changed the semantics and we noticed there was a
> codepath in which touch_nmi_watchdog could be touched from a preemtible area.
> That caused a BUG() to happen when CONFIG_DEBUG_PREEMPT was enabled.  I believe
> it was the acpi code.
> 
> My attempt here re-introduces the change to have the touch_nmi_watchdog() code
> only touch the local cpu instead of all of the cpus.  But instead of using
> __get_cpu_var(), I use the __raw_get_cpu_var() version.
> 
> This avoids the preemption problem.  However my reasoning wasn't because I was
> trying to be lazy.  Instead I rationalized it as, well if preemption is enabled
> then interrupts should be enabled to and the NMI watchdog will have no reason
> to trigger.  So it won't matter if the wrong cpu is touched because the percpu
> interrupt counters the NMI watchdog uses should still be incrementing.
> 
> Signed-off-by: Don Zickus <dzickus@redhat.com>
> ---
>  kernel/watchdog.c |   17 ++++++++++++++++-
>  1 files changed, 16 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index dc8e168..dd0c140 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -141,6 +141,21 @@ void touch_all_softlockup_watchdogs(void)
>  #ifdef CONFIG_HARDLOCKUP_DETECTOR
>  void touch_nmi_watchdog(void)
>  {
> +	/*
> +	 * Using __raw here because some code paths have
> +	 * preemption enabled.  If preemption is enabled
> +	 * then interrupts should be enabled too, in which
> +	 * case we shouldn't have to worry about the watchdog
> +	 * going off.
> +	 */
> +	__raw_get_cpu_var(watchdog_nmi_touch) = true;
> +
> +	touch_softlockup_watchdog();
> +}
> +EXPORT_SYMBOL(touch_nmi_watchdog);



Did the old watchdog also touched every CPUs?

That doesn't appear to be a good thing, we may indeed miss hardlockups
because of that.

And it seems you can drop touch_all_nmi_watchdogs() as, like others
pointed out, there are no users of it.


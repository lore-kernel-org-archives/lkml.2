Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751270Ab2LSVSG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 16:18:06 -0500
Received: from canardo.mork.no ([148.122.252.1]:37855 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004Ab2LSVR7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 16:17:59 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Don Zickus <dzickus@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Norbert Warmuth <nwarmuth@t-online.de>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RESEND][PATCH v3] watchdog: Fix disable/enable regression
Organization: m
References: <87y5h1c70y.fsf@nemi.mork.no>
	<1355946691-7969-1-git-send-email-bjorn@mork.no>
	<20121219201336.GK88797@redhat.com>
Date: Wed, 19 Dec 2012 22:17:42 +0100
In-Reply-To: <20121219201336.GK88797@redhat.com> (Don Zickus's message of
	"Wed, 19 Dec 2012 15:13:36 -0500")
Message-ID: <874njh7nd5.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don Zickus <dzickus@redhat.com> writes:
> On Wed, Dec 19, 2012 at 08:51:31PM +0100, Bjørn Mork wrote:
>> commit 8d451690 ("watchdog: Fix CPU hotplug regression") cause
>> an oops or hard lockup when doing
>> 
>>  echo 0 > /proc/sys/kernel/nmi_watchdog
>>  echo 1 > /proc/sys/kernel/nmi_watchdog
>> 
>> and the kernel is booted with nmi_watchdog=1 (default)
>> 
>> Running laptop-mode-tools and disconnecting/connecting AC power
>> will cause this to trigger, making it a common failure scenario
>> on laptops.
>> 
>> Instead of bailing out of watchdog_disable() when !watchdog_enabled
>> we can initialize the hrtimer regardless of watchdog_enabled status.
>> This makes it safe to call watchdog_disable() in the nmi_watchdog=0
>> case, without the negative effect on the enabled => disabled =>
>> enabled case.
>> 
>> All these tests pass with this patch:
>> - nmi_watchdog=1
>>   echo 0 > /proc/sys/kernel/nmi_watchdog
>>   echo 1 > /proc/sys/kernel/nmi_watchdog
>> 
>> - nmi_watchdog=0
>>   echo 0 > /sys/devices/system/cpu/cpu1/online
>> 
>> - nmi_watchdog=0
>>   echo mem > /sys/power/state
>
> What about the opposite cases?  
> nmi_watchdog=1
> echo 1 > /sys/devices/system/cpu/cpu1/online

I don't see why not. But verifying it would be nice.  I thought that it
would be a simple thing to test using qemu-kvm, but it seems that the
CPU hotplugging support there isn't quite ready. The guest just dies
with "Assertion `bus->allow_hotplug' failed."

I'll go digging for alternatives, but if anyone else could verify this
then I'd appreciate it.

> Are we going to leak memory by re-initing hrtimer?  Or is that caught
> somewhere?

There are no allocations in hrtimer_init() AFAICS? It just initializes
the preallocated hrtimer struct.

> Other than that, the patch seems reasonable to me.  Basically just forcing
> the init of hrtimer so there is something to cancel on the disable side.
> Then again, I don't fully understand the original problem.

I believe the original problem was calling hrtimer_cancel on an
uninitialized hrtimer.  That is likely to blow up here:

static inline
void unlock_hrtimer_base(const struct hrtimer *timer, unsigned long *flags)
{
        raw_spin_unlock_irqrestore(&timer->base->cpu_base->lock, *flags);
}


Note that the lock_hrtimer_base() function protects access to
timer->base with a NULL test.  That should probably be done in unlock as
well, for symmetry?  But this is another issue and not at all urgent.




Bjørn

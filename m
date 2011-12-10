Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab1LJC2d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 21:28:33 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63192 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab1LJC2b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 21:28:31 -0500
MIME-Version: 1.0
In-Reply-To: <CAELBVzAWtTXvc+R1LkHT23SLERsFL5zUh5=_JoizXjJ7s0k8OA@mail.gmail.com>
References: <1323101246-2400-1-git-send-email-daniel@numascale-asia.com>
	<tip-44b111b519160e33fdc41eadb39af86a24707edf@git.kernel.org>
	<20111205203130.GA12364@elte.hu>
	<4EDD5D77.3030101@numascale.com>
	<20111206055023.GB1580@elte.hu>
	<CAELBVzBqNHsnRP=dt7nwFWoigfX4FF6nQio+P+Fz71xQY0qK4Q@mail.gmail.com>
	<20111209072244.GG24537@elte.hu>
	<CAELBVzAWtTXvc+R1LkHT23SLERsFL5zUh5=_JoizXjJ7s0k8OA@mail.gmail.com>
Date: Fri, 9 Dec 2011 22:28:29 -0400
Message-ID: <CAELBVzBPcARsNSDhv0TUfSmXAu3+k5_KK-Aqv2JMaHX+gjOL+w@mail.gmail.com>
Subject: Re: [tip:x86/apic] x86: Add NumaChip support
From: Kevin Winchester <kjwinchester@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steffen Persvold <sp@numascale.com>, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
        tglx@linutronix.de, daniel@numascale-asia.com,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 December 2011 21:52, Kevin Winchester <kjwinchester@gmail.com> wrote:
> On 9 December 2011 03:22, Ingo Molnar <mingo@elte.hu> wrote:
>>
>> * Kevin Winchester <kjwinchester@gmail.com> wrote:
>>
>>> On 6 December 2011 01:50, Ingo Molnar <mingo@elte.hu> wrote:
>>> >
>>> >
>>> > Ideally i think c->phys_proc_id should should be available
>>> > regardless of CONFIG_SMP or CONFIG_NUMA considerations - but
>>> > that would be a wider change. (feel free to have a shot at it
>>> > though, in addition to the fix above)
>>> >
>>>
>>> If Steffen does not plan to do this additional cleanup, I
>>> would give it a try.  You would likely prefer the changes
>>> against -tip, correct?
>>
>> On a second thought, the !SMP block in processor.h::cpuinfo_x86
>> is pretty self-contained and making it unconditional would
>> increase UP kernel size by 4x5==20 bytes.
>>
>> I have not checked how many further simplifications this allows
>> - if it's a really nice cleanup then i guess we could do it and
>> keep the all-zeroes-and-ones default value on UP.
>>
>> The fields *do* make sense on UP as well.
>>
>> So it's a "try and see how it ends up" thing.
>>
>
> So I get the following (gmail-mangled) patch as a cleanup if the
> fields are made available on UP.  Is it worth it?  I'll let you be the
> judge.  One other thing I noticed that prevented a few more #ifdef
> removals was the global smp_num_siblings variable defined in
> smpboot.c.  This variable appears related to hyperthreading siblings
> from what I can tell, but it gets used in ways related to the cpu
> info.  Would it be possible to move this into a new field in struct
> cpuinfo_x86?  It seems like a cpu-related property to me, not that I
> can imagine there will ever be a processor architecture where
> different cpus have different numbers of HT threads.
>
> In any case, if you like the simple cleanup, I can resend with sign
> off and no whitespace damage.  If you want me to go further, let me
> know and I'll give it a shot.
>
>  arch/x86/include/asm/processor.h     |    2 --
>  arch/x86/kernel/amd_nb.c             |    8 ++------
>  arch/x86/kernel/cpu/amd.c            |    2 --
>  arch/x86/kernel/cpu/common.c         |    7 -------
>  arch/x86/kernel/cpu/intel.c          |    2 --
>  arch/x86/kernel/cpu/mcheck/mce.c     |    2 --
>  arch/x86/kernel/cpu/mcheck/mce_amd.c |    7 +------
>  arch/x86/kernel/cpu/proc.c           |    4 +---
>  drivers/edac/sb_edac.c               |    2 --
>  drivers/hwmon/coretemp.c             |    6 ------
>  10 files changed, 4 insertions(+), 38 deletions(-)
>

A couple of other notes:

- For my config, converted to !SMP, the size of the kernel text grew
by 267 bytes:

   text	   data	    bss	    dec	    hex	filename
4734483	 510391	 972040	6216914	 5edcd2	vmlinux.o.before
4734750	 510391	 972040	6217181	 5edddd	vmlinux.o.after

Maybe that makes it no longer worthwhile for removing 34 lines of code...

- The booted_cores field is only set in smpboot.c, and only used there
and in cpu/proc.c in a SMP-specific block of code.  I wasn't sure
where the best place would be to set it for the UP case, so I left it
alone.  That technically makes it wrong since it will be 0 when there
really is one core booted, but no one will notice.  If you have a
suggestion for initializing it, let me know and I can include it.

And in case anyone is wondering, I am aware that this is pretty basic
in nature and not necessarily worth anyone's time to code/review.  But
it gives me a little more insight into the kernel codebase, so I'm
happy to do it anyway.

-- 
Kevin Winchester

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758773Ab1DYSN3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 14:13:29 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64502 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758203Ab1DYSN2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 14:13:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=SseCjuS0I2LQRtMbGL/EwEDNt0xSZLAOCJQaPdSREFlKW5mi34SI2X/R1o9CQyYo8D
         G9ckapAah6TBcpKMUtq8jSGPp8yyQg8D8DZainJe11TJVMxwUNLIGQA8ZjGgamJmsI+k
         LW+mZyGr5Of6r4JecAh5c0TREfOciVx4yCtfg=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110425172914.GB2468@linux.vnet.ibm.com>
References: <20110424202158.45578f31@neptune.home>
	<20110424235928.71af51e0@neptune.home>
	<20110425114429.266A.A69D9226@jp.fujitsu.com>
	<BANLkTinVQtLbmBknBZeY=7w7AOyQk61Pew@mail.gmail.com>
	<20110425111705.786ef0c5@neptune.home>
	<BANLkTi=d0UHrYXyTK0CBZYCSK-ax8+wuWQ@mail.gmail.com>
	<20110425180450.1ede0845@neptune.home>
	<BANLkTikSLA59tdgRL4B=cr5tvP2NbzZ=KA@mail.gmail.com>
	<20110425190032.7904c95d@neptune.home>
	<20110425172914.GB2468@linux.vnet.ibm.com>
Date: Mon, 25 Apr 2011 20:13:27 +0200
Message-ID: <BANLkTim5oKxPT1KT5Zut937H5RVMiyn+Hg@mail.gmail.com>
Subject: Re: 2.6.39-rc4+: Kernel leaking memory during FS scanning, regression?
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: paulmck@linux.vnet.ibm.com
Cc: =?UTF-8?Q?Bruno_Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Frysinger <vapier.adi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Pekka Enberg <penberg@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 25, 2011 at 7:29 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Mon, Apr 25, 2011 at 07:00:32PM +0200, Bruno Prémont wrote:
>> On Mon, 25 April 2011 Linus Torvalds wrote:
>> > 2011/4/25 Bruno Prémont <bonbons@linux-vserver.org>:
>> > >
>> > > kmemleak reports 86681 new leaks between shortly after boot and -2 state.
>> > > (and 2348 additional ones between -2 and -4).
>> >
>> > I wouldn't necessarily trust kmemleak with the whole RCU-freeing
>> > thing. In your slubinfo reports, the kmemleak data itself also tends
>> > to overwhelm everything else - none of it looks unreasonable per se.
>> >
>> > That said, you clearly have a *lot* of filp entries. I wouldn't
>> > consider it unreasonable, though, because depending on load those may
>> > well be fine. Perhaps you really do have some application(s) that hold
>> > thousands of files open. The default file limit is 1024 (I think), but
>> > you can raise it, and some programs do end up opening tens of
>> > thousands of files for filesystem scanning purposes.
>> >
>> > That said, I would suggest simply trying a saner kernel configuration,
>> > and seeing if that makes a difference:
>> >
>> > > Yes, it's uni-processor system, so SMP=n.
>> > > TINY_RCU=y, PREEMPT_VOLUNTARY=y (whole /proc/config.gz attached keeping
>> > > compression)
>> >
>> > I'm not at all certain that TINY_RCU is appropriate for
>> > general-purpose loads. I'd call it more of a "embedded low-performance
>> > option".
>>
>> Well, TINY_RCU is the only option when doing PREEMPT_VOLUNTARY on
>> SMP=n...
>
> You can either set SMP=y and NR_CPUS=1 or you can handed-edit
> init/Kconfig to remove the dependency on SMP.  Just change the
>
>        depends on !PREEMPT && SMP
>
> to:
>
>        depends on !PREEMPT
>
> This will work fine, especially for experimental purposes.
>
>> > The _real_ RCU implementation ("tree rcu") forces quiescent states
>> > every few jiffies and has logic to handle "I've got tons of RCU
>> > events, I really need to start handling them now". All of which I
>> > think tiny-rcu lacks.
>>
>> Going to try it out (will take some time to compile), kmemleak disabled.
>>
>> > So right now I suspect that you have a situation where you just have a
>> > simple load that just ends up never triggering any RCU cleanup, and
>> > the tiny-rcu thing just keeps on gathering events and delays freeing
>> > stuff almost arbitrarily long.
>>
>> I hope tiny-rcu is not that broken... as it would mean driving any
>> PREEMPT_NONE or PREEMPT_VOLUNTARY system out of memory when compiling
>> packages (and probably also just unpacking larger tarballs or running
>> things like du).
>
> If it is broken, I will fix it.  ;-)
>
>                                                        Thanx, Paul
>
>> And with system doing nothing (except monitoring itself) memory usage
>> goes increasing all the time until it starves (well it seems to keep
>> ~20M free, pushing processes it can to swap). Config is just being
>> make oldconfig from working 2.6.38 kernel (answering default for new
>> options)
>>
>> Memory usage evolution graph in first message of this thread:
>> http://thread.gmane.org/gmane.linux.kernel.mm/61909/focus=1130480
>>
>> Attached graph matching numbers of previous mail. (dropping caches was at
>> 17:55, system idle since then)
>>
>> Bruno
>>
>>
>> > So try CONFIG_PREEMPT and CONFIG_TREE_PREEMPT_RCU to see if the
>> > behavior goes away. That would confirm the "it's just tinyrcu being
>> > too dang stupid" hypothesis.
>> >
>> >                      Linus
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Hi,

I was playing with Debian's kernel-buildsystem for -rc4 with a
self-defined '686-up' so-called flavour.

Here I have a Banias Pentium-M (UP, *no* PAE) and still experimenting
with kernel-config options.

CONFIG_X86_UP_APIC=y
CONFIG_X86_UP_IOAPIC=y

...is not possible with CONFIG_SMP=y

These settings are possible by not hacking existing Kconfigs:

$ egrep 'M486|M686|X86_UP|CONFIG_SMP|NR_CPUS|PREEMPT|_RCU|_HIGHMEM|PAE'
debian/build/build_i386_none_686-up/.config
CONFIG_TREE_PREEMPT_RCU=y
# CONFIG_TINY_RCU is not set
# CONFIG_TINY_PREEMPT_RCU is not set
CONFIG_PREEMPT_RCU=y
# CONFIG_RCU_TRACE is not set
CONFIG_RCU_FANOUT=32
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_PREEMPT_NOTIFIERS=y
# CONFIG_SMP is not set
# CONFIG_M486 is not set
CONFIG_M686=y
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_X86_UP_APIC=y
CONFIG_X86_UP_IOAPIC=y
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_HIGHMEM=y
CONFIG_DEBUG_PREEMPT=y
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_DEBUG_HIGHMEM is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
# CONFIG_PREEMPT_TRACER is not set

But I also see these warnings:

.config:2106:warning: override: TREE_PREEMPT_RCU changes choice state
.config:2182:warning: override: PREEMPT changes choice state

Not sure how to interprete them, so I am a bit careful :-).

( Untested - not compiled yet! )

- Sedat -

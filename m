Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444Ab1D2Hzu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 03:55:50 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:43820 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756344Ab1D2Hzs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 03:55:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=XAEqIjFD6gl98mw1V40/NOxeR0odtkfISVHA6JcXBf2lo+ypMV04RDY8wYC4oIPHYI
         ogKrjExcWPLyFnXzAjQR82gLRCcuep8NsP2nVtjbdVo/9l5WZIm3kY3PGgzyh3KuR2dq
         WeVAlnD2dEcRdtcmF7PftytWeM0HSnUapo73E=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <alpine.LFD.2.02.1104282353140.3005@ionos>
References: <20110426112756.GF4308@linux.vnet.ibm.com>
	<20110426183859.6ff6279b@neptune.home>
	<20110426190918.01660ccf@neptune.home>
	<BANLkTikjuqWP+PAsObJH4EAOyzgr2RbYNA@mail.gmail.com>
	<alpine.LFD.2.02.1104262314110.3323@ionos>
	<20110427081501.5ba28155@pluto.restena.lu>
	<20110427204139.1b0ea23b@neptune.home>
	<alpine.LFD.2.02.1104272351290.3323@ionos>
	<alpine.LFD.2.02.1104281051090.19095@ionos>
	<BANLkTinB5S7q88dch78i-h28jDHx5dvfQw@mail.gmail.com>
	<20110428102609.GJ2135@linux.vnet.ibm.com>
	<1303997401.7819.5.camel@marge.simson.net>
	<BANLkTik4+PAGHF-9KREYk8y+KDQLDAp2Mg@mail.gmail.com>
	<alpine.LFD.2.02.1104282044120.3005@ionos>
	<20110428222301.0b745a0a@neptune.home>
	<alpine.LFD.2.02.1104282227340.3005@ionos>
	<20110428224444.43107883@neptune.home>
	<alpine.LFD.2.02.1104282251080.3005@ionos>
	<1304027480.2971.121.camel@work-vm>
	<alpine.LFD.2.02.1104282353140.3005@ionos>
Date: Fri, 29 Apr 2011 09:55:47 +0200
Message-ID: <BANLkTinr4==+BGqoNJseqTJ94hjK1kD1bw@mail.gmail.com>
Subject: Re: 2.6.39-rc4+: Kernel leaking memory during FS scanning, regression?
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>,
        =?UTF-8?Q?Bruno_Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Frysinger <vapier.adi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Pekka Enberg <penberg@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 12:02 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Thu, 28 Apr 2011, john stultz wrote:
>> On Thu, 2011-04-28 at 23:04 +0200, Thomas Gleixner wrote:
>> > /me suspects hrtimer changes to be the real culprit.
>>
>> I'm not seeing anything on right off, but it does smell like
>> e06383db9ec591696a06654257474b85bac1f8cb would be where such an issue
>> would crop up.
>>
>> Bruno, could you try checking out e06383db9ec, confirming it still
>> occurs (and then maybe seeing if it goes away at e06383db9ec^1)?
>>
>> I'll keep digging in the meantime.
>
> I found the bug already. The problem is that sched_init() calls
> init_rt_bandwidth() which calls hrtimer_init() _BEFORE_
> hrtimers_init() is called.
>
> That was unnoticed so far as the CLOCK id to hrtimer base conversion
> was hardcoded. Now we use a table which is set up at hrtimers_init(),
> so the bandwith hrtimer ends up on CLOCK_REALTIME because the table is
> in the bss.
>
> The patch below fixes this, by providing the table statically rather
> than runtime initialized. Though that whole ordering wants to be
> revisited.
>
> Thanks,
>
>        tglx
>
> --- linux-2.6.orig/kernel/hrtimer.c
> +++ linux-2.6/kernel/hrtimer.c
> @@ -81,7 +81,11 @@ DEFINE_PER_CPU(struct hrtimer_cpu_base,
>        }
>  };
>
> -static int hrtimer_clock_to_base_table[MAX_CLOCKS];
> +static int hrtimer_clock_to_base_table[MAX_CLOCKS] = {
> +       [CLOCK_REALTIME] = HRTIMER_BASE_REALTIME,
> +       [CLOCK_MONOTONIC] = HRTIMER_BASE_MONOTONIC,
> +       [CLOCK_BOOTTIME] = HRTIMER_BASE_BOOTTIME,
> +};
>
>  static inline int hrtimer_clockid_to_base(clockid_t clock_id)
>  {
> @@ -1722,10 +1726,6 @@ static struct notifier_block __cpuinitda
>
>  void __init hrtimers_init(void)
>  {
> -       hrtimer_clock_to_base_table[CLOCK_REALTIME] = HRTIMER_BASE_REALTIME;
> -       hrtimer_clock_to_base_table[CLOCK_MONOTONIC] = HRTIMER_BASE_MONOTONIC;
> -       hrtimer_clock_to_base_table[CLOCK_BOOTTIME] = HRTIMER_BASE_BOOTTIME;
> -
>        hrtimer_cpu_notify(&hrtimers_nb, (unsigned long)CPU_UP_PREPARE,
>                          (void *)(long)smp_processor_id());
>        register_cpu_notifier(&hrtimers_nb);
>

Will you send this as a separate patch?

Please also feel free to add:

     Tested-by: Sedat Dilek <sedat.dilek@gmail.com>

If you like also a Reported-by... as the issue is not new, I have
first reported it here [1].

- Sedat -

[1] http://lkml.org/lkml/2011/3/25/97

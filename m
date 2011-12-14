Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab1LNANd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 19:13:33 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63000 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329Ab1LNANa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 19:13:30 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1111152259430.4902@ionos>
References: <20110908215314.829452535@linutronix.de>
	<CADGdYn6V_eQJZ4=irMbSS7XJj4MJVeALxcrWdD7o2bGs1sEJZQ@mail.gmail.com>
	<20110913133258.GA6267@n2100.arm.linux.org.uk>
	<CAKfTPtCWuiOM5+sOwdh1FzXZb1EFT__tVEpRPY5suGOxpYTdQQ@mail.gmail.com>
	<20110913175312.GB6267@n2100.arm.linux.org.uk>
	<20110923084001.GP17169@n2100.arm.linux.org.uk>
	<01d501cc84d6$62720890$275619b0$%kim@samsung.com>
	<alpine.LFD.2.02.1110071354310.3240@ionos>
	<CAPz4a6CkOXp6LHX2hFYVBhXWT4rhCUzLyYTLbO7g8u_jYcHt7Q@mail.gmail.com>
	<CAPz4a6C7md+k8pCz6mJtB-v_1h-faGxQZkOqU9vHUtcG-jrYVQ@mail.gmail.com>
	<4EC2DF93.2050904@codeaurora.org>
	<alpine.LFD.2.02.1111152259430.4902@ionos>
Date: Tue, 13 Dec 2011 16:13:30 -0800
X-Google-Sender-Auth: n5tm6VC1rqU_nHcYfT1S445YvLg
Message-ID: <CAPz4a6BwzAmE=08pCfhK5of0vEV+uPaf8D-9U_MnW5_vAe6NFw@mail.gmail.com>
Subject: Re: Re: [patch] ARM: smpboot: Enable interrupts after marking CPU online/active
From: Dima Zavin <dima@android.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Stepan Moskovchenko <stepanm@codeaurora.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Frank Rowand <frank.rowand@am.sony.com>,
        amit kachhap <amit.kachhap@linaro.org>,
        Colin Cross <ccross@android.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        chaos.youn@samsung.com, LAK <linux-arm-kernel@lists.infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

Did you ever get a chance to look into this further?

Thanks in advance.

--Dima

On Tue, Nov 15, 2011 at 2:00 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Tue, 15 Nov 2011, Stepan Moskovchenko wrote:
>> I am seeing a deadlock when executing hotplug operations with this patch
>> applied. When the secondary CPU gets brought up in _cpu_up, the cpu is turned
>> on
>> and then the online notifier gets called, which is what marks the secondary
>> CPU
>> as active. If _cpu_up on the primary CPU is preempted before the secondary CPU
>> is marked active, it is possible that the primary CPU will want to call
>> smp_call_function (or send an IPI) to the secondary CPU because it is marked
>> online. However, with this patch, the secondary CPU is still spinning on
>> !cpu_active(cpu)
>> with interrupts disabled. So, the primary CPU is now stuck in csd_lock_wait(),
>> waiting for the secondary CPU to respond, while the secondary CPU spins with
>> interrupts disabled, waiting for the primary CPU to mark it as active. So,
>> while
>> your approach to not call smp_function_single may work for you in your
>> specific
>> case, I believe there is still a problem in the general case.
>>
>> One suggestion for resolving this might be making smp_call_function look at
>> the
>> active CPUs rather than online CPUs, or to just let the secondary CPU mark
>> itself as active rather than having the primary CPU do this, though this might
>> defeat the original intended purpose of the active mask.
>
> What a mess. I'll have a look tomorrow.

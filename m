Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946Ab2A0HLA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 02:11:00 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49249 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010Ab2A0HK6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 02:10:58 -0500
MIME-Version: 1.0
In-Reply-To: <B5906170F1614E41A8A28DE3B8D1214331791EA6@DBDE01.ent.ti.com>
References: <1327594923-21822-1-git-send-email-pdeschrijver@nvidia.com>
	<1327594923-21822-4-git-send-email-pdeschrijver@nvidia.com>
	<B5906170F1614E41A8A28DE3B8D1214331791EA6@DBDE01.ent.ti.com>
Date: Thu, 26 Jan 2012 23:10:58 -0800
X-Google-Sender-Auth: t2qee92Io3sjTcSXsotKgCF6seM
Message-ID: <CAMbhsRQ00Cm-wo9hL9jRfpUfATPZc+znNJu-EagK6qV0qRs4SA@mail.gmail.com>
Subject: Re: [PATCH v1 3/3] ARM: tegra: cpuidle driver for tegra
From: Colin Cross <ccross@android.com>
To: "Bedia, Vaibhav" <vaibhav.bedia@ti.com>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 26, 2012 at 10:59 PM, Bedia, Vaibhav <vaibhav.bedia@ti.com> wrote:
> On Thu, Jan 26, 2012 at 21:52:03, Peter De Schrijver wrote:
> [...]
>> +static int tegra_idle_enter_lp3(struct cpuidle_device *dev,
>> +     struct cpuidle_driver *drv, int index)
>> +{
>> +     ktime_t enter, exit;
>> +     s64 us;
>> +
>> +     local_irq_disable();
>> +     local_fiq_disable();
>> +
>> +     enter = ktime_get();
>> +
>> +     tegra_cpu_wfi();
>> +
>> +     exit = ktime_sub(ktime_get(), enter);
>> +     us = ktime_to_us(exit);
>> +
>> +     local_fiq_enable();
>> +     local_irq_enable();
>> +
>> +     dev->last_residency = us;
>> +
>> +     return index;
>> +}
>
> You can probably drop local_irq_disable() and local_irq_enable().

local_irq_enable() is required by the cpuidle call semantics.  See
arch/arm/process.c, it has a 				WARN_ON(irqs_disabled()) after the
idle function call.  The local_irq_disable() can and probably should
be dropped, although a comment that the function is called with
interrupts off and is expected to return with interrupts on would be
helpful.

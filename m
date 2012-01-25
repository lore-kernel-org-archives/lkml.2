Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab2AYNqO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 08:46:14 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35273 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab2AYNqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 08:46:13 -0500
MIME-Version: 1.0
X-Originating-IP: [89.139.53.79]
In-Reply-To: <4F1FF870.3000105@monstr.eu>
References: <4F1EE861.4030405@monstr.eu> <CAK=Wgba5kT8AwLtuHyosucYnWf-EA+xpE1kzmssfhSC7ZXQA=g@mail.gmail.com>
 <4F1FF870.3000105@monstr.eu>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 25 Jan 2012 15:45:48 +0200
Message-ID: <CAK=WgbZwaxMPsMiNcq5yFvBLrcODqGgDT6b=mmQ91JBVtTEyXA@mail.gmail.com>
Subject: Re: remoteproc: Load coprocessor code to the specific main memory location
To: monstr@monstr.eu
Cc: LKML <linux-kernel@vger.kernel.org>,
        John Williams <john.williams@petalogix.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        "Grosen, Mark" <mgrosen@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 2:41 PM, Michal Simek <monstr@monstr.eu> wrote:
> First of all will be the best to describe what we want to achieve.
> We have Zynq platform ARM Cortex-A9(which should be ARMv7 - 2cpus).
> cpu0 runs Linux and cpu1 will be used for real-time os. We would like to use
> remoteproc for loading any code(firmware if you like) for the cpu1 and start
> it.

Sounds cool.

So you're not < ARMv6, and I now understand why you bumped into that
code path: you're using a vanilla kernel, without CMA.

I suggest you merge Marek's CMA branch into your tree. Though 1MB
isn't that much really, and you can easily get away even without CMA.
You just won't have any non-CMA public example to use as a reference
;).

For details about the CMA tree and branches, see Marek's email:

https://lkml.org/lkml/2012/1/10/48

> Then in zynq_rproc_kick I copy content of this 1MB carveout to 0x0 physical

I recommend to keep the ->kick() handler as light as possible, as it
may be frequently triggered (think of a network driver doing I/O).

Ideally you should do the minimum required to only wake up the other
core when you are kicked. Copying a 1MB region every kick sounds
excessive.

> The main my problem is that firmware base addr must be at the beginning of
> address space
> or selected address but it is fixed and known.
..
> ok. How do you handle limitations if coprocessor expect code on any address?

Just make sure you reserve the CMA region at that fixed address.

For a reference how this can be done, look for OMAP_RPROC_CMA_BASE in
my rpmsg_3.2_rc4 branch.

>> Looping in Mark, who did the davinci remoteproc support, and might
>> have the code available to share. Hopefully we'd have the patches
>> posted soon, and then no-iommu platforms could just use them for
>> reference.
>
>
> ok. great. Will look forward for that code and recommendation because I am
> ARM newbie.

So I no longer think you need the davinci code, you can just follow
the OMAP example.

> I am also interested in suggestions about DTS binding. Have someone tried to
> describe it or use it?

No, AFAICT. And I'm not sure there are DTS binding for CMA regions
yet. Feel free to take a stab at it though ;)

Regards,
Ohad.

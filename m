Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab2HMWGc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 18:06:32 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:60963 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451Ab2HMWGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 18:06:13 -0400
MIME-Version: 1.0
In-Reply-To: <20120813173847.GH13446@opensource.wolfsonmicro.com>
References: <1344375978-29981-1-git-send-email-matt@genesi-usa.com>
 <20120809101947.GA8474@sirena.org.uk> <CAKGA1bkwMvDW7nMWxUbNm3_0ZTR2+uKs8UL_HuisJe7cd8POBA@mail.gmail.com>
 <20120813173847.GH13446@opensource.wolfsonmicro.com>
From: Matt Sealey <matt@genesi-usa.com>
Date: Mon, 13 Aug 2012 17:05:52 -0500
Message-ID: <CAKGA1b=ANojue-ZDxmocDhzTcQPuOVocs9yCjezhJrGqsOXEHA@mail.gmail.com>
Subject: Re: [PATCH] efikamx: reintroduce Genesi Efika MX Smarttop via device tree
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Steev Klimaszewski <steev@genesi-usa.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 12:38 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Mon, Aug 13, 2012 at 10:42:58AM -0500, Matt Sealey wrote:
>> On Thu, Aug 9, 2012 at 5:19 AM, Mark Brown
>
>> > This and many of your other regulators have voltage ranges specified but
>> > no consumers which doesn't make sense.  It looks awfully like you've
>> > just typed in the maximum range supported by the regulator which is most
>> > likely broken.
>
>> Okay I have a question about this; some of the regulators (SW1
>> especially) are obviously consumed by the CPU core complex so that
>> when DVFS gives us a hint we can clock down and reduce voltage. How on
>> earth do we implement that?
>
>> We can drop the maximum range to be better for the CPU (1.3V is too
>> high, I think this is legacy from when we may have had a sorted 1GHz
>> MX51 coming out) but I can't find any source for where this is hooked
>> in.
>
> DVFS doesn't use the device model in Linux (yet!) so there's no device
> node and it's all a bit messy.  Shawn Guo is working on some generic DT
> bindings for it which should solve that problem but for now in the
> specific case of CPU bindings it's OK to not have an consumer, it's
> understandable what's going on there.

Going over the regulators, what I have so far is every regulator
properly specced with their fixed voltages where it never changes
(which is everything but SW1 and SW2).

There are still a lot of always-on and boot-on regulators since the
design is pretty poor - some pmic regulators that should have specific
consumers have been re-used in other places to supplement other
regulators or derive other voltages for parts of the board you would
usually have discrete logic to support. In this sense, a lot of the
board remains powered or it will just act weird, and a couple of very
specific ones can be turned on and off and don't need to be enabled
for the boot process, but they will be referenced by a metric f&%@ton
of devices as being a consumer so it's unlikely they'll ever actually
power down. In this case I found one always-on and boot-on that
actually doesn't need to be, but for the most part it stays as it is
with refined voltages.

I'm a little confused by the SW1 and SW2 ->VDDGP,VCC sourcing and what
that's actually supplying and what the voltage ranges SHOULD be - as I
think both need to be ranges. VDDGP should probably not be any more
flexible than 0.85V-1.1V.

That said, VCC seems to be only required to be a fixed 1.225V in the
datasheet? 0.9V to 1.85V seems excessive, but it's actually dependent
on load. I don't think anyone ever changes it, it was one of those
things your average board designer would sit down and say, this is
what it needs to be, and it might get bumped when it turns out
something on the board needs more power than the spec. I have NO idea
what this should be. I could just nail it to 1.225V and cover all
bases at the cost of possibly burning a ton of power. I'm looking into
what it's ACTUALLY running at in the old kernels.

It'll take some digging through the old Freescale code about where
they turn regulators on and off in the fixed board files to find this
out and what the original intent was. In the meantime I might be able
to refine the VDDGP/SW2 source. Shawn, any input? And does mainline
care about MX51 TO2 enough that we'd need to implement the voltage
bumps for that?

-- 
Matt Sealey <matt@genesi-usa.com>
Product Development Analyst, Genesi USA, Inc.

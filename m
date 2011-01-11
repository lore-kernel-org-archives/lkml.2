Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834Ab1AKMLo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 07:11:44 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44597 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755507Ab1AKMLm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 07:11:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=F3P+BTPeHtMFmmZZe+bEtwNX8PLqnSjCyUeX0Jc3+c3BxZwPQHqffokpbCnAy2fmRP
         H42eN7jniQ9VtgF9C6q4G4twqa6FnyzWu+x6ks/5eNF6gMYG8c4Et3bswUlOQ7P6HD+t
         bxG1puDpZ/9/8NZhrgvGJ6ceyBFJ46upM5RHA=
MIME-Version: 1.0
In-Reply-To: <20110111091607.GI12552@n2100.arm.linux.org.uk>
References: <201101111016.42819.jeremy.kerr@canonical.com>
	<20110111091607.GI12552@n2100.arm.linux.org.uk>
Date: Tue, 11 Jan 2011 17:41:24 +0530
Message-ID: <AANLkTikUT6ds6+omkmr2rgUipq=nmEd6GRPngK0+qUZ4@mail.gmail.com>
Subject: Re: Locking in the clk API
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 2:46 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Tue, Jan 11, 2011 at 10:16:42AM +0800, Jeremy Kerr wrote:
>> At present, we can satisfy these with:
>>
>> * clk_enable: may sleep
>
> I object to this as one of the purposes behind the clk API is to allow
> power savings to be made, and unless we can perform clk enable/disable
> from atomic contexts, the best you can do is enable the clock when the
> device is probed and disable it when it's released.
>
> For a lot of systems, modules are loaded at boot, and devices are probed
> at boot time.  They're never unloaded.
>
> This means that clocks will be enabled at boot time and never turned off.
>
> If you're lucky, there may be open/release methods which can be used to
> enable/disable the clock, which reduces the 'clock on' period down to
> the point where userspace opens/closes the device.  That's still
> insufficient and in some cases there aren't calls for this.
>
> Sometimes the only point that you know you need the clock enabled is when
> your driver has already been called in an atomic context.
>
> If such a requirement is imposed, it means that a driver would either have
> to leave the clock always on, or would have to drop such calls if the
> clock wasn't already enabled.

Perhaps we should factor the conventional clk_enable into two parts (say) :-
 a)  clk_setup  : Which does exactly what can't be done in atomic context.
                         Like setting PLLs i.e, if that needs to sleep.
b)  clk_enable : Everything else that gets the clock signals running.

The drivers could do clk_setup in probe/open and clk_enable right before the
the actual need of the clock. That way, drivers don't have to bother
with platform/clock
peculiarities while trying their best to save power.
Of course, power that can't be saved now, won't be saved then.

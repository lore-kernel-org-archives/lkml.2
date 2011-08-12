Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab1HLC7d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 22:59:33 -0400
Received: from smtp-out.google.com ([216.239.44.51]:46572 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282Ab1HLC7a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 22:59:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=OAxEQ39jWFkFTG/RafCVtZY26ORx1hJwgWsFDze54fXOsKI51soImtijqq50gLdn2
	frxg4+kgcg3ujYOnkb5fg==
MIME-Version: 1.0
In-Reply-To: <1313109916.19990.28.camel@finisterre.wolfsonmicro.main>
References: <1312586102-27907-1-git-send-email-swarren@nvidia.com>
	<CAMbhsRScgMaTZ2e3a__OgOrrA6HN9_dkGuuNGaEfP+iqRdjyNQ@mail.gmail.com>
	<20110806084805.GA18098@sirena.org.uk>
	<74CDBE0F657A3D45AFBB94109FB122FF04AEA24CC8@HQMAIL01.nvidia.com>
	<CAMbhsRR2+bhpjhGfUSt9M5tDk1EW2d70yC-tZy27zEgVqtkfSg@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF04AEA24D09@HQMAIL01.nvidia.com>
	<CAMbhsRTVm+dUODDgqiekpTrrNnpo9trJNNvOQ2ETCNkneh-L-g@mail.gmail.com>
	<1313109916.19990.28.camel@finisterre.wolfsonmicro.main>
Date: Thu, 11 Aug 2011 19:59:27 -0700
Message-ID: <CAMbhsRShLvyc2XKJAL8PwR0Uj4Pnp9rVt7QyK1qAVxJ-R2PSdQ@mail.gmail.com>
Subject: Re: [PATCH] i2c/tegra: I2C driver uses the suspend_noirq/resume_noirq
From: Colin Cross <ccross@google.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Stephen Warren <swarren@nvidia.com>, Ben Dooks <ben-linux@fluff.org>,
        Dilan Lee <dilee@nvidia.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 5:45 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Thu, 2011-08-11 at 14:43 -0700, Colin Cross wrote:
>> On Thu, Aug 11, 2011 at 2:09 PM, Stephen Warren <swarren@nvidia.com> wrote:
>
>> > Well, while that's true, the thing is the right way to handle it doesn't
>> > appear to exist at present.
>
>> Yes, but the maintainers have been asked to stop using one-off hacks
>> to fix everything that isn't supported in common code, and work
>> towards getting the common code fixed instead.  If the common code
>> maintainers say this is the best way to fix it for now, fine, but I'd
>> like to hear an opinion first.
>
> We've been through this quite a few times already at the driver core
> level, mostly in the context of PMIC probing. Fixing this properly
> requires some surgery on the core device model infrastructure which it's
> not realistic to expect driver authors to implement.
>
>> > So, in other words, how do you suggest I proceed with this?
>
>> device_pm_move_after(deva, devb) makes should make deva suspend before
>> devb.  Maybe subsystems that link multiple devices together should
>> call device_pm_move_after() to make sure that all of their devices
>> suspend before the parents of any of their devices?
>
> This wouldn't be a robust solution for bus independent subsystems as it
> doesn't maintain any sort of sorting - it just does a direct move so
> it'll only capture the last dependency we saw. If you've got two
> dependencies we could easily end up breaking things.
>
> For example with ASoC we'd sort all the components before the ASoC card
> without regard for their bus dependencies or any other dependencies they
> have (eg, their regulators). Since the ASoC card is a platform device
> it's likely to have registered early with no regard for where the buses
> the card needs are registered. I'd expect there's a reasonable chance
> it'll actually make things worse in the short term.

You can't just move everything after the card, you have to move
everything after the last device that was probed, and it only works if
nothing depends on any of the devices that are moved.

> I'll mail Ted and see if we can get this on the topic for KS, it's
> getting more and more serious.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

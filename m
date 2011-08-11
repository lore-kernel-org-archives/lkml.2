Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421Ab1HKVoO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 17:44:14 -0400
Received: from smtp-out.google.com ([216.239.44.51]:7107 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264Ab1HKVn6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 17:43:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=HzQtA7thNqqziCT5gSkjfXLSfHcHFHqDqSBqCv6zUqZiG4sZCvojp4xocOTy5DEZn
	fw1jyPFBbjzt2G6iQvtGA==
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF04AEA24D09@HQMAIL01.nvidia.com>
References: <1312586102-27907-1-git-send-email-swarren@nvidia.com>
	<CAMbhsRScgMaTZ2e3a__OgOrrA6HN9_dkGuuNGaEfP+iqRdjyNQ@mail.gmail.com>
	<20110806084805.GA18098@sirena.org.uk>
	<74CDBE0F657A3D45AFBB94109FB122FF04AEA24CC8@HQMAIL01.nvidia.com>
	<CAMbhsRR2+bhpjhGfUSt9M5tDk1EW2d70yC-tZy27zEgVqtkfSg@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF04AEA24D09@HQMAIL01.nvidia.com>
Date: Thu, 11 Aug 2011 14:43:55 -0700
Message-ID: <CAMbhsRTVm+dUODDgqiekpTrrNnpo9trJNNvOQ2ETCNkneh-L-g@mail.gmail.com>
Subject: Re: [PATCH] i2c/tegra: I2C driver uses the suspend_noirq/resume_noirq
From: Colin Cross <ccross@google.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ben Dooks <ben-linux@fluff.org>, Dilan Lee <dilee@nvidia.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 2:09 PM, Stephen Warren <swarren@nvidia.com> wrote:
> Colin Cross wrote at Thursday, August 11, 2011 2:51 PM:
>> Cc: Mark Brown; Ben Dooks; Dilan Lee; linux-i2c@vger.kernel.org; linux-tegra@vger.kernel.org; linux-
>> kernel@vger.kernel.org
>> Subject: Re: [PATCH] i2c/tegra: I2C driver uses the suspend_noirq/resume_noirq
>>
>> On Thu, Aug 11, 2011 at 12:35 PM, Stephen Warren <swarren@nvidia.com> wrote:
>> > Mark Brown wrote at Saturday, August 06, 2011 2:48 AM:
>> >> On Fri, Aug 05, 2011 at 09:33:31PM -0700, Colin Cross wrote:
>> > ...
>> >> > NAK - moving the suspend order around is not the correct way to solve
>> >> > this.  If wm8903 needs to talk to the i2c bus in its suspend handler,
>> >> > it needs to be child device on the i2c bus.  suspend_noirq is for
>> >>
>> >> WM8903 is an I2C device.  The problem is that it's suspended as part of
>> >> the ASoC suspend since the audio subsystem is composed of multiple
>> >> devices that all need to work together coherently.  I did start doing
>> >> some stuff to bodge around this like we do on probe but there are enough
>> >> system wide problems with this that it didn't seem worth the complexity
>> >> when the existing workarounds are so straightforward.
>> >
>> > Colin, given Mark's explanation, are you OK with the patch now?
>>
>> It's still not the right way to handle this, are you going to mark
>> every I2C controller as suspend_noirq?  What happens when you find an
>> I2C controller that needs its irq on to suspend?  These are the kinds
>> of hacks we've been asked not to do in ARM, so I'd like to see a
>> response from the I2C maintainers.
>
> Well, while that's true, the thing is the right way to handle it doesn't
> appear to exist at present.

Yes, but the maintainers have been asked to stop using one-off hacks
to fix everything that isn't supported in common code, and work
towards getting the common code fixed instead.  If the common code
maintainers say this is the best way to fix it for now, fine, but I'd
like to hear an opinion first.

> I did briefly try to move the entire ASoC suspend to early suspend (or
> something like that), but ran into a whole slew of issues, that I
> unfortunately don't recall right now. That would also impact every user
> of ASoC, not just Tegra...
>
> So, in other words, how do you suggest I proceed with this?

device_pm_move_after(deva, devb) makes should make deva suspend before
devb.  Maybe subsystems that link multiple devices together should
call device_pm_move_after() to make sure that all of their devices
suspend before the parents of any of their devices?

> Mark Brown wrote:
>> Unfortunately it's the only tool Linux has for dealing with this sort of
>> issue right now.  We were supposed to be getting support for telling the
>> PM core about dependencies but Linus didn't like that,
>
> Mark, can you fill in a little more detail; did Linus not like the concept
> of drivers registering dependencies on each-other, or was there a problem
> with the specific implementation that was proposed? I assume we're still a
> long way away from anything like that working. You also mentioned Grant's
> device registration retry stuff, but doesn't that only solve the initial
> probing, not shutdown/suspend dependencies, or do devices take locks on
> each-other to handle that too?
>
> Thanks.
>
> --
> nvpubilc
>
>

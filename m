Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab1AXUw4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 15:52:56 -0500
Received: from smtp-out.google.com ([74.125.121.67]:19390 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486Ab1AXUwz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 15:52:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=mBTnQ/a+EWxfppFF0aaQpRyic21ZEZ4xTBhICCk8ujGTC0b4sWEbiajHkYz3AalXvz
         POQkQcVlO+9XlmhnDYUg==
MIME-Version: 1.0
In-Reply-To: <20110124202610.GJ29925@opensource.wolfsonmicro.com>
References: <1295834493-5019-1-git-send-email-ccross@android.com>
	<1295834493-5019-21-git-send-email-ccross@android.com>
	<20110124144142.GA16813@sirena.org.uk>
	<AANLkTikrUdLM8VmW5yCndf927E=drZF1gGBwXq6Dj5mW@mail.gmail.com>
	<20110124193539.GI29925@opensource.wolfsonmicro.com>
	<AANLkTikOEm=watbA1G-SFK3PZrntDc+Wun84nGio=YKv@mail.gmail.com>
	<20110124202610.GJ29925@opensource.wolfsonmicro.com>
Date: Mon, 24 Jan 2011 12:52:51 -0800
X-Google-Sender-Auth: 9m-zJcHviwZfkR8mmixY7sYjJSk
Message-ID: <AANLkTinY5mJtC2fiV1iBnPbgwH9v3AmQQ7RR3pYJVACL@mail.gmail.com>
Subject: Re: [PATCH v2 20/28] ARM: tegra: cpufreq: Disable cpufreq during suspend
From: Colin Cross <ccross@android.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-tegra@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        konkers@android.com, linux-kernel@vger.kernel.org, olof@lixom.net,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 12:26 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Mon, Jan 24, 2011 at 11:52:12AM -0800, Colin Cross wrote:
>
>> Even _noirq isn't late enough, if cpufreq keeps trying to change the
>> frequency (and thus voltage) until sysdev suspend.
>
> If it were just cpufreq in isolation I'm not sure it'd be a big deal -
> nothing will go hideously wrong if it's ticking away by itself providing
> it's just governors working away providing the error handling is OK.
> However...
>
>> On Mon, Jan 24, 2011 at 11:35 AM, Mark Brown
>
>> > So you actively need to push the processor into low power mode during
>> > suspend?  I'm still not 100% clear what's triggering the issues you're
>
>> It's more of a voltage scaling issue than a cpufreq issue directly.
>> Tegra requires the voltage be set to nominal during resume, and the
>> only time it can be set for resume is before I2C suspends.  I handle
>> the problem with a suspend notifier in the latest version of the clock
>> voltage scaling patches, but I kept this patch to avoid cpufreq trying
>> to go to frequencies that are not supported by the suspend voltage.
>
> ...it sounds like you do actually have something of the above issue -
> but I think it's a generic-ish problem.  See below.
>
>> > Typically this stuff isn't a problem for regulators themselves since if
>> > they're active by the time I2C is off they normally get suspended by
>> > hardware handshakes from the CPU as that enters low power mode - right
>> > now we have no regulators at all in mainline that do anything in
>> > software on suspend.  We can get a long way by just ignoring what
>> > happens to regulators over suspend (there is some work to do here but
>> > it's orthogonal to this sort of issue).
>
>> The regulator driver itself has nothing to do, and when the CPU enters
>> its lowest power mode it signals the regulator to turn off, but
>> something needs to tell the regulator to go to the correct voltage.
>
> Normally that's handled by the same transition logic - the core PMIC
> will usually sequence a bunch of voltage and power status changes when
> entering its own low power mode and have a similar transition on resume
> which will ensure that the regulators power back up with a sane setup
> regardless of the state they were in beforehand.

I believe Tegra supports this mode, where the Tegra PMC can master the
I2C bus to control an external PMIC during resume, but I've never seen
it used.

> It sounds like for your systems what's happening is that the resume is
> restoring the previously configured voltages for the core rails rather
> than going to a known good state.  Is my understanding correct here?
> While your fix is good and I don't see any reason not to do it this does
> sound like something we should have a solution for in common code as I'd
> not be surprised if there were other hardware out there which did a
> similar thing.

Yes - the core can be connected to a dumb I2C regulator, which the
core can turn on and off with a request line, but can't control the
voltage without a regulator driver controlling the I2C bus.

> Assuming I'm not completely off base with the above it'd be good if you
> could clarify this in the commit message - there's enough dragons with
> this stuff and it's common to refer to other implementations so it'd be
> nice if we had a clear record of the issue in the log.

Will do

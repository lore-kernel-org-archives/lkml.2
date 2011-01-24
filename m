Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab1AXVZD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 16:25:03 -0500
Received: from smtp-out.google.com ([216.239.44.51]:7756 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab1AXVZB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 16:25:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=OLJ+l2fttjRTKUhlPov1xWOenvXk8CuFnd1QhlzgJMti7WbfX4tNrd44aINApoa+la
         cyh5G+V1/4/bRmrq3VYg==
MIME-Version: 1.0
In-Reply-To: <20110124210833.GK29925@opensource.wolfsonmicro.com>
References: <1295834493-5019-1-git-send-email-ccross@android.com>
	<1295834493-5019-21-git-send-email-ccross@android.com>
	<20110124144142.GA16813@sirena.org.uk>
	<AANLkTikrUdLM8VmW5yCndf927E=drZF1gGBwXq6Dj5mW@mail.gmail.com>
	<20110124193539.GI29925@opensource.wolfsonmicro.com>
	<AANLkTikOEm=watbA1G-SFK3PZrntDc+Wun84nGio=YKv@mail.gmail.com>
	<20110124202610.GJ29925@opensource.wolfsonmicro.com>
	<AANLkTinY5mJtC2fiV1iBnPbgwH9v3AmQQ7RR3pYJVACL@mail.gmail.com>
	<20110124210833.GK29925@opensource.wolfsonmicro.com>
Date: Mon, 24 Jan 2011 13:24:58 -0800
X-Google-Sender-Auth: ssq0cqouhZ3SHPS4QTkDeiRT-io
Message-ID: <AANLkTimK7vD6mrPXyRdx331mCnRNLnajCRONT=MzQHwW@mail.gmail.com>
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

On Mon, Jan 24, 2011 at 1:08 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Mon, Jan 24, 2011 at 12:52:51PM -0800, Colin Cross wrote:
>> On Mon, Jan 24, 2011 at 12:26 PM, Mark Brown
>
>> > Normally that's handled by the same transition logic - the core PMIC
>> > will usually sequence a bunch of voltage and power status changes when
>> > entering its own low power mode and have a similar transition on resume
>> > which will ensure that the regulators power back up with a sane setup
>> > regardless of the state they were in beforehand.
>
>> I believe Tegra supports this mode, where the Tegra PMC can master the
>> I2C bus to control an external PMIC during resume, but I've never seen
>> it used.
>
> In almost all cases it's implemented in the PMIC rather than the CPU -
> it's essentially the same logic as implements the initial power on of
> the system and the PMIC needs to be capable of starting the system boot
> without external assistance anyway, including sequencing the power up of
> the CPU.
>
> With most PMICs the settings will be hard coded into the silicon so
> you really need to get a PMIC specifically designed for whatever CPU
> you're using (this is one of the reasons you always see the same
> CPU/PMIC combinations, people are terrified of changing a known good
> pairing in case they build something that won't power on).  Some more
> modern PMICs make this configurable which gives system designers a lot
> more flexibility.

I'm seeing the opposite problem - changing CPUs, and keeping the PMIC.

> The PMC stuff is newer and in the designs I've seen is more focused on
> runtime management than this stuff.
>
>> > It sounds like for your systems what's happening is that the resume is
>> > restoring the previously configured voltages for the core rails rather
>> > than going to a known good state.  Is my understanding correct here?
>> > While your fix is good and I don't see any reason not to do it this does
>> > sound like something we should have a solution for in common code as I'd
>> > not be surprised if there were other hardware out there which did a
>> > similar thing.
>
>> Yes - the core can be connected to a dumb I2C regulator, which the
>> core can turn on and off with a request line, but can't control the
>> voltage without a regulator driver controlling the I2C bus.
>
> AIUI generally they end up working because whatever puts them into
> suspend actually resets them so when you release reset during resume
> they just recover whatever the default voltage they have is and normally
> the boot and resume conditions for the CPU are identical.  I could be
> off base there, most of the regulator API stuff has been done with
> integrated PMICs.

Resetting during suspend would be the sane thing to do, but that's not
what the hardware does.  The regulator also gets turned off during
idle, so it can't just be reset every time it turns off.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab1AXSu5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 13:50:57 -0500
Received: from smtp-out.google.com ([216.239.44.51]:41389 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562Ab1AXSu4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 13:50:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=CDmbb6kBY+jMua22qy/k+iiFMmIut/4/n90DmVHHywpMsYgdbdHgginnwHsTW+BAjC
         sKzDZalvH5I7JuFwyxfQ==
MIME-Version: 1.0
In-Reply-To: <20110124144142.GA16813@sirena.org.uk>
References: <1295834493-5019-1-git-send-email-ccross@android.com>
	<1295834493-5019-21-git-send-email-ccross@android.com>
	<20110124144142.GA16813@sirena.org.uk>
Date: Mon, 24 Jan 2011 10:50:53 -0800
X-Google-Sender-Auth: VgoP47vvUAoA1FYTaYz3-JNF3bY
Message-ID: <AANLkTikrUdLM8VmW5yCndf927E=drZF1gGBwXq6Dj5mW@mail.gmail.com>
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

On Mon, Jan 24, 2011 at 6:41 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Sun, Jan 23, 2011 at 06:01:25PM -0800, Colin Cross wrote:
>> Adds a SUSPEND_PREPARE notification hook to drop the frequency to
>> the lowest possible during suspend.  This prevents the cpufreq driver
>> from attempting regulator calls after suspend has started - the
>> regulator api can call into drivers that have already been suspended.
>
> Hrm, what's the situation where that happens and why does it cause
> problems?  The regulator API doesn't care if suspend is going on, and
> nor do any of the current drivers for regulators.  There is an issue
> with keeping things like I2C alive until the bitter end of suspend so
> you've got a control bus to the regulators but that's a generic issue
> which crops up with other subsystems too so a regulator-specific
> workaround seems dodgy.

The end result is that the regulator driver calls the i2c driver after
the i2c driver has been suspended.  On Tegra, this happens because of
voltage scaling on the CPU regulator, which can be on the i2c bus.  A
sleep in a suspend handler after the i2c bus has been suspended can
cause the cpufreq governor to lower the frequency, and try to lower
the voltage as well.

The problem isn't limited to i2c busses, there are some regulators on
spi busses.  You would need to ensure that any driver that has a
regulator consumer suspends before the regulator driver it
communicates with, and that still wouldn't fix cpufreq, which has a
sysdev suspend handler.

> The patch itself seems fine, it's just that it feels like there's
> something else going on.
>

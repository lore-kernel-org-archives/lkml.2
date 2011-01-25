Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab1AYMkK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 07:40:10 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:32888 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751682Ab1AYMkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 07:40:08 -0500
Date: Tue, 25 Jan 2011 12:40:05 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kmpark@infradead.org>, linux-tegra@vger.kernel.org,
        konkers@android.com, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        olof@lixom.net, Colin Cross <ccross@android.com>
Subject: Re: [PATCH v2 20/28] ARM: tegra: cpufreq: Disable cpufreq during
 suspend
Message-ID: <20110125124005.GB31453@opensource.wolfsonmicro.com>
References: <AANLkTinzXJ=PoSNEHAh1gCeH=2araVTvEB++9kcuUmes@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinzXJ=PoSNEHAh1gCeH=2araVTvEB++9kcuUmes@mail.gmail.com>
X-Cookie: You will soon forget this.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 07:56:19PM +0900, MyungJoo Ham wrote:

> Moreover, the suspend-related cpufreq issue gets worse with hibernation.
> Generally PMICs preserve their register values during suspend-to-mem;
> however, they lose the values with power-off (and hibernation).

That's interesting - hibernation has been a bit easier when I've looked
at this stuff precisely because it's equivalent to a cold boot, if the
PMIC weren't able to boot the CPU then us software engineers wouldn't
have to worry about any of this stuff :)

> In samsung SoCs, we have mitigated the issue by stopping cpufreq at pm_begin
> (could have a bit different name) and resume with end.  When stopping
> cpufreq, we have made it to fix at the boot freq so that we dont face into
> the inconsistency with hibernation.

> Sometimes, when we set voltages for the core, bus, and others, simply saving
> the whole things and restoring them does not work because the order how the
> voltages change may matter (and it does with some of Samsung SoCs). Thus, we
> made them to stop changing and fix at the boot-time default during suspend
> and hibernation.

The ordering matters greatly, this is the big part of what the PMIC
power sequencing is doing.  There's also often some handshaking going on
so the PMIC has to wait for the CPU at various points (with delays or
with explicit signals) in the process.

Just thinking about how we could address this in cpufreq is the major
issue that the CPU comes back from resume in a state other than that
which cpufreq remembered it being in or is the issue that the system
tries to restore old voltages as part of the resume process?  I guess
either way a feature in cpufreq which allows the driver to override the
governor-chosen configuration for suspend would provide a mechanism to
deal with the issue.

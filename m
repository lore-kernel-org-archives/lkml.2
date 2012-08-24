Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759658Ab2HXSxW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 14:53:22 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47106 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab2HXSxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 14:53:16 -0400
Message-ID: <5037CD99.8050700@wwwdotorg.org>
Date: Fri, 24 Aug 2012 12:53:13 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
CC: "olof@lixom.net" <olof@lixom.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] ARM: dt: tegra: harmony: add regulators
References: <1345186799-18229-1-git-send-email-ldewangan@nvidia.com> <502E9B09.3080800@wwwdotorg.org> <502EA1AC.4090205@wwwdotorg.org> <50327242.80103@nvidia.com> <50327897.5030601@wwwdotorg.org> <20120820175410.GI26991@opensource.wolfsonmicro.com> <50327D2D.6000509@wwwdotorg.org> <20120820181432.GJ26991@opensource.wolfsonmicro.com> <503283F8.4070808@wwwdotorg.org> <20120822190714.GF7995@opensource.wolfsonmicro.com>
In-Reply-To: <20120822190714.GF7995@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2012 01:07 PM, Mark Brown wrote:
> On Mon, Aug 20, 2012 at 12:37:44PM -0600, Stephen Warren wrote:
>> On 08/20/2012 12:14 PM, Mark Brown wrote:
> 
>>> Why not just pull the patch in via the regulator tree?  The
>>> idea of merging the entire regulator drivers branch into the
>>> Tegra tree doesn't seem awesome...
> 
>> I think that'd end up causing some annoying conflicts with other 
>> changes that also touch arch/arm/match-tegra/board-dt-tegra20.c. 
>> Perhaps they're manageable; they probably aren't that bad, but
>> it seems better to avoid them.
> 
> Ugh, right.  I guess I'd best rebase the commits out of the
> drivers branch.  Can you let me know what you depend on and I'll
> build a mergable branch for you to pull in?

I believe the only commit the Tegra tree might need is:

b93fffb regulator: tps6586x: add support for SYS rail

There is one other commit that touches this driver queued up for 3.7,
but I've validated that the two commits can merge together without any
conflicts, so I don't think we actually need this in the Tegra tree:

4c79c8d regulator: tps6586x: Convert to
regulator_[enable|disable|is_enabled|get_voltage_sel]_regmap

A few more notes on the overall situation:

a) As background, regulators on the Harmony board are broken in
v3.6-rc2, but fixed in v3.6-rc3. Specifically, commit 798bd59 "ARM:
tegra: more regulator fixes for Harmony" is required.

b) Even on top of v3.6-rc3, commit b93fffb "regulator: tps6586x: add
support for SYS rail" introduces a regression on Harmony. I did give a
Tested-by tag for this commit, but had tested it on a different board.
To fix this, the commit needs to also edit
arch/arm/mach-tegra/board-harmony-power.c and s/vdd_sys/REG-SYS/.

c) I tested all of next-20120822, regulator's for-next, and Tegra's
for-next. In all cases, if I fix the issues above, then merge Laxman's
change to instantiate all Harmony's regulators from DT, without
removing use of board-harmony-power.c, then all the regulator stuff
does in fact work OK; I had previously thought it didn't, but I
believe that was because of (a) and (b) above, not the .dts regulator
patch.

However, because the regulators are now registered from DT first, and
the regulator names in the DT are different to the regulator names in
board-harmony-power.c, Laxman's .dts regulator patch does break PCIe
on Harmony, since it can't obtain the regulators it needs.

Overall, I think the solution is as follows:

1) Remove b93fffb "regulator: tps6586x: add support for SYS rail" from
the regulator tree entirely.

2) Fix that patch to s/vdd_sys/REG-SYS/ in board-harmony-power.c, and
apply it to the Tegra tree.

3) Fix Laxman's regulator .dts patch to solve the PCIe problem,
possibly also remove board-harmony-power.c while we're at it, and
apply it to the Tegra tree.

If it makes life easier, I'm quite happy to move 4c79c8d "regulator:
tps6586x: Convert to
regulator_[enable|disable|is_enabled|get_voltage_sel]_regmap" to the
Tegra tree too. This might be useful; I know that Laxman has another
patch for the TPS6586x driver queued up to move the regulator-specific
DT parsing from the MFD driver into the regulator driver. I have no
idea, but it seems quite likely that would conflict with this patch,
and perhaps make everything easier to go through one tree?

An alternative would be:

1) Remove b93fffb "regulator: tps6586x: add support for SYS rail" from
the regulator tree since it causes a regression.

2) Fix that patch to s/vdd_sys/REG-SYS/ in board-harmony-power.c, and
re-apply it to its own branch in the regulator tree. It would be nice
to base this branch on v3.6-rc3 so Harmony regulators work before the
patch, so the patch can be checked for regressions.

3) Merge that branch into both regulator and Tegra.

4) Apply all future TPS6586x patches to the regulator tree.

5) Apply Laxman's patch to add Harmony regulators to the device tree
to the Tegra tree, after fixing the PCIe interaction issue.

Let me know which way you want to go. Sorry this driver is causing pain.

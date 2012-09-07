Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759481Ab2IGICm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 04:02:42 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2811 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758457Ab2IGICc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 04:02:32 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 07 Sep 2012 01:02:30 -0700
From: Alex Courbot <acourbot@nvidia.com>
To: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
CC: Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Leela Krishna Amudala <leelakrishna.a@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v5 1/4] Runtime Interpreted Power Sequences
Date: Fri, 7 Sep 2012 17:04:24 +0900
Message-ID: <1887927.1deN8M9siP@percival>
Organization: NVIDIA
User-Agent: KMail/4.9.1 (Linux/3.5.3-1-ARCH; KDE/4.9.1; x86_64; ; )
In-Reply-To: <201209061614.54022.heiko@sntech.de>
References: <1346412846-17102-1-git-send-email-acourbot@nvidia.com> <1346412846-17102-2-git-send-email-acourbot@nvidia.com> <201209061614.54022.heiko@sntech.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heiko,

On Thursday 06 September 2012 22:14:53 Heiko Stübner wrote:
> Hi Alexander,
> 
> Am Freitag, 31. August 2012, 13:34:03 schrieb Alexandre Courbot:
> > Some device drivers (panel backlights especially) need to follow precise
> > sequences for powering on and off, involving gpios, regulators, PWMs
> > with a precise powering order and delays to respect between each steps.
> > These sequences are board-specific, and do not belong to a particular
> > driver - therefore they have been performed by board-specific hook
> > functions to far.
> > 
> > With the advent of the device tree and of ARM kernels that are not
> > board-tied, we cannot rely on these board-specific hooks anymore but
> > need a way to implement these sequences in a portable manner. This patch
> > introduces a simple interpreter that can execute such power sequences
> > encoded either as platform data or within the device tree.
> > 
> > Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> 
> I really like this idea, also because I'll have to solve similar problems on
> the way to dt for my tinker-platform.

Glad to read that! :)

> For your power_seq_run function you write that it simply returns an error
> code on failure and looking through it I also just found the error return
> statement. This would leave a device half turned on.
> 
> So I'm wondering, if it shouldn't turn off all the things it turned on until
> the step that produced the error. All your possible step types (execpt the
> delay) are booleans, so it should be possible to simply negate them when
> backtracking through the previous steps.

Indeed, I think you raised an important point. Right now all step types are 
invertible, but we cannot rely on that statement to be true forever. For 
instance, one short-term improvement will be to allow finer regulator control, 
like voltage setting. In this case, how can we go back to the initial state 
without recording it?

If e.g. the power on sequence fails at step N (of M steps for that sequence), 
one could try playing the corresponding power off sequence (either completely 
of from step M - N), but then again we cannot rely on sequences to be 
perfectly symetrical. Maybe this is more something for the calling driver to 
check for and control?

Alex.


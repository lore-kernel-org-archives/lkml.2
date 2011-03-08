Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab1CHNiU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 08:38:20 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37049 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752786Ab1CHNiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 08:38:19 -0500
Date: Tue, 8 Mar 2011 13:38:17 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
        kyungmin.park@samsung.com, myungjoo.ham@gmail.com
Subject: Re: [PATCH] Regulator: add suspend-finish API for regulator core.
Message-ID: <20110308133817.GE20944@opensource.wolfsonmicro.com>
References: <1299549838-9821-1-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299549838-9821-1-git-send-email-myungjoo.ham@samsung.com>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 08, 2011 at 11:03:58AM +0900, MyungJoo Ham wrote:
> The regulator core had suspend-prepare that turns off the regulators
> when entering a system-wide suspend. However, it did not have
> suspend-finish that recovers the change made by suspend-prepare and
> depends on machine pm code or the regulator device or driver
> doing so.

This is a good idea, thanks for working on it.

Your commit message is sligtly inaccurate as this isn't what
suspend_prepare() is for, suspend_prepare() is for matching the suspend
mode configuration of regulators that support that with the suspend mode
Linux is using (RAM, disk and so on).  There is no need for this to
recover the pre-suspend state as hardware implementing suspend mode
configuration should be able to do so autonomously.

Of course not all hardware supports a distinct suspend mode and for
hardware that doesn't we should be doing pretty much this - it's a
bit of a hole in our regulator support at the minute.  It should really
be coupled with a soft suspend mode implementation which can put the
regulators into an appropriate state for suspend on the way down.

> +               if ((rdev->use_count > 0  || rdev->constraints->always_on) &&
> +                               rdev->desc->ops->enable) {
> +                       error = rdev->desc->ops->enable(rdev);
> +                       if (error)
> +                               ret = error;

We should probably also be turning off regulators that shouldn't be on -
a regulator may default to being enabled when we don't want it.
Thinking about it we can probably share most if not all of the code with
regulator_init_complete()...

Ideally we'd also restore voltages but that can always be added later.

> +       return ret;
> +}
> +EXPORT_SYMBOL_GPL(regulator_suspend_finish);

Hrm, I'd really expect the core to be arranging for this to happen
rather than exporting the function?  Though the sequencing so it gets
called at the right time might be a bit tricky and I've not actually
looked at the isues here.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab1L0Kcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 05:32:32 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53959 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753216Ab1L0Kcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 05:32:31 -0500
Date: Tue, 27 Dec 2011 10:32:28 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH] video: s3c-fb: Make runtime PM functional again
Message-ID: <20111227103227.GA2870@opensource.wolfsonmicro.com>
References: <1324911505-31715-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <000801ccc451$b3a853d0$1af8fb70$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000801ccc451$b3a853d0$1af8fb70$%han@samsung.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 27, 2011 at 01:40:47PM +0900, Jingoo Han wrote:

> > While this does make things simpler (the main motivation for the
> > original change) it will not only cause us to use more power in the
> > framebuffer controller but will also prevent us entering lower power
> > domain and SoC wide states as we can never power down the domain
> > containing the device.  Since neither of these things is desirable
> > revert the change.

> The main difference is as follows:
> If no fb windows are opened.
> 	- Your patch: LCD block power is off
> 	- My patch: LCD block power is on still.

By holding the LCD block power on your patch will also prevent the SoC
using lower power modes like STOP and DEEP-STOP on the S3C6410.

> However, after booting, probing, open is called from platform system, soon.
> And, the default window is always opened. This means that at least one window

This only happens if you enable CONFIG_FRAMEBUFFER_CONSOLE as that
causes the console code to become a framebuffer client.

> is opened after booting. So, I don't think that "video: s3c-fb: modify runtime
> pm functions" (commit: 35784b) cause us to use more power in the framebuffer
> controller.

If the console isn't using the framebuffer then whenever userspace
releases we'll be able to runtime suspend the framebuffer.  This isn't
ideal as what userspace expects is that it can hold the device open and
use blanking to save power - I'm working on patches to do this - but
it's a start.

> My intention is that runtime pm is used only for LCD block power off when
> suspend and resume are called.

This isn't runtime PM at all, it's system PM which for some reason calls
runtime PM functions.  At best the runtime PM calls won't do anything as
they're inhibited during system PM.

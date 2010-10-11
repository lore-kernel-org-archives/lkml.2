Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113Ab0JKSvv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 14:51:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54884 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754393Ab0JKSvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 14:51:50 -0400
Date: Mon, 11 Oct 2010 19:51:48 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Peter Ujfalusi <peter.ujfalusi@nokia.com>,
        Jassi Brar <jassi.brar@samsung.com>, alsa-devel@alsa-project.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] ASoC: soc: snprintf() doesn't return negative
Message-ID: <20101011185148.GB22355@opensource.wolfsonmicro.com>
References: <20101011035416.GD5851@bicker> <20101011104009.GB9231@rakim.wolfsonmicro.main> <20101011164038.GE5851@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101011164038.GE5851@bicker>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 11, 2010 at 06:40:38PM +0200, Dan Carpenter wrote:
> On Mon, Oct 11, 2010 at 11:40:09AM +0100, Mark Brown wrote:

> > I'm not going to apply this. snprintf() returns a signed type, checking
> > that the return value is a reasonable thing to do here - at worst we're
> > wasting a few cycles in code that's nowhere near a hot path, at best
> > we're robust in the face of a decision to add error reporting to
> > snprintf() so it's hard to see this change as an improvement.

> It's not a matter of cycles.  My check probably takes the exact same
> number of cycles as your check.  The point is that checking for negative
> doesn't make any sort of sense.  If we did return an error code then we

Remember that we also have to be able to read the code; it's probably
safe to assume that not everyone has the quirks of every snprintf()
implementation committed to memory.  Except for the microoptimisation
all you're doing here is making the code harder to read.

> If "PAGE_SIZE - ret" is a negative number then it triggers a
> WARN_ON_ONCE() in vsnprintf().  It's not possible in this case however.
> Really the original code works fine in practice because the information
> we are printing out is less than PAGE_SIZE.

In actual fact quite a few devices have enough registers to be
truncated, meaning that it's not only possible but likely we'll exercise
the cases that deal with the end of buffer.  If snprintf() is returning
values larger than buffer size it was given we're likely to have an
issue but it seems that there's something missing in your analysis since
we're never seeing WARN_ON()s and are instead seeing the behaviour the
code is intended to give, which is to truncate the output when we run
out of space.

Could you re-check your analysis, please?

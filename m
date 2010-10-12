Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184Ab0JLJfN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 05:35:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43080 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932097Ab0JLJfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 05:35:10 -0400
Date: Tue, 12 Oct 2010 10:35:07 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Dan Carpenter <error27@gmail.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Jaroslav Kysela <perex@perex.cz>,
        Peter Ujfalusi <peter.ujfalusi@nokia.com>,
        Jassi Brar <jassi.brar@samsung.com>, alsa-devel@alsa-project.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] ASoC: soc: snprintf() doesn't return negative
Message-ID: <20101012093506.GB30933@rakim.wolfsonmicro.main>
References: <20101011035416.GD5851@bicker>
 <20101011104009.GB9231@rakim.wolfsonmicro.main>
 <20101011164038.GE5851@bicker>
 <20101011185148.GB22355@opensource.wolfsonmicro.com>
 <20101011194502.GK5851@bicker>
 <s5hpqvg1m7v.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hpqvg1m7v.wl%tiwai@suse.de>
X-Cookie: Words must be weighed, not counted.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 11, 2010 at 10:57:40PM +0200, Takashi Iwai wrote:
> Dan Carpenter wrote:

> Well, actually we should fix either:

> - check the return of snprintf() at each time properly,
> 
> 	list_for_each_entry(dai, &dai_list, list) {
> 		int len = snprintf(buf + ret, PAGE_SIZE - ret, "%s\n", dai->name);
> 		if (len < 0)
> 			return len;
> 		ret += len;
> 	}

In this case we're deliberately eating the error since all these files
are about getting diagnostics out - the code is intentionally soldiering
on and trying to get as much data out as possible rather than giving up
on error.

> In either case, a negative check after for loop is superfluous.

In those ones, yes - it's pretty much there for paranoia since the copy
to userspace is more likely to explode than random memory corruption.

> And, when no negative return value is assured (or filtered out like
> above), there can't be overflow, too.  snprintf() fills the string
> at most the size including NUL-char.  OTOH, it returns the size that
> doesn't include NUL-char.

Dan was saying that it would return sizes larger than the string it
wrote (which is a behaviour of some implementations) which would be
an issue since it would cause us to pass bad buffer pointers into
subsequent snprintf() calls.

I've not had time to look at this properly but Dan's analysis seems off.

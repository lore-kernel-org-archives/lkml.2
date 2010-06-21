Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718Ab0FUXnU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 19:43:20 -0400
Received: from helicon.mas.viperplatform.net.au ([202.147.75.21]:50571 "EHLO
	helicon.mas.viperplatform.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758379Ab0FUXnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 19:43:19 -0400
Date: Tue, 22 Jun 2010 09:43:14 +1000
From: Stuart Longland <redhatter@gentoo.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: ALSA Development List <alsa-devel@alsa-project.org>,
       Takashi Iwai <tiwai@suse.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ASoC: Add new TI TLV320AIC3204 CODEC driver
Message-ID: <20100621234314.GZ7759@www.longlandclan.yi.org>
References: <1276833465-31702-1-git-send-email-redhatter@gentoo.org>
 <1276899876-19001-1-git-send-email-redhatter@gentoo.org>
 <20100619011221.GC2463@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100619011221.GC2463@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 19, 2010 at 02:12:21AM +0100, Mark Brown wrote:
> On Sat, Jun 19, 2010 at 08:24:36AM +1000, Stuart Longland wrote:
> > +	/* Page 1 */
> > +	if (page == 1) {
> > +		if (reg <= 4)
> > +			return 1;
> 
> I can't help but think that this'd be more legible with switch ()
> statements (GCC has an extension for ranges in switch statements which
> you could use).

I gave this some further thought... I'm not certain that a switch
statement is going to be much clearer.  There are two ways I can tackle
this.

One is to go on a page-by-page basis, which is how I do it using the if
statements.  Here; I define my ranges so that I start from the very
end... anything beyond page 70 is invalid ... voila, I eliminate those
early on.  A number of pages have a similar register pattern, and so I
make use of nested if statements to explain this.  The if block for
pages following always use the block before to define the upper,
non-inclusive bound.

The register tests start from register 0.  I could perhaps reverse the
outer ifs to start at page 0 and work forwards too... but I instead work
backwards from page 70.

I exit the function as early as possible to skip unneeded checks, as
soon as I know a range is valid or not, I return 1 or 0.  Perhaps the 1
or 0 could be made clearer (a couple of #defines maybe?) but to me, it
looks fairly clear.

I could use switch statements to replace some or all of the if
statements.  There'd be a small benefit I suppose in making the outer if
statements a switch, but little anywhere else from what I can see.

The other way is that I ignore pages completely; and use the
AIC3204_PGREG macro to define ranges of absolute register addresses.
This may have a small benefit in speed since these are compiled in... as
opposed to runtime masking/shifting, but I don't see that being much
clearer either.  I'd still come to a case statement, then return.

This is a function largely intended for debugging, in fact, I'm thinking
I should probably wrap it in #ifdef CONFIG_DEBUG_FS, since the function
isn't called unless debugfs is enabled.  So I'm not certain that
performance is worth chasing here given the intended purpose -- it's not
something that's called all the time, nor something that will be used in
a production environment.

That's my thoughts on the issue, perhaps naïve, but I'm not sure
there's any real gain in refactoring this.
-- 
Stuart Longland (aka Redhatter, VK4MSL)      .'''.
Gentoo Linux/MIPS Cobalt and Docs Developer  '.'` :
. . . . . . . . . . . . . . . . . . . . . .   .'.'
http://dev.gentoo.org/~redhatter             :.'

I haven't lost my mind...
  ...it's backed up on a tape somewhere.

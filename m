Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165Ab2GYGgb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 02:36:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55894 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab2GYGga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 02:36:30 -0400
Date: Tue, 24 Jul 2012 23:36:24 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Baodong Chen <chenbdchenbd@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fixed a macro coding style issue
Message-ID: <20120725063624.GA6546@core.coreip.homeip.net>
References: <no>
 <1343193656-2643-1-git-send-email-chenbdchenbd@gmail.com>
 <20120725053755.GA2100@core.coreip.homeip.net>
 <20120725061512.GB6481@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120725061512.GB6481@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 07:15:12AM +0100, Al Viro wrote:
> On Tue, Jul 24, 2012 at 10:37:55PM -0700, Dmitry Torokhov wrote:
> > On Wed, Jul 25, 2012 at 01:20:56PM +0800, Baodong Chen wrote:
> > > Fixed a coding style issue in driver/input/input.c
> > > 
> > > Signed-off-by: Baodong Chen <chenbdchenbd@gmail.com>
> > > ---
> > >  drivers/input/input.c |    6 ++++--
> > >  1 files changed, 4 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/input/input.c b/drivers/input/input.c
> > > index 8921c61..c96e983 100644
> > > --- a/drivers/input/input.c
> > > +++ b/drivers/input/input.c
> > > @@ -845,11 +845,13 @@ int input_set_keycode(struct input_dev *dev,
> > >  EXPORT_SYMBOL(input_set_keycode);
> > >  
> > >  #define MATCH_BIT(bit, max) \
> > > +	do { \
> > >  		for (i = 0; i < BITS_TO_LONGS(max); i++) \
> > >  			if ((id->bit[i] & dev->bit[i]) != id->bit[i]) \
> > >  				break; \
> > > -		if (i != BITS_TO_LONGS(max)) \
> > > -			continue;
> > > +			if (i != BITS_TO_LONGS(max)) \
> > > +				continue; \
> > > +	} while (0)
> > 
> > This changes semantics. While current implementation of MATCH_BIT might
> > not be great style, it is not supposed to be used outside of
> > input_match_device(), and the replacement is completely broken.
> 
> Replacement is certainly completely broken, but "might not be great style"
> is quite an understatement.  Everything else aside, it's too obfuscated
> and ugly for anything outside of IOCCC and too verbose for IOCCC.
> 
> Damnit, at least turn that into
> static inline int is_subset(unsigned long *bitmap1, unsigned long *bitmap2, size_t bits)
> {
> 	int i;
> 	for (i = BITS_TO_LONGS(bits); i; bitmap1++, bitmap2++, i--)
> 		if ((*bitmap1 & *bitmap2) != *bitmap1)
> 			return 0;
> 	return 1;
> }
> and just before your loop
> /* ignore ones that don't have bits required by id */
> #define MATCH_BIT(array, bits) if (!is_subset(id->array, dev->array, bits)) continue;

Hmm, we already have bitmap_subset(), I think we can simply use it.

> with #undef MATCH_BIT right after the loop, to make it damn clean that it's local.
> And frankly, I'd consider expanding that variant and killing the macro off.
> Macros that affect control flow are vile and actively confusing for reader.

I agree. In my defense it is quite old code...

-- 
Dmitry

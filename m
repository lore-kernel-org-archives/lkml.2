Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab1HIRoX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 13:44:23 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:47003 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146Ab1HIRoW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 13:44:22 -0400
MIME-Version: 1.0
Message-ID: <747e657f-24be-41ed-a251-36116c8a6a13@default>
Date: Tue, 9 Aug 2011 10:43:16 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Jan Beulich <JBeulich@novell.com>
Cc: hannes@cmpxchg.org, jackdachef@gmail.com, hughd@google.com,
        jeremy@goop.org, npiggin@kernel.dk, linux-mm@kvack.org,
        akpm@linux-foundation.org, sjenning@linux.vnet.ibm.com,
        Chris Mason <chris.mason@oracle.com>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Kurt Hackel <kurt.hackel@oracle.com>, riel@redhat.com,
        ngupta@vflare.org, linux-kernel@vger.kernel.org, matthew@wil.cx
Subject: RE: Subject: [PATCH V6 1/4] mm: frontswap: swap data structure
 changes
References: <20110808204555.GA15850@ca-server1.us.oracle.com>
 <4E414320020000780005057E@nat28.tlf.novell.com><4E414320020000780005057E@nat28.tlf.novell.com>
 <ce8cba73-ec3c-42ae-849a-11db1df8ffa3@default
 4E4179D90200007800050676@nat28.tlf.novell.com>
In-Reply-To: <4E4179D90200007800050676@nat28.tlf.novell.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090206.4E4171C7.007B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Jan Beulich [mailto:JBeulich@novell.com]
> Subject: RE: Subject: [PATCH V6 1/4] mm: frontswap: swap data structure changes
> 
> >>> On 09.08.11 at 17:03, Dan Magenheimer <dan.magenheimer@oracle.com> wrote:
> >> > --- linux/include/linux/swap.h	2011-08-08 08:19:25.880690134 -0600
> >> > +++ frontswap/include/linux/swap.h	2011-08-08 08:59:03.952691415 -0600
> >> > @@ -194,6 +194,8 @@ struct swap_info_struct {
> >> >  	struct block_device *bdev;	/* swap device or bdev of swap file */
> >> >  	struct file *swap_file;		/* seldom referenced */
> >> >  	unsigned int old_block_size;	/* seldom referenced */
> >>
> >> #ifdef CONFIG_FRONTSWAP
> >>
> >> > +	unsigned long *frontswap_map;	/* frontswap in-use, one bit per page */
> >> > +	unsigned int frontswap_pages;	/* frontswap pages in-use counter */
> >>
> >> #endif
> >>
> >> (to eliminate any overhead with that config option unset)
> >>
> >> Jan
> >
> > Hi Jan --
> >
> > Thanks for the review!
> >
> > As noted in the commit comment, if these structure elements are
> > not put inside an #ifdef CONFIG_FRONTSWAP, it becomes
> > unnecessary to clutter the core swap code with several ifdefs.
> > The cost is one pointer and one unsigned int per allocated
> > swap device (often no more than one swap device per system),
> > so the code clarity seemed more important than the tiny
> > additional runtime space cost.
> >
> > Do you disagree?
> 
> Not necessarily - I just know that in other similar occasions (partly
> internally to our company) I was asked to make sure turned off
> features would not leave *any* run time foot print whatsoever.
> 
> Jan

Well I tried adding the ifdef to the structure as you suggested
and it requires three instances of "#ifdef CONFIG_FRONTSWAP"
in mm/swapfile.c.  BUT unless I get into massive code duplication
it still leaves a runtime footprint as extra parameters are passed
to enable_swap_info(), try_to_unuse(), and find_next_to_unuse();
so the intent to achieve zero runtime footprint is illusory.
I expect "absolutely zero runtime footprint" is a goal that very
very few significant new features achieve.

That said, frontswap and cleancache are designed so that they
SHOULD be config=y by default for most distros.  Unless a
module (e.g. zcache or tmem) registers the callbacks, the
overhead is very nearly zero... but if they are config=n,
then a module cannot use them at all.  This would be unfortunate
because the potential performance gain is not insignificant.
I would have preferred them to be merged with default of config=y,
but Linus disabused me of that notion :-}

Anyway, unless you feel very strongly about this, I'm
inclined to not add the ifdef to the struct for the
reasons previously stated.

Dan

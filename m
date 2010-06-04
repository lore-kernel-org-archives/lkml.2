Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab0FDINd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 04:13:33 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38695 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752902Ab0FDINa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 04:13:30 -0400
Date: Fri, 4 Jun 2010 10:13:22 +0200
From: Borislav Petkov <bp@alien8.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Changli Gao <xiaosuo@gmail.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] fs: optimize mpage_readpage()
Message-ID: <20100604081322.GA31027@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Al Viro <viro@ZenIV.linux.org.uk>, Changli Gao <xiaosuo@gmail.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1275095926-18345-1-git-send-email-xiaosuo@gmail.com>
 <20100529121019.GA25092@liondog.tnic>
 <20100604071906.GC31073@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100604071906.GC31073@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ZenIV.linux.org.uk>
Date: Fri, Jun 04, 2010 at 08:19:06AM +0100

> On Sat, May 29, 2010 at 02:10:19PM +0200, Borislav Petkov wrote:
> > > -	struct bio *bio = NULL;
> > > +	struct bio *bio;
> > >  	sector_t last_block_in_bio = 0;
> > >  	struct buffer_head map_bh;
> > >  	unsigned long first_logical_block = 0;
> > >  
> > >  	map_bh.b_state = 0;
> > >  	map_bh.b_size = 0;
> > > -	bio = do_mpage_readpage(bio, page, 1, &last_block_in_bio,
> > > +	bio = do_mpage_readpage(NULL, page, 1, &last_block_in_bio,
> > >  			&map_bh, &first_logical_block, get_block);
> > >  	if (bio)
> > >  		mpage_bio_submit(READ, bio);
> > 
> > Nope, I don't think that's a good idea.
> > 
> > On the one hand, this is a trick to shut up gcc:
> > 
> > fs/mpage.c: In function ???mpage_readpage???:
> > fs/mpage.c:419: warning: ???bio??? is used uninitialized in this function
> 
> File a bug against your version of gcc, then.  The very first operation
> involving bio is assignment to it; if gcc complains about that, it's
> extremely fscked up.
> 
> Said that, I don't see how could that be an optimization.  Recent gcc is
> apparently b0rken in dead stores elimination, but that seems to be
> triggered by passing address of variable to another function later on [1];
> nothing of that kind happens here.
> 
> [1] gcc 4.3 and later (at least) fails to eliminate the first assignment in
> int foo(void)
> {
> 	extern int f(void);
> 	extern int g(int *);
> 	int x;
> 	x = 0;
> 	x = f();
> 	return g(&x);
> }
> with any optimization level (and apparently on any target).

Right, the uninitialized warning above happens when you remove the NULL
assignment, i.e.

struct bio *bio;

...

bio = do_mpage_readpage(bio, ...)

I was trying to prove a point and obviously failed :). Thanks for
correcting me.

But this would normally be a false warning, similar to the one you
describe above - passing an address to a function even though the
function itself only writes to the variable at that address. Most
prominent example

u32 val;

..

pci_read_config_dword(..., &val);

This triggers at a couple of places in arch/x86/ with 2.6.35-rc1. For
example, see <arch/x86/kernel/quirks.c:ati_ixp4x0_rev()>, the u32 d
variable. And see also nvidia_force_enable_hpet() below where gcc is
being shut up with

u32 uninitialized_var(val);

But(!), in the mpage_readpage(), bio _absolutely_ has to be NULL because
it is checked if being so later in do_mpage_readpage(), so this one is a
complete different story.

To cut a long story short, you're correct, gcc is b0rked when warning
about passing addresses of variables to functions which only write to
them.

Such a warning might be valid if the variable doesn't have storage
allocated to it or if the receiving function reads it uninitialized but
I guess gcc can't "see" that across functions... Hmmm...

-- 
Regards/Gruss,
    Boris.

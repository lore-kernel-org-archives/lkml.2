Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab0FDHTL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 03:19:11 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50267 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab0FDHTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 03:19:09 -0400
Date: Fri, 4 Jun 2010 08:19:06 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Borislav Petkov <bp@alien8.de>, Changli Gao <xiaosuo@gmail.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] fs: optimize mpage_readpage()
Message-ID: <20100604071906.GC31073@ZenIV.linux.org.uk>
References: <1275095926-18345-1-git-send-email-xiaosuo@gmail.com>
 <20100529121019.GA25092@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100529121019.GA25092@liondog.tnic>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 29, 2010 at 02:10:19PM +0200, Borislav Petkov wrote:
> > -	struct bio *bio = NULL;
> > +	struct bio *bio;
> >  	sector_t last_block_in_bio = 0;
> >  	struct buffer_head map_bh;
> >  	unsigned long first_logical_block = 0;
> >  
> >  	map_bh.b_state = 0;
> >  	map_bh.b_size = 0;
> > -	bio = do_mpage_readpage(bio, page, 1, &last_block_in_bio,
> > +	bio = do_mpage_readpage(NULL, page, 1, &last_block_in_bio,
> >  			&map_bh, &first_logical_block, get_block);
> >  	if (bio)
> >  		mpage_bio_submit(READ, bio);
> 
> Nope, I don't think that's a good idea.
> 
> On the one hand, this is a trick to shut up gcc:
> 
> fs/mpage.c: In function ???mpage_readpage???:
> fs/mpage.c:419: warning: ???bio??? is used uninitialized in this function

File a bug against your version of gcc, then.  The very first operation
involving bio is assignment to it; if gcc complains about that, it's
extremely fscked up.

Said that, I don't see how could that be an optimization.  Recent gcc is
apparently b0rken in dead stores elimination, but that seems to be
triggered by passing address of variable to another function later on [1];
nothing of that kind happens here.

[1] gcc 4.3 and later (at least) fails to eliminate the first assignment in
int foo(void)
{
	extern int f(void);
	extern int g(int *);
	int x;
	x = 0;
	x = f();
	return g(&x);
}
with any optimization level (and apparently on any target).

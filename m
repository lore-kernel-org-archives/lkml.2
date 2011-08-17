Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870Ab1HQAcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 20:32:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5024 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752592Ab1HQAcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 20:32:08 -0400
Date: Tue, 16 Aug 2011 20:31:39 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: Oops in minixfs_statfs
Message-ID: <20110817003138.GF2227@zod.bos.redhat.com>
References: <20110816164809.GE2227@zod.bos.redhat.com>
 <CAEKwDSC+dKrNWnCZ+VSszuHZL3g=Upr8wSO32r5a8o9Ty0mtTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEKwDSC+dKrNWnCZ+VSszuHZL3g=Upr8wSO32r5a8o9Ty0mtTg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 06:20:05PM -0400, Bob Copeland wrote:
> On Tue, Aug 16, 2011 at 12:48 PM, Josh Boyer <jwboyer@redhat.com> wrote:
> > it seems we're getting a negative number in this particular calculation
> > in fs/minix/bitmap.c, count_free:
> >
> >        i = ((numbits - (numblocks-1) * bh->b_size * 8) / 16) * 2;
> [...]
> > I'm not familiar enough with minixfs to know what the above is trying to
> > actually accomplish.  I instrumented that function a bit and here is
> > some data from the 3 filesytems in question:
> 
> I don't know minix either but I'll take a shot.  This is trying to
> count the number of bits in the free map for inodes or data blocks
> that don't fit in a full file system block.
> 
> count_free takes 3 params:
>   map - an array of buffer heads that represent the free map for a 'thingy'
>         (thingy being the technical term for inode, or data block)
>   numblocks - the number of blocks to scan
>   numbits - the maximum-valued thingy
> 
> So, for example, there might be 4800 inodes in the filesystem.  That
> means there are 4800/8 = 600 bits to represent their in-use state,
> and supposing a buffer head represents a 512-byte buffer (bh->b_size=512),
> you would need two blocks to store that.  numblocks in this hypothetical
> example is 2 and numbits is 4801.

Yep, I gathered that.  In the real case, there are 7 blocks, and the
block size of the fs is 4096.  Though numbits still seems to be "maximum
number of blocks" based on the value and what is being passed to
count_free.

> Here's some annotated code with uninteresting parts removed:
> 
> Loop over all but the last block:
> 
> 	for (i=0; i<numblocks-1; i++) {
> 			sum += nibblemap[bh->b_data[j] & 0xf]
> 				+ nibblemap[(bh->b_data[j]>>4) & 0xf];
> 	}
> 
> Since we're counting zero bits this is just computing hweight(~x)...
> 
> 	if (numblocks==0 || !(bh=map[numblocks-1]))
> 		return(0);
> 
> Lookout, bh is assigned in the conditional!
> 
> Ok so bh is the last block which might not be full of thingys, so
> we only want to look at the part that has thingys and not the rest.
> 
> numblocks - 1 * bh->b_size * 8 is the number of bits we've already
> looked at.  We'll call it nthingys.  numbits - nthingys is the number
> of bits we want to continue to look at.  "(x / 16) * 2 is a fancy way

Yes, except here numbits - nthingys winds up being a negative number in
the failing case.

> of saying "x / 8" except the result is on 2-byte boundaries.  So that's
> the number of bytes left to look at, except for up to 15 possible
> extra bits.
> 
> 	i = ((numbits - (numblocks-1) * bh->b_size * 8) / 16) * 2;
> 	for (j=0; j<i; j++) {
> 		sum += nibblemap[bh->b_data[j] & 0xf]
> 			+ nibblemap[(bh->b_data[j]>>4) & 0xf];
> 	}

And we blow up in here somewhere.

> And then count the remaining 15 bits by masking off whatever portion
> is less than numbits and doing some fancy u16 casting.
> 
> 	i = numbits%16;
> 	if (i!=0) {
> 		i = *(__u16 *)(&bh->b_data[j]) | ~((1<<i) - 1);
> 		sum += nibblemap[i & 0xf] + nibblemap[(i>>4) & 0xf];
> 		sum += nibblemap[(i>>8) & 0xf] + nibblemap[(i>>12) & 0xf];
> 	}
> 
> 	return(sum);
> }
> 
> Does that help?

It helps me understand what the code is doing a bit better, yes.  Thank
you for that.  Unfortunately, it doesn't really tell me why we get a
negative number in this case, and if we should be checking for that here
and what to do about it.

josh

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417Ab1HPWUK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 18:20:10 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:59202 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab1HPWUI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 18:20:08 -0400
MIME-Version: 1.0
In-Reply-To: <20110816164809.GE2227@zod.bos.redhat.com>
References: <20110816164809.GE2227@zod.bos.redhat.com>
Date: Tue, 16 Aug 2011 18:20:05 -0400
X-Google-Sender-Auth: B4lZ5TI6K0LsqpQqjd_cbmcb-6U
Message-ID: <CAEKwDSC+dKrNWnCZ+VSszuHZL3g=Upr8wSO32r5a8o9Ty0mtTg@mail.gmail.com>
Subject: Re: Oops in minixfs_statfs
From: Bob Copeland <me@bobcopeland.com>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 12:48 PM, Josh Boyer <jwboyer@redhat.com> wrote:
> it seems we're getting a negative number in this particular calculation
> in fs/minix/bitmap.c, count_free:
>
>        i = ((numbits - (numblocks-1) * bh->b_size * 8) / 16) * 2;
[...]
> I'm not familiar enough with minixfs to know what the above is trying to
> actually accomplish.  I instrumented that function a bit and here is
> some data from the 3 filesytems in question:

I don't know minix either but I'll take a shot.  This is trying to
count the number of bits in the free map for inodes or data blocks
that don't fit in a full file system block.

count_free takes 3 params:
  map - an array of buffer heads that represent the free map for a 'thingy'
        (thingy being the technical term for inode, or data block)
  numblocks - the number of blocks to scan
  numbits - the maximum-valued thingy

So, for example, there might be 4800 inodes in the filesystem.  That
means there are 4800/8 = 600 bits to represent their in-use state,
and supposing a buffer head represents a 512-byte buffer (bh->b_size=512),
you would need two blocks to store that.  numblocks in this hypothetical
example is 2 and numbits is 4801.

Here's some annotated code with uninteresting parts removed:

Loop over all but the last block:

	for (i=0; i<numblocks-1; i++) {
			sum += nibblemap[bh->b_data[j] & 0xf]
				+ nibblemap[(bh->b_data[j]>>4) & 0xf];
	}

Since we're counting zero bits this is just computing hweight(~x)...

	if (numblocks==0 || !(bh=map[numblocks-1]))
		return(0);

Lookout, bh is assigned in the conditional!

Ok so bh is the last block which might not be full of thingys, so
we only want to look at the part that has thingys and not the rest.

numblocks - 1 * bh->b_size * 8 is the number of bits we've already
looked at.  We'll call it nthingys.  numbits - nthingys is the number
of bits we want to continue to look at.  "(x / 16) * 2 is a fancy way
of saying "x / 8" except the result is on 2-byte boundaries.  So that's
the number of bytes left to look at, except for up to 15 possible
extra bits.

	i = ((numbits - (numblocks-1) * bh->b_size * 8) / 16) * 2;
	for (j=0; j<i; j++) {
		sum += nibblemap[bh->b_data[j] & 0xf]
			+ nibblemap[(bh->b_data[j]>>4) & 0xf];
	}

And then count the remaining 15 bits by masking off whatever portion
is less than numbits and doing some fancy u16 casting.

	i = numbits%16;
	if (i!=0) {
		i = *(__u16 *)(&bh->b_data[j]) | ~((1<<i) - 1);
		sum += nibblemap[i & 0xf] + nibblemap[(i>>4) & 0xf];
		sum += nibblemap[(i>>8) & 0xf] + nibblemap[(i>>12) & 0xf];
	}

	return(sum);
}

Does that help?

-- 
Bob Copeland %% www.bobcopeland.com

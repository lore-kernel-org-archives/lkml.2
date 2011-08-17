Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab1HQCSX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 22:18:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60564 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab1HQCSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 22:18:22 -0400
Date: Wed, 17 Aug 2011 03:18:20 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Josh Boyer <jwboyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Oops in minixfs_statfs
Message-ID: <20110817021820.GU2203@ZenIV.linux.org.uk>
References: <20110816164809.GE2227@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110816164809.GE2227@zod.bos.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 12:48:09PM -0400, Josh Boyer wrote:
> We've had a bug open in Fedora for a while[1] where it's fairly easy to
> generate an oops on a MinixV3 filesystem.  I've looked at it a bit and
> it seems we're getting a negative number in this particular calculation
> in fs/minix/bitmap.c, count_free:
> 
> 	i = ((numbits - (numblocks-1) * bh->b_size * 8) / 16) * 2;
> 
> which causes the loop below it to access bh->b_data outside it's bounds.
> 
> I installed minix 3.1.8 (shoot me now) in a KVM guest today, and two out
> of the three filesystems work fine.  / and /home are both relatively
> small, and a df seems to return fairly accurate numbers.  However, a df
> on /usr (which is ~768M) causes the oops.
> 
> I'm not familiar enough with minixfs to know what the above is trying to
> actually accomplish.  I instrumented that function a bit and here is
> some data from the 3 filesytems in question:
> 
> [   49.114984] imap_blocks 2 zmap_blocks 1 firstdatazone 205
> log_zone_size 0 max_size 7fffffff magic 4d5a nzones 4000 blocksize: 1000
> 
> [   66.380824] imap_blocks 2 zmap_blocks 2 firstdatazone 2a2
> log_zone_size 0 max_size 7fffffff magic 4d5a nzones a700 blocksize: 1000
> 
> [  516.859103] imap_blocks 7 zmap_blocks 7 firstdatazone c11
> log_zone_size 0 max_size 7fffffff magic 4d5a nzones 3001c blocksize:
> 1000
> 
> The calculation of i on line 38 results in fffffe80 for the last
> filesytem when minix_count_free_blocks is called for it.
> 
> Does anyone have an idea of what that particular section is trying to
> count?  (As an aside, the numbits variable is slightly confusing because
> it seems to be a number of blocks, not bits).  I'd be happy to continue
> to poke at this, but I'm a bit stumped at the moment.

The arguments of that function are redundant and it smells like we have
numbits < numblocks * bits_per_block.  Could you print both on that fs?

FWIW, it looks like this thing actually tries to be something like

/* count zero bits in bitmap; bitmap itself is an array of host-endian 16bit */

u32 count_free(struct super_block *sb, struct buffer_head *map[], u32 bits)
{
	size_t size = sb->s_blocksize;
	u32 sum = 0;

	while (bits) {
		struct buffer_head *bh = *map++;
		__u16 *p = bh->b_data;
		if (bits >= size * 8) { /* full block */
			__u16 *end = bh->b_data + size;
			while (p < end)
				sum += hweight16(~*p++);
			bits -= size * 8;
		} else { /* bitmap takes only part of it */
			__u16 *end = p + bits / 16;
			/* full 16bit words */
			while (p < end)
				sum += hweight16(~*p++);
			bits %= 16;
			if (bits) { /* partial word, only lower bits matter */
				sum += hweight16(~*p++ & ((1 << bits) - 1));
				bits = 0;
			}
		}
	}

	return sum;
}

Note that this needs update of callers (both have the superblock ready)
*and* minix_fill_super() needs to verify that
	a) sbi->s_ninodes < sbi->s_imap_blocks * sb->s_blocksize * 8
	b) (sbi->s_nzones - sbi->s_firstdatazone + 1) <=
			 sbi->s_zmap_blocks * sb->s_blocksize * 8
and scream if it isn't.

I *think* that what's happening in your case is that we have more blocks
for block bitmap than we would need to hold all bits.  That would explode
in exactly such a way, but I'd like to see confirmation; what arguments
does your count_free() actually get?  The last two arguments, that is...

NOTE: the above is not even compile-testeed.  It also needs an update to
deal with an atrocious kludge on several architectures - minix bitmaps
are *not* always host-endian on Linux and the things get really ugly
when we go into it; see CONFIG_MINIX_FS_.*_ENDIAN for gory details.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab0EERw3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 13:52:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58529 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751865Ab0EERw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 13:52:27 -0400
Date: Wed, 5 May 2010 10:50:02 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nitin Gupta <ngupta@vflare.org>
cc: Greg KH <greg@kroah.com>, Minchan Kim <minchan.kim@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] ramzswap: Eliminate stale data in compressed
 memory
In-Reply-To: <4BE1A307.709@vflare.org>
Message-ID: <alpine.LFD.2.00.1005051036070.27218@i5.linux-foundation.org>
References: <1273067156-2574-1-git-send-email-ngupta@vflare.org> <alpine.LFD.2.00.1005050809490.5478@i5.linux-foundation.org> <4BE1973D.5040206@vflare.org> <alpine.LFD.2.00.1005050912310.5478@i5.linux-foundation.org> <4BE1A307.709@vflare.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 5 May 2010, Nitin Gupta wrote:
> 
> Please see the original mail below (patch you nacked). Maybe, at that time, I didn't
> make it clear that ramzswap is really a *block device* :)

Oh, you're right. I looked up another patch of yours that had that 
swap_info" thing, and decided I hated that one with a passion, but it's 
not the one I NAK'ed in the earlier discussion.

Now that I see the block-layer patch, my reaction is (a) it's so much 
nicer than using that horrid nasty 'notifier' crap and (b) it reminds me 
why I wasn't entirely happy: it doesn't work - or even make sense - for 
filesystem-backed swap.

So when you do

	struct gendisk *disk = p->bdev->bd_disk;
	..
	if (disk->fops->swap_slot_free_notify)
		disk->fops->swap_slot_free_notify(p->bdev, offset);

there's nothing that says that 'offset' makes any sense at all, because if 
it's a swap-file on a device, it does all kinds of totally wrong things.

So I don't think that patch works either. I still suspect that the right 
"level" for something like this should be the 'mapping' level (which is 
how we actually do the write), but that seems to not work well with the 
block device layer.

So at a _minimum_, that 'disk->fops' approach needs to verify that the 
swap device is actually the whole bdev, and that the bdev isn't just the 
backing store for a swap _file_.

I dunno how to best check that. Either add a new flag to 
'swap_info_struct' that gets set on 'swapon()' whether it's a full device 
or a file. Or possibly just something like

	static int swap_is_block_device(struct swap_info_struct *p)
	{
		return S_ISBLK(p->swap_file->f_mapping->host);
	}

instead.

Because doing that 'disk->fops' thing _really_ isn't right if it isn't a 
disk.

		Linus

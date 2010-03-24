Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab0CXFW7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 01:22:59 -0400
Received: from anchor-post-2.mail.demon.net ([195.173.77.133]:46852 "EHLO
	anchor-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751449Ab0CXFW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 01:22:57 -0400
Message-ID: <4BA9A1BB.4000105@lougher.demon.co.uk>
Date: Wed, 24 Mar 2010 05:23:07 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ferenc Wagner <wferi@niif.hu>
CC: Phillip Lougher <phillip.lougher@gmail.com>, linux-fsdevel@vger.kernel.org,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
Subject: Re: RFC: direct MTD support for SquashFS
References: <87vdcwv139.fsf@tac.ki.iif.hu>	<87ljdsibqe.fsf@macbook.be.48ers.dk> <87r5nhziss.fsf@tac.ki.iif.hu>	<bffbecbb1003181440kc78f4dbvd25d4e2ea17b52e5@mail.gmail.com> <8739zqpxxw.fsf@tac.ki.iif.hu>
In-Reply-To: <8739zqpxxw.fsf@tac.ki.iif.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ferenc Wagner wrote:
> Now with the patch series, sorry.
> 
> Ferenc Wagner <wferi@niif.hu> writes:
> 
>> I've got one more patch, which I forgot to export, to pull out the
>> common logic from the backend init functions back into squashfs_read_data().
>> With the bdev backend, that entails reading the first block twice in a
>> row most of the time.  This again could be worked around by extending
>> the backend interface, but I'm not sure if it's worth it.
> 
> Here it is.  I also corrected the name of SQUASHFS_METADATA_SIZE, so it
> may as well compile now.
> 


Thanks for your patches.

First things first.  Patch sending etiquette :-)

1. Please don't send separate git commits in one big email,  it makes them
    hard to cross-reference (I lost count of the times I had to repeatedly
    scroll though the email to check an earlier commit).

2. Please don't send a patch series consisting of your development process.
    Reviewing takes effort, having reviewed one commit to find it reworked
    in a second commit, and then reworked again, as the code evolves from
    a -> b -> c-> d is irritating, it makes the final solution harder to
    evaluate (because you have to keep all the changes in your head), and
    wastes my time.

3. Incremental patches are valid if they break up a patch series into easily
    digestible changes which can be separately understood, but not if they're
    just reworking your code as development progresses...

OK, now for the specific comments.

Frameworks are supposed to make the code cleaner, more understandable,
and generally better.  Unfortunately, I see no evidence of that in your
patch.  Sorry to be blunt, but there it is.

The backend has seven functions!

+       void	*(*init)(struct squashfs_sb_info *, u64, size_t);
+	void	(*free)(struct squashfs_sb_info *);
+	ssize_t	(*read)(struct squashfs_sb_info *, void **, size_t);
+	int	(*probe)(struct file_system_type *, int, const char *,
+				void*, struct vfsmount *);
+	void	(*kill)(struct squashfs_sb_info *);
+	loff_t  (*size)(const struct super_block *);
+	const char *(*devname)(const struct super_block *, char *);

We move from a single read() function to requiring seven functions to do
the same work, just to add mtd support...

Reading the superblock changes into a 6 function deep nightmare
squashfs_find_backend -> probe -> get_sb_dev -> fill_bdev_super ->
squashfs_fill_super -> add_backend

I find the current 3 function deep situation forced by VFS already a mess,
squashfs_get_sb -> get_sb_bdev -> squashfs_fill_super

Reading a block now takes 3 function calls, init, read, and free.  Plus in
your last commit you make the huge mistake of preferring code elegance over
performance, and resort to calling init, read, and free *twice*, the first
just to read *two* bytes (yes, 2 bytes).  Why do you think the code was
coded that way in the first place?  A fit of absent mindedness perhaps?  No, for
performance reasons.

Secondly you make the classic mistake of concentrating on what you want to do
(add MTD), and not giving a damn about anything else.  You've totally broken all
the read optimisations in zlib decompression for block devices.  Buffer_heads
are deliberately passed directly to the zlib decompressor to allow it to
optimise performance (pass the buffer_head directly to zlib etc.).  Buffer_heads
are exposed to the decompressors without crappy go-between wrappers deliberately.

Unfortunately there are lots of other instances where you've eliminated carefully
optimised code.

That's another of my major issues, the patch seems hugely gratuitous, it
touches a huge amount of files/code it shouldn't do, much of this slicing up
optimisied heavily tested and fragile code into other files/functions hither
and thither.  Unfortunately much of this code took a long time to get
right, and suffered numerous unanticipated edge conditions/fsfuzzer
triggered bugs.  I only touch this code with caution and nothing like to
the extent you've subjected it to.

In short this doesn't pass my quality threshold or the make the minimum changes
necessary threshold.  I wouldn't consider asking Linus to merge this.

BTW as a comparison, I have added MTD support to Squashfs twice in the
past, *with* bad block support.  The latest has a diff patch of ~500 lines,
with far less complexity and code changes necessary.

BTW2 as evidenced by your FIXME comments against my code in your patch,
you really have to get over the notion that if you don't understand it,
the code must be wrong.

Cheers

Phillip


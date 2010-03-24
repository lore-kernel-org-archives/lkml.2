Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796Ab0CXNsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 09:48:30 -0400
Received: from tac.ki.iif.hu ([193.6.222.43]:52422 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755616Ab0CXNs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 09:48:28 -0400
From: Ferenc Wagner <wferi@niif.hu>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: Phillip Lougher <phillip.lougher@gmail.com>, linux-fsdevel@vger.kernel.org,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
Subject: Re: RFC: direct MTD support for SquashFS
References: <87vdcwv139.fsf@tac.ki.iif.hu>
	<87ljdsibqe.fsf@macbook.be.48ers.dk> <87r5nhziss.fsf@tac.ki.iif.hu>
	<bffbecbb1003181440kc78f4dbvd25d4e2ea17b52e5@mail.gmail.com>
	<8739zqpxxw.fsf@tac.ki.iif.hu> <4BA9A1BB.4000105@lougher.demon.co.uk>
Date: Wed, 24 Mar 2010 14:48:09 +0100
In-Reply-To: <4BA9A1BB.4000105@lougher.demon.co.uk> (Phillip Lougher's message
	of "Wed, 24 Mar 2010 05:23:07 +0000")
Message-ID: <87mxxxltk6.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Phillip Lougher <phillip@lougher.demon.co.uk> writes:

> Ferenc Wagner wrote:
>
>> Now with the patch series, sorry.
>>
>> Ferenc Wagner <wferi@niif.hu> writes:
>>
>>> I've got one more patch, which I forgot to export, to pull out the
>>> common logic from the backend init functions back into squashfs_read_data().
>>> With the bdev backend, that entails reading the first block twice in a
>>> row most of the time.  This again could be worked around by extending
>>> the backend interface, but I'm not sure if it's worth it.
>>
>> Here it is.  I also corrected the name of SQUASHFS_METADATA_SIZE, so it
>> may as well compile now.
>
> Thanks for your patches.
>
> First things first.  Patch sending etiquette :-) [...]

Points taken.  About the splits, they were the result of quite some
rebasing: I tried to give each patch a unique focus, but apparently
failed.  Only the last one touches substantial changed code, for the
explicitly stated reason: it hurts performance.

> Frameworks are supposed to make the code cleaner, more understandable,
> and generally better.

This framework is about added flexibility.  I agree it requires some
added complexity, but I hope we can manage it.

> Unfortunately, I see no evidence of that in your patch.  Sorry to be
> blunt, but there it is.

No problem.

> +       void	*(*init)(struct squashfs_sb_info *, u64, size_t);
> +	void	(*free)(struct squashfs_sb_info *);
> +	ssize_t	(*read)(struct squashfs_sb_info *, void **, size_t);
> +	int	(*probe)(struct file_system_type *, int, const char *,
> +				void*, struct vfsmount *);
> +	void	(*kill)(struct squashfs_sb_info *);
> +	loff_t  (*size)(const struct super_block *);
> +	const char *(*devname)(const struct super_block *, char *);
>
> We move from a single read() function to requiring seven functions to do
> the same work, just to add mtd support...

Your single read() function also had separate init, read and free
phases, with something generic in between.  I can try to invert the
structure, but see below.

> Reading the superblock changes into a 6 function deep nightmare
> squashfs_find_backend -> probe -> get_sb_dev -> fill_bdev_super ->
> squashfs_fill_super -> add_backend

It's convoluted, but only moves original code around.  If you prefer, I
can simplify that by embedding squashfs_sb_info into backend-specific
structures and allocating those separately.  This would also get rid of
some of the above 7 functions.

> Reading a block now takes 3 function calls, init, read, and free.

Actually, read must be called several times.  Are you worried by the
cost of the indirect function calls?

> Plus in your last commit you make the huge mistake of preferring code
> elegance over performance, and resort to calling init, read, and free
> *twice*, the first just to read *two* bytes (yes, 2 bytes).  Why do
> you think the code was coded that way in the first place?  A fit of
> absent mindedness perhaps?  No, for performance reasons.

I also pointed this out, and that's mosly why I created a separate last
patch.  I don't think it's optimal, but replicating the metadata length
handling in the backends isn't either.  There's RFC in the subject after
all...

> You've totally broken all the read optimisations in zlib decompression
> for block devices.  Buffer_heads are deliberately passed directly to
> the zlib decompressor to allow it to optimise performance (pass the
> buffer_head directly to zlib etc.).  Buffer_heads are exposed to the
> decompressors without crappy go-between wrappers deliberately.

At least this is something I noticed and expressed my concers about.
You probably missed that due to the lots of scrolling required by my
sub-par patch-posting technique. :)

> Unfortunately there are lots of other instances where you've
> eliminated carefully optimised code.

Could you please provide some examples?

> In short this doesn't pass my quality threshold or the make the
> minimum changes necessary threshold.  I wouldn't consider asking Linus
> to merge this.

Please don't.  It's a proof of concept, nothing more.  Even a proof of a
wrong concept.

> BTW as a comparison, I have added MTD support to Squashfs twice in the
> past, *with* bad block support.

Unfortunately you aren't allowed to share those, if I read it right.

> The latest has a diff patch of ~500 lines, with far less complexity
> and code changes necessary.

Sure, have a look at my very first patch: 3 files changed, 210
insertions, 21 deletions.  And that didn't remove bdev support.

> BTW2 as evidenced by your FIXME comments against my code in your patch,
> you really have to get over the notion that if you don't understand it,
> the code must be wrong.

Sometimes those are FIXMEs to make finding them easier, and are
questions really.  If you feel like answering them:

/* FIXME: == s->s_blocksize(_bits)? */
Why do you use devblksize and devblksize_log2 in squashfs_sb_info?
Aren't they the same as sb->s_blocksize and sb->s_blocksize_bits, as
their names suggest?

/* FIXME: squashfs_put_super has meta_index instead */
The failed_mount: part of squashfs_fill_super() is very similar to
squashfs_put_super(), but frees meta_index instead of id_table.  Why?

These are probably easy questions for people knowing the VFS layer well,
but I am not one of those.  They just triggered my built-in pattern
matcher.
-- 
Regards,
Feri.

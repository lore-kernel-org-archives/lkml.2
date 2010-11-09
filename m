Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab0KIRMV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 12:12:21 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:63126 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437Ab0KIRMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 12:12:17 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: cdhmanning@gmail.com
Subject: Re: [PATCH 6/9] Add some yaffs include files
Date: Tue, 9 Nov 2010 18:12:10 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <1288803204-3849-1-git-send-email-cdhmanning@gmail.com> <1288803204-3849-7-git-send-email-cdhmanning@gmail.com>
In-Reply-To: <1288803204-3849-7-git-send-email-cdhmanning@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201011091812.10318.arnd@arndb.de>
X-Provags-ID: V02:K0:3f1MfpyTrQhTTEPiRK+PbY4yOK6IPgpG8Ymvm44Ap/o
 e9TuXTssK6DJ/PwY0MZuY4dpnL0VcOBJx3VCsxWk0h6VpRHbbH
 o9b8+0RD/CI56vX9izm72drHTg3mUBWnsi0tb6qeohoRw/pEF5
 6VySzdlDNv0Aww7qCM7IoPTfaNQ6M4wfZEelCAn7ySj8F0zAsD
 9oS4zcd0ebjO/B4Y1SZvg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +#ifndef CONFIG_YAFFS_NO_YAFFS1

Why not turn around the logic and make it 
#ifndef CONFIG_YAFFS_YAFFS1

> +struct yaffs_block_info {
> +
> +	int soft_del_pages:10;	/* number of soft deleted pages */
> +	int pages_in_use:10;	/* number of pages in use */
> +	unsigned block_state:4;	/* One of the above block states. NB use unsigned because enum is sometimes an int */
> +	u32 needs_retiring:1;	/* Data has failed on this block, need to get valid data off */
> +	/* and retire the block. */
> +	u32 skip_erased_check:1;	/* If this is set we can skip the erased check on this block */
> +	u32 gc_prioritise:1;	/* An ECC check or blank check has failed on this block.
> +				   It should be prioritised for GC */
> +	u32 chunk_error_strikes:3;	/* How many times we've had ecc etc failures on this block and tried to reuse it */
> +
> +#ifdef CONFIG_YAFFS_YAFFS2
> +	u32 has_shrink_hdr:1;	/* This block has at least one shrink object header */
> +	u32 seq_number;		/* block sequence number for yaffs2 */
> +#endif
> +
> +};

If this is an on-disk structure, it does not appear to be endian-safe.
How do you deal with cross-endian mounts?

I would also recommend padding the bit fields to full 32 bit words.

> diff --git a/fs/yaffs2/yaffs_trace.h b/fs/yaffs2/yaffs_trace.h
> new file mode 100644
> index 0000000..90dbefc
> --- /dev/null
> +++ b/fs/yaffs2/yaffs_trace.h

As mentioned in my other mail, I think the yaffs trace facility should
be removed. You can add standard tracing facilities at a later stage
to replace them.

> diff --git a/fs/yaffs2/yportenv.h b/fs/yaffs2/yportenv.h
> new file mode 100644
> index 0000000..2eae429
> --- /dev/null
> +++ b/fs/yaffs2/yportenv.h

This file would also better not exist. On Linux it is evidently
not required, just open-code the definitions you have here.

If you want portability to other operating systems, the usual
method is to define the Linux specific function names on those
that do not provide them themselves.

> +#define YCHAR char
> +#define YUCHAR unsigned char

Note that "char" by itself may be signed or unsigned, depending on the
architecture. You should replace YCHAR with "signed char" in your
code if you depend on signed behaviour.

> +#define YYIELD() schedule()

Be careful with calling schedule() in your code. It does not have
"yield" semantics on Linux normally, so any code that uses it probably
does not do what you think it should do.

In many cases, cond_resched() is probably the right replacement.

> +#define Y_DUMP_STACK() dump_stack()

This should probably become WARN_ON().

	Arnd

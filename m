Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab1ASXtx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 18:49:53 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52698 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753300Ab1ASXtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 18:49:51 -0500
Date: Wed, 19 Jan 2011 15:49:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stuart Swales <stuart.swales.croftnuisk@gmail.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] adfs: add hexadecimal filetype suffix option
Message-Id: <20110119154915.a0bb2878.akpm@linux-foundation.org>
In-Reply-To: <4D2DEDDB.1070605@gmail.com>
References: <4D2DEDDB.1070605@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Jan 2011 18:07:23 +0000
Stuart Swales <stuart.swales.croftnuisk@gmail.com> wrote:

> From: Stuart Swales<stuart.swales.croftnuisk@gmail.com>
> 
> ADFS (FileCore) storage complies with the RISC OS filetype specification
> (12 bits of file type information is stored in the file load address, rather
> than using a file extension).  The existing driver largely ignores this
> information and does not present it to the end user.
> 
> It is desirable that stored filetypes be made visible to the end user to
> facilitate a precise copy of data and metadata from a hard disc (or image
> thereof) into a RISC OS emulator (such as RPCEmu) or to a network share which
> can be accessed by real Acorn systems.
> 
> This patch implements a per-mount filetype suffix option (use -o ftsuffix=1)
> to present any filetype as a ,xyz hexadecimal suffix on each file.  This type
> suffix is compatible with that used by RISC OS systems that access network
> servers using NFS client software and by RPCemu's host filing system.
> 

I don't really understand this.  Are you saying that if a file on an
adfs partition has name "foo", and one does a `mount -o ftsuffix=1'
then an `ls' would show "foo,ABC"?

If so, that sounds strange but I assume you know what you're doing.

Was `mount -o remount,ftsuffix=1' implemented and tested?

Am I correct in assuming that "mount -o remount,ftsuffix=0" turns this
off again?

I wonder what are the implications of changing filenames on the fly
with a remount.

We have a Documentation/filesystems/adfs.txt.  Please update it.

Again, the patch was mangled by your email client in some fashion and
generates 100% rejects.

Please pass the diff through scripts/checkpatch.pl and address and
warnings which you do not disagree with.

>
> ...
>
> +/* RISC OS 12-bit filetype converts to ,xyz hex filename suffix */
> +static inline char lowercase_hex_digit(__u16 i)
> +{
> +	if (i>= 10)
> +		return 'a' + (i - 10);
> +
> +	return '0' + i;
> +}
> +
> +static inline int append_filetype_suffix(char *buf, __u16 filetype)
> +{
> +	if ((__u16) -1 == filetype)

unneeded cast.

> +		return 0;
> +
> +	*buf++ = ',';
> +	*buf++ = lowercase_hex_digit((filetype>>  8)&  0x0f);
> +	*buf++ = lowercase_hex_digit((filetype>>  4)&  0x0f);
> +	*buf++ = lowercase_hex_digit((filetype>>  0)&  0x0f);
> +	return 4;
> +}

Kernel code tends to avoid using the `if (42 == foo)' construct.  gcc
will generate a warning if the programmer accidentally typed '=', and
it Just Looks Weird.

append_filetype_suffix() is too large to be inlined.

append_filetype_suffix() should use more of the general library
functions.  `grep hex include/linux/kernel.h'.  hex2bin() *should* be
directly applicable here but it isn't because it's stupid.


>   struct adfs_dir_ops {
>   	int	(*read)(struct super_block *sb, unsigned int id, unsigned int sz, struct adfs_dir *dir);
>   	int	(*setpos)(struct adfs_dir *dir, unsigned int fpos);
> diff -uprN -X linux-2.6.37-vanilla/Documentation/dontdiff linux-2.6.37-vanilla/fs/adfs/dir_f.c linux-2.6.37-sks-adfs/fs/adfs/dir_f.c
> --- linux-2.6.37-vanilla/fs/adfs/dir_f.c	2011-01-05 00:50:19.000000000 +0000
> +++ linux-2.6.37-sks-adfs/fs/adfs/dir_f.c	2011-01-12 17:01:49.000000000 +0000
> @@ -52,7 +52,6 @@ static inline int adfs_readname(char *bu
>   			*buf++ = *ptr;
>   		ptr++;
>   	}
> -	*buf = '\0';
> 
>   	return buf - old_buf;
>   }
> @@ -208,7 +207,10 @@ release_buffers:
>    * convert a disk-based directory entry to a Linux ADFS directory entry
>    */
>   static inline void
> -adfs_dir2obj(struct object_info *obj, struct adfs_direntry *de)
> +adfs_dir2obj(
> +	struct adfs_dir *dir,
> +	struct object_info *obj,
> +	struct adfs_direntry *de)

The xfs guys lay out their functions like that, but they're in their
own little world.

>   {
>   	obj->name_len =	adfs_readname(obj->name, de->dirobname, ADFS_F_NAME_LEN);
>   	obj->file_id  = adfs_readval(de->dirinddiscadd, 3);
> @@ -216,6 +218,22 @@ adfs_dir2obj(struct object_info *obj, st
>   	obj->execaddr = adfs_readval(de->direxec, 4);
>   	obj->size     = adfs_readval(de->dirlen,  4);
>   	obj->attr     = de->newdiratts;
> +
> +	obj->filetype = (__u16) -1;
> +	/* object is a file and is filetyped and timestamped?
> +	 * RISC OS 12-bit filetype is stored in load_address[19:8]
> +	 */

Multiline comments are typically laid out as


	/*
	 * object is a file and is filetyped and timestamped?
	 * RISC OS 12-bit filetype is stored in load_address[19:8]
	 */

> +	if ((0 == (obj->attr&  ADFS_NDA_DIRECTORY))&&
> +		(0xfff00000 == (0xfff00000&  obj->loadaddr))) {
> +		obj->filetype = (__u16) ((0x000fff00&  obj->loadaddr)>>  8);

Much coding-style grief there.

> +		/* optionally append the ,xyz hex filetype suffix */
> +		if (ADFS_SB(dir->sb)->s_ftsuffix)
> +			obj->name_len +=
> +				append_filetype_suffix(
> +					&obj->name[obj->name_len],
> +					obj->filetype);
> +	}
>   }
> 
>   /*
>
> ...
>
> @@ -447,11 +456,13 @@ static int adfs_fill_super(struct super_
> 
>   	root_obj.parent_id = root_obj.file_id = le32_to_cpu(dr->root);
>   	root_obj.name_len  = 0;
> -	root_obj.loadaddr  = 0;
> -	root_obj.execaddr  = 0;
> +	/* Set root object date as 01 Jan 1987 00:00:00 */
> +	root_obj.loadaddr  = 0xfff0003f;
> +	root_obj.execaddr  = 0xec22c000;
>   	root_obj.size	   = ADFS_NEWDIR_SIZE;
>   	root_obj.attr	   = ADFS_NDA_DIRECTORY   | ADFS_NDA_OWNER_READ |
>   			     ADFS_NDA_OWNER_WRITE | ADFS_NDA_PUBLIC_READ;
> +	root_obj.filetype  = (__u16) -1;

unneeded cast.

>   	/*
>   	 * If this is a F+ disk with variable length directories,
>
> ...
>


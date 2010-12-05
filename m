Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab0LEW12 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 17:27:28 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:16790 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab0LEW10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 17:27:26 -0500
Date: Sun, 5 Dec 2010 23:20:30 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Charles Manning <cdhmanning@gmail.com>
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] Add yaffs2 file system: xattrib code
In-Reply-To: <1291154254-22533-7-git-send-email-cdhmanning@gmail.com>
Message-ID: <alpine.LNX.2.00.1012052314400.16078@swampdragon.chaosbits.net>
References: <1291154254-22533-1-git-send-email-cdhmanning@gmail.com> <1291154254-22533-7-git-send-email-cdhmanning@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few minor comments can be found below.


On Wed, 1 Dec 2010, Charles Manning wrote:

> Signed-off-by: Charles Manning <cdhmanning@gmail.com>
> ---
>  fs/yaffs2/yaffs_nameval.c |  201 +++++++++++++++++++++++++++++++++++++++++++++
>  fs/yaffs2/yaffs_nameval.h |   28 ++++++
>  2 files changed, 229 insertions(+), 0 deletions(-)
>  create mode 100644 fs/yaffs2/yaffs_nameval.c
>  create mode 100644 fs/yaffs2/yaffs_nameval.h
> 
> diff --git a/fs/yaffs2/yaffs_nameval.c b/fs/yaffs2/yaffs_nameval.c
> new file mode 100644
> index 0000000..d8c548a
> --- /dev/null
> +++ b/fs/yaffs2/yaffs_nameval.c
> @@ -0,0 +1,201 @@
> +/*
> + * YAFFS: Yet Another Flash File System. A NAND-flash specific file system.
> + *
> + * Copyright (C) 2002-2010 Aleph One Ltd.
> + *   for Toby Churchill Ltd and Brightstar Engineering
> + *
> + * Created by Charles Manning <charles@aleph1.co.uk>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +/*
> + * This simple implementation of a name-value store assumes a small number of values and fits
> + * into a small finite buffer.
> + *
> + * Each attribute is stored as a record:
> + *  sizeof(int) bytes   record size.
> + *  strnlen+1 bytes name null terminated.
> + *  nbytes    value.
> + *  ----------
> + *  total size  stored in record size 
> + *
> + * This code has not been tested with unicode yet.
> + */
> +
> +#include "yaffs_nameval.h"
> +
> +#include "yportenv.h"
> +
> +static int nval_find(const char *xb, int xb_size, const YCHAR * name,
> +		     int *exist_size)
> +{
> +	int pos = 0;
> +	int size;
> +
> +	memcpy(&size, xb, sizeof(int));
> +	while (size > 0 && (size < xb_size) && (pos + size < xb_size)) {
> +		if (yaffs_strncmp
> +		    ((YCHAR *) (xb + pos + sizeof(int)), name, size) == 0) {
> +			if (exist_size)
> +				*exist_size = size;
> +			return pos;
> +		}
> +		pos += size;
> +		if (pos < xb_size - sizeof(int))
> +			memcpy(&size, xb + pos, sizeof(int));
> +		else
> +			size = 0;
> +	}
> +	if (exist_size)
> +		*exist_size = 0;
> +	return -1;
> +}
> +
> +static int nval_used(const char *xb, int xb_size)
> +{
> +	int pos = 0;
> +	int size;
> +
> +	memcpy(&size, xb + pos, sizeof(int));
> +	while (size > 0 && (size < xb_size) && (pos + size < xb_size)) {
> +		pos += size;
> +		if (pos < xb_size - sizeof(int))
> +			memcpy(&size, xb + pos, sizeof(int));
> +		else
> +			size = 0;
> +	}
> +	return pos;
> +}
> +
> +int nval_del(char *xb, int xb_size, const YCHAR * name)
> +{
> +	int pos = nval_find(xb, xb_size, name, NULL);
> +	int size;
> +
> +	if (pos >= 0 && pos < xb_size) {
> +		/* Find size, shift rest over this record, then zero out the rest of buffer */
> +		memcpy(&size, xb + pos, sizeof(int));
> +		memcpy(xb + pos, xb + pos + size, xb_size - (pos + size));
> +		memset(xb + (xb_size - size), 0, size);
> +		return 0;
> +	} else {
> +		return -ENODATA;
> +        }
> +}

Why not get rid of the 'else' branch and simply write this as 

int nval_del(char *xb, int xb_size, const YCHAR *name)
{
     int pos = nval_find(xb, xb_size, name, NULL);
     int size;  
     
     if (pos >= 0 && pos < xb_size) {
             /* Find size, shift rest over this record, then zero out the rest of buffer */
             memcpy(&size, xb + pos, sizeof(int));
             memcpy(xb + pos, xb + pos + size, xb_size - (pos + size));
             memset(xb + (xb_size - size), 0, size);
             return 0;
     }
     return -ENODATA;
}


> +
> +int nval_set(char *xb, int xb_size, const YCHAR * name, const char *buf,
                                                 ^^^^^

Why this insistance on making pointer variables look like 
multiplication...?
  int* foo; // prefered by many C++ people
  int *foo; // prefered by many C people
  int * foo; // just plain ugly
(this is not the only location, but I'm not going to point out any more)


> +	     int bsize, int flags)
> +{
> +	int pos;
> +	int namelen = yaffs_strnlen(name, xb_size);
> +	int reclen;
> +	int size_exist = 0;
> +	int space;
> +	int start;
> +
> +	pos = nval_find(xb, xb_size, name, &size_exist);
> +
> +	if (flags & XATTR_CREATE && pos >= 0)
> +		return -EEXIST;
> +	if (flags & XATTR_REPLACE && pos < 0)
> +		return -ENODATA;
> +
> +	start = nval_used(xb, xb_size);
> +	space = xb_size - start + size_exist;
> +
> +	reclen = (sizeof(int) + namelen + 1 + bsize);
> +
> +	if (reclen > space)
> +		return -ENOSPC;
> +
> +	if (pos >= 0) {
> +		nval_del(xb, xb_size, name);
> +		start = nval_used(xb, xb_size);
> +	}
> +
> +	pos = start;
> +
> +	memcpy(xb + pos, &reclen, sizeof(int));
> +	pos += sizeof(int);
> +	yaffs_strncpy((YCHAR *) (xb + pos), name, reclen);
> +	pos += (namelen + 1);
> +	memcpy(xb + pos, buf, bsize);
> +	return 0;
> +}
> +
> +int nval_get(const char *xb, int xb_size, const YCHAR * name, char *buf,
> +	     int bsize)
> +{
> +	int pos = nval_find(xb, xb_size, name, NULL);
> +	int size;
> +
> +	if (pos >= 0 && pos < xb_size) {
> +
> +		memcpy(&size, xb + pos, sizeof(int));
> +		pos += sizeof(int);	/* advance past record length */
> +		size -= sizeof(int);
> +
> +		/* Advance over name string */
> +		while (xb[pos] && size > 0 && pos < xb_size) {
> +			pos++;
> +			size--;
> +		}
> +		/*Advance over NUL */
> +		pos++;
> +		size--;
> +
> +		if (size <= bsize) {
> +			memcpy(buf, xb + pos, size);
> +			return size;
> +		}
> +
> +	}
> +	if (pos >= 0)
> +		return -ERANGE;
> +	else
> +		return -ENODATA;
> +}
> +
> +int nval_list(const char *xb, int xb_size, char *buf, int bsize)
> +{
> +	int pos = 0;
> +	int size;
> +	int name_len;
> +	int ncopied = 0;
> +	int filled = 0;
> +
> +	memcpy(&size, xb + pos, sizeof(int));
> +	while (size > sizeof(int) && size <= xb_size && (pos + size) < xb_size
> +	       && !filled) {
> +		pos += sizeof(int);
> +		size -= sizeof(int);
> +		name_len = yaffs_strnlen((YCHAR *) (xb + pos), size);
> +		if (ncopied + name_len + 1 < bsize) {
> +			memcpy(buf, xb + pos, name_len * sizeof(YCHAR));
> +			buf += name_len;
> +			*buf = '\0';
> +			buf++;
> +			if (sizeof(YCHAR) > 1) {
> +				*buf = '\0';
> +				buf++;
> +			}
> +			ncopied += (name_len + 1);
> +		} else {
> +			filled = 1;
> +                }
Trivial little nit. The line above this comment is indented with spaces, 
not tabs as it should be.


> +		pos += size;
> +		if (pos < xb_size - sizeof(int))
> +			memcpy(&size, xb + pos, sizeof(int));
> +		else
> +			size = 0;
> +	}
> +	return ncopied;
> +}
> +
> +int nval_hasvalues(const char *xb, int xb_size)
> +{
> +	return nval_used(xb, xb_size) > 0;
> +}
> diff --git a/fs/yaffs2/yaffs_nameval.h b/fs/yaffs2/yaffs_nameval.h
> new file mode 100644
> index 0000000..2bb02b6
> --- /dev/null
> +++ b/fs/yaffs2/yaffs_nameval.h
> @@ -0,0 +1,28 @@
> +/*
> + * YAFFS: Yet another Flash File System . A NAND-flash specific file system.
> + *
> + * Copyright (C) 2002-2010 Aleph One Ltd.
> + *   for Toby Churchill Ltd and Brightstar Engineering
> + *
> + * Created by Charles Manning <charles@aleph1.co.uk>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU Lesser General Public License version 2.1 as
> + * published by the Free Software Foundation.
> + *
> + * Note: Only YAFFS headers are LGPL, YAFFS C code is covered by GPL.
> + */
> +
> +#ifndef __NAMEVAL_H__
> +#define __NAMEVAL_H__
> +
> +#include "yportenv.h"
> +
> +int nval_del(char *xb, int xb_size, const YCHAR * name);
> +int nval_set(char *xb, int xb_size, const YCHAR * name, const char *buf,
> +	     int bsize, int flags);
> +int nval_get(const char *xb, int xb_size, const YCHAR * name, char *buf,
> +	     int bsize);
> +int nval_list(const char *xb, int xb_size, char *buf, int bsize);
> +int nval_hasvalues(const char *xb, int xb_size);
> +#endif
> 

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.


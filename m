Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934908Ab0EZX4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 19:56:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52567 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933697Ab0EZX4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 19:56:04 -0400
Date: Wed, 26 May 2010 16:55:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, ebiederm@xmission.com,
       vgoyal@redhat.com, mjg@redhat.com, arozansk@redhat.com,
       Phillip Lougher <phillip@lougher.demon.co.uk>
Subject: Re: [PATCH]: Fix checkstack warning in bunzip2 library
Message-Id: <20100526165511.b2c1198e.akpm@linux-foundation.org>
In-Reply-To: <20100525223406.9446.46193.sendpatchset@prarit.bos.redhat.com>
References: <20100525223406.9446.46193.sendpatchset@prarit.bos.redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 May 2010 18:37:48 -0400
Prarit Bhargava <prarit@redhat.com> wrote:

> Fix checkstack error:
> 
> lib/decompress_bunzip2.c: In function ___get_next_block___:
> lib/decompress_bunzip2.c:511: warning: the frame size of 1932 bytes is larger than 1024 bytes
> 
> byteCount, symToByte, and mtfSymbol cannot be declared static or allocated
> dynamically so place them in the bunzip_data struct.
> 
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> 
> diff --git a/lib/decompress_bunzip2.c b/lib/decompress_bunzip2.c
> index a4e971d..81c8bb1 100644
> --- a/lib/decompress_bunzip2.c
> +++ b/lib/decompress_bunzip2.c
> @@ -107,6 +107,8 @@ struct bunzip_data {
>  	unsigned char selectors[32768];		/* nSelectors = 15 bits */
>  	struct group_data groups[MAX_GROUPS];	/* Huffman coding tables */
>  	int io_error;			/* non-zero if we have IO error */
> +	int byteCount[256];
> +	unsigned char symToByte[256], mtfSymbol[256];
>  };
>  
>  
> @@ -158,14 +160,16 @@ static int INIT get_next_block(struct bunzip_data *bd)
>  	int *base = NULL;
>  	int *limit = NULL;
>  	int dbufCount, nextSym, dbufSize, groupCount, selector,
> -		i, j, k, t, runPos, symCount, symTotal, nSelectors,
> -		byteCount[256];
> -	unsigned char uc, symToByte[256], mtfSymbol[256], *selectors;
> +		i, j, k, t, runPos, symCount, symTotal, nSelectors, *byteCount;
> +	unsigned char uc, *symToByte, *mtfSymbol, *selectors;
>  	unsigned int *dbuf, origPtr;
>  
>  	dbuf = bd->dbuf;
>  	dbufSize = bd->dbufSize;
>  	selectors = bd->selectors;
> +	byteCount = bd->byteCount;
> +	symToByte = bd->symToByte;
> +	mtfSymbol = bd->mtfSymbol;
>  
>  	/* Read in header signature and CRC, then validate signature.
>  	   (last block signature means CRC is for whole file, return now) */

hm, I'm not sure that checkstack warnings are very relevant in the
contexts where this code executes, but the change is clean enough and
squishing a warning is good.

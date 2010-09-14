Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808Ab0INXHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 19:07:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37658 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755135Ab0INXHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 19:07:13 -0400
Date: Tue, 14 Sep 2010 16:06:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Jan Beulich" <JBeulich@novell.com>
Cc: <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] use clear_page()/copy_page() in favor of
 memset()/memcpy() on whole pages
Message-Id: <20100914160654.20c91c22.akpm@linux-foundation.org>
In-Reply-To: <4C7FB50D0200007800013F36@vpn.id2.novell.com>
References: <4C7FB50D0200007800013F36@vpn.id2.novell.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 02 Sep 2010 13:30:37 +0100
"Jan Beulich" <JBeulich@novell.com> wrote:

> After all that's what they are intended for.
> 
> ...
>
> --- linux-2.6.36-rc3/fs/fuse/dev.c
> +++ 2.6.36-rc3-use-clear_page/fs/fuse/dev.c
> @@ -811,7 +811,7 @@ static int fuse_copy_page(struct fuse_co
>  
>  	if (page && zeroing && count < PAGE_SIZE) {
>  		void *mapaddr = kmap_atomic(page, KM_USER1);
> -		memset(mapaddr, 0, PAGE_SIZE);
> +		clear_page(mapaddr);
>  		kunmap_atomic(mapaddr, KM_USER1);
>  	}
>  	while (count) {

fuse wanted to use clear_highpage() here.  But clear_highpage() uses
KM_USER0.  I don't immediately see why fuse uses KM_USER1 here?

>
> ...
>
> --- linux-2.6.36-rc3/kernel/power/snapshot.c
> +++ 2.6.36-rc3-use-clear_page/kernel/power/snapshot.c
> @@ -988,7 +988,7 @@ static void copy_data_page(unsigned long
>  			 */
>  			safe_copy_page(buffer, s_page);
>  			dst = kmap_atomic(d_page, KM_USER0);
> -			memcpy(dst, buffer, PAGE_SIZE);
> +			copy_page(dst, buffer);
>  			kunmap_atomic(dst, KM_USER0);
>  		} else {
>  			safe_copy_page(page_address(d_page), s_page);
> @@ -1636,7 +1636,7 @@ int snapshot_read_next(struct snapshot_h
>  		memory_bm_position_reset(&orig_bm);
>  		memory_bm_position_reset(&copy_bm);
>  	} else if (handle->cur <= nr_meta_pages) {
> -		memset(buffer, 0, PAGE_SIZE);
> +		clear_page(buffer);
>  		pack_pfns(buffer, &orig_bm);
>  	} else {
>  		struct page *page;
> @@ -1650,7 +1650,7 @@ int snapshot_read_next(struct snapshot_h
>  			void *kaddr;
>  
>  			kaddr = kmap_atomic(page, KM_USER0);
> -			memcpy(buffer, kaddr, PAGE_SIZE);
> +			copy_page(buffer, kaddr);
>  			kunmap_atomic(kaddr, KM_USER0);
>  			handle->buffer = buffer;
>  		} else {
> @@ -1933,7 +1933,7 @@ static void copy_last_highmem_page(void)
>  		void *dst;
>  
>  		dst = kmap_atomic(last_highmem_page, KM_USER0);
> -		memcpy(dst, buffer, PAGE_SIZE);
> +		copy_page(dst, buffer);
>  		kunmap_atomic(dst, KM_USER0);
>  		last_highmem_page = NULL;
>  	}
> @@ -2219,9 +2219,9 @@ swap_two_pages_data(struct page *p1, str
>  
>  	kaddr1 = kmap_atomic(p1, KM_USER0);
>  	kaddr2 = kmap_atomic(p2, KM_USER1);
> -	memcpy(buf, kaddr1, PAGE_SIZE);
> -	memcpy(kaddr1, kaddr2, PAGE_SIZE);
> -	memcpy(kaddr2, buf, PAGE_SIZE);
> +	copy_page(buf, kaddr1);
> +	copy_page(kaddr1, kaddr2);
> +	copy_page(kaddr2, buf);
>  	kunmap_atomic(kaddr1, KM_USER0);
>  	kunmap_atomic(kaddr2, KM_USER1);
>  }

The page-copying functions in snapshot.c are magical.  The changes look
OK to me but I'd ask Rafael to double-check, please.

>
> ...
>

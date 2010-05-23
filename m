Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306Ab0EWPTy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 11:19:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040Ab0EWPTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 11:19:52 -0400
Message-ID: <4BF94792.5030405@redhat.com>
Date: Sun, 23 May 2010 18:19:46 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Cesar Eduardo Barros <cesarb@cesarb.net>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mm: Swap checksum
References: <4BF81D87.6010506@cesarb.net> <1274551731-4534-3-git-send-email-cesarb@cesarb.net>
In-Reply-To: <1274551731-4534-3-git-send-email-cesarb@cesarb.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2010 09:08 PM, Cesar Eduardo Barros wrote:
> Add support for checksumming the swap pages written to disk, using the
> same checksum as btrfs (crc32c). Since the contents of the swap do not
> matter after a shutdown, the checksum is kept in memory only.
>
> Note that this code does not checksum the software suspend image.
>
>
>
>   #define SWAP_FLAG_PREFER	0x8000	/* set if swap priority specified */
>   #define SWAP_FLAG_PRIO_MASK	0x7fff
> @@ -180,6 +183,10 @@ struct swap_info_struct {
>   	struct swap_extent *curr_swap_extent;
>   	struct swap_extent first_swap_extent;
>   	struct block_device *bdev;	/* swap device or bdev of swap file */
> +#ifdef CONFIG_SWAP_CHECKSUM
> +	unsigned short *csum_count;	/* usage count of a csum page */
> +	u32 **csum;			/* vmalloc'ed array of swap csums */
> +#endif
>   	struct file *swap_file;		/* seldom referenced */
>   	unsigned int old_block_size;	/* seldom referenced */
>   };
>    

On 64-bit, we may be able to store the checksum in the pte, if the swap 
device is small enough.

If we take the trouble to touch the page, we may as well compare it 
against zero, and if so drop it instead of swapping it out.

-- 
error compiling committee.c: too many arguments to function


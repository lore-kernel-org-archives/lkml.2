Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab2ETP6N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 11:58:13 -0400
Received: from de01.mail.all-tld.net ([195.140.232.8]:58180 "EHLO
	de01.mail.all-tld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab2ETP6L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 11:58:11 -0400
X-Greylist: delayed 1416 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 May 2012 11:58:11 EDT
Date: Sun, 20 May 2012 17:34:20 +0200
From: Anders Larsen <al@alarsen.net>
Subject: Re: [PATCH 03/10] qnx4fs: use memweight()
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <1337520203-29147-3-git-send-email-akinobu.mita@gmail.com>
	(from akinobu.mita@gmail.com on Sun May 20 15:23:16 2012)
X-Mailer: Balsa 2.4.1
Message-Id: <1337528060.4396.0@oscar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
References: <1337520203-29147-3-git-send-email-akinobu.mita@gmail.com>
X-ALL-TLD-GmbH-Information: AEV Virus and Spam Secure Mail System
X-ALL-TLD-GmbH-VirusScanner: Found to be clean
X-ALL-TLD-GmbH-SpamCheck: 
X-MailScanner-From: al@alarsen.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-05-20 15:23:16, Akinobu Mita wrote:
> Use memweight() to count the total number of bits clear in memory  
> area.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Anders Larsen <al@alarsen.net>
> ---
>  fs/qnx4/bitmap.c |   24 +++++-------------------
>  1 files changed, 5 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/qnx4/bitmap.c b/fs/qnx4/bitmap.c
> index 22e0d60..fc04ef1 100644
> --- a/fs/qnx4/bitmap.c
> +++ b/fs/qnx4/bitmap.c
> @@ -17,23 +17,6 @@
>  #include <linux/bitops.h>
>  #include "qnx4.h"
> 
> -static void count_bits(register const char *bmPart, register int  
> size,
> -		       int *const tf)
> -{
> -	char b;
> -	int tot = *tf;
> -
> -	if (size > QNX4_BLOCK_SIZE) {
> -		size = QNX4_BLOCK_SIZE;
> -	}
> -	do {
> -		b = *bmPart++;
> -		tot += 8 - hweight8(b);
> -		size--;
> -	} while (size != 0);
> -	*tf = tot;
> -}
> -
>  unsigned long qnx4_count_free_blocks(struct super_block *sb)
>  {
>  	int start =  
> le32_to_cpu(qnx4_sb(sb)->BitMap->di_first_xtnt.xtnt_blk) - 1;
> @@ -44,13 +27,16 @@ unsigned long qnx4_count_free_blocks(struct  
> super_block *sb)
>  	struct buffer_head *bh;
> 
>  	while (total < size) {
> +		int bytes = min(size - total, QNX4_BLOCK_SIZE);
> +
>  		if ((bh = sb_bread(sb, start + offset)) == NULL) {
>  			printk(KERN_ERR "qnx4: I/O error in counting  
> free blocks\n");
>  			break;
>  		}
> -		count_bits(bh->b_data, size - total, &total_free);
> +		total_free += bytes * BITS_PER_BYTE-

due to the missing whitespace after the macro I had to read that  
statement
three times to comprehend it (which was probably good, since that's the  
beef ;)

> +				memweight(bh->b_data, bytes);
>  		brelse(bh);
> -		total += QNX4_BLOCK_SIZE;
> +		total += bytes;
>  		offset++;
>  	}

Other than that,
Acked-by: Anders Larsen <al@alarsen.net>

Cheers
Anders

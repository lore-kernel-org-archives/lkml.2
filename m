Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722Ab1KUWdc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 17:33:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53454 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab1KUWdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 17:33:31 -0500
Date: Mon, 21 Nov 2011 14:33:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: wangyanqing <udknight@gmail.com>
Cc: warns@pre-sense.de, linux-kernel@vger.kernel.org, tj@kernel.org,
        jaxboe@fusionio.com, Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: [PATCH] fs:partitions:efi.c: bugfix a issue in find_valid_gpt
Message-Id: <20111121143329.ae1ba3de.akpm@linux-foundation.org>
In-Reply-To: <20111121093801.GA1062@udknight.homenetwork>
References: <20111121093801.GA1062@udknight.homenetwork>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Nov 2011 17:38:01 +0800
wangyanqing <udknight@gmail.com> wrote:

> I meet a 3T disk, which partitioned by Windows 7,
> and linux report unknow partition table. But it can been
> detected the partition table when I add gpt to boot
> parameter.
> 
> This issue caused by the find_valid_gpt function will fail
> out when check the legacy mbr failed if there is no gpt boot
> parameter.
> 
> if boot without gpt, we should fail back to check the guid
> partition table when check the legacy mbr failed instead of
> fail out.
> 
> Signed-off-by: Wang YanQing <udknight@gmail.com>
> ---
>  fs/partitions/efi.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/partitions/efi.c b/fs/partitions/efi.c
> index 6296b40..302631e 100644
> --- a/fs/partitions/efi.c
> +++ b/fs/partitions/efi.c
> @@ -543,8 +543,6 @@ static int find_valid_gpt(struct parsed_partitions *state, gpt_header **gpt,
>                          good_pmbr = is_pmbr_valid(legacymbr);
>                          kfree(legacymbr);
>                  }
> -                if (!good_pmbr)
> -                        goto fail;
>          }
>  
>  	good_pgpt = is_gpt_valid(state, GPT_PRIMARY_PARTITION_TABLE_LBA,

If we make this change then we didn't need to calculate good_pmbr.  So
we didn't need to read the LBA and we didn't need to allocate and free
legacymbr.  So afaict all this code just goes away:

--- a/fs/partitions/efi.c
+++ a/fs/partitions/efi.c
@@ -534,18 +534,6 @@
 		return 0;
 
 	lastlba = last_lba(state->bdev);
-        if (!force_gpt) {
-                /* This will be added to the EFI Spec. per Intel after v1.02. */
-                legacymbr = kzalloc(sizeof (*legacymbr), GFP_KERNEL);
-                if (legacymbr) {
-                        read_lba(state, 0, (u8 *) legacymbr,
-				 sizeof (*legacymbr));
-                        good_pmbr = is_pmbr_valid(legacymbr);
-                        kfree(legacymbr);
-                }
-                if (!good_pmbr)
-                        goto fail;
-        }
 
 	good_pgpt = is_gpt_valid(state, GPT_PRIMARY_PARTITION_TABLE_LBA,
 				 &pgpt, &pptes);

and I don't know what the implications of that would be.

Matt, could you please take a look at this?

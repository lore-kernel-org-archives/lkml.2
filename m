Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537Ab1IWDZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 23:25:28 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:22252 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751000Ab1IWDZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 23:25:25 -0400
Date: Thu, 22 Sep 2011 20:25:25 -0700 (PDT)
From: Andrei Warkentin <awarkentin@vmware.com>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-kernel@vger.kernel.org, cjb@laptop.org, linux-mmc@vger.kernel.org
Message-ID: <728441958.616721.1316748325054.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
In-Reply-To: <1316705680-1940-1-git-send-email-linkinjeon@gmail.com>
Subject: Re: [PATCH] mmc : general purpose partition support.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.62.177]
X-Mailer: Zimbra 7.1.1_GA_3225 (ZimbraWebClient - SAF3 (Linux)/7.1.1_GA_3225)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Namjae,

I scanned over your changes to enable GP partitions, and while I 
did not yet test your changes, they do appear to be ok.

Please CC me on the next version of your patch so I can give
it a spin and Ack on it.

I do suggest at least thinking about ways to improve on this. Back
when I added boot partition support, I already didn't like the fact
that the block driver had to be aware of the eMMC partitions, with all
the code duplication and such. By adding four more partitions,
you've compounded the problem and now you have six pieces of 
code that really look the same.

The core/mmc.c right now scans the size values and stores them
in mmc_card, and the block driver is smart enough to know what
to do with them. Why not make the block code generic at the expense
of keeping an array of structures in mmc_card? The block driver
would then just iterate over these and create the additional devices. The partition
switch routine would then operate on these structures, and could then be pulled out
of the block driver, making it simpler. 

Each physical partition could be described by something like - 
struct mmc_part {
    unsigned int size;
    unsigned int cookie;        /* for mmc, idx used in mmc_switch, part_type from current mmc_blk_data */
    char name[DISK_NAME_LEN];
    bool force_ro;              /* to make boot parts RO by default */
};

Just an idea. Clearly, if MMC grows by another 4-5 possible partitions, it's not
realistic to be copy-pasting the same block of code, nor would it make sense
if/when these types of devices support an arbitrary amount of physical partitions.

Thanks,
A

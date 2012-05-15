Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932611Ab2EORs3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 13:48:29 -0400
Received: from mail.grid-net.com ([97.65.115.2]:40551 "EHLO mail.grid-net.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754656Ab2EORs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 13:48:27 -0400
Message-ID: <4FB296EA.5090104@grid-net.com>
Date: Tue, 15 May 2012 10:48:26 -0700
From: Subodh Nijsure <snijsure@grid-net.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: <linux-mtd@lists.infradead.org>, <Heinz.Egger@linutronix.de>,
        <tglx@linutronix.de>, <tim.bird@am.sony.com>,
        <linux-kernel@vger.kernel.org>, <dedekind1@gmail.com>
Subject: Re: [RFC v4] UBI: Fastmap support (aka checkpointing)
References: <1337101871-31181-1-git-send-email-richard@nod.at>
In-Reply-To: <1337101871-31181-1-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.0.120]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Richard,

On 05/15/2012 10:11 AM, Richard Weinberger wrote:
> v1: https://lwn.net/Articles/481612/
> v2: https://lwn.net/Articles/496586/
> v3: Didn't release it to linux-mtd
Will kernel that has older UBI drivers be able to mount and update the 
UBI volumes that have been created with checkpointing feature?

Say I have bootrom that has 3.0.X kernel that has no knowledge of UBI 
checkpointing, and my flash /dev/mtd2 has UBI volume with checkpointing 
enabled. Will this bootrom be able to attach /dev/mtd2 and mount  UBI 
volume and read/write files on it?

-Subodh
> Changes since v1:
>          - renamed it to UBIVIS (at least in Kconfig)
>          - UBIVIS parameters are now configurable via Kconfig
>          - several bugs have been fixed (design and implementation bugs)
>          - added lots of comments to make the review process easier
>          - made checkpatch.pl happy
>
> Changes since v2:
>          - minor bugs have been fixed
>          - renamed it to UBI fastmap (as Artem requested)
>
> Changes since v3:
>          - changed the on-flash layout (added padding fields, turned the
>            EBA storage into an array)
>          - fixed some corner cases (the protection queue needed some extra work)
> 	- removed the data type hint logic
> 	- rebased to Artems mtd tree
>
> [PATCH 1/7] [RFC] UBI: Export next_sqnum()
> [PATCH 2/7] [RFC] UBI: Export compare_lebs()
> [PATCH 3/7] [RFC] UBI: Add fastmap on-flash layout
> [PATCH 4/7] [RFC] UBI: Add fastmap structs to ubi_device
> [PATCH 5/7] [RFC] UBI: Make wl subsystem fastmap aware
> [PATCH 6/7] [RFC] UBI: Implement fastmapping support
> [PATCH 7/7] [RFC] UBI: Wire up fastmap support
>
> git://git.kernel.org/pub/scm/linux/kernel/git/rw/ubi2.git ubi2/v4
>
> Some benchmark numbers:
>
> 4GiB NAND
> Erase block size: 1MiB
> Page size: 4096
> Total PEBs: 4081*
>
> Attach method   Time**          #scanned PEBs
> ---------------------------------------------
> scanning        0m4.568s        4081
> fastmap         0m0.486s        3
>
>
> 2GiB NAND
> Erase block size: 1MiB
> Page size: 4096
> Total PEBs: 2062*
>
> Attach method   Time            #scanned PEBs
> ---------------------------------------------
> scanning        0m2.440s        2062
> fastmap         0m0.439s        3
>
>
> 1GiB NAND
> Erase block size: 1MiB
> Page size: 4096
> Total PEBs: 1038*
>
> Attach method   Time            #scanned PEBs
> ---------------------------------------------
> scanning        0m1.351s        1038
> fastmap         0m0.422s        4
>
>
> We observe that attaching by scanning depends on the total size N of the UBI
> device.It has a complexity of O(N).
> Whereas attaching by fastmap has a nearly constant attaching time.
> In the best case fastmap has to scan only one PEB.
> This case can happen if the complete fastmap fits into one PEB, the fastmap
> super block is the first PEB on the MTD partition and the fastmap pool is empty.
> On the other side, in the worst case fastmap has to scan UBI_FM_MAX_START +
> UBI_FM_MAX_BLOCKS + UBI_FM_MAX_POOL_SIZE PEBs.
> With the current default settings this would be 192 PEBs.
> So, attaching via fastmap has a complexity of O(1).
> I think we can reduce UBI_FM_MAX_BLOCKS and UBI_FM_MAX_POOL_SIZE to a much
> smaller value. On most real NAND chips the whole fastmap fits into one PEB.
>
> TODO:
>          - Artem is fully happy with the current on-flash layout,
>            maybe I can merge the erase counters into the EBA table
>          - Get a full review :)
>
> Thanks,
> //richard
>
> *) Didn't use the full NAND for UBI because Kernel, U-Boot, DT needed also
> some space.
>
> **) Time was taken by: "time ubiattach -m 5"
>
> ______________________________________________________
> Linux MTD discussion mailing list
> http://lists.infradead.org/mailman/listinfo/linux-mtd/


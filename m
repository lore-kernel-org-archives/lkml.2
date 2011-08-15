Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab1HOLy2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 07:54:28 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46565 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab1HOLy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 07:54:26 -0400
Subject: Re: [PATCH] UBI: new module ubiblk: block layer on top of UBI
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: David Wagner <david.wagner@free-electrons.com>
Cc: linux-mtd@lists.infradead.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
        tim.bird@am.sony.com
Date: Mon, 15 Aug 2011 14:56:02 +0300
In-Reply-To: <1311683250-7921-1-git-send-email-david.wagner@free-electrons.com>
References: <1308922482-14967-1-git-send-email-david.wagner@free-electrons.com>
	 <1311683250-7921-1-git-send-email-david.wagner@free-electrons.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1313409368.2583.14.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-26 at 14:27 +0200, David Wagner wrote:
> Advantages of ubiblk over gluebi+mtdblock_ro:
> 
>  * Simpler architecture
> 
>  * The numbering of devices is much easier with ubiblk than with
>    gluebi+mtdblock_ro. With gluebi+mtdblock_ro, you get one additional
>    MTD device for each UBI volume, so the number of MTD devices grows
>    quite a lot and is a bit difficult to understand. For example,
>    mtdblock[0-4] might be your real MTD partitions, while mtdblock[5-9]
>    might be your UBI volumes.
>    It also means that if a new real MTD
>    partition is added, the number of all the MTD devices exposing UBI
>    volumes will be incremented by one, which is a bit
>    confusing/annoying.
>    As well, if you add an UBI volume, the mtdblock devices that are
>    emulated on top of volumes that come after this new one will have
>    their ID incremented.
> 
>  * The performance appears to be slightly better with ubiblk than
>    gluebi+mtdblock_ro, according to our benchmarks (see
>    http://elinux.org/Flash_Filesystem_Benchmarks_2.6.39)

Hi, sounds good.

However, what I think is wrong is to follow the MTD + mtdblock approach:
mtdblock creates a block device for every MTD device - this is wasteful
and confusing. Indeed, it is wasteful because we end up with potentially
many unneeded block devices which are not used but consume resources.
Confusing is because people get impression that /dev/mtdblock* are the
right interfaces to access the MTD devices, which is wrong.

You can say that gluebi is also doing something like that - yes, this is
because gluebi is kind of temporary solution for software which cannot
work with UBI. We wanted to keep it very simple.

My suggestion is to do something similar to UBI:

* make ubiblk register its own character device (/dev/ubiblk_ctl,
similar to /dev/ubi_ctl).
* add a couple of ioclts to create / delete ubiblk devices (similar to
UBI attach/detach)
* add a couple of user-space tools to mtd-utils to create / delete
ubiblk devices (similar to ubiattach / ubidetach).

The other reason why I think this more complex approach is justified is
that when / if you decide to add R/W support to ubiblk, you'd have
troubles with the current approach (e.g., what if the UBI volume you are
looking at is not ubiblk-formatted?)

I think it should be rather easy to implement /dev/ubiblk_ctl.

-- 
Best Regards,
Artem Bityutskiy


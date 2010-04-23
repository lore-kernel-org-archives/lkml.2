Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198Ab0DWMHN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 08:07:13 -0400
Received: from smtp.nokia.com ([192.100.122.233]:51161 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932164Ab0DWMHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 08:07:09 -0400
Subject: Re: [PATCH] Fix a huge latency problem in the MTD CFI and LPDDR
 flash drivers.
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, dwmw2@infradead.org, michael.kreuzer@nsn.com,
       nico@fluxnic.net
In-Reply-To: <1271623604.7050.0.camel@wall-e.seibold.net>
References: <1271623604.7050.0.camel@wall-e.seibold.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Apr 2010 15:03:24 +0300
Message-ID: <1272024204.6917.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 23 Apr 2010 12:06:32.0754 (UTC) FILETIME=[6A006120:01CAE2DD]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-04-18 at 22:46 +0200, Stefani Seibold wrote:
> From: Stefani Seibold <stefani@seibold.net>
> 
> The use of a memcpy() during a spinlock operation will cause very long
> thread context switch delays if the flash chip bandwidth is low and the
> data to be copied large, because a spinlock will disable preemption.
> 
> For example: A flash with 6,5 MB/s bandwidth will cause under ubifs,
> which request sometimes 128 KB (the flash erase size), a preemption delay of
> 20 milliseconds. High priority threads will not be served during this
> time, regardless whether this threads access the flash or not. This behavior
> breaks real time.
> 
> The patch changes all the use of spin_lock operations for xxxx->mutex
> into mutex operations, which is exact what the name says and means.
> 
> I have checked the code of the drivers and there is no use of atomic
> pathes like interrupt or timers. The mtdoops facility will also not be used
> by this drivers. So it is dave to replace the spin_lock against mutex.
> 
> There is no performance regression since the mutex is normally not
> acquired.
> 
> Changelog:
>  06.03.2010 First release
>  26.03.2010 Fix mutex[1] issue and tested it for compile failure
> 
> Signed-off-by: Stefani Seibold <stefani@seibold.net>
> ---
>  drivers/mtd/chips/cfi_cmdset_0001.c |  131 +++++++++++++++++-----------------
>  drivers/mtd/chips/cfi_cmdset_0002.c |  122 ++++++++++++++++----------------
>  drivers/mtd/chips/cfi_cmdset_0020.c |  136 +++++++++++++++++-----------------
>  drivers/mtd/chips/fwh_lock.h        |    6 +-
>  drivers/mtd/chips/gen_probe.c       |    3 +-
>  drivers/mtd/lpddr/lpddr_cmds.c      |   79 ++++++++++----------
>  include/linux/mtd/flashchip.h       |    4 +-
>  7 files changed, 239 insertions(+), 242 deletions(-)

Pushed to l2-mtd-2.6.git / master.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)


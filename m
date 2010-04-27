Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab0D0NMN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 09:12:13 -0400
Received: from smtp.nokia.com ([192.100.122.233]:17450 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579Ab0D0NMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 09:12:06 -0400
Subject: Re: [PATCHv2 1/2] MTD: cfi_cmdset_0002: Add reboot notifier for
 AMD flashes
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Kevin Cernekee <cernekee@gmail.com>
Cc: dwmw2@infradead.org, saeed.bishara@gmail.com,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <a00f98bfcda7db841108605ebab8d07363f4aa8b@localhost.localdomain>
References: <1271221078.2532.5.camel@localhost.localdomain>
	 <a00f98bfcda7db841108605ebab8d07363f4aa8b@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Apr 2010 16:07:34 +0300
Message-ID: <1272373654.7750.7.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 27 Apr 2010 13:11:48.0637 (UTC) FILETIME=[31B3B4D0:01CAE60B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-14 at 17:57 -0700, Kevin Cernekee wrote:
> Ensure that the flash device is in a quiescent state before rebooting.
> The implementation is closely modeled after the cfe_cmdset_0001 reboot
> notifier, commit 963a6fb0a0d336d0513083b7e4b5c3ff9d6d2061 .
> 
> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
> ---
>  drivers/mtd/chips/cfi_cmdset_0002.c |   56 +++++++++++++++++++++++++++++++++++
>  1 files changed, 56 insertions(+), 0 deletions(-)

This patch conflicts with the patch from Stefani, which is sitting in my
l2-mtd-2.6.git tree
(http://git.infradead.org/users/dedekind/l2-mtd-2.6.git). Could you
please amend it and re-send?

The conflicting patch is:

Author: Stefani Seibold <stefani@seibold.net>
Date:   Sun Apr 18 22:46:44 2010 +0200

    mtd: fix a huge latency problem in the MTD CFI and LPDDR flash drivers.
    
    The use of a memcpy() during a spinlock operation will cause very long
    thread context switch delays if the flash chip bandwidth is low and the
    data to be copied large, because a spinlock will disable preemption.
    
    For example: A flash with 6,5 MB/s bandwidth will cause under ubifs,
    which request sometimes 128 KB (the flash erase size), a preemption delay of
    20 milliseconds. High priority threads will not be served during this
    time, regardless whether this threads access the flash or not. This behavior
    breaks real time.
    
    The patch changes all the use of spin_lock operations for xxxx->mutex
    into mutex operations, which is exact what the name says and means.
    
    I have checked the code of the drivers and there is no use of atomic
    pathes like interrupt or timers. The mtdoops facility will also not be used
    by this drivers. So it is dave to replace the spin_lock against mutex.
    
    There is no performance regression since the mutex is normally not
    acquired.
    
    Changelog:
     06.03.2010 First release
     26.03.2010 Fix mutex[1] issue and tested it for compile failure
    
    Signed-off-by: Stefani Seibold <stefani@seibold.net>
    Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>


-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)


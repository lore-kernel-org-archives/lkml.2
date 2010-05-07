Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab0EGPNo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 11:13:44 -0400
Received: from smtp.nokia.com ([192.100.105.134]:28299 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754976Ab0EGPNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 11:13:42 -0400
Subject: Re: UBIFS: Oops while rebooting 2.6.34-rc6
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Daniel Mack <daniel@caiaq.de>
Cc: Adrian Hunter <adrian.hunter@nokia.com>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, Sven Neumann <s.neumann@raumfeld.com>
In-Reply-To: <20100507131652.GT30801@buzzloop.caiaq.de>
References: <20100507131652.GT30801@buzzloop.caiaq.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 May 2010 18:12:34 +0300
Message-ID: <1273245154.4537.288.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 07 May 2010 15:13:21.0969 (UTC) FILETIME=[D4FF5A10:01CAEDF7]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good Evening,

On Fri, 2010-05-07 at 15:16 +0200, Daniel Mack wrote:
> We've had a kernel Oops today when rebooting an ARM PXA based machine
> while file I/O via SSH was outstanding.
> 
> Daniel
> 
> # reboot
> # [  671.190085] UBIFS: un-mount UBI device 0, volume 1
> The system is going down NOW!
> Sent SIGTERM to all processes
> [  672.083833] Unable to handle kernel NULL pointer dereference at virtual address 000000ac
> [  672.094587] pgd = c0004000
> [  672.097301] [000000ac] *pgd=00000000
> [  672.100850] Internal error: Oops: 817 [#1]
> [  672.104919] last sysfs file: /sys/devices/platform/spi_gpio.0/spi0.2/value
> [  672.111741] Modules linked in: eeti_ts libertas_sdio libertas pxamci ds2760_battery w1_ds2760 wire
> [  672.120641] CPU: 0    Tainted: G        W   (2.6.34-rc6 #154)
> [  672.126376] PC is at mutex_lock+0x4/0x14
> [  672.130291] LR is at make_reservation+0x74/0x328

Hi,

is this reproducible? It looks like this came from:

journal.c:127:  mutex_lock_nested(&wbuf->io_mutex, wbuf->jhead);

May be memory corruption? Did you try to see where exectly was the oops,
on which C statement?

Do you have lockdep enabled? Can it be that lockdep somehow shutdown
first? This is unlikely, though.

May be the FS was somehow unmounted, so UBIFS freed its data structures,
and now UBIFS accesses freed memory?

Try to inject some printks to ubifs_umount() or just enable the general
UBIFS messages (enable UBIFS debugging in menuconfig first, then enable
the general messages via module parameters or sysfs, see
Documentation/filesystems/ubifs.txt).

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)


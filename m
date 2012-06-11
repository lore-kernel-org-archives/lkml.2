Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab2FKNO7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 09:14:59 -0400
Received: from smtp-out-197.synserver.de ([212.40.185.197]:1246 "EHLO
	smtp-out-192.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752234Ab2FKNO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 09:14:58 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 29054
From: Lars-Peter Clausen <lars@metafoo.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, Randy Dunlap <rdunlap@xenotime.net>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-iio@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] staging:iio:ad7298: Fix linker error due to missing IIO kfifo buffer
Date: Mon, 11 Jun 2012 15:09:21 +0200
Message-Id: <1339420161-23760-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <4FD23340.70108@xenotime.net>
References: <4FD23340.70108@xenotime.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ad7298 drivers buffer implementation uses the IIO kfifo buffer, so it needs
to select IIO_KFIFO_BUF. Otherwise (if no other driver selects the symbol) the
following linker error will occur:

drivers/built-in.o: In function `ad7298_register_ring_funcs_and_init':
	(.text+0x245cf2): undefined reference to `iio_kfifo_allocate'
drivers/built-in.o: In function `ad7298_register_ring_funcs_and_init':
	(.text+0x245d7d): undefined reference to `iio_kfifo_free'
drivers/built-in.o: In function `ad7298_ring_cleanup':
	(.text+0x245dcd): undefined reference to `iio_kfifo_free'

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Reported-by: Randy Dunlap <rdunlap@xenotime.net>

---
The patch is only required for 3.5-rc1+. Versions prior to 3.5-rc1 require a
different patch (IIO_SW_RING instead of IIO_KFIFO_BUF) which I'll send to stable
once this patch is in Linus' tree.
---
 drivers/staging/iio/adc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/iio/adc/Kconfig b/drivers/staging/iio/adc/Kconfig
index 2490dd2..8f1b3af 100644
--- a/drivers/staging/iio/adc/Kconfig
+++ b/drivers/staging/iio/adc/Kconfig
@@ -13,6 +13,7 @@ config AD7291
 config AD7298
 	tristate "Analog Devices AD7298 ADC driver"
 	depends on SPI
+	select IIO_KFIFO_BUF if IIO_BUFFER
 	help
 	  Say yes here to build support for Analog Devices AD7298
 	  8 Channel ADC with temperature sensor.
-- 
1.7.10


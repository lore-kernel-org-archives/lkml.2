Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030773Ab2HQD36 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 23:29:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46822 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030673Ab2HQD1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 23:27:07 -0400
Message-Id: <20120817030248.367798409@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 17 Aug 2012 04:03:12 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Arnd Bergmann <arnd@arndb.de>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Daniel Ribeiro <drwyrm@gmail.com>
Subject: [ 29/37] ARM: pxa: remove irq_to_gpio from ezx-pcap driver
In-Reply-To: <20120817030243.807605523@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit 59ee93a528b94ef4e81a08db252b0326feff171f upstream.

The irq_to_gpio function was removed from the pxa platform
in linux-3.2, and this driver has been broken since.

There is actually no in-tree user of this driver that adds
this platform device, but the driver can and does get enabled
on some platforms.

Without this patch, building ezx_defconfig results in:

drivers/mfd/ezx-pcap.c: In function 'pcap_isr_work':
drivers/mfd/ezx-pcap.c:205:2: error: implicit declaration of function 'irq_to_gpio' [-Werror=implicit-function-declaration]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Daniel Ribeiro <drwyrm@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/mfd/ezx-pcap.c       |    2 +-
 include/linux/mfd/ezx-pcap.h |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/ezx-pcap.c b/drivers/mfd/ezx-pcap.c
index 43a76c4..db662e2 100644
--- a/drivers/mfd/ezx-pcap.c
+++ b/drivers/mfd/ezx-pcap.c
@@ -202,7 +202,7 @@ static void pcap_isr_work(struct work_struct *work)
 		}
 		local_irq_enable();
 		ezx_pcap_write(pcap, PCAP_REG_MSR, pcap->msr);
-	} while (gpio_get_value(irq_to_gpio(pcap->spi->irq)));
+	} while (gpio_get_value(pdata->gpio));
 }
 
 static void pcap_irq_handler(unsigned int irq, struct irq_desc *desc)
diff --git a/include/linux/mfd/ezx-pcap.h b/include/linux/mfd/ezx-pcap.h
index 40c37216..32a1b5c 100644
--- a/include/linux/mfd/ezx-pcap.h
+++ b/include/linux/mfd/ezx-pcap.h
@@ -16,6 +16,7 @@ struct pcap_subdev {
 struct pcap_platform_data {
 	unsigned int irq_base;
 	unsigned int config;
+	int gpio;
 	void (*init) (void *);	/* board specific init */
 	int num_subdevs;
 	struct pcap_subdev *subdevs;



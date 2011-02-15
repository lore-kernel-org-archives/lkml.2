Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab1BOV7D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 16:59:03 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:13700 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755465Ab1BOV67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 16:58:59 -0500
Message-ID: <4D5AF711.3000508@bluewatersys.com>
Date: Wed, 16 Feb 2011 10:58:41 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Thomas Chou <thomas@wytron.com.tw>,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, nios2-dev@sopc.et.ntust.edu.tw,
        devicetree-discuss@lists.ozlabs.org,
        spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH v9] spi: New driver for Altera SPI
References: <1297142509-20158-1-git-send-email-thomas@wytron.com.tw> <1297649443-11491-1-git-send-email-thomas@wytron.com.tw> <4D58917E.9050408@bluewatersys.com> <4D5A2591.5090901@wytron.com.tw> <20110215194257.GB7649@angua.secretlab.ca>
In-Reply-To: <20110215194257.GB7649@angua.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/02/11 08:42, Grant Likely wrote:
> On Tue, Feb 15, 2011 at 03:04:49PM +0800, Thomas Chou wrote:
>> Dear Ryan,
>>
>> On 02/14/2011 10:20 AM, Ryan Mallon wrote:
>>> On 02/14/2011 03:10 PM, Thomas Chou wrote:
>>>> This patch adds a new SPI driver to support the Altera SOPC Builder
>>>> SPI component. It uses the bitbanging library.
>>>>
>>>> Signed-off-by: Thomas Chou<thomas@wytron.com.tw>
>>>> ---
>>>> +struct altera_spi {
>>>> +	/* bitbang has to be first */
>>>> +	struct spi_bitbang bitbang;
>>> Is this still true? I had a quick look and can't see anything which
>>> relies on spi_bitbang being the first entry. Things like this should be
>>> using container_of so that position in the struct is irrelevant.
>>>
>>> ~Ryan
>>>
>> Yes, sadly true. This is due to the implementation of the bitbanging
>> library, spi_bitbang.c, which assumes the struct spi_bitbang is the
>> first of drvdata. Though it could be changed in the future (beyond
>> this little driver), every bitbanging library user has to follow
>> this for now.
> Should be easy to fix if it is indeed still true (I haven't dug deep
> enough to find the design error yet).  Anybody want to volunteer?
>
> g.
>
The problem is that spi_master_get_devdata is used to get both 
struct spi_bitbang and the controller dependent structure, which means
that struct spi_bitbang must be the first entry in the container
structure.

The following incomplete, untested patch shows a possible way to fix
this by introducing spi_alloc_master_bitbang. spi_master_get_devdata
now returns a pointer to struct spi_bitbang only. Drivers which need
an additional container struct should allocate it themselves and 
pass the bitbang field to spi_alloc_master_bitbang. The driver 
specific container can be fetched with:

static inline struct my_spi *to_my_spi(struct spi_master *master)
{
	struct spi_bitbang *bitbang = spi_master_get_devdata(master);
	return container_of(bitbang, struct my_spi, bitbang);
} 

This patch only adds the alloc function and shows the necessary
changes to the spi_gpio.c driver, which is actually pretty minimal.
If there is any interest I can code up a proper patch.

~Ryan

---
diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 34bb17f..52ec691 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -27,6 +27,7 @@
 #include <linux/slab.h>
 #include <linux/mod_devicetable.h>
 #include <linux/spi/spi.h>
+#include <linux/spi/spi_bitbang.h>
 #include <linux/of_spi.h>
 #include <linux/pm_runtime.h>
 
@@ -560,6 +561,24 @@ struct spi_master *spi_alloc_master(struct device *dev, unsigned size)
 }
 EXPORT_SYMBOL_GPL(spi_alloc_master);
 
+struct spi_master *spi_alloc_master_bitbang(struct device *dev,
+					    struct spi_bitbang *bitbang)
+{
+	struct spi_master *master;
+
+	master = kzalloc(sizeof(struct spi_master), GFP_KERNEL);
+	if (!master)
+		return NULL;
+
+	device_initialize(&master->dev);
+	master->dev.class = &spi_master_class;
+	master->dev.parent = get_device(dev);
+	spi_master_set_devdata(master, bitbang);
+
+	return master;
+}
+EXPORT_SYMBOL_GPL(spi_alloc_master_bitbang);
+
 /**
  * spi_register_master - register SPI master controller
  * @master: initialized master, originally from spi_alloc_master()
diff --git a/drivers/spi/spi_gpio.c b/drivers/spi/spi_gpio.c
index 63e51b0..169dbf0 100644
--- a/drivers/spi/spi_gpio.c
+++ b/drivers/spi/spi_gpio.c
@@ -329,12 +329,17 @@ static int __init spi_gpio_probe(struct platform_device *pdev)
 	if (status < 0)
 		return status;
 
-	master = spi_alloc_master(&pdev->dev, sizeof *spi_gpio);
-	if (!master) {
+	spi_gpio = kzalloc(sizeof(struct spi_gpio), GFP_KERNEL);
+	if (!spi_gpio) {
 		status = -ENOMEM;
 		goto gpio_free;
 	}
-	spi_gpio = spi_master_get_devdata(master);
+
+	master = spi_alloc_master_bitbang(&pdev->dev, &spi_gpio->bitbang);
+	if (!master) {
+		status = -ENOMEM;
+		goto spi_gpio_free;
+	}
 	platform_set_drvdata(pdev, spi_gpio);
 
 	spi_gpio->pdev = pdev;
@@ -367,6 +372,8 @@ static int __init spi_gpio_probe(struct platform_device *pdev)
 	status = spi_bitbang_start(&spi_gpio->bitbang);
 	if (status < 0) {
 		spi_master_put(spi_gpio->bitbang.master);
+spi_gpio_free:
+		kfree(spi_gpio);
 gpio_free:
 		if (SPI_MISO_GPIO != SPI_GPIO_NO_MISO)
 			gpio_free(SPI_MISO_GPIO);
@@ -391,6 +398,7 @@ static int __exit spi_gpio_remove(struct platform_device *pdev)
 	/* stop() unregisters child devices too */
 	status = spi_bitbang_stop(&spi_gpio->bitbang);
 	spi_master_put(spi_gpio->bitbang.master);
+	kfree(spi_gpio);
 
 	platform_set_drvdata(pdev, NULL);
 
diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index b4d7710..3f72a34 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -336,7 +336,8 @@ static inline void spi_master_put(struct spi_master *master)
 /* the spi driver core manages memory for the spi_master classdev */
 extern struct spi_master *
 spi_alloc_master(struct device *host, unsigned size);
-
+extern struct spi_master *
+spi_alloc_master_bitbang(struct device *host, struct spi_bitbang *bitbang);
 extern int spi_register_master(struct spi_master *master);
 extern void spi_unregister_master(struct spi_master *master);
 



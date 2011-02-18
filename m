Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547Ab1BRK3A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 05:29:00 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:46549 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947Ab1BRK26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 05:28:58 -0500
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: "'Arnd Bergmann'" <arnd@arndb.de>, <dmitry.torokhov@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        "'Greg KH'" <greg@kroah.com>
References: <015701cbcdae$7d5f43f0$781dcbd0$@mprc.pku.edu.cn> <201102171803.15785.arnd@arndb.de>
In-Reply-To: <201102171803.15785.arnd@arndb.de>
Subject: RE: [PATCH 11/12] unicore32 machine related files: ps2 driver
Date: Fri, 18 Feb 2011 18:28:45 +0800
Message-ID: <00eb01cbcf56$9f372700$dda57500$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQHwh2GX42xqIG1pSB6ZyMOWdcE4LgJvzZEgk6ofLnA=
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Friday, February 18, 2011 1:03 AM
> To: Guan Xuetao
> Cc: linux-kernel@vger.kernel.org; linux-arch@vger.kernel.org; 'Greg KH'
> Subject: Re: [PATCH 11/12] unicore32 machine related files: ps2 driver
> 
> On Wednesday 16 February 2011, Guan Xuetao wrote:
> > +/*
> > + * Register numbers.
> > + */
> > +#define I8042_COMMAND_REG      ((unsigned long)&PS2_COMMAND)
> > +#define I8042_STATUS_REG       ((unsigned long)&PS2_STATUS)
> > +#define I8042_DATA_REG         ((unsigned long)&PS2_DATA)
> > +
> > +static inline int i8042_read_data(void)
> > +{
> > +       return inb(I8042_DATA_REG);
> > +}
> > +
> > +static inline int i8042_read_status(void)
> > +{
> > +       return inb(I8042_STATUS_REG);
> > +}
> > +
> 
> This is not a correct way to use inb()/outb(), as far as I can tell:
> PS2_COMMAND is an mmio pointer (or should be, see my other message).
> 
> inb() however is only defined on PCI/ISA PIO port numbers, which
> are in the range between 0 and 65535, and typically get mapped
> into the memory from the PCI driver.
Thanks.
Please see my patch following, and cc to Dmitry Torokhov.

From: GuanXuetao <gxt@mprc.pku.edu.cn>
Date: Fri, 18 Feb 2011 18:38:33 +0800
Subject: [PATCH] unicore32: adjust i8042-unicore32io codes
   replace inb/outb with readb/writeb in i8042-unicore32io.h
   and correct typecasting of register and region macros
   -- by advice with Arnd Bergmann

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 drivers/input/serio/i8042-unicore32io.h |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/input/serio/i8042-unicore32io.h b/drivers/input/serio/i8042-unicore32io.h
index 6a7e8b3..2cdd872 100644
--- a/drivers/input/serio/i8042-unicore32io.h
+++ b/drivers/input/serio/i8042-unicore32io.h
@@ -29,33 +29,36 @@
 /*
  * Register numbers.
  */
-#define I8042_COMMAND_REG	((unsigned long)&PS2_COMMAND)
-#define I8042_STATUS_REG	((unsigned long)&PS2_STATUS)
-#define I8042_DATA_REG		((unsigned long)&PS2_DATA)
+#define I8042_COMMAND_REG	((volatile void __iomem *)&PS2_COMMAND)
+#define I8042_STATUS_REG	((volatile void __iomem *)&PS2_STATUS)
+#define I8042_DATA_REG		((volatile void __iomem *)&PS2_DATA)
+
+#define I8042_REGION_START	(resource_size_t)(&PS2_DATA)
+#define I8042_REGION_SIZE	(resource_size_t)(16)
 
 static inline int i8042_read_data(void)
 {
-	return inb(I8042_DATA_REG);
+	return readb(I8042_DATA_REG);
 }
 
 static inline int i8042_read_status(void)
 {
-	return inb(I8042_STATUS_REG);
+	return readb(I8042_STATUS_REG);
 }
 
 static inline void i8042_write_data(int val)
 {
-	outb(val, I8042_DATA_REG);
+	writeb(val, I8042_DATA_REG);
 }
 
 static inline void i8042_write_command(int val)
 {
-	outb(val, I8042_COMMAND_REG);
+	writeb(val, I8042_COMMAND_REG);
 }
 
 static inline int i8042_platform_init(void)
 {
-	if (!request_region(I8042_DATA_REG, 16, "i8042"))
+	if (!request_region(I8042_REGION_START, I8042_REGION_SIZE, "i8042"))
 		return -EBUSY;
 
 	i8042_reset = 1;
@@ -64,7 +67,7 @@ static inline int i8042_platform_init(void)
 
 static inline void i8042_platform_exit(void)
 {
-	release_region(I8042_DATA_REG, 16);
+	release_region(I8042_REGION_START, I8042_REGION_SIZE);
 }
 
 #endif /* _I8042_UNICORE32_H */
-- 
1.6.2.2

> 
> 	Arnd

Thanks & Regards.

Guan Xuetao


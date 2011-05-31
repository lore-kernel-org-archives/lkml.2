Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150Ab1EaIwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 04:52:17 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:48974 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752482Ab1EaIwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 04:52:15 -0400
From: Xiangliang Yu <yuxiangl@marvell.com>
To: Greg KH <greg@kroah.com>
CC: "James.Bottomley@suse.de" <James.Bottomley@suse.de>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jacky Feng <jfeng@marvell.com>
Date: Tue, 31 May 2011 01:52:05 -0700
Subject: RE: [PATCH 3/9] [SCSI] mvsas: Add driver version and interrupt
 coalescing to device 	attributes in sysfs
Thread-Topic: [PATCH 3/9] [SCSI] mvsas: Add driver version and interrupt
 coalescing to device 	attributes in sysfs
Thread-Index: AcwfZhmCqqXEh8ntQ8WROtDItTg19wAB0ayA
Message-ID: <F766E4F80769BD478052FB6533FA745D19FAD84E4F@SC-VEXCH4.marvell.com>
References: <20110526021809.GA22496@kroah.com>
 <F766E4F80769BD478052FB6533FA745D19FAD846E0@SC-VEXCH4.marvell.com>
 <20110526141430.GD4164@kroah.com>
 <F766E4F80769BD478052FB6533FA745D19FAD848FB@SC-VEXCH4.marvell.com>
 <20110527073302.GA16178@kroah.com>
 <F766E4F80769BD478052FB6533FA745D19FAD84C40@SC-VEXCH4.marvell.com>
 <20110530074508.GB7806@kroah.com>
 <F766E4F80769BD478052FB6533FA745D19FAD84CD9@SC-VEXCH4.marvell.com>
 <20110530144815.GB2689@kroah.com>
 <F766E4F80769BD478052FB6533FA745D19FAD84E1E@SC-VEXCH4.marvell.com>
 <20110531074116.GB6099@kroah.com>
In-Reply-To: <20110531074116.GB6099@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p4V8qOrl005385


>> 
>> >Then I would strongly recommend never exporting this value to allow it
> >>to be changed at all then.  It doesn't sound worth it.
> >OK, Thanks!
> >I remove the sysfs file and the modified patch is:

>Thanks for removing it, but you still left part of it in the patch, see
>below.

>> diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
>> index 9f1cccc..d977684 100644
>> --- a/drivers/scsi/mvsas/mv_init.c
>> +++ b/drivers/scsi/mvsas/mv_init.c
>> @@ -34,6 +34,8 @@ MODULE_PARM_DESC(collector, "\n"
>>  	"\tThe mvsas SAS LLDD supports both modes.\n"
>>  	"\tDefault: 1 (Direct Mode).\n");
>>  
>> +int interrupt_coalescing = 0x80;

>This should be named something else, or made static, as you just made it
>a global name, which is not good at all.
OK, thanks£¡

>> @@ -48,6 +50,8 @@ static const struct mvs_chip_info mvs_chips[] = {
>>  	[chip_1320] =	{ 2, 4, 0x800, 17, 64,  9, &mvs_94xx_dispatch, },
> > };
>  >
> >+struct device_attribute *mvst_host_attrs[] = { NULL };
> >+
> > #define SOC_SAS_NUM 2
> > #define SG_MX 64
> > 
> >@@ -74,6 +78,7 @@ static struct scsi_host_template mvs_sht = {
> > 	.slave_alloc		= mvs_slave_alloc,
> > 	.target_destroy		= sas_target_destroy,
> > 	.ioctl			= sas_ioctl,
> >+	.shost_attrs		= mvst_host_attrs,

> Here, you don't need these at all now, right?
I think I may need these someday, but I can remove these. Anyway, thanks!

drivers/scsi/mvsas/mv_64xx.c  |   25 ++++++++++++++++++++++++-
 drivers/scsi/mvsas/mv_94xx.c  |   26 +++++++++++++++++++++++++-
 drivers/scsi/mvsas/mv_chips.h |    2 ++
 drivers/scsi/mvsas/mv_sas.h   |    1 +
 4 files changed, 52 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_64xx.c b/drivers/scsi/mvsas/mv_64xx.c
index 0e13e64..c88b8a7 100644
--- a/drivers/scsi/mvsas/mv_64xx.c
+++ b/drivers/scsi/mvsas/mv_64xx.c
@@ -402,7 +402,7 @@ static int __devinit mvs_64xx_init(struct mvs_info *mvi)
 	tmp = 0;
 	mw32(MVS_INT_COAL, tmp);
 
-	tmp = 0x100;
+	tmp = 0x10000 | interrupt_coalescing;
 	mw32(MVS_INT_COAL_TMOUT, tmp);
 
 	/* ladies and gentlemen, start your engines */
@@ -758,6 +758,28 @@ void mvs_64xx_fix_dma(dma_addr_t buf_dma, int buf_len, int from, void *prd)
 }
 #endif
 
+static void mvs_64xx_tune_interrupt(struct mvs_info *mvi, u32 time)
+{
+	void __iomem *regs = mvi->regs;
+	u32 tmp = 0;
+	/* interrupt coalescing may cause missing HW interrput in some case,
+	 * and the max count is 0x1ff, while our max slot is 0x200,
+	 * it will make count 0.
+	 */
+	if (time == 0) {
+		mw32(MVS_INT_COAL, 0);
+		mw32(MVS_INT_COAL_TMOUT, 0x10000);
+	} else {
+		if (MVS_CHIP_SLOT_SZ > 0x1ff)
+			mw32(MVS_INT_COAL, 0x1ff|COAL_EN);
+		else
+			mw32(MVS_INT_COAL, MVS_CHIP_SLOT_SZ|COAL_EN);
+
+		tmp = 0x10000 | time;
+		mw32(MVS_INT_COAL_TMOUT, tmp);
+	}
+}
+
 const struct mvs_dispatch mvs_64xx_dispatch = {
 	"mv64xx",
 	mvs_64xx_init,
@@ -811,6 +833,7 @@ const struct mvs_dispatch mvs_64xx_dispatch = {
 #ifndef DISABLE_HOTPLUG_DMA_FIX
 	mvs_64xx_fix_dma,
 #endif
+	mvs_64xx_tune_interrupt,
 	NULL,
 };
 
diff --git a/drivers/scsi/mvsas/mv_94xx.c b/drivers/scsi/mvsas/mv_94xx.c
index 3f2ad93..e589f31 100644
--- a/drivers/scsi/mvsas/mv_94xx.c
+++ b/drivers/scsi/mvsas/mv_94xx.c
@@ -475,7 +475,7 @@ static int __devinit mvs_94xx_init(struct mvs_info *mvi)
 	tmp = 0;
 	mw32(MVS_INT_COAL, tmp);
 
-	tmp = 0x100;
+	tmp = 0x10000 | interrupt_coalescing;
 	mw32(MVS_INT_COAL_TMOUT, tmp);
 
 	/* ladies and gentlemen, start your engines */
@@ -894,6 +894,29 @@ static void mvs_94xx_clear_srs_irq(struct mvs_info *mvi, u8 reg_set,
 {
 }
 
+static void mvs_94xx_tune_interrupt(struct mvs_info *mvi, u32 time)
+{
+	void __iomem *regs = mvi->regs;
+	u32 tmp = 0;
+	/* interrupt coalescing may cause missing HW interrput in some case,
+	 * and the max count is 0x1ff, while our max slot is 0x200,
+	 * it will make count 0.
+	 */
+	if (time == 0) {
+		mw32(MVS_INT_COAL, 0);
+		mw32(MVS_INT_COAL_TMOUT, 0x10000);
+	} else {
+		if (MVS_CHIP_SLOT_SZ > 0x1ff)
+			mw32(MVS_INT_COAL, 0x1ff|COAL_EN);
+		else
+			mw32(MVS_INT_COAL, MVS_CHIP_SLOT_SZ|COAL_EN);
+
+		tmp = 0x10000 | time;
+		mw32(MVS_INT_COAL_TMOUT, tmp);
+	}
+
+}
+
 const struct mvs_dispatch mvs_94xx_dispatch = {
 	"mv94xx",
 	mvs_94xx_init,
@@ -947,6 +970,7 @@ const struct mvs_dispatch mvs_94xx_dispatch = {
 #ifndef DISABLE_HOTPLUG_DMA_FIX
 	mvs_94xx_fix_dma,
 #endif
+	mvs_94xx_tune_interrupt,
 	mvs_94xx_non_spec_ncq_error,
 };
 
diff --git a/drivers/scsi/mvsas/mv_chips.h b/drivers/scsi/mvsas/mv_chips.h
index 4519f80..850eb73 100644
--- a/drivers/scsi/mvsas/mv_chips.h
+++ b/drivers/scsi/mvsas/mv_chips.h
@@ -41,6 +41,8 @@
 #define iow8(reg, val) 		outb((unsigned long)(val, regs + reg))
 #define ior8(reg) 		inb((unsigned long)(regs + reg))
 
+static int interrupt_coalescing = 0x80;
+
 static inline u32 mvs_cr32(struct mvs_info *mvi, u32 addr)
 {
 	void __iomem *regs = mvi->regs;
diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sas.h
index 8740b78..847e374 100644
--- a/drivers/scsi/mvsas/mv_sas.h
+++ b/drivers/scsi/mvsas/mv_sas.h
@@ -170,6 +170,7 @@ struct mvs_dispatch {
 #ifndef DISABLE_HOTPLUG_DMA_FIX
 	void (*dma_fix)(dma_addr_t buf_dma, int buf_len, int from, void *prd);
 #endif
+	void (*tune_interrupt)(struct mvs_info *mvi, u32 time);
 	void (*non_spec_ncq_error)(struct mvs_info *mvi);
 
 };
-- 
1.7.4.4

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212Ab2KGBMJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 20:12:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:54256 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693Ab2KGBMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 20:12:07 -0500
Date: Wed, 7 Nov 2012 02:12:03 +0100
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Antti Palosaari <crope@iki.fi>
Subject: Re: linux-next: build failure after merge of the v4l-dvb tree
Message-ID: <20121107021203.1a5c52bc@gaivota.chehab>
In-Reply-To: <20121107110559.862517a9ca96383d0ea8f308@canb.auug.org.au>
References: <20121107110559.862517a9ca96383d0ea8f308@canb.auug.org.au>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.13; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, 7 Nov 2012 11:05:59 +1100
Stephen Rothwell <sfr@canb.auug.org.au> escreveu:

> Hi Mauro,
> 
> After merging the v4l-dvb tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/built-in.o: In function `sms_ir_event':
> (.text+0x129b95): undefined reference to `ir_raw_event_store'
> drivers/built-in.o: In function `sms_ir_event':
> (.text+0x129bb4): undefined reference to `ir_raw_event_handle'
> drivers/built-in.o: In function `sms_ir_init':
> (.text+0x129bec): undefined reference to `smscore_get_board_id'
> drivers/built-in.o: In function `sms_ir_init':
> (.text+0x129c17): undefined reference to `rc_allocate_device'
> drivers/built-in.o: In function `sms_ir_init':
> (.text+0x129cac): undefined reference to `sms_get_board'
> drivers/built-in.o: In function `sms_ir_init':
> (.text+0x129d41): undefined reference to `sms_get_board'
> drivers/built-in.o: In function `sms_ir_init':
> (.text+0x129d8c): undefined reference to `rc_register_device'
> drivers/built-in.o: In function `sms_ir_init':
> (.text+0x129dc3): undefined reference to `rc_free_device'
> drivers/built-in.o: In function `sms_ir_exit':
> (.text+0x129e15): undefined reference to `rc_unregister_device'
> 
> Caused (I think) by commit fdd1eeb49d36 ("[media] siano: allow compiling
> it without RC support").  In this build, CONFIG_SMS_SIANO_RC=y and
> CONFIG_RC_CORE=m .

Gah, this is one of those things that will require to trick Kconfig.

The thing is that the siano core driver needs to depend on RC_CORE, when
RC is selected. 

While I haven't tested yet, I suspect that the following patch will
likely do the trick.

It has one small drawback: if RC_CORE is a module, the siano driver
can't be builtin, even if siano RC is not selected. 

-

siano: make siano driver a module, when RC_CORE is selected as 'm'

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/common/siano/Kconfig b/drivers/media/common/siano/Kconfig
index 3cb7823..68f0f60 100644
--- a/drivers/media/common/siano/Kconfig
+++ b/drivers/media/common/siano/Kconfig
@@ -5,6 +5,7 @@
 config SMS_SIANO_MDTV
 	tristate
 	depends on DVB_CORE && HAS_DMA
+	depends on !RC_CORE || RC_CORE
 	depends on SMS_USB_DRV || SMS_SDIO_DRV
 	default y
 
diff --git a/drivers/media/common/siano/Makefile b/drivers/media/common/siano/Makefile
index 0e6f5e9..9e7fdf2 100644
--- a/drivers/media/common/siano/Makefile
+++ b/drivers/media/common/siano/Makefile
@@ -1,7 +1,10 @@
 smsmdtv-objs := smscoreapi.o sms-cards.o smsendian.o
 
 obj-$(CONFIG_SMS_SIANO_MDTV) += smsmdtv.o smsdvb.o
-obj-$(CONFIG_SMS_SIANO_RC) += smsir.o
+
+ifeq ($(CONFIG_SMS_SIANO_RC),y)
+  obj-$(CONFIG_SMS_SIANO_MDTV) += smsir.o
+endif
 
 ccflags-y += -Idrivers/media/dvb-core
 ccflags-y += $(extra-cflags-y) $(extra-cflags-m)
diff --git a/drivers/media/mmc/siano/Kconfig b/drivers/media/mmc/siano/Kconfig
index 69f8061..aa05ad3 100644
--- a/drivers/media/mmc/siano/Kconfig
+++ b/drivers/media/mmc/siano/Kconfig
@@ -4,7 +4,7 @@
 
 config SMS_SDIO_DRV
 	tristate "Siano SMS1xxx based MDTV via SDIO interface"
-	depends on DVB_CORE && RC_CORE && HAS_DMA
+	depends on DVB_CORE && HAS_DMA
 	depends on MMC
 	select MEDIA_COMMON_OPTIONS
 	---help---
diff --git a/drivers/media/usb/siano/Kconfig b/drivers/media/usb/siano/Kconfig
index b2c229e..5afbd9a 100644
--- a/drivers/media/usb/siano/Kconfig
+++ b/drivers/media/usb/siano/Kconfig
@@ -4,7 +4,7 @@
 
 config SMS_USB_DRV
 	tristate "Siano SMS1xxx based MDTV receiver"
-	depends on DVB_CORE && RC_CORE && HAS_DMA
+	depends on DVB_CORE && HAS_DMA
 	select MEDIA_COMMON_OPTIONS
 	---help---
 	  Choose if you would like to have Siano's support for USB interface


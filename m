Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216Ab0DGSoN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 14:44:13 -0400
Received: from legolas.restena.lu ([158.64.1.34]:58638 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756Ab0DGSoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 14:44:11 -0400
Date: Wed, 7 Apr 2010 20:44:04 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       rvinyard@cs.nmsu.edu
Subject: Re: [PATCH mmotm] hid-picolcd: depends on LCD_CLASS_DEVICE
Message-ID: <20100407204404.5233ba6b@neptune.home>
In-Reply-To: <20100406095633.49ec957a.randy.dunlap@oracle.com>
References: <201004052336.o35NaeSE015814@imap1.linux-foundation.org>
	<20100405220414.9d90da83.randy.dunlap@oracle.com>
	<alpine.LNX.2.00.1004061038510.8345@pobox.suse.cz>
	<20100406105635.5384a087@pluto.restena.lu>
	<20100406082614.79aaf1c5.randy.dunlap@oracle.com>
	<20100406183535.7de3c628@neptune.home>
	<20100406095633.49ec957a.randy.dunlap@oracle.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 April 2010 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > 
> > One of my attempts did end up with a circular loop with regard to FB
> > (some of the FB drivers did select INPUT)?  
> 
>   (not that I can find)
> 
> CONFIG_VT does select INPUT
> and CONFIG_DRM_I915 does
> 	select INPUT if ACPI

A newer attempt still produces the same result:

drivers/input/Kconfig:9:error: found recursive dependency: INPUT ->
       HID_SUPPORT -> HID_PICOLCD_FB -> FB -> FB_STI -> VT -> INPUT

(it's only FB which causes the loop, LEDS, LCD and BACKLIGHT are fine)

This is with following patch on top of the improved deps patch I sent
a few minutes ago deeper in this thread.

Is there a way around this?


diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 782a34e..711c091 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -285,7 +285,7 @@ config HID_PICOLCD_FB
 	bool "Framebuffer support"
 	default !EMBEDDED
 	depends on HID_PICOLCD
-	depends on HID_PICOLCD=FB || FB=y
+	select FB
 	select FB_DEFERRED_IO
 	select FB_SYS_FILLRECT
 	select FB_SYS_COPYAREA
@@ -299,7 +299,8 @@ config HID_PICOLCD_BACKLIGHT
 	bool "Backlight control"
 	default !EMBEDDED
 	depends on HID_PICOLCD
-	depends on HID_PICOLCD=BACKLIGHT_CLASS_DEVICE || BACKLIGHT_CLASS_DEVICE=y
+	select BACKLIGHT_LCD_SUPPORT
+	select BACKLIGHT_CLASS_DEVICE
 	---help---
 	  Provide access to PicoLCD's backlight control via backlight
 	  class.
@@ -308,7 +309,8 @@ config HID_PICOLCD_LCD
 	bool "Contrast control"
 	default !EMBEDDED
 	depends on HID_PICOLCD
-	depends on HID_PICOLCD=LCD_CLASS_DEVICE || LCD_CLASS_DEVICE=y
+	select BACKLIGHT_LCD_SUPPORT
+	select LCD_CLASS_DEVICE
 	---help---
 	  Provide access to PicoLCD's LCD contrast via lcd class.
 
@@ -316,7 +318,8 @@ config HID_PICOLCD_LEDS
 	bool "GPO via leds class"
 	default !EMBEDDED
 	depends on HID_PICOLCD
-	depends on HID_PICOLCD=LEDS_CLASS || LEDS_CLASS=y
+	select NEW_LEDS
+	select LEDS_CLASS
 	---help---
 	  Provide access to PicoLCD's GPO pins via leds class.
 

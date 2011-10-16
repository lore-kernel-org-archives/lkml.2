Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab1JPLSF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 07:18:05 -0400
Received: from oceanic.CalvaEDI.COM ([89.202.194.168]:61403 "EHLO
	oceanic.CalvaEDI.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab1JPLSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 07:18:03 -0400
X-Greylist: delayed 386 seconds by postgrey-1.27 at vger.kernel.org; Sun, 16 Oct 2011 07:18:03 EDT
Message-ID: <4E9ABBF6.3000504@calvaedi.com>
Date: Sun, 16 Oct 2011 13:11:50 +0200
From: John Hughes <john@calvaedi.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20111004 Icedove/3.0.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Mattia Dongili <malattia@linux.it>,
        Stelian Pop <stelian@popies.net>
Subject: sony-laptop driver: Volume keys on Sony Vaio TX3 don't work
Content-Type: multipart/mixed;
 boundary="------------060509040901010307050408"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060509040901010307050408
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Even though sony-laptop has code to handle the volume-up/volume-down 
keys they don't work.  Pressing volume-down gets treated as 
SONYPI_EVENT_PKEY_P1 and volume-up as SONYPI_EVENT_PKEY_P2.

This is because volume-down generates event 0x01 with data mask 0x05 and 
although the sonypi_volumeev table exists to handle this the table 
sonypi_pkeyev steals the event before it gets handled.

Re-ordering the entries in the table type3_events and fixing the bug in 
sonypi_volumeev (up and down were inverted) makes the volume keys work.

See attached patch.

The two remaining problems are:

1. the EJECT key is mapped to FN_E
2. the MUTE key (event 5f, 31) is mapped to nothing.   (Not to important 
as it turns the speaker off in hardware).

--------------060509040901010307050408
Content-Type: text/x-patch;
 name="sony-vaio-tx3.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="sony-vaio-tx3.patch"

--- drivers/platform/x86/sony-laptop.c.orig	2009-12-03 04:51:21.000000000 +0100
+++ drivers/platform/x86/sony-laptop.c	2011-10-16 12:58:07.000000000 +0200
@@ -1576,8 +1576,8 @@
 
 /* The set of possible volume events */
 static struct sonypi_event sonypi_volumeev[] = {
-	{ 0x01, SONYPI_EVENT_VOLUME_INC_PRESSED },
-	{ 0x02, SONYPI_EVENT_VOLUME_DEC_PRESSED },
+	{ 0x01, SONYPI_EVENT_VOLUME_DEC_PRESSED },
+	{ 0x02, SONYPI_EVENT_VOLUME_INC_PRESSED },
 	{ 0, 0 }
 };
 
@@ -1624,10 +1624,10 @@
 	{ 0x31, SONYPI_MEMORYSTICK_MASK, sonypi_memorystickev },
 	{ 0x41, SONYPI_BATTERY_MASK, sonypi_batteryev },
 	{ 0x31, SONYPI_PKEY_MASK, sonypi_pkeyev },
+	{ 0x05, SONYPI_PKEY_MASK, sonypi_volumeev },
 	{ 0x05, SONYPI_PKEY_MASK, sonypi_pkeyev },
 	{ 0x05, SONYPI_ZOOM_MASK, sonypi_zoomev },
 	{ 0x05, SONYPI_CAPTURE_MASK, sonypi_captureev },
-	{ 0x05, SONYPI_PKEY_MASK, sonypi_volumeev },
 	{ 0x05, SONYPI_PKEY_MASK, sonypi_brightnessev },
 	{ 0 },
 };

--------------060509040901010307050408--

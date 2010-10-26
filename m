Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932974Ab0JZMGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 08:06:21 -0400
Received: from redmars.org ([92.243.31.175]:41723 "EHLO deckard.alcopop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932618Ab0JZMGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 08:06:20 -0400
Date: Tue, 26 Oct 2010 13:06:19 +0100
From: Jon Dowland <jmtd@debian.org>
To: Azael Avalos <coproscefalo@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] toshiba_acpi.c: Add key_entry for a lone FN keypress
Message-ID: <20101026120619.GB27720@deckard.alcopop.org>
References: <20101023221253.GA4829@hathor> <201010251127.37374.dmitry.torokhov@gmail.com> <AANLkTikcnJQnWYP+BTpUAvizU1iwwUo4=Nabe0L6xMXa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikcnJQnWYP+BTpUAvizU1iwwUo4=Nabe0L6xMXa@mail.gmail.com>
X-Challenge-Response: refused
X-Forelli-filterword: GO1268Op
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 25, 2010 at 12:42:41PM -0600, Azael Avalos wrote:
> It actually generates on key press/release with different key codes,
> 0x17f and 0x100 respectively. So I think that both should be added.

Presently the driver ignores key release events and only deals with key
presses.  It also filters out a 0x100 value specifically in the event
handler.  Do you mean something like this (untested)?

--- toshiba_acpi.c~	2010-10-26 12:56:46.000000000 +0100
+++ toshiba_acpi.c	2010-10-26 13:04:42.000000000 +0100
@@ -123,6 +123,7 @@
 MODULE_DEVICE_TABLE(acpi, toshiba_device_ids);
 
 static const struct key_entry toshiba_acpi_keymap[] __initconst = {
+	{ KE_KEY, 0x100, { KEY_FN } }, /* up */
 	{ KE_KEY, 0x101, { KEY_MUTE } },
 	{ KE_KEY, 0x102, { KEY_ZOOMOUT } },
 	{ KE_KEY, 0x103, { KEY_ZOOMIN } },
@@ -135,6 +136,7 @@
 	{ KE_KEY, 0x141, { KEY_BRIGHTNESSUP } },
 	{ KE_KEY, 0x142, { KEY_WLAN } },
 	{ KE_KEY, 0x143, { KEY_PROG1 } },
+	{ KE_KEY, 0x17f, { KEY_FN } }, /* down */
 	{ KE_KEY, 0xb05, { KEY_PROG2 } },
 	{ KE_KEY, 0xb06, { KEY_WWW } },
 	{ KE_KEY, 0xb07, { KEY_MAIL } },
@@ -854,8 +856,6 @@
 	do {
 		hci_read1(HCI_SYSTEM_EVENT, &value, &hci_result);
 		if (hci_result == HCI_SUCCESS) {
-			if (value == 0x100)
-				continue;
 			/* act on key press; ignore key release */
 			if (value & 0x80)
 				continue;


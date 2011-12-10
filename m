Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572Ab1LJTps (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 14:45:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4370 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068Ab1LJTpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 14:45:47 -0500
Date: Sat, 10 Dec 2011 19:45:39 +0000
From: "Richard W.M. Jones" <rjones@redhat.com>
To: alsa-devel@alsa-project.org
Cc: Tom Walder <tom.walder@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] Jabra SPEAK 410 USB - no audio playback
Message-ID: <20111210194539.GF16692@amd.home.annexia.org>
References: <20111210142419.GC16692@amd.home.annexia.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="aYDVKSzuImP48n7V"
Content-Disposition: inline
In-Reply-To: <20111210142419.GC16692@amd.home.annexia.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aYDVKSzuImP48n7V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


The attached patch fixes USB audio support for the Jabra SPEAK 410 USB.

The problem, as I understand it, is that the device contains a
Class-Specific Endpoint (CS_ENDPOINT) descriptor before the Endpoint
(ENDPOINT) descriptor.  The USB code all assumes that CS_ENDPOINT can
only appear after ENDPOINT.  Therefore the USB code divides up the
interface descriptor into "stuff before ENDPOINT" (in
interface->extra) and "stuff after ENDPOINT" (in
interface->endpoint[0]->extra).  For this device, this division does
not work.

You can see lsusb for my device here:
http://mailman.alsa-project.org/pipermail/alsa-devel/2011-December/047036.html
Notice the "** UNRECOGNIZED: 07 25 01 81 02 00 00" line which is the
CS_ENDPOINT descriptor.

The solution (which is a hack ...) is to also search interface->extra
looking for the missing descriptor.

For me, this fully enables the functions of this device.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming blog: http://rwmj.wordpress.com
Fedora now supports 80 OCaml packages (the OPEN alternative to F#)
http://cocan.org/getting_started_with_ocaml_on_red_hat_and_fedora

--aYDVKSzuImP48n7V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="linux-3.1.fc16-jabra.patch"

diff -uNrp kernel-3.1.fc16.orig/sound/usb/stream.c kernel-3.1.fc16.new/sound/usb/stream.c
--- kernel-3.1.fc16.orig/sound/usb/stream.c	2011-12-10 18:03:29.658729051 +0000
+++ kernel-3.1.fc16.new/sound/usb/stream.c	2011-12-10 18:08:41.468694907 +0000
@@ -164,6 +164,12 @@ static int parse_uac_endpoint_attributes
 
 	csep = snd_usb_find_desc(alts->endpoint[0].extra, alts->endpoint[0].extralen, NULL, USB_DT_CS_ENDPOINT);
 
+	/* Jabra SPEAK 410 USB has CS_ENDPOINT before ordinary ENDPOINT,
+	 * which confuses the USB descriptor parsing code.  Try looking
+	 * for CS_ENDPOINT in the interface->extra - RWMJ. */
+	if (!csep)
+		csep = snd_usb_find_desc(alts->extra, alts->extralen, NULL, USB_DT_CS_ENDPOINT);
+
 	/* Creamware Noah has this descriptor after the 2nd endpoint */
 	if (!csep && altsd->bNumEndpoints >= 2)
 		csep = snd_usb_find_desc(alts->endpoint[1].extra, alts->endpoint[1].extralen, NULL, USB_DT_CS_ENDPOINT);

--aYDVKSzuImP48n7V--

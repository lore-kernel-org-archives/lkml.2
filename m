Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478Ab2FORmN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 13:42:13 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55517 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab2FORmK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 13:42:10 -0400
MIME-Version: 1.0
Date: Fri, 15 Jun 2012 19:42:08 +0200
X-Google-Sender-Auth: OzGL4GeAW1d7m9yA9nNBTbzMut0
Message-ID: <CAMuHMdXk6pByz14JcDgY+UE6QM0sHD8cbXye9CgOVSRRtr7J+Q@mail.gmail.com>
Subject: [-next] FATAL: drivers/gpu/drm/udl/udl: sizeof(struct
 usb_device_id)=24 is not a modulo of the size of section __mod_usb_device_table=44.
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: USB list <linux-usb@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Linux-Next <linux-next@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 81df2d594340dcb6d1a02191976be88a1ca8120c ("USB: allow match
on bInterfaceNumber") added a byte to the interior of struct usb_device_id,
enabling implicit padding:

--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -115,6 +118,9 @@ struct usb_device_id {
        __u8            bInterfaceSubClass;
        __u8            bInterfaceProtocol;

+       /* Used for vendor-specific interface matches */
+       __u8            bInterfaceNumber;
+
        /* not matched against */
        kernel_ulong_t  driver_info;
 };

On m68k, this causes failures like:

| FATAL: drivers/gpu/drm/udl/udl: sizeof(struct usb_device_id)=24 is
not a modulo of the size of section __mod_usb_device_table=44.
| Fix definition of struct usb_device_id in mod_devicetable.h

M68k is special in that it uses 2 for the alignment of 32-bit entities, hence
sizeof(struct usb_device_id) = 22.

However, when cross-compiling on amd64, sizeof(struct usb_device_id) = 24
in scripts/mod/file2alias.c.

m68k/allmodconfig at http://kisskb.ellerman.id.au/kisskb/buildresult/6518563/

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

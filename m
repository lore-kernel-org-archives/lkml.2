Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758529Ab2FOXM1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 19:12:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51801 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758479Ab2FOXMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 19:12:24 -0400
Date: Fri, 15 Jun 2012 16:12:20 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        USB list <linux-usb@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Linux-Next <linux-next@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [-next] FATAL: drivers/gpu/drm/udl/udl: sizeof(struct
 usb_device_id)=24 is not a modulo of the size of section
 __mod_usb_device_table=44.
Message-ID: <20120615231220.GC8205@kroah.com>
References: <CAMuHMdXk6pByz14JcDgY+UE6QM0sHD8cbXye9CgOVSRRtr7J+Q@mail.gmail.com>
 <20120615201021.GB14544@kroah.com>
 <CAMuHMdUj6tAcWhkSkV43Kw3-2-3+JzgP6W=2w3fjL2KBfRh9ZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdUj6tAcWhkSkV43Kw3-2-3+JzgP6W=2w3fjL2KBfRh9ZQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 11:02:55PM +0200, Geert Uytterhoeven wrote:
> Hi Greg,
> 
> On Fri, Jun 15, 2012 at 10:10 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Fri, Jun 15, 2012 at 07:42:08PM +0200, Geert Uytterhoeven wrote:
> >> commit 81df2d594340dcb6d1a02191976be88a1ca8120c ("USB: allow match
> >> on bInterfaceNumber") added a byte to the interior of struct usb_device_id,
> >> enabling implicit padding:
> >>
> >> --- a/include/linux/mod_devicetable.h
> >> +++ b/include/linux/mod_devicetable.h
> >> @@ -115,6 +118,9 @@ struct usb_device_id {
> >>         __u8            bInterfaceSubClass;
> >>         __u8            bInterfaceProtocol;
> >>
> >> +       /* Used for vendor-specific interface matches */
> >> +       __u8            bInterfaceNumber;
> >> +
> >>         /* not matched against */
> >>         kernel_ulong_t  driver_info;
> >>  };
> >>
> >> On m68k, this causes failures like:
> >>
> >> | FATAL: drivers/gpu/drm/udl/udl: sizeof(struct usb_device_id)=24 is
> >> not a modulo of the size of section __mod_usb_device_table=44.
> >> | Fix definition of struct usb_device_id in mod_devicetable.h
> >>
> >> M68k is special in that it uses 2 for the alignment of 32-bit entities, hence
> >> sizeof(struct usb_device_id) = 22.
> >>
> >> However, when cross-compiling on amd64, sizeof(struct usb_device_id) = 24
> >> in scripts/mod/file2alias.c.
> >
> > I don't really understand, what is the problem here?  The fact that we
> > added one byte to the structure?  And now something breaks?  How?
> >
> > What can we do to resolve it?
> 
> As "kernel_ulong_t  driver_info" is no longer naturally aligned, the
> compiler will
> add implicit padding. But the padding depends on the architecture.

Ah, so we were "lucky" before, nice.

> It can be fixed by adding explicit padding. Probably it should be padded by
> 7 bytes (not 3), as kernel_ulong_t may require 8-byte alignment on some 64-bit
> platforms. Or by an explicit alignment attribute.
> 
> See also
>   * commit 8175fe2dda1c93a9c596921c8ed4a0b4baccdefe ("HID: fix
> hid_device_id for cross compiling")
>   * commit 7492d4a416d68ab4bd254b36ffcc4e0138daa8ff ("sdio: fix module
> device table definition for m68k")
>   * commit 9e2d3cd34a159948dc753a14573e16bffc04dba8 ("[PATCH]
> mod_devicetable.h fixes")

So would the patch below fix this?  It should force alignment of the
driver_data field, which is all you want here, right?

> Still, there's a bug in file2alias (which is compiled by the host
> compiler), in that
> it may use different padding than the target platform when cross-compiling.

That's not good, but outside of this specific issue, right?  Have we
just been fortunate it hasn't really hit us yet?

thanks,

greg k-h

diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 7771d45..6955045 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -122,7 +122,8 @@ struct usb_device_id {
 	__u8		bInterfaceNumber;
 
 	/* not matched against */
-	kernel_ulong_t	driver_info;
+	kernel_ulong_t	driver_info
+		__attribute__((aligned(sizeof(kernel_ulong_t))));
 };
 
 /* Some useful macros to use to create struct usb_device_id */

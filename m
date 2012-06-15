Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966Ab2FOVC7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 17:02:59 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54920 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757882Ab2FOVC4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 17:02:56 -0400
MIME-Version: 1.0
In-Reply-To: <20120615201021.GB14544@kroah.com>
References: <CAMuHMdXk6pByz14JcDgY+UE6QM0sHD8cbXye9CgOVSRRtr7J+Q@mail.gmail.com>
	<20120615201021.GB14544@kroah.com>
Date: Fri, 15 Jun 2012 23:02:55 +0200
X-Google-Sender-Auth: c6asuX6N7pMZ0TSoDC7A2tEBhr0
Message-ID: <CAMuHMdUj6tAcWhkSkV43Kw3-2-3+JzgP6W=2w3fjL2KBfRh9ZQ@mail.gmail.com>
Subject: Re: [-next] FATAL: drivers/gpu/drm/udl/udl: sizeof(struct
 usb_device_id)=24 is not a modulo of the size of section __mod_usb_device_table=44.
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        USB list <linux-usb@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Linux-Next <linux-next@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Fri, Jun 15, 2012 at 10:10 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Fri, Jun 15, 2012 at 07:42:08PM +0200, Geert Uytterhoeven wrote:
>> commit 81df2d594340dcb6d1a02191976be88a1ca8120c ("USB: allow match
>> on bInterfaceNumber") added a byte to the interior of struct usb_device_id,
>> enabling implicit padding:
>>
>> --- a/include/linux/mod_devicetable.h
>> +++ b/include/linux/mod_devicetable.h
>> @@ -115,6 +118,9 @@ struct usb_device_id {
>>         __u8            bInterfaceSubClass;
>>         __u8            bInterfaceProtocol;
>>
>> +       /* Used for vendor-specific interface matches */
>> +       __u8            bInterfaceNumber;
>> +
>>         /* not matched against */
>>         kernel_ulong_t  driver_info;
>>  };
>>
>> On m68k, this causes failures like:
>>
>> | FATAL: drivers/gpu/drm/udl/udl: sizeof(struct usb_device_id)=24 is
>> not a modulo of the size of section __mod_usb_device_table=44.
>> | Fix definition of struct usb_device_id in mod_devicetable.h
>>
>> M68k is special in that it uses 2 for the alignment of 32-bit entities, hence
>> sizeof(struct usb_device_id) = 22.
>>
>> However, when cross-compiling on amd64, sizeof(struct usb_device_id) = 24
>> in scripts/mod/file2alias.c.
>
> I don't really understand, what is the problem here?  The fact that we
> added one byte to the structure?  And now something breaks?  How?
>
> What can we do to resolve it?

As "kernel_ulong_t  driver_info" is no longer naturally aligned, the
compiler will
add implicit padding. But the padding depends on the architecture.

It can be fixed by adding explicit padding. Probably it should be padded by
7 bytes (not 3), as kernel_ulong_t may require 8-byte alignment on some 64-bit
platforms. Or by an explicit alignment attribute.

See also
  * commit 8175fe2dda1c93a9c596921c8ed4a0b4baccdefe ("HID: fix
hid_device_id for cross compiling")
  * commit 7492d4a416d68ab4bd254b36ffcc4e0138daa8ff ("sdio: fix module
device table definition for m68k")
  * commit 9e2d3cd34a159948dc753a14573e16bffc04dba8 ("[PATCH]
mod_devicetable.h fixes")

Still, there's a bug in file2alias (which is compiled by the host
compiler), in that
it may use different padding than the target platform when cross-compiling.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

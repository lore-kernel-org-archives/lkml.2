Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549Ab2FYVnY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 17:43:24 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:59626 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756145Ab2FYVnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 17:43:21 -0400
X-Auth-Info: SIwRfXL1csNUXLZFlCNocd6L/nLpVDF8paNz+aCQwOc=
From: Andreas Schwab <schwab@linux-m68k.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: =?utf-8?Q?Bj=C3=B8rn?= Mork <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Linux-Next <linux-next@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH] mod/file2alias: make modalias generation safe for cross compiling
References: <CAMuHMdXk6pByz14JcDgY+UE6QM0sHD8cbXye9CgOVSRRtr7J+Q@mail.gmail.com>
	<20120615201021.GB14544@kroah.com>
	<CAMuHMdUj6tAcWhkSkV43Kw3-2-3+JzgP6W=2w3fjL2KBfRh9ZQ@mail.gmail.com>
	<20120615231220.GC8205@kroah.com> <87lijns84s.fsf@nemi.mork.no>
	<m2bokjb6tv.fsf@igel.home> <87fw9urqau.fsf@nemi.mork.no>
	<m2d34n1sz9.fsf_-_@igel.home>
	<alpine.DEB.2.00.1206252217580.21346@ayla.of.borg>
X-Yow: Hand me a pair of leather pants and a CASIO keyboard
 -- I'm living for today!
Date: Mon, 25 Jun 2012 23:43:15 +0200
In-Reply-To: <alpine.DEB.2.00.1206252217580.21346@ayla.of.borg> (Geert
	Uytterhoeven's message of "Mon, 25 Jun 2012 22:32:53 +0200 (CEST)")
Message-ID: <m28vfb130s.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:

> 	Hi Andreas,
>
> On Mon, 25 Jun 2012, Andreas Schwab wrote:
>> --- /dev/null
>> +++ b/scripts/mod/devicetable-offsets.c
>> @@ -0,0 +1,171 @@
>> +#include <linux/kbuild.h>
>> +#include <linux/mod_devicetable.h>
>> +
>> +#define DEVID(devid) DEFINE(SIZE_##devid, sizeof(struct devid))
>> +#define DEVID_FIELD(devid, field) \
>> +	DEFINE(OFF_##devid##_##field, offsetof(struct devid, field))
>> +
>> +int main(void)
>> +{
>> +	DEVID(usb_device_id);
>> +	DEVID_FIELD(usb_device_id, match_flags);
>> +	DEVID_FIELD(usb_device_id, idVendor);
>> +	DEVID_FIELD(usb_device_id, idProduct);
>> +	DEVID_FIELD(usb_device_id, bcdDevice_lo);
>> +	DEVID_FIELD(usb_device_id, bcdDevice_hi);
>> +	DEVID_FIELD(usb_device_id, bDeviceClass);
>> +	DEVID_FIELD(usb_device_id, bDeviceSubClass);
>> +	DEVID_FIELD(usb_device_id, bDeviceProtocol);
>> +	DEVID_FIELD(usb_device_id, bInterfaceClass);
>> +	DEVID_FIELD(usb_device_id, bInterfaceSubClass);
>> +	DEVID_FIELD(usb_device_id, bInterfaceProtocol);
>
> These are all duplicates of the structures in <linux/mod_devicetable.h>.
> Can't you get rid of the duplication by putting e.g. the following
> in <linux/mod_devicetable.h>:
>
>     DEVID_START(usb_device_id);
>     DEVID_FIELD(usb_device_id, __u16, match_flags);
>     DEVID_FIELD(usb_device_id, __u16, idVendor);
>     DEVID_FIELD(usb_device_id, __u16, idProduct);
>     DEVID_FIELD(usb_device_id, __u16, bcdDevice_lo);
>     DEVID_FIELD(usb_device_id, __u16, bcdDevice_hi);
>     DEVID_FIELD(usb_device_id, __u8, bDeviceClass);
>     DEVID_FIELD(usb_device_id, __u8, bDeviceSubClass);
>     DEVID_FIELD(usb_device_id, __u8, bDeviceProtocol);
>     DEVID_FIELD(usb_device_id, __u8, bInterfaceClass);
>     DEVID_FIELD(usb_device_id, __u8, bInterfaceSubClass);
>     DEVID_FIELD(usb_device_id, __u8, bInterfaceProtocol);
>     DEVID_END();
>
> and redefining the DEVID_*() macros depending on
>   1. __KERNEL__, to generate the C struct definitions for kernel builds,
>   2. first inclusion by devicetable-offsets.c, also to generate C struct
>      definitions,
>   3. second inclusion by devicetable-offsets.c, to generate the sizes and
>      offset definitions for modalias?

That requires some reorganisation of the struct pnp_card_device_id which
has a somewhat complicated structure (which also accounts for the
ugliest part of the patch).

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373Ab2FYUc7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 16:32:59 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:53070 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755900Ab2FYUc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 16:32:57 -0400
Date: Mon, 25 Jun 2012 22:32:53 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andreas Schwab <schwab@linux-m68k.org>
cc: =?ISO-8859-15?Q?Bj=F8rn_Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Linux-Next <linux-next@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH] mod/file2alias: make modalias generation safe for cross
 compiling
In-Reply-To: <m2d34n1sz9.fsf_-_@igel.home>
Message-ID: <alpine.DEB.2.00.1206252217580.21346@ayla.of.borg>
References: <CAMuHMdXk6pByz14JcDgY+UE6QM0sHD8cbXye9CgOVSRRtr7J+Q@mail.gmail.com> <20120615201021.GB14544@kroah.com> <CAMuHMdUj6tAcWhkSkV43Kw3-2-3+JzgP6W=2w3fjL2KBfRh9ZQ@mail.gmail.com> <20120615231220.GC8205@kroah.com> <87lijns84s.fsf@nemi.mork.no>
 <m2bokjb6tv.fsf@igel.home> <87fw9urqau.fsf@nemi.mork.no> <m2d34n1sz9.fsf_-_@igel.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Andreas,

On Mon, 25 Jun 2012, Andreas Schwab wrote:
> Use the target compiler to compute the offsets of the fields of the
> device_id structures, so that it won't be broken by different alignments
> between the host and target ABIs.

Thanks, very nice!

> --- a/include/linux/mod_devicetable.h
> +++ b/include/linux/mod_devicetable.h
> @@ -33,8 +33,7 @@ struct ieee1394_device_id {
>  	__u32 model_id;
>  	__u32 specifier_id;
>  	__u32 version;
> -	kernel_ulong_t driver_data
> -		__attribute__((aligned(sizeof(kernel_ulong_t))));
> +	kernel_ulong_t driver_data;

After this, we can also get rid of kernel_ulong_t, but that's a more intruisive
patch all over the place.

> --- /dev/null
> +++ b/scripts/mod/devicetable-offsets.c
> @@ -0,0 +1,171 @@
> +#include <linux/kbuild.h>
> +#include <linux/mod_devicetable.h>
> +
> +#define DEVID(devid) DEFINE(SIZE_##devid, sizeof(struct devid))
> +#define DEVID_FIELD(devid, field) \
> +	DEFINE(OFF_##devid##_##field, offsetof(struct devid, field))
> +
> +int main(void)
> +{
> +	DEVID(usb_device_id);
> +	DEVID_FIELD(usb_device_id, match_flags);
> +	DEVID_FIELD(usb_device_id, idVendor);
> +	DEVID_FIELD(usb_device_id, idProduct);
> +	DEVID_FIELD(usb_device_id, bcdDevice_lo);
> +	DEVID_FIELD(usb_device_id, bcdDevice_hi);
> +	DEVID_FIELD(usb_device_id, bDeviceClass);
> +	DEVID_FIELD(usb_device_id, bDeviceSubClass);
> +	DEVID_FIELD(usb_device_id, bDeviceProtocol);
> +	DEVID_FIELD(usb_device_id, bInterfaceClass);
> +	DEVID_FIELD(usb_device_id, bInterfaceSubClass);
> +	DEVID_FIELD(usb_device_id, bInterfaceProtocol);

These are all duplicates of the structures in <linux/mod_devicetable.h>.
Can't you get rid of the duplication by putting e.g. the following
in <linux/mod_devicetable.h>:

    DEVID_START(usb_device_id);
    DEVID_FIELD(usb_device_id, __u16, match_flags);
    DEVID_FIELD(usb_device_id, __u16, idVendor);
    DEVID_FIELD(usb_device_id, __u16, idProduct);
    DEVID_FIELD(usb_device_id, __u16, bcdDevice_lo);
    DEVID_FIELD(usb_device_id, __u16, bcdDevice_hi);
    DEVID_FIELD(usb_device_id, __u8, bDeviceClass);
    DEVID_FIELD(usb_device_id, __u8, bDeviceSubClass);
    DEVID_FIELD(usb_device_id, __u8, bDeviceProtocol);
    DEVID_FIELD(usb_device_id, __u8, bInterfaceClass);
    DEVID_FIELD(usb_device_id, __u8, bInterfaceSubClass);
    DEVID_FIELD(usb_device_id, __u8, bInterfaceProtocol);
    DEVID_END();

and redefining the DEVID_*() macros depending on
  1. __KERNEL__, to generate the C struct definitions for kernel builds,
  2. first inclusion by devicetable-offsets.c, also to generate C struct
     definitions,
  3. second inclusion by devicetable-offsets.c, to generate the sizes and
     offset definitions for modalias?

> --- a/scripts/mod/file2alias.c
> +++ b/scripts/mod/file2alias.c
> @@ -116,7 +129,6 @@ static inline void add_wildcard(char *str)
>  		strcat(str + len, "*");
>  }
>  
> -unsigned int cross_build = 0;
>  /**
>   * Check that sizeof(device_id type) are consistent with size of section
>   * in .o file. If in-consistent then userspace and kernel does not agree
> @@ -131,8 +143,6 @@ static void device_id_check(const char *modname, const char *device_id,
>  	int i;
>  
>  	if (size % id_size || size < id_size) {
> -		if (cross_build != 0)
> -			return;
>  		fatal("%s: sizeof(struct %s_device_id)=%lu is not a modulo "
>  		      "of the size of section __mod_%s_device_table=%lu.\n"
>  		      "Fix definition of struct %s_device_id "

Funny, I didn't know there was a check for cross-compiling, supposedly to
ignore the warnings.
And it didn't work, as the problem was noticed originally on the linux-next
build service (which uses cross-compiling), and also showed up for my own
cross-builds.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

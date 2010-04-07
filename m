Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932912Ab0DGQbb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 12:31:31 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:33540 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932695Ab0DGQb2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 12:31:28 -0400
Date: Wed, 7 Apr 2010 09:20:10 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Bruno =?ISO-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       rvinyard@cs.nmsu.edu
Subject: Re: [PATCH mmotm] hid-picolcd: depends on LCD_CLASS_DEVICE
Message-Id: <20100407092010.4cd60ece.randy.dunlap@oracle.com>
In-Reply-To: <20100406230434.1336c317@neptune.home>
References: <201004052336.o35NaeSE015814@imap1.linux-foundation.org>
	<20100405220414.9d90da83.randy.dunlap@oracle.com>
	<alpine.LNX.2.00.1004061038510.8345@pobox.suse.cz>
	<20100406105635.5384a087@pluto.restena.lu>
	<20100406082614.79aaf1c5.randy.dunlap@oracle.com>
	<20100406183535.7de3c628@neptune.home>
	<20100406095633.49ec957a.randy.dunlap@oracle.com>
	<20100406230434.1336c317@neptune.home>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B0204.4BBCB125.0116:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Apr 2010 23:04:34 +0200 Bruno Prémont wrote:

> On Tue, 06 April 2010 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > > It triggers the issue by having PicoLCD built-in while one of the
> > > optional dependencies as a module.
> > 
> > Yes, basically what the patch description said.
> 
> Oops, sorry I didn't completely read the patch description.
> 
> > > Any idea of how this can be solved with kbuild in order to keep the
> > > dependencies optional?
> > > 
> > > Something that would satisfy the following pseudocode:
> > >   if CONFIG_HID_PICOLCD == y
> > >     assert(CONFIG_LCD_CLASS_DEVICE != m)
> > > 
> > 
> > If you don't want the kconfig machinery to do that (it appears that you don't),
> > then I guess that you'll need to expand the source code to handle
> > CONFIG_LCD_CLASS_DEVICE=y and CONFIG_LCD_CLASS_DEVICE=m differently.
> > Or only handle them differently if HID_PICOLCD=y.  :(
> 
> Below a patch (against 2.6.34-rc3 + Jiri's picolcd branch) which
> should fix above issue keeping the deps optional.
> 
> With it it's not yet possible to select the deps from HID menu.
> 
> I did a few oldconfig and compile-tests with PICOLCD=y/m and same for
> the deps (not switched FB for those tests).
> 
> Bruno
> 
> 
> 
> 
> 
> HID_PICOLCD should depend on LCD_CLASS_DEVICE, otherwise the
> build fails when HID_PICOLCD=y and LCD_CLASS_DEVICE=m:
> 
> hid-picolcd.c:(.text+0x84523f): undefined reference to `lcd_device_unregister'
> hid-picolcd.c:(.text+0x8478ab): undefined reference to `lcd_device_register'
> hid-picolcd.c:(.text+0x84c15f): undefined reference to `lcd_device_unregister'
> 
> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
> 
> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
> index a2ecd83..39df4f5 100644
> --- a/drivers/hid/Kconfig
> +++ b/drivers/hid/Kconfig
> @@ -285,6 +285,35 @@ config HID_PICOLCD
>  	  Features that are not (yet) supported:
>  	  - IR
>  

All of these user-visible kconfig options need help text also...

> +config HID_PICOLCD_FB
> +	bool "Framebuffer support"
> +	default !EMBEDDED
> +	depends on HID_PICOLCD
> +	depends on HID_PICOLCD=FB || FB=y
> +	select FB_DEFERRED_IO
> +	select FB_SYS_FILLRECT
> +	select FB_SYS_COPYAREA
> +	select FB_SYS_IMAGEBLIT
> +	select FB_SYS_FOPS
> +
> +config HID_PICOLCD_BACKLIGHT
> +	bool "Backlight control"
> +	default !EMBEDDED
> +	depends on HID_PICOLCD
> +	depends on HID_PICOLCD=BACKLIGHT_CLASS_DEVICE || BACKLIGHT_CLASS_DEVICE=y
> +
> +config HID_PICOLCD_LCD
> +	bool "Contrast control"
> +	default !EMBEDDED
> +	depends on HID_PICOLCD
> +	depends on HID_PICOLCD=LCD_CLASS_DEVICE || LCD_CLASS_DEVICE=y
> +
> +config HID_PICOLCD_LEDS
> +	bool "GPO via leds class"
> +	default !EMBEDDED
> +	depends on HID_PICOLCD
> +	depends on HID_PICOLCD=LEDS_CLASS || LEDS_CLASS=y
> +
>  config HID_QUANTA
>  	tristate "Quanta Optical Touch"
>  	depends on USB_HID


---
~Randy

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab1KQTRF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 14:17:05 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33730 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465Ab1KQTRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 14:17:03 -0500
Date: Thu, 17 Nov 2011 11:16:50 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: John Hughes <john@calvaedi.com>
Cc: Mattia Dongili <malattia@linux.it>,
        platform-driver-x86 <platform-driver-x86@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] to fix scancodes returned by sony-laptop driver
Message-ID: <20111117191650.GA31479@core.coreip.homeip.net>
References: <4EC4064D.6010706@calvaedi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EC4064D.6010706@calvaedi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 16, 2011 at 07:51:57PM +0100, John Hughes wrote:
> Fix scancodes returned by driver to match scancodes used to remap keys.
> 
> (Before the patch FN/E returned scancode 0x1B, but to remap scancode
> 0x14 had to be used).
> 

> The scancodes returned by the sony-laptop driver for function keys did not
> match the scancodes used to remap keys.  Also, since the scancode was sent
> to the input subsystem after the mapped keysym the /lib/udev/keymap
> utility was confused about which scancode to report for which keysym.
> 
> This patch fixes the driver so the correct scancode is shown for each
> key.  It also adds to the documentation a description of where to find
> the scancodes.
> 
> Signed-off-by: John Hughes <john@calva.com>

Acked-by: Dmitry Torokhov <dtor@mail.ru>

> 
> diff --git a/Documentation/laptops/sony-laptop.txt b/Documentation/laptops/sony-laptop.txt
> index 2bd4e82..0d5ac7f 100644
> --- a/Documentation/laptops/sony-laptop.txt
> +++ b/Documentation/laptops/sony-laptop.txt
> @@ -17,6 +17,11 @@ subsystem. See the logs of acpid or /proc/acpi/event and
>  devices are created by the driver. Additionally, loading the driver with the
>  debug option will report all events in the kernel log.
>  
> +The "scancodes" passed to the input system (that can be remapped with udev)
> +are indexes to the table "sony_laptop_input_keycode_map" in the sony-laptop.c
> +module.  For example the "FN/E" key combination (EJECTCD on some models)
> +generates the scancode 20 (0x14).
> +
>  Backlight control:
>  ------------------
>  If your laptop model supports it, you will find sysfs files in the
> diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
> index bbd182e..f148459 100644
> --- a/drivers/platform/x86/sony-laptop.c
> +++ b/drivers/platform/x86/sony-laptop.c
> @@ -347,6 +347,7 @@ static void sony_laptop_report_input_event(u8 event)
>  	struct input_dev *jog_dev = sony_laptop_input.jog_dev;
>  	struct input_dev *key_dev = sony_laptop_input.key_dev;
>  	struct sony_laptop_keypress kp = { NULL };
> +	int scancode;
>  
>  	if (event == SONYPI_EVENT_FNKEY_RELEASED ||
>  			event == SONYPI_EVENT_ANYBUTTON_RELEASED) {
> @@ -380,8 +381,8 @@ static void sony_laptop_report_input_event(u8 event)
>  			dprintk("sony_laptop_report_input_event, event not known: %d\n", event);
>  			break;
>  		}
> -		if (sony_laptop_input_index[event] != -1) {
> -			kp.key = sony_laptop_input_keycode_map[sony_laptop_input_index[event]];
> +		if ((scancode = sony_laptop_input_index[event]) != -1) {
> +			kp.key = sony_laptop_input_keycode_map[scancode];
>  			if (kp.key != KEY_UNKNOWN)
>  				kp.dev = key_dev;
>  		}
> @@ -389,9 +390,9 @@ static void sony_laptop_report_input_event(u8 event)
>  	}
>  
>  	if (kp.dev) {
> -		input_report_key(kp.dev, kp.key, 1);
>  		/* we emit the scancode so we can always remap the key */
> -		input_event(kp.dev, EV_MSC, MSC_SCAN, event);
> +		input_event(kp.dev, EV_MSC, MSC_SCAN, scancode);
> +		input_report_key(kp.dev, kp.key, 1);
>  		input_sync(kp.dev);
>  
>  		/* schedule key release */

-- 
Dmitry

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab2FRHIW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 03:08:22 -0400
Received: from server.atrad.com.au ([150.101.241.2]:52085 "EHLO
	server.atrad.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab2FRHIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 03:08:21 -0400
Date: Mon, 18 Jun 2012 16:38:00 +0930
From: Jonathan Woithe <jwoithe@just42.net>
To: Joe Perches <joe@perches.com>
Cc: Matthew Garrett <mjg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        jwoithe@just42.net
Subject: Re: [PATCH 4/5] fujitsu-laptop: Convert dbg_printk and vdbg_printk
 to fuj_dbg
Message-ID: <20120618070800.GA26951@marvin.atrad.com.au>
References: <cover.1339985626.git.joe@perches.com>
 <5c36501015f98b98ae1d000442c44c7ff775b538.1339985627.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c36501015f98b98ae1d000442c44c7ff775b538.1339985627.git.joe@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2012 at 07:25:11PM -0700, Joe Perches wrote:
> Use more current logging styles.
> 
> Add #define DEBUG to enable dynamic debug.
> Remove unused #defines.
> Use eliminated_printk to verify fuj_dbg arguments.
> Argument alignment and format coalescing.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Looks reasonable to me.

Acked-by: Jonathan Woithe <jwoithe@just42.net>

> ---
>  drivers/platform/x86/fujitsu-laptop.c |  103 +++++++++++++++------------------
>  1 files changed, 47 insertions(+), 56 deletions(-)
> 
> diff --git a/drivers/platform/x86/fujitsu-laptop.c b/drivers/platform/x86/fujitsu-laptop.c
> index c4c1a54..e2aae57 100644
> --- a/drivers/platform/x86/fujitsu-laptop.c
> +++ b/drivers/platform/x86/fujitsu-laptop.c
> @@ -118,27 +118,22 @@
>  #define RINGBUFFERSIZE 40
>  
>  /* Debugging */
> -#define FUJLAPTOP_LOG	   ACPI_FUJITSU_HID ": "
> -#define FUJLAPTOP_ERR	   KERN_ERR FUJLAPTOP_LOG
> -#define FUJLAPTOP_NOTICE   KERN_NOTICE FUJLAPTOP_LOG
> -#define FUJLAPTOP_INFO	   KERN_INFO FUJLAPTOP_LOG
> -#define FUJLAPTOP_DEBUG    KERN_DEBUG FUJLAPTOP_LOG
> -
>  #define FUJLAPTOP_DBG_ALL	  0xffff
>  #define FUJLAPTOP_DBG_ERROR	  0x0001
>  #define FUJLAPTOP_DBG_WARN	  0x0002
>  #define FUJLAPTOP_DBG_INFO	  0x0004
>  #define FUJLAPTOP_DBG_TRACE	  0x0008
>  
> -#define dbg_printk(a_dbg_level, format, arg...) \
> -	do { if (dbg_level & a_dbg_level) \
> -		printk(FUJLAPTOP_DEBUG "%s: " format, __func__ , ## arg); \
> -	} while (0)
>  #ifdef CONFIG_FUJITSU_LAPTOP_DEBUG
> -#define vdbg_printk(a_dbg_level, format, arg...) \
> -	dbg_printk(a_dbg_level, format, ## arg)
> +#define DEBUG
> +#define fuj_dbg(a_dbg_level, format, ...)				\
> +do {									\
> +	if (dbg_level & a_dbg_level)					\
> +		pr_debug("%s: " format, __func__ , ##__VA_ARGS__);	\
> +} while (0)
>  #else
> -#define vdbg_printk(a_dbg_level, format, arg...)
> +#define fuj_dbg(a_dbg_level, format, ...)		\
> +	eliminated_printk(format, ##__VA_ARGS__)
>  #endif
>  
>  /* Device controlling the backlight and associated keys */
> @@ -225,8 +220,7 @@ static int call_fext_func(int cmd, int arg0, int arg1, int arg2)
>  
>  	status = acpi_get_handle(fujitsu_hotkey->acpi_handle, "FUNC", &handle);
>  	if (ACPI_FAILURE(status)) {
> -		vdbg_printk(FUJLAPTOP_DBG_ERROR,
> -				"FUNC interface is not present\n");
> +		fuj_dbg(FUJLAPTOP_DBG_ERROR, "FUNC interface is not present\n");
>  		return -ENODEV;
>  	}
>  
> @@ -240,23 +234,22 @@ static int call_fext_func(int cmd, int arg0, int arg1, int arg2)
>  
>  	status = acpi_evaluate_object(handle, NULL, &arg_list, &output);
>  	if (ACPI_FAILURE(status)) {
> -		vdbg_printk(FUJLAPTOP_DBG_WARN,
> +		fuj_dbg(FUJLAPTOP_DBG_WARN,
>  			"FUNC 0x%x (args 0x%x, 0x%x, 0x%x) call failed\n",
> -				cmd, arg0, arg1, arg2);
> +			cmd, arg0, arg1, arg2);
>  		return -ENODEV;
>  	}
>  
>  	if (out_obj.type != ACPI_TYPE_INTEGER) {
> -		vdbg_printk(FUJLAPTOP_DBG_WARN,
> -			"FUNC 0x%x (args 0x%x, 0x%x, 0x%x) did not "
> -			"return an integer\n",
> +		fuj_dbg(FUJLAPTOP_DBG_WARN,
> +			"FUNC 0x%x (args 0x%x, 0x%x, 0x%x) did not return an integer\n",
>  			cmd, arg0, arg1, arg2);
>  		return -ENODEV;
>  	}
>  
> -	vdbg_printk(FUJLAPTOP_DBG_TRACE,
> +	fuj_dbg(FUJLAPTOP_DBG_TRACE,
>  		"FUNC 0x%x (args 0x%x, 0x%x, 0x%x) returned 0x%x\n",
> -			cmd, arg0, arg1, arg2, (int)out_obj.integer.value);
> +		cmd, arg0, arg1, arg2, (int)out_obj.integer.value);
>  	return out_obj.integer.value;
>  }
>  
> @@ -321,15 +314,14 @@ static int set_lcd_level(int level)
>  	struct acpi_object_list arg_list = { 1, &arg0 };
>  	acpi_handle handle = NULL;
>  
> -	vdbg_printk(FUJLAPTOP_DBG_TRACE, "set lcd level via SBLL [%d]\n",
> -		    level);
> +	fuj_dbg(FUJLAPTOP_DBG_TRACE, "set lcd level via SBLL [%d]\n", level);
>  
>  	if (level < 0 || level >= fujitsu->max_brightness)
>  		return -EINVAL;
>  
>  	status = acpi_get_handle(fujitsu->acpi_handle, "SBLL", &handle);
>  	if (ACPI_FAILURE(status)) {
> -		vdbg_printk(FUJLAPTOP_DBG_ERROR, "SBLL not present\n");
> +		fuj_dbg(FUJLAPTOP_DBG_ERROR, "SBLL not present\n");
>  		return -ENODEV;
>  	}
>  
> @@ -349,15 +341,14 @@ static int set_lcd_level_alt(int level)
>  	struct acpi_object_list arg_list = { 1, &arg0 };
>  	acpi_handle handle = NULL;
>  
> -	vdbg_printk(FUJLAPTOP_DBG_TRACE, "set lcd level via SBL2 [%d]\n",
> -		    level);
> +	fuj_dbg(FUJLAPTOP_DBG_TRACE, "set lcd level via SBL2 [%d]\n", level);
>  
>  	if (level < 0 || level >= fujitsu->max_brightness)
>  		return -EINVAL;
>  
>  	status = acpi_get_handle(fujitsu->acpi_handle, "SBL2", &handle);
>  	if (ACPI_FAILURE(status)) {
> -		vdbg_printk(FUJLAPTOP_DBG_ERROR, "SBL2 not present\n");
> +		fuj_dbg(FUJLAPTOP_DBG_ERROR, "SBL2 not present\n");
>  		return -ENODEV;
>  	}
>  
> @@ -375,7 +366,7 @@ static int get_lcd_level(void)
>  	unsigned long long state = 0;
>  	acpi_status status = AE_OK;
>  
> -	vdbg_printk(FUJLAPTOP_DBG_TRACE, "get lcd level via GBLL\n");
> +	fuj_dbg(FUJLAPTOP_DBG_TRACE, "get lcd level via GBLL\n");
>  
>  	status =
>  	    acpi_evaluate_integer(fujitsu->acpi_handle, "GBLL", NULL, &state);
> @@ -397,7 +388,7 @@ static int get_max_brightness(void)
>  	unsigned long long state = 0;
>  	acpi_status status = AE_OK;
>  
> -	vdbg_printk(FUJLAPTOP_DBG_TRACE, "get max lcd level via RBLL\n");
> +	fuj_dbg(FUJLAPTOP_DBG_TRACE, "get max lcd level via RBLL\n");
>  
>  	status =
>  	    acpi_evaluate_integer(fujitsu->acpi_handle, "RBLL", NULL, &state);
> @@ -424,7 +415,7 @@ static int bl_update_status(struct backlight_device *b)
>  	else
>  		ret = call_fext_func(FUNC_BACKLIGHT, 0x1, 0x4, 0x0);
>  	if (ret != 0)
> -		vdbg_printk(FUJLAPTOP_DBG_ERROR,
> +		fuj_dbg(FUJLAPTOP_DBG_ERROR,
>  			"Unable to adjust backlight power, error code %i\n",
>  			ret);
>  
> @@ -433,7 +424,7 @@ static int bl_update_status(struct backlight_device *b)
>  	else
>  		ret = set_lcd_level(b->props.brightness);
>  	if (ret != 0)
> -		vdbg_printk(FUJLAPTOP_DBG_ERROR,
> +		fuj_dbg(FUJLAPTOP_DBG_ERROR,
>  			"Unable to adjust LCD brightness, error code %i\n",
>  			ret);
>  	return ret;
> @@ -594,8 +585,8 @@ static void dmi_check_cb_common(const struct dmi_system_id *id)
>  			use_alt_lcd_levels = 1;
>  		else
>  			use_alt_lcd_levels = 0;
> -		vdbg_printk(FUJLAPTOP_DBG_TRACE, "auto-detected usealt as "
> -			"%i\n", use_alt_lcd_levels);
> +		fuj_dbg(FUJLAPTOP_DBG_TRACE, "auto-detected usealt as %i\n",
> +			use_alt_lcd_levels);
>  	}
>  }
>  
> @@ -704,7 +695,7 @@ static int acpi_fujitsu_add(struct acpi_device *device)
>  
>  	if (ACPI_SUCCESS
>  	    (acpi_get_handle(device->handle, METHOD_NAME__INI, &handle))) {
> -		vdbg_printk(FUJLAPTOP_DBG_INFO, "Invoking _INI\n");
> +		fuj_dbg(FUJLAPTOP_DBG_INFO, "Invoking _INI\n");
>  		if (ACPI_FAILURE
>  		    (acpi_evaluate_object
>  		     (device->handle, METHOD_NAME__INI, NULL, NULL)))
> @@ -714,9 +705,9 @@ static int acpi_fujitsu_add(struct acpi_device *device)
>  	/* do config (detect defaults) */
>  	use_alt_lcd_levels = use_alt_lcd_levels == 1 ? 1 : 0;
>  	disable_brightness_adjust = disable_brightness_adjust == 1 ? 1 : 0;
> -	vdbg_printk(FUJLAPTOP_DBG_INFO,
> -		    "config: [alt interface: %d], [adjust disable: %d]\n",
> -		    use_alt_lcd_levels, disable_brightness_adjust);
> +	fuj_dbg(FUJLAPTOP_DBG_INFO,
> +		"config: [alt interface: %d], [adjust disable: %d]\n",
> +		use_alt_lcd_levels, disable_brightness_adjust);
>  
>  	if (get_max_brightness() <= 0)
>  		fujitsu->max_brightness = FUJITSU_LCD_N_LEVELS;
> @@ -762,9 +753,9 @@ static void acpi_fujitsu_notify(struct acpi_device *device, u32 event)
>  		get_lcd_level();
>  		newb = fujitsu->brightness_level;
>  
> -		vdbg_printk(FUJLAPTOP_DBG_TRACE,
> -			    "brightness button event [%i -> %i (%i)]\n",
> -			    oldb, newb, fujitsu->brightness_changed);
> +		fuj_dbg(FUJLAPTOP_DBG_TRACE,
> +			"brightness button event [%i -> %i (%i)]\n",
> +			oldb, newb, fujitsu->brightness_changed);
>  
>  		if (oldb < newb) {
>  			if (disable_brightness_adjust != 1) {
> @@ -790,8 +781,8 @@ static void acpi_fujitsu_notify(struct acpi_device *device, u32 event)
>  		break;
>  	default:
>  		keycode = KEY_UNKNOWN;
> -		vdbg_printk(FUJLAPTOP_DBG_WARN,
> -			    "unsupported event [0x%x]\n", event);
> +		fuj_dbg(FUJLAPTOP_DBG_WARN, "unsupported event [0x%x]\n",
> +			event);
>  		break;
>  	}
>  
> @@ -872,7 +863,7 @@ static int acpi_fujitsu_hotkey_add(struct acpi_device *device)
>  
>  	if (ACPI_SUCCESS
>  	    (acpi_get_handle(device->handle, METHOD_NAME__INI, &handle))) {
> -		vdbg_printk(FUJLAPTOP_DBG_INFO, "Invoking _INI\n");
> +		fuj_dbg(FUJLAPTOP_DBG_INFO, "Invoking _INI\n");
>  		if (ACPI_FAILURE
>  		    (acpi_evaluate_object
>  		     (device->handle, METHOD_NAME__INI, NULL, NULL)))
> @@ -883,7 +874,7 @@ static int acpi_fujitsu_hotkey_add(struct acpi_device *device)
>  	while (call_fext_func(FUNC_BUTTONS, 0x1, 0x0, 0x0) != 0
>  		&& (i++) < MAX_HOTKEY_RINGBUFFER_SIZE)
>  		; /* No action, result is discarded */
> -	vdbg_printk(FUJLAPTOP_DBG_INFO, "Discarded %i ringbuffer entries\n", i);
> +	fuj_dbg(FUJLAPTOP_DBG_INFO, "Discarded %i ringbuffer entries\n", i);
>  
>  	fujitsu_hotkey->rfkill_supported =
>  		call_fext_func(FUNC_RFKILL, 0x0, 0x0, 0x0);
> @@ -996,13 +987,13 @@ static void acpi_fujitsu_hotkey_notify(struct acpi_device *device, u32 event)
>  				keycode = 0;
>  				break;
>  			default:
> -				vdbg_printk(FUJLAPTOP_DBG_WARN,
> -					    "Unknown GIRB result [%x]\n", irb);
> +				fuj_dbg(FUJLAPTOP_DBG_WARN,
> +					"Unknown GIRB result [%x]\n", irb);
>  				keycode = -1;
>  				break;
>  			}
>  			if (keycode > 0) {
> -				vdbg_printk(FUJLAPTOP_DBG_TRACE,
> +				fuj_dbg(FUJLAPTOP_DBG_TRACE,
>  					"Push keycode into ringbuffer [%d]\n",
>  					keycode);
>  				status = kfifo_in_locked(&fujitsu_hotkey->fifo,
> @@ -1010,9 +1001,9 @@ static void acpi_fujitsu_hotkey_notify(struct acpi_device *device, u32 event)
>  						   sizeof(keycode),
>  						   &fujitsu_hotkey->fifo_lock);
>  				if (status != sizeof(keycode)) {
> -					vdbg_printk(FUJLAPTOP_DBG_WARN,
> -					    "Could not push keycode [0x%x]\n",
> -					    keycode);
> +					fuj_dbg(FUJLAPTOP_DBG_WARN,
> +						"Could not push keycode [0x%x]\n",
> +						keycode);
>  				} else {
>  					input_report_key(input, keycode, 1);
>  					input_sync(input);
> @@ -1027,9 +1018,9 @@ static void acpi_fujitsu_hotkey_notify(struct acpi_device *device, u32 event)
>  					 == sizeof(keycode_r)) {
>  					input_report_key(input, keycode_r, 0);
>  					input_sync(input);
> -					vdbg_printk(FUJLAPTOP_DBG_TRACE,
> -					  "Pop keycode from ringbuffer [%d]\n",
> -					  keycode_r);
> +					fuj_dbg(FUJLAPTOP_DBG_TRACE,
> +						"Pop keycode from ringbuffer [%d]\n",
> +						keycode_r);
>  				}
>  			}
>  		}
> @@ -1037,8 +1028,8 @@ static void acpi_fujitsu_hotkey_notify(struct acpi_device *device, u32 event)
>  		break;
>  	default:
>  		keycode = KEY_UNKNOWN;
> -		vdbg_printk(FUJLAPTOP_DBG_WARN,
> -			    "Unsupported event [0x%x]\n", event);
> +		fuj_dbg(FUJLAPTOP_DBG_WARN, "Unsupported event [0x%x]\n",
> +			event);
>  		input_report_key(input, keycode, 1);
>  		input_sync(input);
>  		input_report_key(input, keycode, 0);
> -- 
> 1.7.8.111.gad25c.dirty

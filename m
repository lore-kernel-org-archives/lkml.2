Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760642Ab2EIRpo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 13:45:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49340 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758551Ab2EIRpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 13:45:39 -0400
Date: Wed, 9 May 2012 10:45:35 -0700
From: Seth Forshee <seth.forshee@canonical.com>
To: Azael Avalos <coproscefalo@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Add SCI operations and adapt Illumination code
Message-ID: <20120509174535.GB7189@ubuntu-mba>
Mail-Followup-To: Azael Avalos <coproscefalo@gmail.com>,
	Matthew Garrett <mjg@redhat.com>,
	platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CAGdLNWFFX-SP65nJrUDFq4i6vY-xCuGOJJK7RZZdFt2jtopYng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGdLNWFFX-SP65nJrUDFq4i6vY-xCuGOJJK7RZZdFt2jtopYng@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 10:03:01AM -0600, Azael Avalos wrote:
> SCI stands for Software Configuration Interface and
> it is supposed to be present on all Toshiba models.
> 
> Illumination code is now adapted to use SCI calls and
> is not registered unless the SCI is present.
> 
> Signed-off-by: Azael Avalos <coproscefalo@gmail.com>

Acked-by: Seth Forshee <seth.forshee@canonical.com>

> ---
> 
> v2: Corrected style problem as noted be Seth Forshee
> 
> Please consider applying this as a fix for 3.4 or 3.5.
> 
> This will fix up things for a proper Illumination check,
> as it stands now its just "checking" the SCI and not
> the Illumination support per se.
> 
> I'll gladly fix this if it causes merging trouble because
> of the other patches sent.
> 
> 
>  drivers/platform/x86/toshiba_acpi.c |  173 +++++++++++++++++++++--------------
>  1 files changed, 105 insertions(+), 68 deletions(-)
> 
> diff --git a/drivers/platform/x86/toshiba_acpi.c
> b/drivers/platform/x86/toshiba_acpi.c
> index ee79ce6..78c9bb3 100644
> --- a/drivers/platform/x86/toshiba_acpi.c
> +++ b/drivers/platform/x86/toshiba_acpi.c
> @@ -84,13 +84,23 @@ MODULE_LICENSE("GPL");
>  #define HCI_WORDS			6
> 
>  /* operations */
> -#define HCI_SET				0xff00
> +#define SCI_SUPPORT_CHECK		0xf000
> +#define SCI_OPEN			0xf100
> +#define SCI_CLOSE			0xf200
> +#define SCI_GET				0xf300
> +#define SCI_SET				0xf400
>  #define HCI_GET				0xfe00
> +#define HCI_SET				0xff00
> +
> 
>  /* return codes */
>  #define HCI_SUCCESS			0x0000
>  #define HCI_FAILURE			0x1000
>  #define HCI_NOT_SUPPORTED		0x8000
> +#define SCI_ALREADY_OPEN		0x8100
> +#define SCI_NOT_OPENED			0x8200
> +#define SCI_INPUT_DATA_ERROR		0x8300
> +#define SCI_NOT_PRESENT			0x8600
>  #define HCI_EMPTY			0x8c00
> 
>  /* registers */
> @@ -100,6 +110,7 @@ MODULE_LICENSE("GPL");
>  #define HCI_HOTKEY_EVENT		0x001e
>  #define HCI_LCD_BRIGHTNESS		0x002a
>  #define HCI_WIRELESS			0x0056
> +#define SCI_ILLUMINATION		0x014e
> 
>  /* field definitions */
>  #define HCI_HOTKEY_DISABLE		0x0b
> @@ -128,6 +139,7 @@ struct toshiba_acpi_dev {
>  	int last_key_event;
>  	int key_event_valid;
> 
> +	unsigned int sci_opened:1;
>  	unsigned int illumination_supported:1;
>  	unsigned int video_supported:1;
>  	unsigned int fan_supported:1;
> @@ -286,21 +298,78 @@ static acpi_status hci_read2(struct
> toshiba_acpi_dev *dev, u32 reg,
>  	return status;
>  }
> 
> -/* Illumination support */
> -static int toshiba_illumination_available(struct toshiba_acpi_dev *dev)
> +/* sci functions */
> +static int sci_open(struct toshiba_acpi_dev *dev)
>  {
> -	u32 in[HCI_WORDS] = { 0, 0, 0, 0, 0, 0 };
> +	u32 in[HCI_WORDS] = { SCI_OPEN, 0, 0, 0, 0, 0 };
>  	u32 out[HCI_WORDS];
>  	acpi_status status;
> 
> -	in[0] = 0xf100;
>  	status = hci_raw(dev, in, out);
>  	if (ACPI_FAILURE(status)) {
> -		pr_info("Illumination device not available\n");
> +		pr_err("ACPI call to open SCI failed.\n");
> +		return 0;
> +	} else if (out[0] == SCI_NOT_PRESENT) {
> +		pr_info("Toshiba SCI is not present.\n");
>  		return 0;
> +	} else if (out[0] == SCI_ALREADY_OPEN) {
> +		pr_notice("Toshiba SCI already opened.\n");
>  	}
> -	in[0] = 0xf400;
> +
> +	return 1;
> +}
> +
> +static void sci_close(struct toshiba_acpi_dev *dev)
> +{
> +	u32 in[HCI_WORDS] = { SCI_CLOSE, 0, 0, 0, 0, 0 };
> +	u32 out[HCI_WORDS];
> +	acpi_status status;
> +
>  	status = hci_raw(dev, in, out);
> +	if (ACPI_FAILURE(status))
> +		pr_err("ACPI call to close SCI failed.\n");
> +	else if (out[0] == SCI_NOT_PRESENT)
> +		pr_info("Toshiba SCI is not present.\n");
> +	else if (out[0] == SCI_NOT_OPENED)
> +		pr_notice("Toshiba SCI not opened.\n");
> +}
> +
> +static acpi_status sci_read(struct toshiba_acpi_dev *dev, u32 reg,
> +			    u32 *out1, u32 *result)
> +{
> +	u32 in[HCI_WORDS] = { SCI_GET, reg, 0, 0, 0, 0 };
> +	u32 out[HCI_WORDS];
> +	acpi_status status = hci_raw(dev, in, out);
> +	*out1 = out[2];
> +	*result = (ACPI_SUCCESS(status)) ? out[0] : HCI_FAILURE;
> +	return status;
> +}
> +
> +static acpi_status sci_write(struct toshiba_acpi_dev *dev, u32 reg,
> +			     u32 in1, u32 *result)
> +{
> +	u32 in[HCI_WORDS] = { SCI_SET, reg, in1, 0, 0, 0 };
> +	u32 out[HCI_WORDS];
> +	acpi_status status = hci_raw(dev, in, out);
> +	*result = (ACPI_SUCCESS(status)) ? out[0] : HCI_FAILURE;
> +	return status;
> +}
> +
> +/* Illumination support */
> +static int toshiba_illumination_available(struct toshiba_acpi_dev *dev)
> +{
> +	u32 value, result;
> +	acpi_status status;
> +
> +	status = sci_read(dev, SCI_ILLUMINATION, &value, &result);
> +	if (ACPI_FAILURE(status) || result == SCI_INPUT_DATA_ERROR) {
> +		pr_err("ACPI call for illumination failed.\n");
> +		return 0;
> +	} else if (result == HCI_NOT_SUPPORTED) {
> +		pr_info("Illumination device not available\n");
> +		return 0;
> +	}
> +
>  	return 1;
>  }
> 
> @@ -309,82 +378,38 @@ static void toshiba_illumination_set(struct
> led_classdev *cdev,
>  {
>  	struct toshiba_acpi_dev *dev = container_of(cdev,
>  			struct toshiba_acpi_dev, led_dev);
> -	u32 in[HCI_WORDS] = { 0, 0, 0, 0, 0, 0 };
> -	u32 out[HCI_WORDS];
> +	u32 state, result;
>  	acpi_status status;
> 
> -	/* First request : initialize communication. */
> -	in[0] = 0xf100;
> -	status = hci_raw(dev, in, out);
> -	if (ACPI_FAILURE(status)) {
> -		pr_info("Illumination device not available\n");
> +	/* Switch the illumination on/off */
> +	state = (brightness) ? 1 : 0;
> +	status = sci_write(dev, SCI_ILLUMINATION, state, &result);
> +	if (ACPI_FAILURE(status) || result == SCI_INPUT_DATA_ERROR) {
> +		pr_err("ACPI call for illumination failed.\n");
>  		return;
> +	} else if (result == HCI_NOT_SUPPORTED) {
> +		pr_info("Illumination not supported\n");
>  	}
> -
> -	if (brightness) {
> -		/* Switch the illumination on */
> -		in[0] = 0xf400;
> -		in[1] = 0x14e;
> -		in[2] = 1;
> -		status = hci_raw(dev, in, out);
> -		if (ACPI_FAILURE(status)) {
> -			pr_info("ACPI call for illumination failed\n");
> -			return;
> -		}
> -	} else {
> -		/* Switch the illumination off */
> -		in[0] = 0xf400;
> -		in[1] = 0x14e;
> -		in[2] = 0;
> -		status = hci_raw(dev, in, out);
> -		if (ACPI_FAILURE(status)) {
> -			pr_info("ACPI call for illumination failed.\n");
> -			return;
> -		}
> -	}
> -
> -	/* Last request : close communication. */
> -	in[0] = 0xf200;
> -	in[1] = 0;
> -	in[2] = 0;
> -	hci_raw(dev, in, out);
>  }
> 
>  static enum led_brightness toshiba_illumination_get(struct led_classdev *cdev)
>  {
>  	struct toshiba_acpi_dev *dev = container_of(cdev,
>  			struct toshiba_acpi_dev, led_dev);
> -	u32 in[HCI_WORDS] = { 0, 0, 0, 0, 0, 0 };
> -	u32 out[HCI_WORDS];
> +	u32 state, result;
>  	acpi_status status;
> -	enum led_brightness result;
> -
> -	/* First request : initialize communication. */
> -	in[0] = 0xf100;
> -	status = hci_raw(dev, in, out);
> -	if (ACPI_FAILURE(status)) {
> -		pr_info("Illumination device not available\n");
> -		return LED_OFF;
> -	}
> 
>  	/* Check the illumination */
> -	in[0] = 0xf300;
> -	in[1] = 0x14e;
> -	status = hci_raw(dev, in, out);
> -	if (ACPI_FAILURE(status)) {
> -		pr_info("ACPI call for illumination failed.\n");
> +	status = sci_read(dev, SCI_ILLUMINATION, &state, &result);
> +	if (ACPI_FAILURE(status) || result == SCI_INPUT_DATA_ERROR) {
> +		pr_err("ACPI call for illumination failed.\n");
> +		return LED_OFF;
> +	} else if (result == HCI_NOT_SUPPORTED) {
> +		pr_info("Illumination not supported\n");
>  		return LED_OFF;
>  	}
> 
> -	result = out[2] ? LED_FULL : LED_OFF;
> -
> -	/* Last request : close communication. */
> -	in[0] = 0xf200;
> -	in[1] = 0;
> -	in[2] = 0;
> -	hci_raw(dev, in, out);
> -
> -	return result;
> +	return state ? LED_FULL : LED_OFF;
>  }
> 
>  /* Bluetooth rfkill handlers */
> @@ -1047,6 +1072,9 @@ static int toshiba_acpi_remove(struct
> acpi_device *acpi_dev, int type)
>  	if (dev->illumination_supported)
>  		led_classdev_unregister(&dev->led_dev);
> 
> +	if (dev->sci_opened)
> +		sci_close(dev);
> +
>  	if (toshiba_acpi)
>  		toshiba_acpi = NULL;
> 
> @@ -1099,6 +1127,15 @@ static int __devinit toshiba_acpi_add(struct
> acpi_device *acpi_dev)
>  	dev->method_hci = hci_method;
>  	acpi_dev->driver_data = dev;
> 
> +	/* Open Toshiba SCI, if present */
> +	ret = sci_open(dev);
> +	if (ret == 0) {
> +		pr_info("Toshiba SCI could not be opened.\n");
> +		dev->sci_opened = 0;
> +	} else {
> +		dev->sci_opened = 1;
> +	}
> +
>  	if (toshiba_acpi_setup_keyboard(dev))
>  		pr_info("Unable to activate hotkeys\n");
> 
> @@ -1141,7 +1178,7 @@ static int __devinit toshiba_acpi_add(struct
> acpi_device *acpi_dev)
>  		}
>  	}
> 
> -	if (toshiba_illumination_available(dev)) {
> +	if (dev->sci_opened && toshiba_illumination_available(dev)) {
>  		dev->led_dev.name = "toshiba::illumination";
>  		dev->led_dev.max_brightness = 1;
>  		dev->led_dev.brightness_set = toshiba_illumination_set;
> -- 
> 1.7.3.4
> 
> 
> 
> -- 
> -- El mundo apesta y vosotros apestais tambien --
> --
> To unsubscribe from this list: send the line "unsubscribe platform-driver-x86" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

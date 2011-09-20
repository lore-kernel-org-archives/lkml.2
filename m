Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402Ab1ITWR7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 18:17:59 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:44268 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751180Ab1ITWR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 18:17:58 -0400
Subject: Re: [PATCH 1/6] toshiba_acpi: Convert to use acpi_driver
From: Joe Perches <joe@perches.com>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Matthew Garrett <mjg@redhat.com>, Azael Avalos <coproscefalo@gmail.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 20 Sep 2011 15:17:57 -0700
In-Reply-To: <1316555754-25949-2-git-send-email-seth.forshee@canonical.com>
References: <1316555754-25949-1-git-send-email-seth.forshee@canonical.com>
	 <1316555754-25949-2-git-send-email-seth.forshee@canonical.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.91- 
Content-Transfer-Encoding: 7bit
Message-ID: <1316557078.1903.11.camel@Joe-Laptop>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-20 at 16:55 -0500, Seth Forshee wrote:
> Changes toshiba_acpi to register an acpi driver and eliminates the
> platform device it was using.

Just trivial comments...

> diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
> +static acpi_status hci_raw(struct toshiba_acpi_dev *dev,
> +			   const u32 in[HCI_WORDS], u32 out[HCI_WORDS])
[]
> @@ -237,85 +234,79 @@ static acpi_status hci_raw(const u32 in[HCI_WORDS], u32 out[HCI_WORDS])
>   * may be useful (such as "not supported").
>   */
>  
> -static acpi_status hci_write1(u32 reg, u32 in1, u32 * result)
> +static acpi_status hci_write1(struct toshiba_acpi_dev *dev, u32 reg,
> +			      u32 in1, u32 *result)
>  {
>  	u32 in[HCI_WORDS] = { HCI_SET, reg, in1, 0, 0, 0 };

A lot of the in[HCI_WORDS] could be static const or const

	static const u32 in[HCI_WORDS] etc...

> +static acpi_status hci_read1(struct toshiba_acpi_dev *dev, u32 reg,
> +			     u32 *out1, u32 *result)
>  {
>  	u32 in[HCI_WORDS] = { HCI_GET, reg, 0, 0, 0, 0 };

here too.

>  	u32 out[HCI_WORDS];
> -	acpi_status status = hci_raw(in, out);
> +	acpi_status status = hci_raw(dev, in, out);
>  	*out1 = out[2];
>  	*result = (status == AE_OK) ? out[0] : HCI_FAILURE;
>  	return status;
>  }
>  
> -static acpi_status hci_write2(u32 reg, u32 in1, u32 in2, u32 *result)
> +static acpi_status hci_write2(struct toshiba_acpi_dev *dev, u32 reg,
> +			      u32 in1, u32 in2, u32 *result)
>  {
>  	u32 in[HCI_WORDS] = { HCI_SET, reg, in1, in2, 0, 0 };

const etc.

> @@ -507,8 +486,13 @@ static int get_lcd(struct backlight_device *bd)
>  
>  static int lcd_proc_show(struct seq_file *m, void *v)
>  {
> -	int value = get_lcd(NULL);
> +	struct toshiba_acpi_dev *dev = m->private;
> +	int value;
> +
> +	if (!dev->backlight_dev)
> +		return -ENODEV;
>  
> +	value = get_lcd(dev->backlight_dev);
>  	if (value >= 0) {
>  		seq_printf(m, "brightness:              %d\n", value);
>  		seq_printf(m, "brightness_levels:       %d\n",

Some small amount space could be saved by using:

		seq_printf(m, "%-24s %d\n", "brightness:", value);
		seq_printf(m, "%-24s %d\n", "brightness_levels:", etc...
[]
> @@ -675,13 +663,14 @@ static const struct file_operations video_proc_fops = {
>  
>  static int fan_proc_show(struct seq_file *m, void *v)
>  {
> +	struct toshiba_acpi_dev *dev = m->private;
>  	u32 hci_result;
>  	u32 value;
>  
> -	hci_read1(HCI_FAN, &value, &hci_result);
> +	hci_read1(dev, HCI_FAN, &value, &hci_result);
>  	if (hci_result == HCI_SUCCESS) {
>  		seq_printf(m, "running:                 %d\n", (value > 0));

Here too:

		seq_printf(m, "%-24s %d\n", "running:", (value > 0);

> -		seq_printf(m, "force_on:                %d\n", force_fan);
> +		seq_printf(m, "force_on:                %d\n", dev->force_fan);

etc.



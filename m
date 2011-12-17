Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751316Ab1LQIby (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 03:31:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43670 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750806Ab1LQIbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 03:31:47 -0500
From: Thomas Renninger <trenn@suse.de>
To: Seth Forshee <seth.forshee@canonical.com>
Subject: Re: [PATCH 2/4] toshiba_acpi: Support alternate hotkey interfaces
Date: Sat, 17 Dec 2011 09:31:43 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc5-5.99.12.5343e5f-desktop; KDE/4.4.4; x86_64; ; )
Cc: Matthew Garrett <mjg@redhat.com>, Len Brown <lenb@kernel.org>,
        Azael Avalos <coproscefalo@gmail.com>,
        platform-driver-x86@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1323972371-13189-1-git-send-email-seth.forshee@canonical.com> <1323972371-13189-3-git-send-email-seth.forshee@canonical.com>
In-Reply-To: <1323972371-13189-3-git-send-email-seth.forshee@canonical.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201112170931.44171.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 December 2011 19:06:09 Seth Forshee wrote:
...  
> +static bool toshiba_acpi_i8042_filter(unsigned char data, unsigned char str,
> +				      struct serio *port)
> +{
> +	if (str & 0x20)
> +		return false;
> +
> +	if (unlikely(data == 0xe0))
> +		return false;
> +
> +	if ((data & 0x7f) == TOS1900_FN_SCAN) {
> +		schedule_work(&toshiba_acpi->hotkey_work);
> +		return true;
> +	}
What have you tried to check whether some other kind of ACPI event
is happening?
Do any acpi/SCI interrupts happen?:
watch -n1 "cat /proc/interrupts |grep acpi"

Could it by chance be an EC or other device GPE/SCI?

> +
> +	return false;
> +}
> +
> +static void toshiba_acpi_hotkey_work(struct work_struct *work)
> +{
> +	acpi_handle ec_handle = ec_get_handle();
> +	acpi_status status;
> +
> +	if (!ec_handle)
> +		return;
> +
> +	status = acpi_evaluate_object(ec_handle, "NTFY", NULL, NULL);
> +	if (ACPI_FAILURE(status))
> +		pr_err("ACPI NTFY method execution failed\n");
Why is calling NTFY needed?

...

> +static int toshiba_acpi_suspend(struct acpi_device *acpi_dev,
> +				pm_message_t state)
> +{
> +	struct toshiba_acpi_dev *dev = acpi_driver_data(acpi_dev);
> +	u32 result;
> +
> +	if (dev->hotkey_dev)
> +		hci_write1(dev, HCI_HOTKEY_EVENT, HCI_HOTKEY_DISABLE, &result);
> +
> +	return 0;
> +}
> +
> +static int toshiba_acpi_resume(struct acpi_device *acpi_dev)
> +{
> +	struct toshiba_acpi_dev *dev = acpi_driver_data(acpi_dev);
> +	u32 result;
> +
> +	if (dev->hotkey_dev)
> +		hci_write1(dev, HCI_HOTKEY_EVENT, HCI_HOTKEY_ENABLE, &result);
> +
> +	return 0;
> +}
What are the suspend/resume funcs for?
What bad things happen without them?


     Thomas

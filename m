Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410Ab1LQPHw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 10:07:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36636 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345Ab1LQPHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 10:07:50 -0500
Date: Sat, 17 Dec 2011 09:07:42 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Thomas Renninger <trenn@suse.de>
Cc: Azael Avalos <coproscefalo@gmail.com>, Matthew Garrett <mjg@redhat.com>,
        Len Brown <lenb@kernel.org>, platform-driver-x86@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] toshiba_acpi: Support alternate hotkey interfaces
Message-ID: <20111217150742.GA6916@ubuntu-mba>
Mail-Followup-To: Thomas Renninger <trenn@suse.de>,
	Azael Avalos <coproscefalo@gmail.com>,
	Matthew Garrett <mjg@redhat.com>, Len Brown <lenb@kernel.org>,
	platform-driver-x86@vger.kernel.org, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1323972371-13189-1-git-send-email-seth.forshee@canonical.com>
 <1323972371-13189-3-git-send-email-seth.forshee@canonical.com>
 <201112170931.44171.trenn@suse.de>
 <CAGdLNWFeRD=K0YWwr=r2Rznr1N4B6HMPOUF4vWv1aOZbDy+rEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGdLNWFeRD=K0YWwr=r2Rznr1N4B6HMPOUF4vWv1aOZbDy+rEQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 17, 2011 at 04:32:14AM -0700, Azael Avalos wrote:
> 2011/12/17 Thomas Renninger <trenn@suse.de>:
> > On Thursday 15 December 2011 19:06:09 Seth Forshee wrote:
> > ...
> >> +static bool toshiba_acpi_i8042_filter(unsigned char data, unsigned char str,
> >> +                                   struct serio *port)
> >> +{
> >> +     if (str & 0x20)
> >> +             return false;
> >> +
> >> +     if (unlikely(data == 0xe0))
> >> +             return false;
> >> +
> >> +     if ((data & 0x7f) == TOS1900_FN_SCAN) {
> >> +             schedule_work(&toshiba_acpi->hotkey_work);
> >> +             return true;
> >> +     }
> > What have you tried to check whether some other kind of ACPI event
> > is happening?
> > Do any acpi/SCI interrupts happen?:
> > watch -n1 "cat /proc/interrupts |grep acpi"
> 
> I already did this, no events whatsoever, I was using a Satellite X205
> at the time

I've done similar checks on the NB505, no events.

> >
> > Could it by chance be an EC or other device GPE/SCI?
> >
> 
> Seth mentioned me something about this, but w/o proper docs from
> Toshiba, we are blindly shooting.
> 
> Seth?

In the DSDTs I've inspected there is an EC query method that looks like
it handles events for the hotkeys, but I've never been able to find
anything that will cause the GPE to trigger when the hotkeys are
pressed.

Interestingly, I also saw that the Windows hotkey driver for the NB505
logs some messages that indicate it's also filtering Fn key presses, and
I also found that the binary contains the NTFY string. That's not proof
of anything, but it does suggest that the Windows driver might be doing
something similar to support hotkeys. Which makes me wonder if the GPE
works at all.

> 
> >> +
> >> +     return false;
> >> +}
> >> +
> >> +static void toshiba_acpi_hotkey_work(struct work_struct *work)
> >> +{
> >> +     acpi_handle ec_handle = ec_get_handle();
> >> +     acpi_status status;
> >> +
> >> +     if (!ec_handle)
> >> +             return;
> >> +
> >> +     status = acpi_evaluate_object(ec_handle, "NTFY", NULL, NULL);
> >> +     if (ACPI_FAILURE(status))
> >> +             pr_err("ACPI NTFY method execution failed\n");
> > Why is calling NTFY needed?
> 
> The NTFY method triggers a 0x80 notify event on TOS1900 device,
> and thus being trapped by toshiba_acpi_notify, here are the methods
> 
> Method (NTFY, 0, NotSerialized)
> {
>   Store (One, ^^^^VALZ.TECF)
>   Notify (VALZ, 0x80)
>   Return (0xAA)
> }
> 
> And then
> 
> Method (INFO, 0, NotSerialized)
> {
>   If (TECF)
>   {
>     Store (Zero, TECF)
>     Store (^^PCI0.LPCB.EC0.TOHK, Local0)
>     Store (Zero, ^^PCI0.LPCB.EC0.TOHK)
>   }
>   Else
>   {
>     Store (Zero, Local0)
>   }
> 
>   Return (Local0)
> }

The NB505 is very similar. We might be able to get by without NTFY if
all it was doing was providing the notification, but as you can see it
also sets a flag that's needed to read the hotkey event with the INFO
method.

> >
> > ...
> >
> >> +static int toshiba_acpi_suspend(struct acpi_device *acpi_dev,
> >> +                             pm_message_t state)
> >> +{
> >> +     struct toshiba_acpi_dev *dev = acpi_driver_data(acpi_dev);
> >> +     u32 result;
> >> +
> >> +     if (dev->hotkey_dev)
> >> +             hci_write1(dev, HCI_HOTKEY_EVENT, HCI_HOTKEY_DISABLE, &result);
> >> +
> >> +     return 0;
> >> +}
> >> +
> >> +static int toshiba_acpi_resume(struct acpi_device *acpi_dev)
> >> +{
> >> +     struct toshiba_acpi_dev *dev = acpi_driver_data(acpi_dev);
> >> +     u32 result;
> >> +
> >> +     if (dev->hotkey_dev)
> >> +             hci_write1(dev, HCI_HOTKEY_EVENT, HCI_HOTKEY_ENABLE, &result);
> >> +
> >> +     return 0;
> >> +}
> > What are the suspend/resume funcs for?
> > What bad things happen without them?
> 
> Some models (NB500 among others) stop sending hotkey events
> when resumed, and even activating the hotkeys again don't work,
> the suspend/resume functions do the trick ;)

The NB505 (which is what I've been testing with) requires this as well.

Seth


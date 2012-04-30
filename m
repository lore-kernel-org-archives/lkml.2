Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902Ab2D3VjV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 17:39:21 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:56328 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756673Ab2D3VjS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 17:39:18 -0400
MIME-Version: 1.0
In-Reply-To: <201204302341.12528.rjw@sisk.pl>
References: <201204292244.16467.rjw@sisk.pl> <CAErSpo7oGWNVeT6OCgaFdb_+uPAumggE-Z+OdnH=9aW+_N3B6g@mail.gmail.com>
 <201204302341.12528.rjw@sisk.pl>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 30 Apr 2012 15:38:55 -0600
Message-ID: <CAErSpo57jEuoKLnqVp6V-fkb8TBj+cUv3kgEbfpvFErE315pCA@mail.gmail.com>
Subject: Re: [PATCH] ACPI / PCI: Make _SxD/_SxW check follow ACPI 4.0a spec
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>, linux-pci@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        "Oleksij Rempel (fishor)" <bug-track@fisher-privat.net>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 3:41 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Monday, April 30, 2012, Bjorn Helgaas wrote:
>> On Sun, Apr 29, 2012 at 2:44 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > From: Oleksij Rempel <bug-track@fisher-privat.net>
>> >
>> > This patch makes _SxD/_SxW check follow the ACPI 4.0a specification
>> > more closely and fixes suspend bug found on ASUS Zenbook UX31E.
>> >
>> > Some OEM use _SxD fileds do blacklist brocken Dx states.
>> > If _SxD/_SxW return values are check before suspend as appropriate,
>> > some nasty suspend/resume issues may be avoided.
>> >
>> > References: https://bugzilla.kernel.org/show_bug.cgi?id=42728
>> > Signed-off-by: Oleksij Rempel <bug-track@fisher-privat.net>
>> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
>> > ---
>> >
>> > Bjorn, Len,
>> >
>> > This is -stable material and therefore v3.4 as well, IMO.  Please let me
>> > know if one of you can take it or whether you want me to handle it all the
>> > way to Linus.
>>
>> I'm OK with this from a PCI perspective.  Most of the change is in
>> ACPI, so I propose that either you or Len take care of it.
>>
>> The second paragraph of the changelog has several typos
>> (fileds/fields, do/to, brocken/broken, etc).
>
> Thanks for spotting that, the version below should be better.
>
> I'll wait for Len to respond till Friday and will take care of the patch myself
> if he doesn't say anything.
>
> May I assume an ACK from you?

Yep, sorry :)

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

> ---
> From: Oleksij Rempel <bug-track@fisher-privat.net>
> Subject: ACPI / PCI: Make _SxD/_SxW check follow ACPI 4.0a spec
>
> This patch makes _SxD/_SxW check follow the ACPI 4.0a specification
> more closely and fixes suspend bug found on ASUS Zenbook UX31E.
>
> Some OEM use _SxD fields to blacklist broken device Dx states, so
> if _SxD/_SxW return values are checked before suspend as appropriate,
> some nasty suspend/resume issues may be avoided.
>
> References: https://bugzilla.kernel.org/show_bug.cgi?id=42728
> Signed-off-by: Oleksij Rempel <bug-track@fisher-privat.net>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/acpi/sleep.c |   22 +++++++++++++++++++++-
>  drivers/pci/pci.c    |   12 +++++++++++-
>  2 files changed, 32 insertions(+), 2 deletions(-)
>
> Index: linux/drivers/acpi/sleep.c
> ===================================================================
> --- linux.orig/drivers/acpi/sleep.c
> +++ linux/drivers/acpi/sleep.c
> @@ -720,10 +720,30 @@ int acpi_pm_device_sleep_state(struct de
>         *
>         * NOTE: We rely on acpi_evaluate_integer() not clobbering the integer
>         * provided -- that's our fault recovery, we ignore retval.
> +        *
> +        * According to ACPI 4.0a (April 5, 2010), page 294,
> +        * Table 7-7 S3 Action / Result Table, we need to evaluate _SxW in
> +        * addition to _SxD if the device is configured for wakeup:
> +        * Desired Action    | _S3D | _PRW | _S3W | Resultant D-state
> +        * Enter S3          |  N/A |  D/C |  N/A | OSPM decides
> +        * Enter S3, No Wake |   2  |  D/C |  D/C | Enter D2 or D3
> +        * Enter S3, Wake    |   2  |   3  |  N/A | Enter D2
> +        * Enter S3, Wake    |   2  |   3  |   3  | Enter D2 or D3
> +        * Enter S3, Wake    |  N/A |   3  |   2  | Enter D0, D1 or D2
>         */
> -       if (acpi_target_sleep_state > ACPI_STATE_S0)
> +       if (acpi_target_sleep_state > ACPI_STATE_S0) {
> +               acpi_status status;
> +
>                acpi_evaluate_integer(handle, acpi_method, NULL, &d_min);
>
> +               if (device_may_wakeup(dev)) {
> +                       acpi_method[3] = 'W';
> +                       status = acpi_evaluate_integer(handle, acpi_method,
> +                                                      NULL, &d_max);
> +                       if (ACPI_FAILURE(status))
> +                               d_max = d_min;
> +               }
> +       }
>        /*
>         * If _PRW says we can wake up the system from the target sleep state,
>         * the D-state returned by _SxD is sufficient for that (we assume a
> Index: linux/drivers/pci/pci.c
> ===================================================================
> --- linux.orig/drivers/pci/pci.c
> +++ linux/drivers/pci/pci.c
> @@ -1691,10 +1691,20 @@ pci_power_t pci_target_state(struct pci_
>  {
>        pci_power_t target_state = PCI_D3hot;
>
> -       if (platform_pci_power_manageable(dev)) {
> +       /*
> +        * According to ACPI 4.0a,7.2 Device Power Management Objects, device
> +        * with wake capability should have _PRW or _PSW object and can have
> +        * _SxD or _SxW object.
> +        * It looks like some OEMs use this fields to avoid buggy Dx states
> +        * of devices, so we need to check for _PRW or _PSW and see if _SxD or
> +        * _SxW indicate to overwrite Dx.
> +        */
> +       if (platform_pci_power_manageable(dev)
> +           || platform_pci_can_wakeup(dev)) {
>                /*
>                 * Call the platform to choose the target state of the device
>                 * and enable wake-up from this state if supported.
> +                * (Check _SxD and _SxW)
>                 */
>                pci_power_t state = platform_pci_choose_state(dev);
>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552Ab2EDFXY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 01:23:24 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:57040 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751301Ab2EDFXU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 01:23:20 -0400
MIME-Version: 1.0
In-Reply-To: <20120423015247.GA1119@localhost.amd.com>
References: <1335143029.4927.45.camel@minggr>
	<20120423015247.GA1119@localhost.amd.com>
Date: Fri, 4 May 2012 13:23:19 +0800
X-Google-Sender-Auth: yq0FynMc87kMXUbE7HpVPGQYmfc
Message-ID: <CAF1ivSb+FWm6LUUA65em7mZSKiG0GSHEUe3VQgZ-TEuTjqoLcQ@mail.gmail.com>
Subject: Re: [PATCH v3] ACPI: D3 states cleanup
From: Lin Ming <ming.m.lin@intel.com>
To: Aaron Lu <aaron.lu@amd.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, lenb <lenb@kernel.org>,
        linux-acpi <linux-acpi@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 9:52 AM, Aaron Lu <aaron.lu@amd.com> wrote:
> On Mon, Apr 23, 2012 at 09:03:49AM +0800, Lin Ming wrote:
>> There are two ACPI D3 states defined now:
>> ACPI_STATE_D3 and ACPI_STATE_D3_COLD.
>>
>> But the uses of these states are not clear/correct in some code.
>> For example, some code refer ACPI_STATE_D3 as D3hot and others refer
>> it as D3cold.
>>
>> This patch introduces ACPI_STATE_D3_HOT to refer to ACPI D3hot state.
>> D3hot is only valid if _PR3 present.
>> And changes ACPI_STATE_D3 to refer to ACPI D3cold state only.
>> Also redefines ACPI_STATE_D3_COLD the same as ACPI_STATE_D3.
>>
>
> Reviewed-by: Aaron Lu <aaron.lu@amd.com>
>
> Thanks,
> Aaron
>
>> Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

Len,

Will you apply this patch?

Thanks,
Lin Ming

>> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
>> ---
>>
>> v3: D3hot is only valid if _PR3 present
>>
>>  drivers/acpi/power.c   |    2 +-
>>  drivers/acpi/scan.c    |   17 +++++++----------
>>  drivers/pci/pci-acpi.c |    4 ++--
>>  include/acpi/actypes.h |    7 ++++---
>>  4 files changed, 14 insertions(+), 16 deletions(-)
>>
>> diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
>> index 7049a7d..330bb4d 100644
>> --- a/drivers/acpi/power.c
>> +++ b/drivers/acpi/power.c
>> @@ -631,7 +631,7 @@ int acpi_power_get_inferred_state(struct acpi_device *device, int *state)
>>        * We know a device's inferred power state when all the resources
>>        * required for a given D-state are 'on'.
>>        */
>> -     for (i = ACPI_STATE_D0; i < ACPI_STATE_D3; i++) {
>> +     for (i = ACPI_STATE_D0; i < ACPI_STATE_D3_HOT; i++) {
>>               list = &device->power.states[i].resources;
>>               if (list->count < 1)
>>                       continue;
>> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
>> index 767e2dc..7417267 100644
>> --- a/drivers/acpi/scan.c
>> +++ b/drivers/acpi/scan.c
>> @@ -869,7 +869,7 @@ static int acpi_bus_get_power_flags(struct acpi_device *device)
>>       /*
>>        * Enumerate supported power management states
>>        */
>> -     for (i = ACPI_STATE_D0; i <= ACPI_STATE_D3; i++) {
>> +     for (i = ACPI_STATE_D0; i <= ACPI_STATE_D3_HOT; i++) {
>>               struct acpi_device_power_state *ps = &device->power.states[i];
>>               char object_name[5] = { '_', 'P', 'R', '0' + i, '\0' };
>>
>> @@ -884,21 +884,18 @@ static int acpi_bus_get_power_flags(struct acpi_device *device)
>>                               acpi_bus_add_power_resource(ps->resources.handles[j]);
>>               }
>>
>> -             /* The exist of _PR3 indicates D3Cold support */
>> -             if (i == ACPI_STATE_D3) {
>> -                     status = acpi_get_handle(device->handle, object_name, &handle);
>> -                     if (ACPI_SUCCESS(status))
>> -                             device->power.states[ACPI_STATE_D3_COLD].flags.valid = 1;
>> -             }
>> -
>>               /* Evaluate "_PSx" to see if we can do explicit sets */
>>               object_name[2] = 'S';
>>               status = acpi_get_handle(device->handle, object_name, &handle);
>>               if (ACPI_SUCCESS(status))
>>                       ps->flags.explicit_set = 1;
>>
>> -             /* State is valid if we have some power control */
>> -             if (ps->resources.count || ps->flags.explicit_set)
>> +             /*
>> +              * State is valid if there are means to put the device into it.
>> +              * D3hot is only valid if _PR3 present.
>> +              */
>> +             if (ps->resources.count ||
>> +                 (ps->flags.explicit_set && i < ACPI_STATE_D3_HOT))
>>                       ps->flags.valid = 1;
>>
>>               ps->power = -1; /* Unknown - driver assigned */
>> diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
>> index 0f150f2..1929c0c 100644
>> --- a/drivers/pci/pci-acpi.c
>> +++ b/drivers/pci/pci-acpi.c
>> @@ -200,7 +200,7 @@ static pci_power_t acpi_pci_choose_state(struct pci_dev *pdev)
>>               return PCI_D1;
>>       case ACPI_STATE_D2:
>>               return PCI_D2;
>> -     case ACPI_STATE_D3:
>> +     case ACPI_STATE_D3_HOT:
>>               return PCI_D3hot;
>>       case ACPI_STATE_D3_COLD:
>>               return PCI_D3cold;
>> @@ -223,7 +223,7 @@ static int acpi_pci_set_power_state(struct pci_dev *dev, pci_power_t state)
>>               [PCI_D0] = ACPI_STATE_D0,
>>               [PCI_D1] = ACPI_STATE_D1,
>>               [PCI_D2] = ACPI_STATE_D2,
>> -             [PCI_D3hot] = ACPI_STATE_D3,
>> +             [PCI_D3hot] = ACPI_STATE_D3_HOT,
>>               [PCI_D3cold] = ACPI_STATE_D3
>>       };
>>       int error = -EINVAL;
>> diff --git a/include/acpi/actypes.h b/include/acpi/actypes.h
>> index eba6604..e8bcc47 100644
>> --- a/include/acpi/actypes.h
>> +++ b/include/acpi/actypes.h
>> @@ -499,9 +499,10 @@ typedef u64 acpi_integer;
>>  #define ACPI_STATE_D0                   (u8) 0
>>  #define ACPI_STATE_D1                   (u8) 1
>>  #define ACPI_STATE_D2                   (u8) 2
>> -#define ACPI_STATE_D3                   (u8) 3
>> -#define ACPI_STATE_D3_COLD              (u8) 4
>> -#define ACPI_D_STATES_MAX               ACPI_STATE_D3_COLD
>> +#define ACPI_STATE_D3_HOT               (u8) 3
>> +#define ACPI_STATE_D3                   (u8) 4
>> +#define ACPI_STATE_D3_COLD              ACPI_STATE_D3
>> +#define ACPI_D_STATES_MAX               ACPI_STATE_D3
>>  #define ACPI_D_STATE_COUNT              5
>>
>>  #define ACPI_STATE_C0                   (u8) 0
>> --
>> 1.7.2.5
>>
>>
>>
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

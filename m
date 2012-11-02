Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab2KBPDf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 11:03:35 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55708 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806Ab2KBPDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 11:03:33 -0400
MIME-Version: 1.0
In-Reply-To: <1952961.jiv6kKxT5N@vostro.rjw.lan>
References: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
	<1350593430-24470-2-git-send-email-yinghai@kernel.org>
	<1952961.jiv6kKxT5N@vostro.rjw.lan>
Date: Fri, 2 Nov 2012 08:03:31 -0700
X-Google-Sender-Auth: hEschSZHXOa5LHQY3OICpNTfkD0
Message-ID: <CAE9FiQXdQhv1bxue3PQpCGWdeoLSGrtgcZ+1MAvh+L+zEUFuNw@mail.gmail.com>
Subject: Re: [PATCH 1/3] ACPI: Introduce a new acpi handle to determine HID match.
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org, Tang Chen <tangchen@cn.fujitsu.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 2, 2012 at 5:23 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Thursday, October 18, 2012 01:50:09 PM Yinghai Lu wrote:
>> From: Tang Chen <tangchen@cn.fujitsu.com>
>>
>> We need to find out if one handle is for root bridge, and install notify
>> handler for it to handle pci root bus hot add.
>> At that time, root bridge acpi device is not created yet.
>>
>> So acpi_match_device_ids() will not work.
>>
>> This patch add a function to check if new acpi handle's HID matches a list
>> of IDs.  The new api use acpi_device_info instead acpi_device.
>>
>> -v2: updated changelog, also check length for string info...
>>      change checking sequence by moving string comaring close to for loop.
>>                                       - Yinghai
>>
>> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> Cc: Len Brown <lenb@kernel.org>
>> Cc: linux-acpi@vger.kernel.org
>> ---
>>  drivers/acpi/scan.c     |   33 +++++++++++++++++++++++++++++++++
>>  include/acpi/acpi_bus.h |    2 ++
>>  2 files changed, 35 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
>> index 5dfec09..33ca993 100644
>> --- a/drivers/acpi/scan.c
>> +++ b/drivers/acpi/scan.c
>> @@ -312,6 +312,39 @@ int acpi_match_device_ids(struct acpi_device *device,
>>  }
>>  EXPORT_SYMBOL(acpi_match_device_ids);
>>
>> +int acpi_match_object_info_ids(struct acpi_device_info *info,
>> +                            const struct acpi_device_id *ids)
>> +{
>> +     const struct acpi_device_id *id;
>> +     char *str;
>> +     u32 len;
>> +     int i;
>> +
>> +     len = info->hardware_id.length;
>> +     if (len) {
>> +             str = info->hardware_id.string;
>> +             if (str)
>> +                     for (id = ids; id->id[0]; id++)
>> +                             if (!strcmp((char *)id->id, str))
>> +                                     return 0;
>> +     }
>> +
>> +     for (i = 0; i < info->compatible_id_list.count; i++) {
>> +             len = info->compatible_id_list.ids[i].length;
>> +             if (!len)
>> +                     continue;
>> +             str = info->compatible_id_list.ids[i].string;
>> +             if (!str)
>> +                     continue;
>> +             for (id = ids; id->id[0]; id++)
>> +                     if (!strcmp((char *)id->id, str))
>> +                             return 0;
>> +     }
>> +
>> +     return -ENOENT;
>> +}
>> +EXPORT_SYMBOL(acpi_match_object_info_ids);
>
> EXPORT_SYMBOL_GPL, please?

yes, will change that while sending next version..

>
>> +
>>  static void acpi_free_ids(struct acpi_device *device)
>>  {
>>       struct acpi_hardware_id *id, *tmp;
>> diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
>> index 608f92f..6ac415c 100644
>> --- a/include/acpi/acpi_bus.h
>> +++ b/include/acpi/acpi_bus.h
>> @@ -374,6 +374,8 @@ int acpi_bus_start(struct acpi_device *device);
>>  acpi_status acpi_bus_get_ejd(acpi_handle handle, acpi_handle * ejd);
>>  int acpi_match_device_ids(struct acpi_device *device,
>>                         const struct acpi_device_id *ids);
>> +int acpi_match_object_info_ids(struct acpi_device_info *info,
>> +                            const struct acpi_device_id *ids);
>>  int acpi_create_dir(struct acpi_device *);
>>  void acpi_remove_dir(struct acpi_device *);
>
> I wonder which code path(s) is(are) going to use the new routine?

that is for installing handler for pci root bus removal. will resend
them in batch 3.

http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-yinghai.git;a=shortlog;h=refs/heads/for-pci-split-pci-root-hp-2

http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-yinghai.git;a=commitdiff;h=b3752f4571a3db1bbbaf204a6cb85aadbd40b19d
   PCI, acpiphp: Separate out hot-add support of pci host bridge

http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-yinghai.git;a=commitdiff;h=bda84c28ae8e00315fcc7dffceb301e082369c3e
   PCI: correctly detect ACPI PCI host bridge objects

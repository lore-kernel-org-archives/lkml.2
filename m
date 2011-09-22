Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712Ab1IVQxv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 12:53:51 -0400
Received: from smtp-out.google.com ([216.239.44.51]:45883 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab1IVQxs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 12:53:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=ebVykgFkOrC+H5ME0DhKgijEDnyldVKsoAN37aKVgChPNRrnbLiJCyEJoWcyqNo6m
	jonPHOnIbtr8b029ggSSQ==
MIME-Version: 1.0
In-Reply-To: <CAErSpo5gV7AspUQp7_JOFuY0c0YnFWxj2TKUX-r6-0dVkj5FPA@mail.gmail.com>
References: <4E714FAA.8060708@huawei.com> <CAErSpo5gV7AspUQp7_JOFuY0c0YnFWxj2TKUX-r6-0dVkj5FPA@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 22 Sep 2011 10:53:20 -0600
Message-ID: <CAErSpo71cC5=K7DXYs+aEnU2J91TX7ys8bpnUSmdob1dgdaBSg@mail.gmail.com>
Subject: Re: [PATCH v4] acpi: Fix CPU hot removal problem
To: "canquan.shen" <shencanquan@huawei.com>
Cc: len.brown@intel.com, "shemminger@vyatta.com" <shemminger@vyatta.com>,
        "yakui.zhao@intel.com" <yakui.zhao@intel.com>,
        "xiaowei.yang@huawei.com" <xiaowei.yang@huawei.com>,
        hanweidong <hanweidong@huawei.com>, linqiangmin@huawei.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        khalid.aziz@hp.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 14, 2011 at 8:56 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Wed, Sep 14, 2011 at 7:06 PM, canquan.shen <shencanquan@huawei.com> wrote:
>> We run linux as a guest in Xen environment. When we used the xen tools
>> (xm vcpu-set <n>) to hot add and remove vcpu to and from the guest, we
>> encountered the failure on vcpu removal. We found the reason is that it
>> didn't go to really remove cpu in the cpu removal code path.
>>
>> This patch adds acpi_bus_trim in acpi_process_hotplug_notify to fix this
>> issue. With this patch, it works fine for us.
>>
>> Signed-off-by:Canquan Shen <shencanquan@huawei.com>
>
> Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>

On second thought, let's think about this a bit more.

As I mentioned before, I have a long-term goal to move the hotplug
flow out of drivers and into the ACPI core.  That will be easier if
the code in the drivers is as generic as possible.

The dock and acpiphp hot-remove code calls acpi_bus_trim(), then
evaluates _EJ0.  The core acpi_bus_hot_remove_device() function
already does both acpi_bus_trim() and _EJ0.  This function is
currently only used when we write to sysfs "eject" files, but I wonder
if we should use it in acpi_processor_hotplug_notify() as well.

That would get us one step closer to removing this gunk from the
drivers and having acpi_bus_notify() look something like this:

    case ACPI_NOTIFY_EJECT_REQUEST:
        driver->ops.remove(device);
        acpi_bus_hot_remove_device(device);
        break;

There is a description of a CPU hot-remove that does include _EJ0
methods in the "DIG64 Hot-Plug & Partitioning Flows Specification"
[1], sec 2.2.4.  I know this document is Itanium-oriented, but this
part seems fairly generic and it's the only description of the process
I've seen so far.

So would using acpi_bus_hot_remove_device() instead of acpi_bus_trim()
also solve your problem, Canquan?

Bjorn

[1] http://www.dig64.org/home/DIG64_HPPF_R1_0.pdf

>> ---
>>  drivers/acpi/processor_driver.c |    6 ++++++
>>  1 files changed, 6 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/acpi/processor_driver.c
>> b/drivers/acpi/processor_driver.c
>> index a4e0f1b..03d92d6 100644
>> --- a/drivers/acpi/processor_driver.c
>> +++ b/drivers/acpi/processor_driver.c
>> @@ -641,6 +641,7 @@ static void acpi_processor_hotplug_notify(acpi_handle
>> handle,
>>        struct acpi_processor *pr;
>>        struct acpi_device *device = NULL;
>>        int result;
>> +       u32 id;
>>
>>
>>        switch (event) {
>> @@ -677,6 +678,11 @@ static void acpi_processor_hotplug_notify(acpi_handle
>> handle,
>>                                    "Driver data is NULL, dropping EJECT\n");
>>                        return;
>>                }
>> +               id = pr->id;
>> +               if (acpi_bus_trim(device, 1)) {
>> +                       printk(KERN_ERR  PREFIX
>> +                                   "Fail to Remove CPU %d\n", id);
>> +               }
>>                break;
>>        default:
>>                ACPI_DEBUG_PRINT((ACPI_DB_INFO,
>> --
>> 1.7.6.0
>>
>>
>

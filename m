Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab1I3FVI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 01:21:08 -0400
Received: from smtp-out.google.com ([216.239.44.51]:58567 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300Ab1I3FVG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 01:21:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=EAF7bnxN3FYEPEvNRLWwPeadMv4aO85Y4bHKtP79yY/K5/aehbDs5HZScOuL8d9cP
	u/n6UjaM+KlDqPUJiE3Kw==
MIME-Version: 1.0
In-Reply-To: <4E83E8EF.30806@huawei.com>
References: <4E7D7468.4040506@huawei.com> <4E83E27E.5090608@linux.intel.com> <4E83E8EF.30806@huawei.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 29 Sep 2011 23:20:42 -0600
Message-ID: <CAErSpo63mEbhmDCYpYQZ7hmoEz3A03pbS513myt+GrwPG+pK5w@mail.gmail.com>
Subject: Re: [PATCH v5] acpi: Fix CPU hot removal problem
To: "canquan.shen" <shencanquan@huawei.com>
Cc: Chen Gong <gong.chen@linux.intel.com>, len.brown@intel.com,
        "shemminger@vyatta.com" <shemminger@vyatta.com>,
        "yakui.zhao@intel.com" <yakui.zhao@intel.com>,
        "xiaowei.yang@huawei.com" <xiaowei.yang@huawei.com>,
        hanweidong <hanweidong@huawei.com>, linqiangmin@huawei.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        khalid.aziz@hp.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 9:41 PM, canquan.shen <shencanquan@huawei.com> wrote:
>
> On 2011/9/29 11:14, Chen Gong wrote:
>>
>> 于 2011/9/24 14:10, canquan.shen 写道:
>>>
>>> We run linux as a guest in Xen environment. When we used the xen tools
>>> (xm vcpu-set <n>) to hot add and remove vcpu to and from the guest, we
>>> encountered the failure on vcpu removal. We found the reason is that it
>>> did't go to really remove cpu in the cpu removal code path.
>>>
>>> This patch adds acpi_bus_hot_remove_device in
>>> acpi_process_hotplug_notify to
>>> fix this issue. With this patch, it works fine for us.
>>>
>>> Signed-off-by: Canquan Shen <shencanquan@huawei.com>
>>> ---
>>> drivers/acpi/processor_driver.c | 13 +------------
>>> drivers/acpi/scan.c | 4 ++--
>>> include/acpi/acpi_bus.h | 1 +
>>> 3 files changed, 4 insertions(+), 14 deletions(-)
>>>
>>> diff --git a/drivers/acpi/processor_driver.c
>>> b/drivers/acpi/processor_driver.c
>>> index a4e0f1b..8429688 100644
>>> --- a/drivers/acpi/processor_driver.c
>>> +++ b/drivers/acpi/processor_driver.c
>>> @@ -665,18 +665,7 @@ static void
>>> acpi_processor_hotplug_notify(acpi_handle handle,
>>> case ACPI_NOTIFY_EJECT_REQUEST:
>>> ACPI_DEBUG_PRINT((ACPI_DB_INFO,
>>> "received ACPI_NOTIFY_EJECT_REQUEST\n"));
>>> -
>>> - if (acpi_bus_get_device(handle, &device)) {
>>> - printk(KERN_ERR PREFIX
>>> - "Device don't exist, dropping EJECT\n");
>>> - break;
>>> - }
>>> - pr = acpi_driver_data(device);
>>> - if (!pr) {
>>> - printk(KERN_ERR PREFIX
>>> - "Driver data is NULL, dropping EJECT\n");
>>> - return;
>>> - }
>>> + acpi_bus_hot_remove_device(handle);
>>
>> As the description in __acpi_os_execute(in acpi_os_hotplug_execute),
>> /*
>> * We can't run hotplug code in keventd_wq/kacpid_wq/kacpid_notify_wq
>> * because the hotplug code may call driver .remove() functions,
>> * which invoke flush_scheduled_work/acpi_os_wait_events_complete
>> * to flush these workqueues.
>> */
>> If so, why not using following call:
>>
>> acpi_os_hotplug_execute(acpi_bus_hot_remove_device, acpi_device->handle);
>>
>>
>
> It is ok if using the acpi_os_hotplug_execute. but it is complex and more time for removal cpu because it is add to queue and some time the work will be called.
> I think that it is clear to call directly acpi_bus_hot_remove_device function in acpi_processor_hotplug_notify.

Chen, you're right that the CPU hot-remove notifier is running in a
workqueue, we are proposing  that the notifier call
acpi_bus_hot_remove_device(), which calls the .remove() method, and
that can cause a deadlock if .remove() waits for the workqueue to be
flushed.

The usual way this deadlock happens is when the .remove() method uses
acpi_remove_notify_handler().  But the processor_driver .remove()
method doesn't do anything with notify handler registration; the
handler is registered/unregistered by the module init/exit functions.
So I don't think we need to use acpi_os_hotplug_execute() in this case
because I don't think there's a risk of deadlock.

However, if new CPU devices appear in the namespace after module-init,
I don't think processor_driver will handle them correctly.  This looks
like just another artifact of our screwed-up ACPI hotplug handling.

Bjorn

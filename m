Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab1IMPuJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 11:50:09 -0400
Received: from smtp-out.google.com ([74.125.121.67]:52337 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755128Ab1IMPuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 11:50:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:x-system-of-record;
	b=f/XUBQ42LbJwcC2wo+H/YMTCXOpQRrHL8ieS60qb9oItTrLNzmn2ubkC+gutt26oo
	uOeXPaRwjeZUKpMl5Jrzw==
MIME-Version: 1.0
In-Reply-To: <4E6EF0EB.2040701@huawei.com>
References: <4E682AC8.7040302@huawei.com> <4E6EF0EB.2040701@huawei.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 13 Sep 2011 09:49:42 -0600
Message-ID: <CAErSpo70vev68-MMfr0VM5eZsOJ0T6sTXWSvZk0r-=rwx-KOPQ@mail.gmail.com>
Subject: Re: [PATCH v2] acpi: Fix CPU hot removal problem
To: "canquan.shen" <shencanquan@huawei.com>
Cc: len.brown@intel.com, "shemminger@vyatta.com" <shemminger@vyatta.com>,
        "yakui.zhao@intel.com" <yakui.zhao@intel.com>,
        "xiaowei.yang@huawei.com" <xiaowei.yang@huawei.com>,
        hanweidong <hanweidong@huawei.com>, linqiangmin@huawei.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 12, 2011 at 11:58 PM, canquan.shen <shencanquan@huawei.com> wrote:
> On 2011/9/8 10:39, canquan.shen wrote:
>>
>> We run Linux as a guest in Xen environment. When used xen tools
>> (xm vcpu-set <n>) to hot add and remove vcpu to and from the guest,
>> we encountered the failure on vcpu removal. We found the reason is
>> that it didn't go to really remove cpu in the cpu removal code path.
>>
>> This patch adds acpi_bus_trim in acpi_process_hotplug_notify to fix
>> this issue. With this patch, it works fine for us.
>>
>> Signed-off-by: Canquan Shen <shencanquan@huawei.com>
>> ---
>> drivers/acpi/processor_driver.c | 5 +++++
>> 1 files changed, 5 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/acpi/processor_driver.c
>> b/drivers/acpi/processor_driver.c
>> index a1c564f..114592f 100644
>> --- a/drivers/acpi/processor_driver.c
>> +++ b/drivers/acpi/processor_driver.c
>> @@ -678,7 +678,11 @@ static void
>> acpi_processor_hotplug_notify(acpi_handle handle,
>> return;
>> }
>>
>> + if (acpi_bus_trim(device, 1)) {
>> + printk(KERN_ERR PREFIX
>> + "Removing device failed\n");
>> + return;
>> + }
>> break;
>> default:
>> ACPI_DEBUG_PRINT((ACPI_DB_INFO,

I think this patch is OK.  One nit is that kernel printks should never
be constant strings.  There's almost always more information that's
useful in debugging.  This error should at least tell us which driver
is involved, and preferably which specific device (though we have to
be careful in case the device struct is freed by acpi_bus_trim()).

Bjorn

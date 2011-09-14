Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650Ab1INOO3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 10:14:29 -0400
Received: from smtp-out.google.com ([216.239.44.51]:50317 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572Ab1INOO1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 10:14:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=hxwTfqvlXodGWubtuFdZuYgJVWBywF7plZGzQkLXoLeUQW300FY0Ty6DBFhRf9bqC
	IARYWdDYJQv3Dkl0IUgGg==
MIME-Version: 1.0
In-Reply-To: <4E700EDA.7090505@huawei.com>
References: <4E700EDA.7090505@huawei.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 14 Sep 2011 08:14:04 -0600
Message-ID: <CAErSpo4F1oH6uBcbYRf9M49=kk49H==r=Cuh2Mrx2Wq4rmUeVg@mail.gmail.com>
Subject: Re: [PATCH v3] acpi: Fix CPU hot removal problem
To: "canquan.shen" <shencanquan@huawei.com>
Cc: len.brown@intel.com, "shemminger@vyatta.com" <shemminger@vyatta.com>,
        "yakui.zhao@intel.com" <yakui.zhao@intel.com>,
        "xiaowei.yang@huawei.com" <xiaowei.yang@huawei.com>,
        hanweidong <hanweidong@huawei.com>, linqiangmin@huawei.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 13, 2011 at 8:18 PM, canquan.shen <shencanquan@huawei.com> wrote:
> We run linux as a guest in Xen environment. When we used the xen tools
> (xm vcpu-set <n>) to hot add and remove vcpu to and from the guest, we
> encountered the failure on vcpu removal. We found the reason is that it
> didn't go to really remove cpu in the cpu removal code path.
>
> This patch adds acpi_bus_trim in acpi_process_hotplug_notify to fix this
> issue. With this patch, it works fine for us.
>
> Signed-off-by: Shen canquan <shencanquan@huawei.com>
> ---
>  drivers/acpi/processor_driver.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/acpi/processor_driver.c
> b/drivers/acpi/processor_driver.c
> index a4e0f1b..0856ef8 100644
> --- a/drivers/acpi/processor_driver.c
> +++ b/drivers/acpi/processor_driver.c
> @@ -677,6 +677,13 @@ static void acpi_processor_hotplug_notify(acpi_handle
> handle,
>                                    "Driver data is NULL, dropping EJECT\n");
>                        return;
>                }
> +               ACPI_DEBUG_PRINT((ACPI_DB_INFO,
> +                       "Hot-removing processor device %s\n",
> +                       dev_name(&device->dev)));
> +               if (acpi_bus_trim(device, 1)) {
> +                       printk(KERN_ERR "ACPI: Removing device failed!\n");

We can do better than that.  Nobody ever looks at ACPI_DEBUG_PRINT info.

    u32 id;
    ...
    id = pr->id;
    if (acpi_bus_trim(device, 1))
        printk(KERN_ERR PREFIX "Failed to remove CPU %d\n", id);

(No "return" needed here.  In fact, the "return" at the bottom of
acpi_processor_hotplug_notify() is also superfluous.  You could remove
it at the same time.)

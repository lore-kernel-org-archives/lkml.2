Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab1IOC5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 22:57:25 -0400
Received: from smtp-out.google.com ([216.239.44.51]:23278 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247Ab1IOC5Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 22:57:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=nhjC7FXNfQH6pbitBRg6b0Z4Ntf6CvWXEC+6P9rpbAqTPe1us2d2g1NgycaB/mrNw
	y2aql7KGU2XaBI5QIXlaw==
MIME-Version: 1.0
In-Reply-To: <4E714FAA.8060708@huawei.com>
References: <4E714FAA.8060708@huawei.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 14 Sep 2011 20:56:58 -0600
Message-ID: <CAErSpo5gV7AspUQp7_JOFuY0c0YnFWxj2TKUX-r6-0dVkj5FPA@mail.gmail.com>
Subject: Re: [PATCH v4] acpi: Fix CPU hot removal problem
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

On Wed, Sep 14, 2011 at 7:06 PM, canquan.shen <shencanquan@huawei.com> wrote:
> We run linux as a guest in Xen environment. When we used the xen tools
> (xm vcpu-set <n>) to hot add and remove vcpu to and from the guest, we
> encountered the failure on vcpu removal. We found the reason is that it
> didn't go to really remove cpu in the cpu removal code path.
>
> This patch adds acpi_bus_trim in acpi_process_hotplug_notify to fix this
> issue. With this patch, it works fine for us.
>
> Signed-off-by:Canquan Shen <shencanquan@huawei.com>

Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>

> ---
>  drivers/acpi/processor_driver.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/acpi/processor_driver.c
> b/drivers/acpi/processor_driver.c
> index a4e0f1b..03d92d6 100644
> --- a/drivers/acpi/processor_driver.c
> +++ b/drivers/acpi/processor_driver.c
> @@ -641,6 +641,7 @@ static void acpi_processor_hotplug_notify(acpi_handle
> handle,
>        struct acpi_processor *pr;
>        struct acpi_device *device = NULL;
>        int result;
> +       u32 id;
>
>
>        switch (event) {
> @@ -677,6 +678,11 @@ static void acpi_processor_hotplug_notify(acpi_handle
> handle,
>                                    "Driver data is NULL, dropping EJECT\n");
>                        return;
>                }
> +               id = pr->id;
> +               if (acpi_bus_trim(device, 1)) {
> +                       printk(KERN_ERR  PREFIX
> +                                   "Fail to Remove CPU %d\n", id);
> +               }
>                break;
>        default:
>                ACPI_DEBUG_PRINT((ACPI_DB_INFO,
> --
> 1.7.6.0
>
>

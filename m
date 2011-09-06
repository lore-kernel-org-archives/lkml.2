Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681Ab1IFETk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 00:19:40 -0400
Received: from smtp-out.google.com ([74.125.121.67]:28586 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab1IFETc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 00:19:32 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=UzVvFZFWhQg1CkVPIfLJ12/BE++lnd9NjNvEt1/nNAPRyoxOvRdheazL2G5kws63F
	aoQUTq9QIM08Oc61IBoCg==
MIME-Version: 1.0
In-Reply-To: <F1F5DF04259F1B4A82BD6BDE1C479F74098285B0@szxeml527-mbx.china.huawei.com>
References: <F1F5DF04259F1B4A82BD6BDE1C479F74098285B0@szxeml527-mbx.china.huawei.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 5 Sep 2011 22:19:09 -0600
Message-ID: <CAErSpo4JsyHag24SH=zSRHt4c8kYwdcXEnCConGEi2u6dN-pnw@mail.gmail.com>
Subject: Re: Re : [PATCH] acpi: Fix hot cpu remove problem on acpi subsystem
To: Shen Canquan <shencanquan@huawei.com>
Cc: "lenb@kernel.org" <lenb@kernel.org>,
        "rui.zhao@intel.com" <rui.zhao@intel.com>,
        "shemminger@vyatta.com" <shemminger@vyatta.com>,
        "yakui.zhao@intel.com" <yakui.zhao@intel.com>,
        "xiaowei.yang@huawei.com" <xiaowei.yang@huawei.com>,
        hanweidong <hanweidong@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 主题: [PATCH] acpi: Fix hot cpu remove problem on acpi subsystem
>
> In Xen virtualization environment, When I used xen tools (xm vcpu-set vcpu_number ) to test the vcpu add and remove, I found it is failure on vcpu remove, I found the reason is that nothing to do when cpu remove in acpi_processor_hotplug_notify function, so I add the code of send the OFFLINE message to udev and add the rule of udev. it is ok on vcpu remove.
> Signed-off-by: Shen canquan <shencanquan@huawei.com>
> ---
>  drivers/acpi/processor_driver.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
> index a4e0f1b..a1c564f 100644
> --- a/drivers/acpi/processor_driver.c
> +++ b/drivers/acpi/processor_driver.c
> @@ -677,6 +677,8 @@ static void acpi_processor_hotplug_notify(acpi_handle handle,
>                                     "Driver data is NULL, dropping EJECT\n");
>                         return;
>                 }
> +
> +               kobject_uevent(&device->dev.kobj, KOBJ_OFFLINE);
>                 break;
>         default:
>                 ACPI_DEBUG_PRINT((ACPI_DB_INFO,

The processor driver used to generate ONLINE and OFFLINE messages.  I
removed them with c1815e0740.  According to the changelog, the driver
core still generates KOBJ_ADD and KOBJ_REMOVE events.

Could you fix the Xen vcpu add/remove problem by looking for
ADD/REMOVE events rather than ONLINE/OFFLINE?

I removed ONLINE/OFFLINE because I think hotplug should be handled in
the ACPI core, not in the drivers.  Removing ONLINE/OFFLINE got rid of
one small piece of driver-specific hotplug handling.  Obviously,
there's still a lot to do.

If using ADD/REMOVE is not sufficient, what is the justification for
needing both REMOVE and OFFLINE, and how would they be different?

Bjorn

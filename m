Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935973Ab2JYR2X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 13:28:23 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:21448 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755511Ab2JYR2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 13:28:22 -0400
Message-ID: <1351185648.19172.51.camel@misato.fc.hp.com>
Subject: Re: [PATCH v2 2/2] Improve container_notify_cb() to support
 container hot-remove.
From: Toshi Kani <toshi.kani@hp.com>
To: Jiang Liu <jiang.liu@huawei.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>, yinghai@kernel.org,
        bhelgaas@google.com, lenb@kernel.org, izumi.taku@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, mihailm@parallels.com,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 25 Oct 2012 11:20:48 -0600
In-Reply-To: <50889A14.9030607@huawei.com>
References: <1351058750-4275-1-git-send-email-tangchen@cn.fujitsu.com>
	  <1351058750-4275-3-git-send-email-tangchen@cn.fujitsu.com>
	 <1351098875.19172.21.camel@misato.fc.hp.com>
	 <5088967E.3060204@cn.fujitsu.com> <50889A14.9030607@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-25 at 09:47 +0800, Jiang Liu wrote:
> On 2012-10-25 9:31, Tang Chen wrote:
> > Hi Toshi,
> > 
> > On 10/25/2012 01:14 AM, Toshi Kani wrote:
> >> On Wed, 2012-10-24 at 14:05 +0800, Tang Chen wrote:
> >>> +static int container_device_remove(struct acpi_device *device)
> >>> +{
> >>> +    int ret;
> >>> +    struct acpi_eject_event *ej_event;
> >>> +
> >>> +    /* stop container device at first */
> >>> +    ret = acpi_bus_trim(device, 0);
> >>
> >> Hi Tang,
> >>
> >> Why do you need to call acpi_bus_trim(device,0) to stop the container
> >> device first?
> > 
> > This issue was introduced by Lu Yinghai, I think he could give a better
> > answer than me. :)
> > Please refer to the following url:
> > 
> > http://www.spinics.net/lists/linux-pci/msg17667.html
> > 
> > However, this is not applied into the pci tree yet.
> We have worked out a patch set to clean up the logic for PCI/ACPI binding
> relationship. It updates PCI/ACPI binding relationship by registering bus
> notification onto pci_bus_type instead of hooking into the ACPI/glue.c.

Thanks for the info and pointer.  Tang, I'd suggest you add such info to
the comment so that others know that this step is needed for removing
PCI bridges.  It helps us to know where to look at...

> To accommodate that patch set, the ACPI device destroy process has been
> split into two steps:
> 1) acpi_bus_trim(device,0) to unbind ACPI drivers

Does this step also detach PCI drivers from PCI cards as well?

Thanks,
-Toshi


> 2) acpi_bus_trim(device,1) to destroy ACPI devices
> 
> > 
> >>
> >>> +    printk(KERN_WARNING "acpi_bus_trim stop return %x\n", ret);
> >>
> >> Do you need this message in the normal case?  If so, I'd suggest to use
> >> pr_debug().
> >>
> >>> +    if (ret)
> >>> +        return ret;
> >>> +
> >>> +    /* event originated from ACPI eject notification */
> >>> +    device->flags.eject_pending = 1;
> >>
> >> You do not need to set the eject_pending flag when the handler calls
> >> acpi_bus_hot_remove_device().  It was set before because the handler did
> >> not initiate the hot-remove operation.
> > 
> > I just set it to keep the logic the same as before.
> > And thanks for telling me this. :)
> > 
> >>
> > ...
> >>> +        printk(KERN_WARNING "Container driver received %s event\n",
> >>> +            "ACPI_NOTIFY_EJECT_REQUEST");
> >>
> >> Same as other comment.  Suggest to use pr_debug().
> > 
> > OK. :)
> > 
> >>
> >>> +
> >>> +        if (!present || ACPI_FAILURE(status) || !device)
> >>> +            break;
> >>> +
> >>> +        result = container_device_remove(device);
> >>> +        if (result) {
> >>> +            printk(KERN_WARNING "Failed to remove container\n");
> >>
> >> Please use pr_warn().
> >>
> >> Thanks,
> >> -Toshi
> >>
> >>> +            break;
> >>>           }
> >>> -        break;
> >>> +
> >>> +        return;
> >>>
> >>>       default:
> >>>           /* non-hotplug event; possibly handled by other handler */
> >>
> >>
> >> -- 
> >> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> > 
> > 
> > .
> > 
> 
> 



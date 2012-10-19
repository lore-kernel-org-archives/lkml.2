Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260Ab2JSIuz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 04:50:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:14988 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755252Ab2JSIuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 04:50:51 -0400
X-IronPort-AV: E=Sophos;i="4.80,612,1344182400"; 
   d="scan'208";a="6030277"
Message-ID: <50811428.7040001@cn.fujitsu.com>
Date: Fri, 19 Oct 2012 16:49:44 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: jiang.liu@huawei.com, bhelgaas@google.com, lenb@kernel.org,
        izumi.taku@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Update acpi_root_bridge_list in container hotplug
 path.
References: <1350444308-27102-1-git-send-email-tangchen@cn.fujitsu.com> <CAE9FiQVFc9VVfWZpEfjPeGvo5pby3BQNzDei3VTXdoR048_SPg@mail.gmail.com> <507E60C2.6010104@cn.fujitsu.com> <CAE9FiQX60dOE7odBx4OC0kawesZW3w9yLHEhmLoOvASaZ7q8dw@mail.gmail.com>
In-Reply-To: <CAE9FiQX60dOE7odBx4OC0kawesZW3w9yLHEhmLoOvASaZ7q8dw@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/19 16:50:25,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/19 16:50:26,
	Serialize complete at 2012/10/19 16:50:26
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2012 12:28 AM, Yinghai Lu wrote:
> On Wed, Oct 17, 2012 at 12:39 AM, Tang Chen<tangchen@cn.fujitsu.com>  wrote:
>> On 10/17/2012 01:18 PM, Yinghai Lu wrote:
>>
>> And also, I have another 2 questions, maybe you can help me.
>> 1) Do we need to put PNP0A08 into acpi_pci_roots ?
>
> looks like we need to unify those two ids.
>
>> 2) In container_notify_cb(), when it got a ACPI_NOTIFY_EJECT_REQUEST
>>     event, it doesn't do the hot-remove things.
>>     I use your sci emulator patch to test it. I did the following thing:
>>          echo echo "\_SB_.LSB1">  /sys/kernel/debug/acpi/sci_notify
>>     where \_SB_.LSB1 is a container, it just did nothing.
>>     Do we need to support this operation ?
>
> yes, looks like need to add container_device_remove and call it under
>   container_notify_cb/ACPI_NOTIFY_EJECT_REQUEST
>
> and should look like handle_root_bridge_removal to call acpi_bus_trim two times.

Hi Yinghai,

You said the following in another patch:
"[PATCH 27/40] ACPI: acpi_bus_trim to support two steps."

 > For root bus hotremove support, we need to have pci device removed
 > before acpi devices.
 >
 > So try to keep all acpi devices, and only stop drivers with them.

Is it just container and pci_root_bridge hot-remove need to call
acpi_bus_trim() twice ? For normal device without sub-device, I think
it is OK to call acpi_bus_trim(device, 1).

The reason why I'm asking this question is:

I saw in acpi_bus_hot_remove_device(), it almost does the same things
you did in handle_root_bridge_removal(), except calling acpi_bus_trim()
twice. And there are more than one path could do container hot-remove.

If I add a container_device_remove() doing the similar things, it could
be duplicated. So, shall we just remove handle_root_bridge_removal(),
and only use acpi_bus_hot_remove_device() ?

Of course, we need to call acpi_bus_trim() twice in
acpi_bus_hot_remove_device().

Thanks. :)

>
> Thanks
>
> Yinghai
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


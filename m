Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751288Ab2KPCqI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 21:46:08 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27412 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab2KPCqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 21:46:06 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6897"; a="7252370"
Message-ID: <50A5A8EC.8090500@codeaurora.org>
Date: Thu, 15 Nov 2012 18:46:04 -0800
From: Stepan Moskovchenko <stepanm@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Rob Herring <robherring2@gmail.com>, devicetree-discuss@lists.ozlabs.org,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] dt/platform: Use cell-index for device naming if available
References: <1352508532-19241-1-git-send-email-stepanm@codeaurora.org>    <509F0E56.6080806@gmail.com>    <CACxGe6s3gJ4fmhn9VBd1Fq8bH5S0_ejmE=KqVjYn20bT42wQ_Q@mail.gmail.com> <554191d69bc21a4b133fb876df84ff89.squirrel@www.codeaurora.org> <50A1B50B.4020509@codeaurora.org> <20121115161020.3205E3E194B@localhost>
In-Reply-To: <20121115161020.3205E3E194B@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2012 8:10 AM, Grant Likely wrote:
> On Mon, 12 Nov 2012 18:48:43 -0800, Stepan Moskovchenko <stepanm@codeaurora.org> wrote:
>> On 11/11/2012 5:45 PM, Stepan Moskovchenko wrote:
>>>
>>>> On Sun, Nov 11, 2012 at 2:32 AM, Rob Herring <robherring2@gmail.com>
>>>> wrote:
>>>>> On 11/09/2012 06:48 PM, Stepan Moskovchenko wrote:
>>>>>> Use the cell-index property to construct names for platform
>>>>>> devices, falling back on the existing scheme of using the
>>>>>> device register address if cell-index is not specified.
>>>>>>
>>>>>> The cell-index property is a more useful device identifier,
>>>>>> especially in systems containing several numbered instances
>>>>>> of a particular hardware block, since it more easily
>>>>>> illustrates how devices relate to each other.
>>>>>>
>>>>>> Additionally, userspace software may rely on the classic
>>>>>> <name>.<id> naming scheme to access device attributes in
>>>>>> sysfs, without having to know the physical addresses of
>>>>>> that device on every platform the userspace software may
>>>>>> support. Using cell-index for device naming allows the
>>>>>> device addresses to be hidden from userspace and to be
>>>>>> exposed by logical device number without having to rely on
>>>>>> auxdata to perform name overrides. This allows userspace to
>>>>>> make assumptions about which sysfs nodes map to which
>>>>>> logical instance of a specific hardware block.
>>>>>>
>>>>>> Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
>>>>>> ---
>>>>>> I had also considered using something like the linux,label property to
>>>>>> allow
>>>>>> custom names for platform devices without resorting to auxdata, but the
>>>>>> cell-index approach seems more in line with what cell-index was
>>>>>> intended for
>>>>>> and with what the pre-DT platform device naming scheme used to be.
>>>>>> Please let
>>>>>> me know if you think there is a better way to accomplish this.
>>>>>>
>>>>>> This is just being sent out as an RFC for now. If there are no
>>>>>> objections, I
>>>>>> will send this out as an official patch, along with (or combined with)
>>>>>> a patch
>>>>>> to fix up the device names in things like clock tables of any affected
>>>>>> platforms.
>>>>>
>>>>> cell-index is basically deprecated. This has been discussed multiple
>>>>> times in the past. You can use auxdata if you really need to have the
>>>>> old name.
>>>>
>>>> Actually, I think it would be fine to use an /aliases entry to set the
>>>> device name. That's the place to put global namespace information.
>>>>
>>>> g.
>>>>
>>>
>>> Ah, thank you. I would prefer to stay away from auxdata, since it involves
>>> placing more platform-specific data into the kernel, and it is my
>>> understanding that auxdata is intended as a temporary measure. The
>>> /aliases approach looks interesting, and I'll see what I can do with it -
>>> hopefully I can have an RFC / patch soon. It looks like we would want an
>>> "inverse" alias lookup- that is, we would need to know which alias
>>> corresponds to a given node. Is it possible for a node to have multiple
>>> aliases?
>
> yes
>
>>> If so, which shall we use to create the device name? Anyway, I
>>> will further look into how these aliases work.
>
> Well, why exactly do you want to control the names of devices? Is it so
> that devices match up with what they are, or is it to make things match
> up with things like clocks and regulators. If it is the latter, then no,
> don't do this. Use auxdata. When the kernel requires a specific name for
> a device it is very much a kernel *internal* detail. It does not make
> sense to encode that into the device tree when it isn't something part
> of the binding.
>
>
>>>
>>> Steve
>>
>> Hi Grant,
>>
>> Looking through the alias code, I see that the stem and the alias ID are
>> stored and parsed separately. For the current way of using aliases, this
>> makes sense. However, can you please clarify what you meant by using an
>> /aliases entry to set the device name?
>>
>> The first and most straightforward approach would be to use the entire
>> alias name as the device name, making no distinction between the alias
>> stem and ID. However, since it is possible to have multiple aliases to
>> the same device, which of the aliases shall we use to construct the
>> device name? Additionally, this may cause possible problems for legacy
>> software that expects names in the format of <name>.<ID>, since '.' is
>> not a valid character for alias names as defined by the DT spec,
>> although strictly speaking this approach would successfully solve the
>> problem of giving devices predictable and controllable names.
>>
>> Another way an /aliases entry could be used to set the device name is to
>> have a <name>.<ID> naming scheme, where the name comes from node->name
>> (as is done in of_device_make_bus_id) and the ID gets queried using
>> of_alias_get_id(). We would need to create a new alias stem for this
>> purpose, and suppose that something like "platform" would work. The
>> name-setting code would then roughly look as follows:
>>
>> +	alias_id = of_alias_get_id(node, "platform");
>> +	if (alias_id != -ENODEV) {
>> +		dev_set_name(dev, "%s.%d", node->name, alias_id);
>> +		return;
>> +	}
>>
>> The downside to this approach is that it imposes the restriction that
>> device ID numbers now have to be unique throughout the system, whereas
>> before only the <name>.<ID> combinations had to be unique. This is the
>> result of only the ID number being present in the alias table, with each
>> such ID number having the "platform" stem, and the restriction that node
>> properties shall have unique names.
>
> Again, this all looks like trying to manipulate names to keep the kernel
> happy. Since the kernel has the restrictions on naming, that is where
> the fixups should be made. Either by devres or by changing the expected
> name in the clk/regulator tables.
>
>> A third possible solution is to use an alias stem prefix for defining
>> the device name. That is, the alias to set the device name would have
>> some prefix (such as "platform-" for example) and the aliases would look
>> something like platform-<name><ID>. The code to assign device names
>> would find the matching alias containing the "platform-" prefix, strip
>> the prefix, and use the resulting name and ID to construct the device
>> name. This approach would make it more obvious as to which of several
>> aliases is used to set the device name, but it imposes additional
>> structure on the stem names and causes any aliases starting with
>> "platform-" to become magical, which bothers me slightly.
>
> And specific to the current Linux implementation details.
>
>> Do any of these describe what you intended when you suggested using the
>> /aliases node to set device names, or is there another approach that I
>> have missed? Can you please elaborate further?
>
> Really, all I was thinking about was allowing the device that has an
> alias "eth0" to be given a name with 'eth0' in it somewhere. Since names
> like that are a global namespace, /aliases is the place to get them
> because there is no chance of colision with that approach.
>
> g.
>

Hi Grant,
I realize that auxdata is the correct thing to use for keeping the 
kernel happy (for things like clocks and regulator consumers) but this 
is not the problem I am trying to solve. My goal is to try to keep 
userspace happy by trying to create common and predictable names for 
functionally equivalent devices across different hardware platforms.
For instance, two similar SoCs may have an SDCC controller which may be 
logically referred to as "the first SDCC device", though the physical 
address of this device may be different on the two SoCs. And, due to the 
<reg>.<name> naming convention, the sysfs entries associated with a 
particular device will be a dependent on the physical address of the device.

If userspace wants to touch the sysfs entries of what can logically be 
described as "the first SDCC device", then userspace needs to know the 
physical address of this device on each SoC variant it may be running 
on, since the path to the sysfs entries for this device will be based on 
the physical address of the device. By using a device naming scheme that 
replaces the physical address with a logical device number, the 
userspace-facing interface for each device (such as sysfs entries) could 
be kept common across SoC variants even when device physical addresses 
can move around but devices still have the same logical assignments.

I realize that this problem can be solved by using auxdata to set the 
device name, but in this case the only purpose of the auxdata would be 
to keep userspace happy, since all the other in-kernel relationships 
(for things like clocks and regulators) can already work without having 
to rely on auxdata. So, introducing auxdata just for consistency of 
userspace-facing names seems silly and, I am trying to come up with a 
more appropriate solution.

What do you think?

Steve




-- 
  The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
  hosted by The Linux Foundation

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758398Ab0FBPx3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 11:53:29 -0400
Received: from relay1.sgi.com ([192.48.179.29]:51144 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757940Ab0FBPx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 11:53:28 -0400
Message-ID: <4C067E73.2010005@sgi.com>
Date: Wed, 02 Jun 2010 10:53:23 -0500
From: Mike Habeck <habeck@sgi.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Mike Travis <travis@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       x86@kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jacob Pan <jacob.jun.pan@intel.com>, Tejun Heo <tj@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: [Patch 1/1] x86 pci: Add option to not assign BAR's if not already
 assigned
References: <4BEAF008.9030805@sgi.com> <4C0021DC.60608@zytor.com> <4C039980.3020608@sgi.com> <201006011649.56074.bjorn.helgaas@hp.com>
In-Reply-To: <201006011649.56074.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
> [Re-added linux-pci, which got lost again somewhere.]
> 
> On Monday, May 31, 2010 05:12:00 am Mike Travis wrote:
>> H. Peter Anvin wrote:
>>> On 05/28/2010 10:10 AM, Mike Travis wrote:
>>>> H. Peter Anvin wrote:
>>>>> On 05/28/2010 09:53 AM, Mike Travis wrote:
>>>>>> Any further consideration for this patch, or has it been rejected?
> 
> I'm disappointed that you didn't rework this to make it generic,
> not x86-specific.  That would be pretty easy and would remove
> the need for somebody else to come and clean it up later.
> 
>>>>> Well, it's really up to Jesse, but as far as I can see, this patch is a
>>>>> net loss of functionality and doesn't actually add anything.  Without
>>>>> this patch, some resources that were not assigned by BIOS will be
>>>>> unreachable.  With this patch, *all* resources that were not assigned by
>>>>> BIOS will be unreachable...
>>>>>
>>>>> 	-hpa
>>>>>
>>>> Apparently you're missing the point of the patch?  The patch is needed
>>>> because BIOS is purposely not assigning I/O BAR's to devices that won't
>>>> use them, freeing up the resource for devices that do need them.  Where
>>>> is the "all" resources that are not reachable?
>>> No, the patch isn't needed for those.
>>>
>>> Without your patch:
>>>
>>> - Devices assigned by BIOS remain assigned;
>>> - Devices not assigned by BIOS get assigned until address space
>>>   exhausted.
>>>
>>> With your patch:
>>>
>>> - Devices assigned by BIOS remain assigned;
>>> - Devices not assigned by BIOS never get assigned at all.
>>>
>>> What am I missing here?
>> BIOS still assigns the MMIO BAR's so the devices are alive.
> 
> I'm sorry; I don't follow this.  BIOS assigns MMIO BARs regardless
> of whether we have your patch.
> 
> I'm still having trouble reconciling the stated purpose, i.e., the
> changelog, with the behavior.  The changelog implies that the patch
> is required to make >16 devices with I/O BARs work at all, but per
> Mike Habeck, the patch just gets rid of some warnings and maybe helps
> with hot-add of devices using I/O space.

greaterthan 16 devices will still work if the BIOS doesn't assign
the I/O BARs and the kernel does (including the devices that don't
get assigned due to the kernel running out of I/O Port resources).
And when the kernel runs out of I/O Port space it will warn for
those devices it couldn't assign: (example):

   pci 0002:03:00.0: BAR 5: can't allocate I/O resource [0x0-0x7f]

But if the kernel assigns all the I/O Port space to these devices
we know don't need it (thus the reason the BIOS didn't assign it)
then I believe hot-add of devices using I/O space will fail.
What the patch is attempting to do is allow the BIOS a way to
not assign resources it knows are not needed and thus make sure
the kernel doesn't override that.

There is also the issue that quirk_system_pci_resources() thinks
those unassigned I/O resources are using I/O port space 0x0-0xFF.
Since the BIOS never assigned the BAR the kernel reads it as
having a base of 0x0 and a limit of whatever the BAR size is when
it writes all 1's to obtain the size.  So that results in
quirk_system_pci_resources() disabling pnp devices: (example):

   pnp 00:11: io resource (0x92-0x92) overlaps 0002:03:00.0 BAR 0 (0x0-0xff), disabling
   pnp 00:11: io resource (0x10-0x1f) overlaps 0002:03:00.0 BAR 0 (0x0-0xff), disabling
   pnp 00:11: io resource (0x72-0x73) overlaps 0002:03:00.0 BAR 0 (0x0-0xff), disabling
   pnp 00:11: io resource (0x80-0x80) overlaps 0002:03:00.0 BAR 0 (0x0-0xff), disabling
   pnp 00:11: io resource (0x84-0x86) overlaps 0002:03:00.0 BAR 0 (0x0-0xff), disabling
   pnp 00:11: io resource (0x88-0x88) overlaps 0002:03:00.0 BAR 0 (0x0-0xff), disabling
   pnp 00:11: io resource (0x8c-0x8e) overlaps 0002:03:00.0 BAR 0 (0x0-0xff), disabling
   pnp 00:11: io resource (0x90-0x9f) overlaps 0002:03:00.0 BAR 0 (0x0-0xff), disabling

One could argue this is a quirk_system_pci_resources() issue and
should be handled there rather than "zeroing out the resource if
the bios didn't assign it" as the patch does, but what the patch
is attempting to do (as stated above) is to allow the BIOS a way
to not assign resources it knows are not needed and thus make sure
the kernel doesn't override that... and in doing that the quirk
issue goes away too.

-mike



> 
> Is there a deeper problem that happens if we exhaust I/O space?
> Are we releasing device resources in pci_assign_unassigned_bridge_resources()
> and then we fail to reassign even MMIO resources after we exhaust
> I/O space?
> 
> Maybe a complete dmesg log showing the failure would be helpful.  if
> so, you could open a kernel.org bugzilla and reference it in your
> changelog so we can take this issue into account in future PCI work.
> 
> Bjorn


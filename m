Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714Ab0DEWDP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 18:03:15 -0400
Received: from claw.goop.org ([74.207.240.146]:53779 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756450Ab0DEWDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 18:03:10 -0400
Message-ID: <4BBA5E1C.10706@goop.org>
Date: Mon, 05 Apr 2010 15:03:08 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Dmitry Torokhov <dtor@vmware.com>, linux-kernel@vger.kernel.org,
       pv-drivers@vmware.com, Avi Kivity <avi@redhat.com>,
       Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: Re: [PATCH] VMware Balloon driver
References: <20100404215202.GA13020@dtor-ws.eng.vmware.com> <20100405142419.2c9bea3d.akpm@linux-foundation.org>
In-Reply-To: <20100405142419.2c9bea3d.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2010 02:24 PM, Andrew Morton wrote:
> I think I've forgotten what balloon drivers do.  Are they as nasty a
> hack as I remember believing them to be?
>    

(I haven't looked at Dmitry's patch yet, so this is from the Xen 
perspective.)

In the simplest form, they just look like a driver which allocates a 
pile of pages, and the underlying memory gets returned to the 
hypervisor.  When you want the memory back, it reattaches memory to the 
pageframes and releases the memory back to the kernel.  This allows a 
virtual machine to shrink with respect to its original size.

Going the other way - expanding beyond the memory allocation - is a bit 
trickier because you need to get some new page structures from 
somewhere.   We don't do this in Xen yet, but I've done some experiments 
with hotplug memory to implement this.  Or a simpler approach is to fake 
up some reserved E820 ranges to grow into.


> A summary of what this code sets out to do, and how it does it would be
> useful.
>
> Also please explain the applicability of this driver.  Will xen use it?
> kvm?  Out-of-tree code?
>    
The basic idea of the driver is to allow a guest system to give up 
memory it isn't using so it can be reused by other virtual machines (or 
the host itself).

Xen and KVM already have equivalents in the kernel.  Now that I've had a 
quick look at Dmitry's patch, it's certainly along the same lines as the 
Xen code, but it isn't clear to me how much code they could end up 
sharing.  There's a couple of similar-looking loops, but the bulk of the 
code appears to be VMware specific.

One area that would be very useful as common code would be some kind of 
policy engine to drive the balloon driver.  That is, something that can 
look at the VM's state and say "we really have a couple hundred MB of 
excess memory we could happily give back to the host".  And - very 
important - "don't go below X MB, because then we'll die in a flaming 
swap storm".

At the moment this is driven by vendor-specific tools with heuristics of 
varying degrees of sophistication (which could be as simple as 
absolutely manual control).  The problem has two sides because there's 
the decision made by guests on how much memory they can afford to give 
up, and also on the host side who knows what the system-wide memory 
pressures are.  And it can be affected by hypervisor-specific features, 
such as whether pages can be transparently shared between domains, 
demand-faulted from swap, etc.

And Dan Magenheimer is playing with a more fine-grained mechanism where 
a guest kernel can draw on spare host memory without actually committing 
that memory to the guest, which allows memory to be reallocated on the 
fly with more fluidity.

> The code implements a user-visible API (in /proc, at least).  Please
> fully describe the proposed interface(s) in the changelog so we can
> review and understand that proposal.
>    

It seems to me that sysfs would be a better match.  It would be nice to 
try and avoid gratuitous differences.

>> ...
>>
>> +static bool vmballoon_send_start(struct vmballoon *b)
>> +{
>> +	unsigned long status, dummy;
>> +
>> +	STATS_INC(b->stats.start);
>> +
>> +	status = VMWARE_BALLOON_CMD(START, VMW_BALLOON_PROTOCOL_VERSION, dummy);
>> +	if (status == VMW_BALLOON_SUCCESS)
>> +		return true;
>> +
>> +	pr_debug("%s - failed, hv returns %ld\n", __func__, status);
>>      
> The code refers to something called "hv".  I suspect that's stale?
>    

hv = hypervisor

     J

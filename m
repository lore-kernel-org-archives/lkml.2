Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab2ASNaI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 08:30:08 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:45399 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab2ASNaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 08:30:04 -0500
Message-ID: <4F181ACF.20505@linux.vnet.ibm.com>
Date: Thu, 19 Jan 2012 18:59:51 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Kay Sievers <kay.sievers@vrfy.org>, Alan Stern <stern@rowland.harvard.edu>,
        "Luck, Tony" <tony.luck@intel.com>, Greg KH <gregkh@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Sergei Trofimovich <slyich@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        Borislav Petkov <bp@amd64.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "prasad@linux.vnet.ibm.com" <prasad@linux.vnet.ibm.com>,
        Ming Lei <tom.leiming@gmail.com>, Djalal Harouni <tixxdz@opendz.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Andi Kleen <ak@linux.intel.com>,
        "gouders@et.bocholt.fh-gelsenkirchen.de" 
	<gouders@et.bocholt.fh-gelsenkirchen.de>,
        Marcos Souza <marcos.mage@gmail.com>,
        "justinmattock@gmail.com" <justinmattock@gmail.com>,
        Jeff Chua <jeff.chua.linux@gmail.com>
Subject: Re: [PATCH] mce: fix warning messages about static struct mce_device
References: <3908561D78D1C84285E8C5FCA982C28F01CF24@ORSMSX104.amr.corp.intel.com> <Pine.LNX.4.44L0.1201181257540.1343-100000@iolanthe.rowland.org> <CAPXgP10Du4nJ_hdfwqV0Fr6XEVkTMO6jZ_TS_T-J-grDG7nKJw@mail.gmail.com> <20120119123223.GD3936@elte.hu>
In-Reply-To: <20120119123223.GD3936@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12011913-9574-0000-0000-00000104F60B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2012 06:02 PM, Ingo Molnar wrote:

> 
> * Kay Sievers <kay.sievers@vrfy.org> wrote:
> 
>>> There's nothing special about the driver model code in this 
>>> respect. The same restriction applies wherever object 
>>> lifetimes are controlled by reference counting.
>>
>> Right. But it might not be obvious what 's the background 
>> here:
>>
>> An allocated device object(memory) usually represents an 
>> actual device(hardware). The object can have N users. Every of 
>> the users is required to take a reference to the object, which 
>> pins the object's memory as long as any of the N users might 
>> need to access it.
>>
>> In a hotplug world, we deal with device-removal.  On 
>> disconnect, we usually just orphan the object, we remove it 
>> from visibility, disconnect the device <-> object relation.
>>
>> All of the N users with a reference can still access the 
>> memory, they just do not talk to a real device anymore. The 
>> invalidated/orphaned state is communicated otherwise by locks 
>> and flags in the device object. Only after all of the N users 
>> left the object alone, the memory of the orphan if free'd.
> 
> But this is not what happened here - it's a special piece of 
> fundamental hardware that doesnt hot-plug separately from the 
> CPU and that has just a single "user".
> 
> So i'm curious, why wasn't the memset() enough? It should have 
> resolved the bug AFAICS.
> 


 It did! The memset _did_ fix the bug.

See  commit a3301b7 (x86/mce: Fix CPU hotplug and suspend regression
related to MCE).

Just to clarify: the bug was that a CPU offline + CPU online would
lead to usage of stale pointers in some device structure related
to MCE and hence, suspend-resume would not work on the second attempt
to suspend. And (as expected), the other symptom of this bug was: a
CPU offline + CPU online would cause the machine to oops because it
tried to dereference some invalid pointer.

And the memset() fixed this bug. Completely.

But what still remained after the memset, was only a harmless warning
about machinecheck not having a release() function. This was only a
reflection of the semantics that the driver-core imposed, but not
really a bug as such. (And as I mentioned in one of my earlier posts,
this warning existed in much older kernels too, but was hidden because
pr_debug() was used to print it. Now that the callpaths changed after
the change over from sysdev to struct device, we now started hitting
a WARN(), instead of a mild pr_debug(). But the message conveyed
by either of these was exactly the same.)

So, the discussion in this thread was about how best to get rid of
that warning, by playing by the rules of the driver-core instead of
circumventing it by having a dummy release function just to silence
the warning.

Regards,
Srivatsa S. Bhat


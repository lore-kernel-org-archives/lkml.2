Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138Ab2ARTcW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 14:32:22 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:51956 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431Ab2ARTcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 14:32:20 -0500
Message-ID: <4F171E22.7000104@linux.vnet.ibm.com>
Date: Thu, 19 Jan 2012 01:01:46 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Alan Stern <stern@rowland.harvard.edu>, "Luck, Tony" <tony.luck@intel.com>,
        Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
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
References: <3908561D78D1C84285E8C5FCA982C28F01CF24@ORSMSX104.amr.corp.intel.com> <Pine.LNX.4.44L0.1201181257540.1343-100000@iolanthe.rowland.org> <CAPXgP10Du4nJ_hdfwqV0Fr6XEVkTMO6jZ_TS_T-J-grDG7nKJw@mail.gmail.com>
In-Reply-To: <CAPXgP10Du4nJ_hdfwqV0Fr6XEVkTMO6jZ_TS_T-J-grDG7nKJw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12011819-3864-0000-0000-00000105567A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2012 12:20 AM, Kay Sievers wrote:

> On Wed, Jan 18, 2012 at 19:10, Alan Stern <stern@rowland.harvard.edu> wrote:
> 
>> There's nothing special about the driver model code in this respect.
>> The same restriction applies wherever object lifetimes are controlled
>> by reference counting.
> 
> Right. But it might not be obvious what 's the background here:
> 
> An allocated device object(memory) usually represents an actual
> device(hardware). The object can have N users. Every of the users is
> required to take a reference to the object, which pins the object's
> memory as long as any of the N users might need to access it.
> 
> In a hotplug world, we deal with device-removal.  On disconnect, we
> usually just orphan the object, we remove it from visibility,
> disconnect the device <-> object relation.
> 
> All of the  N users with a reference can still access the memory, they
> just do not talk to a real device anymore. The invalidated/orphaned
> state is communicated otherwise by locks and flags in the device
> object. Only after all of the N users left the object alone, the
> memory of the orphan if free'd.
> 
> If in the time-window between disconnecting the object from the device
> and freeing the orphaned object's memory, the same device comes back,
> we allocate a new object which is associated with the device. It
> usually has the same name and same properties as the original one.
> 
> This way, the new object is full functional, does not conflict with
> the older one, and also all the users of the old memory are still fine
> and can cleanup a lazy as they need without much synchronization.
> 
> Now, all that might not apply to machinecheck, and it might be that
> machinecheck is fully able to handle all that just fine with the
> statically allocated same memory -- allocating new device memory on
> hotplug is still the model that should always be preferred over any
> other, if possible.
> 
> It's usually the simplest safest and most flexible for anything that
> can come and go at any time, and memory which might be in used by
> other running code.
> 


Thanks for the crystal clear explanations from both you and Alan. Now
I am convinced.. :-) And thanks to Tony for bringing this up!

Regards,
Srivatsa S. Bhat


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090Ab2ARSun (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 13:50:43 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58042 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755359Ab2ARSul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 13:50:41 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1201181257540.1343-100000@iolanthe.rowland.org>
References: <3908561D78D1C84285E8C5FCA982C28F01CF24@ORSMSX104.amr.corp.intel.com>
 <Pine.LNX.4.44L0.1201181257540.1343-100000@iolanthe.rowland.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 18 Jan 2012 19:50:20 +0100
Message-ID: <CAPXgP10Du4nJ_hdfwqV0Fr6XEVkTMO6jZ_TS_T-J-grDG7nKJw@mail.gmail.com>
Subject: Re: [PATCH] mce: fix warning messages about static struct mce_device
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Luck, Tony" <tony.luck@intel.com>, Greg KH <gregkh@suse.de>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 19:10, Alan Stern <stern@rowland.harvard.edu> wrote:

> There's nothing special about the driver model code in this respect.
> The same restriction applies wherever object lifetimes are controlled
> by reference counting.

Right. But it might not be obvious what 's the background here:

An allocated device object(memory) usually represents an actual
device(hardware). The object can have N users. Every of the users is
required to take a reference to the object, which pins the object's
memory as long as any of the N users might need to access it.

In a hotplug world, we deal with device-removal.  On disconnect, we
usually just orphan the object, we remove it from visibility,
disconnect the device <-> object relation.

All of the  N users with a reference can still access the memory, they
just do not talk to a real device anymore. The invalidated/orphaned
state is communicated otherwise by locks and flags in the device
object. Only after all of the N users left the object alone, the
memory of the orphan if free'd.

If in the time-window between disconnecting the object from the device
and freeing the orphaned object's memory, the same device comes back,
we allocate a new object which is associated with the device. It
usually has the same name and same properties as the original one.

This way, the new object is full functional, does not conflict with
the older one, and also all the users of the old memory are still fine
and can cleanup a lazy as they need without much synchronization.

Now, all that might not apply to machinecheck, and it might be that
machinecheck is fully able to handle all that just fine with the
statically allocated same memory -- allocating new device memory on
hotplug is still the model that should always be preferred over any
other, if possible.

It's usually the simplest safest and most flexible for anything that
can come and go at any time, and memory which might be in used by
other running code.

And hey, filesystems work successful with this model since ages.
Nobody invented anything new here. Device hotplug/unplug/cleanup is
not much different from create/unlink/release. Open/truncate is
usually much harder to manage in concurrency situations. :)

Kay

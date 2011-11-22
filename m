Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891Ab1KVTqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 14:46:34 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45316 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756109Ab1KVTqb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 14:46:31 -0500
References: <20111118220849.GA25205@suse.de> <9E9C8A95-723C-427A-AD01-17284EDF7E4F@gmail.com> <20111121173620.GA5028@suse.de> <20111121181724.GB12011@local> <4498E0C9-B5E9-44B5-8868-140D6416100E@gmail.com> <20111122153525.GB17268@redhat.com> <40906F5E-5E97-44CF-AB95-40355204B63F@gmail.com> <20111122173722.GA29068@redhat.com> <20111122175402.GC15508@local> <20111122184040.GB5235@redhat.com> <20111122185244.GD15508@local>
In-Reply-To: <20111122185244.GD15508@local>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Message-Id: <CCF15D66-9712-40DF-8B0F-6EB5CEEFCA20@gmail.com>
Content-Transfer-Encoding: 8BIT
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Greg KH <gregkh@suse.de>,
        tglx@linutronix.de, linux-pci@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
From: Jean-Francois Dagenais <jeff.dagenais@gmail.com>
Subject: Re: extra large DMA buffer for PCI-E device under UIO
Date: Tue, 22 Nov 2011 14:50:32 -0500
To: "Hans J. Koch" <hjk@hansjkoch.de>, Matthew Wilcox <matthew@wil.cx>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 22, 2011, at 13:52, Hans J. Koch wrote:

> On Tue, Nov 22, 2011 at 08:40:40PM +0200, Michael S. Tsirkin wrote:
>> On Tue, Nov 22, 2011 at 06:54:02PM +0100, Hans J. Koch wrote:
>>> On Tue, Nov 22, 2011 at 07:37:23PM +0200, Michael S. Tsirkin wrote:
>>> [...]
>>>>> Or am I better off with a UIO solution?
>>>> 
>>>> You should probably write a proper kernel driver, not a UIO one.
>>>> your kernel driver would have to prevent the device fom DMA into memory
>>>> outside the allocated range, even if userspace is malicious.
>>>> That's why UIO is generally not recommended for PCI devices that do DMA.
>>> 
>>> When UIO was designed, the main goal was the ability to handle interrupts
>>> from userspace. There was no requirement for DMA. In fact, in five years I
>>> didn't get one real world device on my desk that needed it. That doesn't
>>> mean there are no such devices. Adding DMA support to the UIO core was
>>> discussed several times but noone ever did it. Ideas are still welcome...
>>> 
>>> If parts of the driver should be in userspace, you should really try
>>> to extend the UIO core instead of re-implementing UIO functionality in
>>> a "proper kernel driver".
>>> 
>>> Thanks,
>>> Hans
>> 
>> Right, I really meant put all of the driver in the kernel.
>> If parts are in userspace, and device can do DMA,
>> you are faced with the problem as userspace suddenly
>> can access arbitrary memory through the device.
> 
> That's nothing UIO specific. You have the same problem with /dev/mem
> or graphic cards. If you're root, you can do lots of things that can
> compromise security or crash your system.
Exactly, and remember, this is a closed, embedded and controlled system, with a
"kiosk" application running.

As a product supporter, if the end-user decides to temper with his unit and read/write 
anywhere in the system, it would surely qualify as un-supported use of the system
and so my design should not account for this.

Since this FPGA-PCI-e device is the reason for being of the product, it rules over
any other factor as priority 1. I mean, as long as the system doesn't swap, we're
happy.

Matthew Wilcox <matthew@wil.cx> wrote:
> Is it really key?  If you supported, ohidon'tknow, 2MB pages, you'd
> need 64 entries in the FPGA to store the addresses of those 2MB pages,
> which doesn't sound like a huge burden.
This is an excellent idea, and thank you for bringing me back to earth. It is definitely
doable and would solve my 4MB cap problem. It would require work on
the FPGA side as well as mods to my uio driver to manage the memory and
override uio's page_fault implementation (if I am correct), but the rest of our code
base would be unaffected.

What would be completely ideal for me is the idea to cut out a chunk of physical ram
from the kernel though, like those integrated graphic chips do. 

"Michael S. Tsirkin" <mst@redhat.com> wrote:
> You can use alloc_bootmem I guess.
That sounds like something I could use, any idea how to do this elegantly? Meaning,
where is the earliest point I can successfully call alloc_bootmem(128MB) successfully?
How do I communicate this cleanly to my pci probe function so I can hand it to uio?
Using plain old global exported symbols?

Would I encounter cache problems or the like? Or is snooping guaranteed on modern
Intel platforms (Atom E6XX)?

> 
> Thanks,
> Hans
Super thanks again for all the help guys, making real progress here.
/jfd
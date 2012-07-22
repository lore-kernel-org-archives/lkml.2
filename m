Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab2GVXuf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 19:50:35 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:49313 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab2GVXud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 19:50:33 -0400
Message-ID: <500C91E0.8090108@gmail.com>
Date: Mon, 23 Jul 2012 01:50:56 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120713 Thunderbird/13.0
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: Wen Congyang <wency@cn.fujitsu.com>, Gleb Natapov <gleb@redhat.com>,
        kvm list <kvm@vger.kernel.org>, Jan Kiszka <jan.kiszka@siemens.com>,
        qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        rusty@rustcorp.com.au
Subject: Re: [Qemu-devel] [PATCH v7.5] kvm: notify host when the guest is
 panicked
References: <500A565A.8080403@cn.fujitsu.com> <500A6BF1.4030002@cn.fujitsu.com> <500BE68D.90005@gmail.com> <87wr1vwquz.fsf@codemonkey.ws> <500C5C91.3060505@gmail.com> <87txwzctje.fsf@codemonkey.ws>
In-Reply-To: <87txwzctje.fsf@codemonkey.ws>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2012 12:36 AM, Anthony Liguori wrote:
> Sasha Levin <levinsasha928@gmail.com> writes:
> 
>> On 07/22/2012 09:14 PM, Anthony Liguori wrote:
>>> Sasha Levin <levinsasha928@gmail.com> writes:
>>>
>>>> On 07/21/2012 10:44 AM, Wen Congyang wrote:
>>>>> We can know the guest is panicked when the guest runs on xen.
>>>>> But we do not have such feature on kvm.
>>>>>
>>>>> Another purpose of this feature is: management app(for example:
>>>>> libvirt) can do auto dump when the guest is panicked. If management
>>>>> app does not do auto dump, the guest's user can do dump by hand if
>>>>> he sees the guest is panicked.
>>>>>
>>>>> We have three solutions to implement this feature:
>>>>> 1. use vmcall
>>>>> 2. use I/O port
>>>>> 3. use virtio-serial.
>>>>>
>>>>> We have decided to avoid touching hypervisor. The reason why I choose
>>>>> choose the I/O port is:
>>>>> 1. it is easier to implememt
>>>>> 2. it does not depend any virtual device
>>>>> 3. it can work when starting the kernel
>>>>
>>>> Was the option of implementing a virtio-watchdog driver considered?
>>>>
>>>> You're basically re-implementing a watchdog, a guest-host interface and a set of protocols for guest-host communications.
>>>>
>>>> Why can't we re-use everything we have now, push a virtio watchdog
>>>> driver into drivers/watchdog/, and gain a more complete solution to
>>>> detecting hangs inside the guest.
>>>
>>> The purpose of virtio is not to reinvent every possible type of device.
>>> There are plenty of hardware watchdogs that are very suitable to be used
>>> for this purpose.  QEMU implements quite a few already.
>>>
>>> Watchdogs are not performance sensitive so there's no point in using
>>> virtio.
>>
>> The issue here is not performance, but the adding of a brand new
>> guest-host interface.
> 
> We have:
> 
> 1) Virtio--this is our preferred PV interface.  It needs PCI to be fully
> initialized and probably will live as a module.
> 
> 2) Hypercalls--this a secondary PV interface but is available very
> early.  It's terminated in kvm.ko which means it can only operate on
> things that are logically part of the CPU and/or APIC complex.
> 
> This patch introduces a third interface which is available early like
> hypercalls but not necessarily terminated in kvm.ko.  That means it can
> have a broader scope in functionality than (2).
> 
> We could just as well use a hypercall and have multiple commands issued
> to that hypercall as a convention and add a new exit type to KVM that
> sent that specific hypercall to userspace for processing.
> 
> But a PIO operation already has this behavior and requires no changes to kvm.ko.

I don't dispute that there may be a need for another guest-host interface, but this patch can basically be called "kvm: notify host when the guest is panicked, oh, btw, and add a brand new undocumented interface"

The new interface should at least come in it's own patch, with documentation.

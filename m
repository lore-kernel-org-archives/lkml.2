Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab2GVWgo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 18:36:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:32868 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692Ab2GVWgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 18:36:42 -0400
From: Anthony Liguori <anthony@codemonkey.ws>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>, Gleb Natapov <gleb@redhat.com>,
        kvm list <kvm@vger.kernel.org>, Jan Kiszka <jan.kiszka@siemens.com>,
        qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        rusty@rustcorp.com.au
Subject: Re: [Qemu-devel] [PATCH v7.5] kvm: notify host when the guest is panicked
In-Reply-To: <500C5C91.3060505@gmail.com>
References: <500A565A.8080403@cn.fujitsu.com> <500A6BF1.4030002@cn.fujitsu.com> <500BE68D.90005@gmail.com> <87wr1vwquz.fsf@codemonkey.ws> <500C5C91.3060505@gmail.com>
User-Agent: Notmuch/0.13.2+60~g7ecf77d (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Sun, 22 Jul 2012 17:36:37 -0500
Message-ID: <87txwzctje.fsf@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin <levinsasha928@gmail.com> writes:

> On 07/22/2012 09:14 PM, Anthony Liguori wrote:
>> Sasha Levin <levinsasha928@gmail.com> writes:
>> 
>>> On 07/21/2012 10:44 AM, Wen Congyang wrote:
>>>> We can know the guest is panicked when the guest runs on xen.
>>>> But we do not have such feature on kvm.
>>>>
>>>> Another purpose of this feature is: management app(for example:
>>>> libvirt) can do auto dump when the guest is panicked. If management
>>>> app does not do auto dump, the guest's user can do dump by hand if
>>>> he sees the guest is panicked.
>>>>
>>>> We have three solutions to implement this feature:
>>>> 1. use vmcall
>>>> 2. use I/O port
>>>> 3. use virtio-serial.
>>>>
>>>> We have decided to avoid touching hypervisor. The reason why I choose
>>>> choose the I/O port is:
>>>> 1. it is easier to implememt
>>>> 2. it does not depend any virtual device
>>>> 3. it can work when starting the kernel
>>>
>>> Was the option of implementing a virtio-watchdog driver considered?
>>>
>>> You're basically re-implementing a watchdog, a guest-host interface and a set of protocols for guest-host communications.
>>>
>>> Why can't we re-use everything we have now, push a virtio watchdog
>>> driver into drivers/watchdog/, and gain a more complete solution to
>>> detecting hangs inside the guest.
>> 
>> The purpose of virtio is not to reinvent every possible type of device.
>> There are plenty of hardware watchdogs that are very suitable to be used
>> for this purpose.  QEMU implements quite a few already.
>> 
>> Watchdogs are not performance sensitive so there's no point in using
>> virtio.
>
> The issue here is not performance, but the adding of a brand new
> guest-host interface.

We have:

1) Virtio--this is our preferred PV interface.  It needs PCI to be fully
initialized and probably will live as a module.

2) Hypercalls--this a secondary PV interface but is available very
early.  It's terminated in kvm.ko which means it can only operate on
things that are logically part of the CPU and/or APIC complex.

This patch introduces a third interface which is available early like
hypercalls but not necessarily terminated in kvm.ko.  That means it can
have a broader scope in functionality than (2).

We could just as well use a hypercall and have multiple commands issued
to that hypercall as a convention and add a new exit type to KVM that
sent that specific hypercall to userspace for processing.

But a PIO operation already has this behavior and requires no changes to kvm.ko.

> virtio-rng isn't performance sensitive either, yet it was implemented
> using virtio so there wouldn't be yet another interface to communicate
> between guest and host.

There isn't really an obvious discrete RNG that is widely supported.

> This patch goes ahead to add a "arch pv features" interface using
> ioports, without any idea what it might be used for beyond this
> watchdog.

It's not a watchdog--it's the opposite of a watchdog.

You know such a thing already exists in the kernel, right?  S390 has had
a hypercall like this for years.

Regards,

Anthony Liguori

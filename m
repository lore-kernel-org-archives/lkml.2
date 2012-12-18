Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab2LRXrY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 18:47:24 -0500
Received: from mail-vb0-f52.google.com ([209.85.212.52]:47465 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304Ab2LRXrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 18:47:23 -0500
MIME-Version: 1.0
In-Reply-To: <4447450.z46Q2xYLQX@vostro.rjw.lan>
References: <8498184.VilrUmatxI@vostro.rjw.lan> <3027479.MToB281uxK@vostro.rjw.lan>
 <1355868912.18964.381.camel@misato.fc.hp.com> <4447450.z46Q2xYLQX@vostro.rjw.lan>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 18 Dec 2012 16:19:55 -0700
Message-ID: <CAErSpo63cQJskAJKBwai6ipToVHEEwCWXeRfBOzF29Ds29MTbA@mail.gmail.com>
Subject: Re: [PATCH rev.2 1/6] ACPI: Separate adding ACPI device objects from
 probing ACPI drivers
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Toshi Kani <toshi.kani@hp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing0307@gmail.com>, Jiang Liu <liuj97@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 4:00 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Tuesday, December 18, 2012 03:15:12 PM Toshi Kani wrote:
>> On Tue, 2012-12-18 at 22:57 +0100, Rafael J. Wysocki wrote:
>> > On Tuesday, December 18, 2012 09:10:41 AM Toshi Kani wrote:
>> > > On Tue, 2012-12-18 at 02:48 +0100, Rafael J. Wysocki wrote:
>>  :
>> > > We need to decide which module is responsible for calling .bind().  I
>> > > think it should be the ACPI scan module, not the ACPI PCI root bridge
>> > > driver, because:
>> > >  - bind() needs to be called when _ADR device is added.  The ACPI scan
>> > > module can scan any devices, while the PCI root driver can only scan
>> > > when it is added.
>> > >  - acpi_bus_remove() calls unbind() at hot-remove.  The same module
>> > > should be responsible for both bind() and unbind() handling.
>> > >  - It is cleaner to keep struct acpi_device_ops interface to be called
>> > > by the ACPI core.
>> >
>> > I agree with that. :-)
>> >
>> > Moreover, I don't think we need acpi_pci_bind() and acpi_pci_unbind() at all.
>> >
>> > > So, I would propose the following changes.
>> > >
>> > >  - Move the acpi_hot_add_bind() call back to the original place after
>> > > the device_attach() call.
>> > >  - Rename the name of acpi_hot_add_bind() to something like
>> > > acpi_bind_adr_device() since it is no longer hot-add only (and is
>> > > specific to _ADR devices).
>> > >  - Create its pair function, acpi_unbind_adr_device(), which is called
>> > > from acpi_bus_remove().  When a constructor interface is introduced, its
>> > > destructor should be introduced as well.
>> > >  - Remove the binding procedure from acpi_pci_root_add().  This should
>> > > be done in patch [2/6].
>> >
>> > Well, what about moving the code from acpi_pci_bind()/acpi_pci_unbind()
>> > somewhere else and removing those things altogether?
>>
>> Sounds nice.  It will be bonus point if you can do that. :-)
>
> I think I can, but I need a few more patches on top of what I've already posted
> to do that.
>
> I think that https://patchwork.kernel.org/patch/1889821/ and
> https://patchwork.kernel.org/patch/1884701/ can stay as they are, since there's
> some material on top of them already and I'll cut the new patches on top of all
> that.  I'll repost the whole series some time later this week, stay tuned. :-)

I haven't follow this closely enough to give useful feedback, but I
trust that what you're doing is going in the right direction.

The only question I have right now is what I mentioned earlier on IRC,
namely, the idea of "binding" an ACPI handle or device to a pci_dev,
and whether there's a way to guarantee that the binding doesn't become
stale.  For example, if we bind pci_dev A to acpi_device B, I think we
essentially capture the pointer to B and store that pointer in A.
Obviously we want to know that the captured pointer in A remains valid
as long as A exists, but I don't know what assures us of that.

I don't think this is a new question; I have the same question about
the current code before your changes.  But it seems like you're
simplifying this area in a way that might make it easier to answer the
question.

Bjorn

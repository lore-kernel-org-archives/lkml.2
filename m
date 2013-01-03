Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab3ACVpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 16:45:00 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:43872 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622Ab3ACVoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 16:44:55 -0500
MIME-Version: 1.0
In-Reply-To: <4246925.1ZrcBKvkL7@vostro.rjw.lan>
References: <16168955.038G1kVfN2@vostro.rjw.lan> <CAErSpo7tiCn5jBKorO7UjNQbceObAg_uGqtzpBfALBcCUMe1Yw@mail.gmail.com>
 <4246925.1ZrcBKvkL7@vostro.rjw.lan>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 3 Jan 2013 14:44:32 -0700
Message-ID: <CAErSpo4dvy_fK+C+TdyjP_ct15ZGM0qPmkFpdxjk=LUvL2_5hw@mail.gmail.com>
Subject: Re: [PATCH] PCI / ACPI: Rework ACPI device nodes lookup for the PCI
 bus type
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Wu <lekensteyn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 3, 2013 at 1:17 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Thursday, January 03, 2013 08:16:26 AM Bjorn Helgaas wrote:
>> On Fri, Dec 28, 2012 at 2:29 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> >
>> > As the kernel Bugzilla report #42696 indicates, it generally is not
>> > sufficient to use _ADR to get an ACPI device node corresponding to
>> > the given PCI device, because there may be multiple objects with
>> > matching _ADR in the ACPI namespace (this probably is against the
>> > spec, but it evidently happens in practice).
>>
>> I don't see anything in sec 6.1.1 (_ADR) that precludes having
>> multiple objects that contain the same _ADR. Do you have any other
>> pointers?
>
> Section 6.1 implicitly means that.  It says that for PCI devices _ADR
> must be present to identify which device is represented by the given
> ACPI node.  Next, Section 6.1.1 says that the parent bus should be inferred
> from the location of the _ADR object's device package in the ACPI namespace,
> so clearly, if that's under the PCI root bridge ACPI node, the _ADR
> corresponds to a PCI device's bus address.

I agree that for namespace Devices below a PCI host bridge, the _ADR
value and its position in the hierarchy is required to be sufficient
to identify a PCI device and function (or the set of all functions on
a device #).

> Then, Table 6-139 specifies the format of _ADR for PCI devices as being
> euqivalent to devfn, which means that if two nodes with the same _ADR are
> present in one scope (under one parent), then it is impossible to distinguish
> between them and that's against Section 6.1.

This is the bit I don't understand.  Where's the requirement that we
be able to distinguish between two namespace nodes with the same _ADR?

Linux assumes we can start from a PCI device and identify a single
related ACPI namespace node, e.g., in acpi_pci_find_device().  But all
I see in the spec is a requirement that we can start from an ACPI
namespace node and find a PCI device.  So I'm not sure
acpi_pci_find_device() is based on a valid assumption.

Let's say we want to provide _SUN and _UID.  _SUN is a slot number
that may apply to several PCI functions, while _UID probably refers to
a single PCI function.  Is it legal to provide two namespace objects,
one with _ADR 0x0003ffff and _SUN, and another with _ADR 0x00030000
and _UID?  If so, which node should acpi_pci_find_device() return?

> So I really think it *is* against the spec - not because _ADR is generally
> required to be unique, but because _ADR *is* required to be sufficient for
> matching ACPI nodes under a PCI root bridge's node with PCI devices.

>> > One possible way to improve the situation is to use the presence of
>> > another ACPI method to distinguish between the matching namespace
>> > nodes.  For example, if the presence of _INI is checked in addition
>> > to the return value of _ADR, bug #42696 goes away on the affected
>> > machines.  Of course, this is somewhat arbitrary, but it may be
>> > argued that executing _INI for an ACPI device node kind of means that
>> > we are going to use that device node going forward, so we should
>> > generally prefer the nodes where we have executed _INI to "competing"
>> > nodes without _INI.
>>
>> I consider this a purely ACPI issue, and hence something that you own
>> completely.
>
> OK
>
>> That said, my opinion is that this heuristic doesn't sound reliable to
>> me.  It feels like an ad hoc solution that works for the case at hand,
>> but I don't have any reason to think BIOS writers will unconsciously
>> make the same assumptions or that other OSes will contain the same
>> algorithm.
>
> It's supposed to be a heuristic that is less likely to break things. :-)
>
> I have a reason to believe that other OSes simply happen to work with
> the broken machines in question, because they match _ADR in direct order,
> while we match them in reverse order.  The original proposal was to
> change our code to match _ADR in direct order, but Len was afraid that it
> could break systems that we happen to handle correctly (but then they would
> not be handled correctly by other OSes, so perhaps it's what we should do
> after all).
>
>> The existence of acpi_get_child_device() means we're assuming there
>> can only be a single child with matching _ADR.  Since that assumption
>> turned out to be false,
>
> For PCI devices this is required by the spec, AFAICS.
>
>> maybe we need a way to deal with several children.
>>
>> Maybe we need a list of matching children, or maybe we
>> search matching children for a method at the time we need it instead
>> of trying to pick one child up front.
>
> It may not be entirely clear from the changelog, but for PCI devices we use
> acpi_get_child_device(), or acpi_get_child(), to find the ACPI "companion" node
> for a given PCI device, so we have to pick one.  Now, the spec is pretty clear
> in that _ADR is the only thing we can use to do that.
>
> If _ADR doesn't work, we have to do strange things to work around breakage,
> unless we want to use blacklists.
>
> Thanks,
> Rafael
>
>
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.

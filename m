Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab3ACUMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 15:12:18 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:58868 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753430Ab3ACUMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 15:12:14 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Wu <lekensteyn@gmail.com>
Subject: Re: [PATCH] PCI / ACPI: Rework ACPI device nodes lookup for the PCI bus type
Date: Thu, 03 Jan 2013 21:17:50 +0100
Message-ID: <4246925.1ZrcBKvkL7@vostro.rjw.lan>
User-Agent: KMail/4.9.4 (Linux/3.8.0-rc1+; KDE/4.9.4; x86_64; ; )
In-Reply-To: <CAErSpo7tiCn5jBKorO7UjNQbceObAg_uGqtzpBfALBcCUMe1Yw@mail.gmail.com>
References: <16168955.038G1kVfN2@vostro.rjw.lan> <CAErSpo7tiCn5jBKorO7UjNQbceObAg_uGqtzpBfALBcCUMe1Yw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 03, 2013 08:16:26 AM Bjorn Helgaas wrote:
> On Fri, Dec 28, 2012 at 2:29 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >
> > As the kernel Bugzilla report #42696 indicates, it generally is not
> > sufficient to use _ADR to get an ACPI device node corresponding to
> > the given PCI device, because there may be multiple objects with
> > matching _ADR in the ACPI namespace (this probably is against the
> > spec, but it evidently happens in practice).
> 
> I don't see anything in sec 6.1.1 (_ADR) that precludes having
> multiple objects that contain the same _ADR. Do you have any other
> pointers?

Section 6.1 implicitly means that.  It says that for PCI devices _ADR
must be present to identify which device is represented by the given
ACPI node.  Next, Section 6.1.1 says that the parent bus should be inferred
from the location of the _ADR object's device package in the ACPI namespace,
so clearly, if that's under the PCI root bridge ACPI node, the _ADR
corresponds to a PCI device's bus address.

Then, Table 6-139 specifies the format of _ADR for PCI devices as being
euqivalent to devfn, which means that if two nodes with the same _ADR are
present in one scope (under one parent), then it is impossible to distinguish
between them and that's against Section 6.1.

So I really think it *is* against the spec - not because _ADR is generally
required to be unique, but because _ADR *is* required to be sufficient for
matching ACPI nodes under a PCI root bridge's node with PCI devices.

> > One possible way to improve the situation is to use the presence of
> > another ACPI method to distinguish between the matching namespace
> > nodes.  For example, if the presence of _INI is checked in addition
> > to the return value of _ADR, bug #42696 goes away on the affected
> > machines.  Of course, this is somewhat arbitrary, but it may be
> > argued that executing _INI for an ACPI device node kind of means that
> > we are going to use that device node going forward, so we should
> > generally prefer the nodes where we have executed _INI to "competing"
> > nodes without _INI.
> 
> I consider this a purely ACPI issue, and hence something that you own
> completely.

OK

> That said, my opinion is that this heuristic doesn't sound reliable to
> me.  It feels like an ad hoc solution that works for the case at hand,
> but I don't have any reason to think BIOS writers will unconsciously
> make the same assumptions or that other OSes will contain the same
> algorithm.

It's supposed to be a heuristic that is less likely to break things. :-)

I have a reason to believe that other OSes simply happen to work with
the broken machines in question, because they match _ADR in direct order,
while we match them in reverse order.  The original proposal was to
change our code to match _ADR in direct order, but Len was afraid that it
could break systems that we happen to handle correctly (but then they would
not be handled correctly by other OSes, so perhaps it's what we should do
after all).

> The existence of acpi_get_child_device() means we're assuming there
> can only be a single child with matching _ADR.  Since that assumption
> turned out to be false,

For PCI devices this is required by the spec, AFAICS.

> maybe we need a way to deal with several children.
>
> Maybe we need a list of matching children, or maybe we
> search matching children for a method at the time we need it instead
> of trying to pick one child up front.

It may not be entirely clear from the changelog, but for PCI devices we use
acpi_get_child_device(), or acpi_get_child(), to find the ACPI "companion" node
for a given PCI device, so we have to pick one.  Now, the spec is pretty clear
in that _ADR is the only thing we can use to do that.

If _ADR doesn't work, we have to do strange things to work around breakage,
unless we want to use blacklists.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

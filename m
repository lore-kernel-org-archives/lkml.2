Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab2LSLIk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 06:08:40 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:37583 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296Ab2LSLIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 06:08:32 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Toshi Kani <toshi.kani@hp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing0307@gmail.com>, Jiang Liu <liuj97@gmail.com>
Subject: Re: [PATCH rev.2 1/6] ACPI: Separate adding ACPI device objects from probing ACPI drivers
Date: Wed, 19 Dec 2012 12:13:45 +0100
Message-ID: <9914743.4VRVUiabDD@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0; KDE/4.9.3; x86_64; ; )
In-Reply-To: <CAErSpo63cQJskAJKBwai6ipToVHEEwCWXeRfBOzF29Ds29MTbA@mail.gmail.com>
References: <8498184.VilrUmatxI@vostro.rjw.lan> <4447450.z46Q2xYLQX@vostro.rjw.lan> <CAErSpo63cQJskAJKBwai6ipToVHEEwCWXeRfBOzF29Ds29MTbA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 18, 2012 04:19:55 PM Bjorn Helgaas wrote:
> On Tue, Dec 18, 2012 at 4:00 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Tuesday, December 18, 2012 03:15:12 PM Toshi Kani wrote:
> >> On Tue, 2012-12-18 at 22:57 +0100, Rafael J. Wysocki wrote:
> >> > On Tuesday, December 18, 2012 09:10:41 AM Toshi Kani wrote:
> >> > > On Tue, 2012-12-18 at 02:48 +0100, Rafael J. Wysocki wrote:
> >>  :
> >> > > We need to decide which module is responsible for calling .bind().  I
> >> > > think it should be the ACPI scan module, not the ACPI PCI root bridge
> >> > > driver, because:
> >> > >  - bind() needs to be called when _ADR device is added.  The ACPI scan
> >> > > module can scan any devices, while the PCI root driver can only scan
> >> > > when it is added.
> >> > >  - acpi_bus_remove() calls unbind() at hot-remove.  The same module
> >> > > should be responsible for both bind() and unbind() handling.
> >> > >  - It is cleaner to keep struct acpi_device_ops interface to be called
> >> > > by the ACPI core.
> >> >
> >> > I agree with that. :-)
> >> >
> >> > Moreover, I don't think we need acpi_pci_bind() and acpi_pci_unbind() at all.
> >> >
> >> > > So, I would propose the following changes.
> >> > >
> >> > >  - Move the acpi_hot_add_bind() call back to the original place after
> >> > > the device_attach() call.
> >> > >  - Rename the name of acpi_hot_add_bind() to something like
> >> > > acpi_bind_adr_device() since it is no longer hot-add only (and is
> >> > > specific to _ADR devices).
> >> > >  - Create its pair function, acpi_unbind_adr_device(), which is called
> >> > > from acpi_bus_remove().  When a constructor interface is introduced, its
> >> > > destructor should be introduced as well.
> >> > >  - Remove the binding procedure from acpi_pci_root_add().  This should
> >> > > be done in patch [2/6].
> >> >
> >> > Well, what about moving the code from acpi_pci_bind()/acpi_pci_unbind()
> >> > somewhere else and removing those things altogether?
> >>
> >> Sounds nice.  It will be bonus point if you can do that. :-)
> >
> > I think I can, but I need a few more patches on top of what I've already posted
> > to do that.
> >
> > I think that https://patchwork.kernel.org/patch/1889821/ and
> > https://patchwork.kernel.org/patch/1884701/ can stay as they are, since there's
> > some material on top of them already and I'll cut the new patches on top of all
> > that.  I'll repost the whole series some time later this week, stay tuned. :-)
> 
> I haven't follow this closely enough to give useful feedback, but I
> trust that what you're doing is going in the right direction.

Cool. :-)

> The only question I have right now is what I mentioned earlier on IRC,
> namely, the idea of "binding" an ACPI handle or device to a pci_dev,
> and whether there's a way to guarantee that the binding doesn't become
> stale.  For example, if we bind pci_dev A to acpi_device B, I think we
> essentially capture the pointer to B and store that pointer in A.
> Obviously we want to know that the captured pointer in A remains valid
> as long as A exists, but I don't know what assures us of that.

This really is a bit more complicated.

First, what we store in A is not a pointer to B, but rather the corresponding
ACPICA handle, which is guaranteed to live longer that B itself.

Second, we not only store the B's handle in A, but also a pointer to A in B
(in the physical_node_list list).  Moreover, we create the "firmware_node"
sysfs file under A and a "physical_node" sysfs file under B.

All of that becomes invalid when either A or B is removed without notice.

For the removal of A we have acpi_platform_notify() that calls
acpi_unbind_one() which kills all of that stuff, so as long as A is removed
earlier than B, we have no problems.

For the removal of B, however, we seem to assume that if the device is
ejectable, there will be an ACPI driver bound to B (ie. the struct acpi_device)
that will take care of the removal of the physical nodes associated with it
before B itself is removed.  At least that's my understanding of the current
code.  Moreover, I'm not sure if this assumption is universally satisfied.

> I don't think this is a new question; I have the same question about
> the current code before your changes.  But it seems like you're
> simplifying this area in a way that might make it easier to answer the
> question.

Well, my patches are not likely to make things worse in this area. :-)

Anyway, I think we should make acpi_bus_scan(), or even acpi_bus_add() after
my changes, mutually exclusive with acpi_bus_trim(), because that will ensure
that we won't be removing ACPI device objects while setting them up (or the
other way around).  That would require us to redesign some ACPI drivers first,
though, because they call acpi_bus_trim() in their initialization code paths
(I don't really think they should be doing that).

Moreover, I think we should make the ACPI core trigger the removal of all
physical nodes (As) associated with the given ACPI node (B) after calling
device_release_driver() in acpi_bus_remove().  That will ensure that all
physical nodes are gone along with all the binding-related stuff (thanks to
acpi_platform_notify()) before the ACPI node is removed.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

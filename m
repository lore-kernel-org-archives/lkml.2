Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038Ab1JJVEt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 17:04:49 -0400
Received: from smtp-out.google.com ([216.239.44.51]:7887 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab1JJVEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 17:04:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:x-system-of-record;
	b=uLZtfZzHecsL4YNJSFoWi65OSfxRKSbFAJBhJeD/1uSJ/XNegnAAEF2+sYQcmWH+h
	FrrEq48bZy099FXyg9K5g==
MIME-Version: 1.0
In-Reply-To: <CAErSpo5py82G1=6BOTG4RSAj6_SRzN4fng6sECU2sS+u9quixw@mail.gmail.com>
References: <1314845309-3277-1-git-send-email-dczhu@mips.com> <CAErSpo5py82G1=6BOTG4RSAj6_SRzN4fng6sECU2sS+u9quixw@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 10 Oct 2011 15:04:21 -0600
Message-ID: <CAErSpo5HNKi7NSKBbyL3o39Ow+Xkncyccrj5PQNaoeMdLHJsFQ@mail.gmail.com>
Subject: Re: [RESEND PATCH v3 0/2] Pass resources to pci_create_bus() and fix
 MIPS PCI resources
To: Deng-Cheng Zhu <dczhu@mips.com>
Cc: jbarnes@virtuousgeek.org, ralf@linux-mips.org, monstr@monstr.eu,
        benh@kernel.crashing.org, paulus@samba.org, davem@davemloft.net,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, eyal@mips.com, zenon@mips.com,
        dengcheng.zhu@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 7, 2011 at 3:50 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Wed, Aug 31, 2011 at 8:48 PM, Deng-Cheng Zhu <dczhu@mips.com> wrote:
>> (Resending the patch set to include more arch maintainers.)
>>
>> Change the pci_create_bus() interface to pass in available resources to get them
>> settled down early. This is to avoid possible resource conflicts while doing
>> pci_scan_slot() in pci_scan_child_bus(). Note that pcibios_fixup_bus() can get
>> rid of such conflicts, but it's done AFTER scanning slots.
>>
>> In addition, MIPS PCI resources are now fixed using this new interface.
>
> Jesse, I assume these are headed for the 3.2 merge window, right?

I tried to build on these patches to convert x86 to using the new
pci_create_bus() interface, but I couldn't figure out a nice way to
handle an arbitrary number of resources.

We made pci_create_bus() take a "struct pci_bus_resource *"
(https://lkml.org/lkml/2011/8/26/88):

    struct pci_bus *pci_create_bus(struct device *parent, int bus,
			       struct pci_ops *ops, void *sysdata,
			       struct pci_bus_resource *bus_res);

Where pci_bus_resource looks like this:

    struct pci_bus_resource {
        struct list_head list;
        struct resource *res;
        unsigned int flags;
    };

Conceptually, we're passing a list of resources to pci_create_bus(),
which I think is the right thing.  But I think the best way to do that
is by passing a pointer to a struct list_head, not a pointer to a
pci_bus_resource.

If we pass a pci_bus_resource, we're basically using that as a
container for a list (as per include/linux/list.h), but it's not a
well-formed list.  Normally a list contains one list_head per element,
plus an extra list_head for the head of the list.  There's a nice
drawing on page 296 of http://lwn.net/images/pdf/LDD3/ch11.pdf.

The list built in your MIPS patch (https://lkml.org/lkml/2011/8/26/89)
consists of two pci_bus_resource structs (each with a list_head), but
there's no third list_head for the head of the list.  I think if you
tried to use list_for_each_entry() to iterate through the list, it
would not work correctly.

I'll post a slightly modified series to show what I mean.  Take a look
and see if it makes sense to you.

Bjorn

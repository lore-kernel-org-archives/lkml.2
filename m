Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab1G1RBi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 13:01:38 -0400
Received: from smtp-out.google.com ([74.125.121.67]:42878 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755745Ab1G1RBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 13:01:37 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:x-system-of-record;
	b=rt2NDrUqN/NySWe4L9yPVe+IV6Bg8DGAffRMZqSQLF7fvZnYDpIMKzohp0hyBBxTY
	1a4Kgoje2IjgBbi9GQclw==
MIME-Version: 1.0
In-Reply-To: <1311852512-7340-2-git-send-email-dengcheng.zhu@gmail.com>
References: <1311852512-7340-1-git-send-email-dengcheng.zhu@gmail.com> <1311852512-7340-2-git-send-email-dengcheng.zhu@gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 28 Jul 2011 09:59:03 -0600
Message-ID: <CAErSpo5hZGAzc17GApEfuzduvzh6haVLBKRvizcRxGLnh8ebuA@mail.gmail.com>
Subject: Re: [PATCH 1/2] PCI: make pci_claim_resource() work with conflict
 resources as appropriate
To: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
Cc: jbarnes@virtuousgeek.org, torvalds@linux-foundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, eyal@mips.com, zenon@mips.com,
        Ralf Baechle <ralph@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 28, 2011 at 5:28 AM, Deng-Cheng Zhu <dengcheng.zhu@gmail.com> wrote:
> In resolving a network driver issue with the MIPS Malta platform, the root
> cause was traced into pci_claim_resource():
>
> MIPS System Controller's PCI I/O resources stay in 0x1000-0xffffff. When
> PCI quirks start claiming resources using request_resource_conflict(),
> collisions happen and -EBUSY is returned, thereby rendering the onboard AMD
> PCnet32 NIC unaware of quirks' region and preventing the NIC from functioning.
> For PCI quirks, PIIX4 ACPI is expected to claim 0x1000-0x103f, and PIIX4 SMB to
> claim 0x1100-0x110f, both of which fall into the MSC I/O range. Certainly, we
> can increase the start point of this range in arch/mips/mti-malta/malta-pci.c to
> avoid the collisions. But a fix in here looks more justified, though it seems to
> have a wider impact. Using insert_xxx as opposed to request_xxx will register
> PCI quirks' resources as children of MSC I/O and return OK, instead of seeing
> collisions which are actually resolvable.

What's the collision?  Can we see the dmesg log (which should have
that information) and maybe the /proc/ioports contents?  Did something
change the order in which we claim resources, so things that used to
work now cause conflicts?

I think insert_resource() (where the newly-inserted resource can
become the parent of something that was previously inserted) is sort
of a hack, and the fact that we need it is telling us that we're doing
things in the wrong order.  It's nicer when we can discover and claim
resources in a top-down hierarchical way.  But I recognize that may
not always be possible, or at least not convenient.

Bjorn

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab1HAPVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 11:21:40 -0400
Received: from smtp-out.google.com ([74.125.121.67]:19620 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab1HAPVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 11:21:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:x-system-of-record;
	b=YDqegdRi81+tDsX0IKb11Kj/YDCxZIZy0+MtrJ9oZsiHN8vJ+U1/+ME9WVaYFc5XS
	5a+ZgfhqINlk6MaeQQh7A==
MIME-Version: 1.0
In-Reply-To: <CAOfQC9-vT0F-atsuQ1DRg1cFMzRq3rjfa3hvsemLqnRCJedFkA@mail.gmail.com>
References: <1311852512-7340-1-git-send-email-dengcheng.zhu@gmail.com>
 <1311852512-7340-2-git-send-email-dengcheng.zhu@gmail.com>
 <20110728115330.GA29899@linux-mips.org> <CAOfQC9-Z31SSv8agzxZ_hvPOOLY8p0F6yc1=o-QPbDwbNxavTg@mail.gmail.com>
 <CAErSpo6SLCLxh6vOwLaj5AYXNLrUEtQgfMU_hFCKJVH1dC5neQ@mail.gmail.com> <CAOfQC9-vT0F-atsuQ1DRg1cFMzRq3rjfa3hvsemLqnRCJedFkA@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 1 Aug 2011 09:21:11 -0600
Message-ID: <CAErSpo5A0At+U4gZ6s6ER2vzBzRiV9iJVkZtGH+gnAWeT+N=Ag@mail.gmail.com>
Subject: Re: [PATCH 1/2] PCI: make pci_claim_resource() work with conflict
 resources as appropriate
To: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, jbarnes@virtuousgeek.org,
        torvalds@linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org, eyal@mips.com,
        zenon@mips.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 1, 2011 at 4:13 AM, Deng-Cheng Zhu <dengcheng.zhu@gmail.com> wrote:
> It was found that PCI quirks claim resources (by calling pci_claim_resource())
> *BEFORE* pcibios_fixup_bus() is called. In pcibios_fixup_bus(),
> pci_bus->resource[0] for the root bus DOES point to msc_io_resource. If PCI
> quirks do the resource claim after the arch-defined pcibios_fixup_bus() being
> called, then the problem with Malta goes away.

Oh, I see.  pcibios_fixup_bus() copies the hose resources to the root
bus pci_bus structure.  I think that's bogus because we have the
interval between mips_pcibios_init() and pcibios_fixup_bus() where the
root bus resources are incorrect.

I think it would be better to set up the resources correctly right
away, as we do on x86.  In fact, I'm dubious about pci_create_bus()
filling in ioport_resource and iomem_resource as defaults -- that's
never what we really want there, and we have to rely on the arch
coming back later to fix it up.

I'd like to see some sort of restructuring there so we could pass in a
list of resources at the time we create the bus.

Bjorn

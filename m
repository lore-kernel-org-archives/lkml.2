Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab1G2SJX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 14:09:23 -0400
Received: from smtp-out.google.com ([74.125.121.67]:22724 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233Ab1G2SJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 14:09:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:x-system-of-record;
	b=MdjhUOxfol/n+uMUZ18zn4qzfx27K8vhgQxFmN7YdNdz78/sVrwVEvVOINJIicwtZ
	bR1zo0XboKJ0EhX+kxoaA==
MIME-Version: 1.0
In-Reply-To: <CAOfQC9-Z31SSv8agzxZ_hvPOOLY8p0F6yc1=o-QPbDwbNxavTg@mail.gmail.com>
References: <1311852512-7340-1-git-send-email-dengcheng.zhu@gmail.com>
 <1311852512-7340-2-git-send-email-dengcheng.zhu@gmail.com>
 <20110728115330.GA29899@linux-mips.org> <CAOfQC9-Z31SSv8agzxZ_hvPOOLY8p0F6yc1=o-QPbDwbNxavTg@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 29 Jul 2011 11:35:51 -0600
Message-ID: <CAErSpo6SLCLxh6vOwLaj5AYXNLrUEtQgfMU_hFCKJVH1dC5neQ@mail.gmail.com>
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

On Fri, Jul 29, 2011 at 12:32 AM, Deng-Cheng Zhu
<dengcheng.zhu@gmail.com> wrote:
> I noticed that at 79896cf42f Linus changed the function from insert_resource()
> to request_resource() (and later evolved into request_resource_conflict()) and
> he explained the reason. So, in the NIC's case, the problem is that in
> pci_claim_resource() the function pci_find_parent_resource() returns the root
> (0x0-0xffffff) rather than the MSC PCI I/O (0x1000-0xffffff).

This seems like the real problem: PCI has the wrong idea of the
resources available on bus 00.  The pci_bus->resource[0] for bus 00
points to ioport_resource (the default put there by pci_create_bus()),
when it should point to to msc_io_resource instead.

Some architectures fill in the pci_bus->resource[] array directly for
host bridges (for examples, try 'grep -r "resource\[0\] = " arch/').
On x86 and ia64, we use pci_bus_remove_resources() and
pci_bus_add_resource(), and I'd prefer that style for new code because
it hides some ugly implementation details.

I'm a little puzzled that we don't see this problem on more
architectures.  The grep above only found a few arches that update the
root bus resources.  I would expect most of the ones it didn't find to
be broken the same way Malta is.

Bjorn

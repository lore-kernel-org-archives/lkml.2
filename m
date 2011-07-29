Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab1G2GcJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 02:32:09 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:43319 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837Ab1G2GcH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 02:32:07 -0400
MIME-Version: 1.0
In-Reply-To: <20110728115330.GA29899@linux-mips.org>
References: <1311852512-7340-1-git-send-email-dengcheng.zhu@gmail.com>
	<1311852512-7340-2-git-send-email-dengcheng.zhu@gmail.com>
	<20110728115330.GA29899@linux-mips.org>
Date: Fri, 29 Jul 2011 14:32:06 +0800
Message-ID: <CAOfQC9-Z31SSv8agzxZ_hvPOOLY8p0F6yc1=o-QPbDwbNxavTg@mail.gmail.com>
Subject: Re: [PATCH 1/2] PCI: make pci_claim_resource() work with conflict
 resources as appropriate
From: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: jbarnes@virtuousgeek.org, torvalds@linux-foundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, eyal@mips.com, zenon@mips.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed that at 79896cf42f Linus changed the function from insert_resource()
to request_resource() (and later evolved into request_resource_conflict()) and
he explained the reason. So, in the NIC's case, the problem is that in
pci_claim_resource() the function pci_find_parent_resource() returns the root
(0x0-0xffffff) rather than the MSC PCI I/O (0x1000-0xffffff). So
request_resource_conflict() for PCI quirks (0x1000-0x103f and 0x1100-0x110f)
will simply return an error, coz these 2 regions 'conflict' with MSC PCI I/O.
Instead, insert_resource_conflict() will also find the collisions but register
quirks as children of MSC PCI I/O (is this supposed to be correct?) and return
a success.


Deng-Cheng

2011/7/28 Ralf Baechle <ralf@linux-mips.org>
>
> On Thu, Jul 28, 2011 at 07:28:31PM +0800, Deng-Cheng Zhu wrote:
>
> > In resolving a network driver issue with the MIPS Malta platform, the root
> > cause was traced into pci_claim_resource():
> >
> > MIPS System Controller's PCI I/O resources stay in 0x1000-0xffffff. When
> > PCI quirks start claiming resources using request_resource_conflict(),
> > collisions happen and -EBUSY is returned, thereby rendering the onboard AMD
> > PCnet32 NIC unaware of quirks' region and preventing the NIC from functioning.
> > For PCI quirks, PIIX4 ACPI is expected to claim 0x1000-0x103f, and PIIX4 SMB to
> > claim 0x1100-0x110f, both of which fall into the MSC I/O range. Certainly, we
> > can increase the start point of this range in arch/mips/mti-malta/malta-pci.c to
> > avoid the collisions. But a fix in here looks more justified, though it seems to
> > have a wider impact. Using insert_xxx as opposed to request_xxx will register
> > PCI quirks' resources as children of MSC I/O and return OK, instead of seeing
> > collisions which are actually resolvable.
>
> This used to work in the past; do you know which commit broke the resource
> handling for the NIC?
>
>  Ralf

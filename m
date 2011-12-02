Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947Ab1LBSs6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 13:48:58 -0500
Received: from usmamail.tilera.com ([206.83.70.75]:40546 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810Ab1LBSsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 13:48:55 -0500
Message-ID: <4ED91D95.6040601@tilera.com>
Date: Fri, 2 Dec 2011 13:48:53 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-arch@vger.kernel.org>, Rolf Eike Beer <eike-kernel@sf-tec.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Maxin B. John" <maxin.john@gmail.com>, Tejun Heo <tj@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Paul Mundt <lethal@linux-sh.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "David S. Miller" <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] lib/devres.c: allow specifying NO_IOPORT while using
 PCI
References: <cover.1322592494.git.mst@redhat.com> <201111301549.57430.arnd@arndb.de> <201112011815.pB1IFGZe004948@farm-0002.internal.tilera.com> <1616727.0BYPKXtoA0@wuerfel>
In-Reply-To: <1616727.0BYPKXtoA0@wuerfel>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/1/2011 5:47 PM, Arnd Bergmann wrote:
> On Thursday 01 December 2011 12:59:19 Chris Metcalf wrote:
>> The tile architecture does not support IOPORT, but it does support
>> PCI and IOMEM.  We were not specifying NO_IOPORT, though, because it
>> was causing a couple of functions (pcim_iomap_regions and pcim_iomap_table)
>> that are needed to not get provided.  Moving the #ifdef fixes this
>> so that those functions and some related ones are now always provided
>> if CONFIG_PCI is true.
>>
>> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> Hmm, I'm sure that Al Viro intentionally did it the way it is, but I'm
> not sure exactly why that would be.
>
> Any driver using the functions you now expose for NO_IOPORT is probably
> prepared to handle both MMIO and PIO BARs on PCI, which you can consider
> broken in the case where a card actually requires PIO.
>
> On tile, it would be just as broken as other drivers that directly use
> inb/outb to do the port access, but on platforms that actually have
> PIO but are not able to map them (like arm/mach-rpc), you would now
> enable people to write silently broken drivers.
>
> However, assuming they check the return value of the *iomap, the
> drivers could still easily detect this case at runtime. Also, at
> least on tile, you already provide a pci_iomap function, which
> has the exact same problem as the devres functions.
>
> One area where your patch might actually break existing code is
> architectures that allow the devres functions to be built *and*
> have PCI support but don't provide a pci_iomap function, because
> they do not support mapping the PIO range into addresses. I'm
> not sure if that's actually still the case anywhere after Michael's
> recent patches, but it used to be the case on RPC and probably others.

Sounds sufficiently subtle that I'll plan to drop the patch unless someone
else (maybe Al Viro, now cc'ed) wants to weigh in.  For tile this just
means we'll continue not to set NO_IOPORT, at the cost of a few hundred
bytes of dead code; no big deal.

The specific issue I saw was calls to pcim_iomap_{regions,table} from
drivers/ata/libata-sff.c and drivers/ata/sata_sil24.c; we use the
sata_sil24 in one of our platforms (TILEmpower).

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


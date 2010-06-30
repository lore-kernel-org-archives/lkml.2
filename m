Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347Ab0F3Vp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 17:45:28 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:53132 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756811Ab0F3Vp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 17:45:26 -0400
Date: Wed, 30 Jun 2010 14:45:05 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, muli@il.ibm.com,
       cschultz@linux.vnet.ibm.com, stable@kernel.org, tglx@linutronix.de,
       mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, Calgary: Increase max PHB number
Message-ID: <20100630214505.GO15515@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20100624212647.GI15515@tux1.beaverton.ibm.com> <tip-499a00e92dd9a75395081f595e681629eb1eebad@git.kernel.org> <20100629155151.7caaff4b.akpm@linux-foundation.org> <4C2BB7C0.9040000@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C2BB7C0.9040000@zytor.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 02:31:44PM -0700, H. Peter Anvin wrote:
> On 06/29/2010 03:51 PM, Andrew Morton wrote:
> > On Fri, 25 Jun 2010 15:29:50 GMT
> > "tip-bot for Darrick J. Wong" <djwong@us.ibm.com> wrote:
> > 
> >> Commit-ID:  499a00e92dd9a75395081f595e681629eb1eebad
> >> Gitweb:     http://git.kernel.org/tip/499a00e92dd9a75395081f595e681629eb1eebad
> >> Author:     Darrick J. Wong <djwong@us.ibm.com>
> >> AuthorDate: Thu, 24 Jun 2010 14:26:47 -0700
> >> Committer:  Ingo Molnar <mingo@elte.hu>
> >> CommitDate: Fri, 25 Jun 2010 16:14:58 +0200
> >>
> >> x86, Calgary: Increase max PHB number
> > 
> > arch/x86/kernel/pci-calgary_64.c: In function 'calgary_init_one':
> > arch/x86/kernel/pci-calgary_64.c:1059: warning: comparison is always false due to limited range of data type
> > 
> > from
> > 
> >         BUG_ON(dev->bus->number >= MAX_PHB_BUS_NUM);
> > 
> > with
> > 
> > http://userweb.kernel.org/~akpm/stuff/config-akpm2.txt
> 
> This comes from:
> 
> /*
>  * The maximum PHB bus number.
>  * x3950M2 (rare): 8 chassis, 48 PHBs per chassis = 384
>  * x3950M2: 4 chassis, 48 PHBs per chassis        = 192
>  * x3950 (PCIE): 8 chassis, 32 PHBs per chassis   = 256
>  * x3950 (PCIX): 8 chassis, 16 PHBs per chassis   = 128
>  */
> #define MAX_PHB_BUS_NUM		384
> 
> Clearly there can't be 384 busses with standard PCI numbering (bus
> numbers are 8 bits).  That means either that the number 384 is just
> wrong, or it means that there are multiple PCI domains involved, and
> that the BUG_ON() should be something else.
> 
> Furthermore, in get_tce_space_from_tar() we have:
> 
> 	for (bus = 0; bus < MAX_PHB_BUS_NUM; bus++) {
> 		struct calgary_bus_info *info = &bus_info[bus];
> 		unsigned short pci_device;
> 		u32 val;
> 
> 		val = read_pci_config(bus, 0, 0, 0);
> 		pci_device = (val & 0xFFFF0000) >> 16;
> 
> ... which assumes the bus is a PCI bus number, no domain involved.
> 
> Does this mean the limit should be 256 (in which case we can just drop
> the BUG_ON()), or is there support for domains which should be in this
> code but isn't?

Yes, it should be 256.  Some time ago there was talk of building 8-node
x3950M2s with PCI domain support, but the final word now is that nobody will
ever have more than 4 nodes.  The BUG_ON can be dropped, too.  I'll send a
patch shortly that incorporates both updates.

(Honestly I sort of wonder if the Calgary code should be removed entirely,
but that's a whole different battle....)

--D

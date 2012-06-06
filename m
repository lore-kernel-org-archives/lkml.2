Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042Ab2FFSTy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 14:19:54 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:39872 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752667Ab2FFSTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 14:19:53 -0400
Message-ID: <1339006789.2836.51.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCH v9] tilegx network driver: initial support
From: Ben Hutchings <bhutchings@solarflare.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Chris Metcalf <cmetcalf@tilera.com>, <arnd@arndb.de>,
        David Miller <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Date: Wed, 6 Jun 2012 19:19:49 +0100
In-Reply-To: <1339006223.26966.36.camel@edumazet-glaptop>
References: <201205201636.q4KGaoA3003845@farm-0027.internal.tilera.com>
	 <20120520.165546.1211013675964130504.davem@davemloft.net>
	 <201205240115.q4O1FwqG006336@lab-41.internal.tilera.com>
	 <20120524.003148.700603156196416506.davem@davemloft.net>
	 <201205251853.q4PIrE7T000723@lab-41.internal.tilera.com>
	 <201206042023.q54KNEZp003834@farm-0002.internal.tilera.com>
	 <1339006223.26966.36.camel@edumazet-glaptop>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-6.800.1017-18950.005
X-TM-AS-Result: No--16.296600-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 20:10 +0200, Eric Dumazet wrote:
> On Mon, 2012-06-04 at 16:12 -0400, Chris Metcalf wrote:
> > This change adds support for the tilegx network driver based on the
> > GXIO IORPC support in the tilegx software stack, using the on-chip
> > mPIPE packet processing engine.
> > 
> 
> > +
> > +/* Do "TSO" handling for egress.
> > + *
> > + * Normally drivers set NETIF_F_TSO only to support hardware TSO;
> > + * otherwise the stack uses scatter-gather to implement GSO in software.
> > + * On our testing, enabling GSO support (via NETIF_F_SG) drops network
> > + * performance down to around 7.5 Gbps on the 10G interfaces, although
> > + * also dropping cpu utilization way down, to under 8%.  But
> > + * implementing "TSO" in the driver brings performance back up to line
> > + * rate, while dropping cpu usage even further, to less than 4%.  In
> > + * practice, profiling of GSO shows that skb_segment() is what causes
> > + * the performance overheads; we benefit in the driver from using
> > + * preallocated memory to duplicate the TCP/IP headers.
> > + */
> 
> All this stuff cost about 300 lines of code in this driver, without IPv6
> support.
> 
> I am pretty sure this performance problem should be solved in net/{core|
> ipv4|ipv6} instead
> 
> What TCP performance do you get with TSO/GSO and SG off ?

It's a real problem and we have soft-TSO in the sfc driver for the same
reason.  GSO means more allocation, more DMA mapping, more calls into
the driver and more register writes.

If drivers could use GSO explicitly from their ndo_start_xmit function,
more like they do with GRO, much of this would presumably be avoidable.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.


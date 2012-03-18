Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab2CRTxP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 15:53:15 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:40567 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756118Ab2CRTwy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 15:52:54 -0400
MIME-Version: 1.0
Message-ID: <534c5acf-74df-4ecc-8b97-4945f61e5560@default>
Date: Sun, 18 Mar 2012 12:52:37 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Akshay Karle <akshay.a.karle@gmail.com>
Cc: Konrad Wilk <konrad.wilk@oracle.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, ashu tripathi <er.ashutripathi@gmail.com>,
        nishant gulhane <nishant.s.gulhane@gmail.com>,
        Shreyas Mahure <shreyas.mahure@gmail.com>,
        amarmore2006 <amarmore2006@gmail.com>,
        mahesh mohan <mahesh6490@gmail.com>
Subject: RE: [RFC 1/2] kvm: host-side changes for tmem on KVM
References: <1331225648.2585.27.camel@aks>
 <20120315165400.GL30250@phenom.dumpdata.com> <1331836868.2215.43.camel@aks>
 <33e296c5-825f-44a2-8f42-e76caf3715a6@default> <1332007375.2110.8.camel@aks>
In-Reply-To: <1332007375.2110.8.camel@aks>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090205.4F663D14.0066,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Akshay Karle [mailto:akshay.a.karle@gmail.com]
> Subject: RE: [RFC 1/2] kvm: host-side changes for tmem on KVM
> 
> > > From: Akshay Karle [mailto:akshay.a.karle@gmail.com]
> > > Subject: Re: [RFC 1/2] kvm: host-side changes for tmem on KVM
> > >
> > > >> @@ -669,7 +670,6 @@ static struct zv_hdr *zv_create(struct x
> > > >>       int chunks = (alloc_size + (CHUNK_SIZE - 1)) >> CHUNK_SHIFT;
> > > >>       int ret;
> > > >>
> > > >> -     BUG_ON(!irqs_disabled());
> > > >
> > > > Can you explain why?
> > >
> > > Zcache is by default used in the non-virtualized environment for page compression. Whenever
> > > a page is to be evicted from the page cache the spin_lock_irq is held on the page mapping.
> > > To ensure that this is done, the BUG_ON(!irqs_disabled()) was used.
> > > But now the situation is different, we are using zcache functions for kvm VM's.
> > > So if any page of the guest is to be evicted the irqs should be disabled in just that
> > > guest and not the host, so we removed the BUG_ON(!irqs_disabled()); line.
> >
> > I think irqs may still need to be disabled (in your code by the caller)
> > since the tmem code (in tmem.c) takes spinlocks with this assumption.
> > I'm not sure since I don't know what can occur with scheduling a
> > kvm guest during an interrupt... can a different vcpu of the same guest
> > be scheduled on this same host pcpu?
> 
> The irqs are disabled but only in the guest kernel not in the host. We
> tried adding the spin_lock_irq code into the host but that was resulting
> in host panic as the lock is being taken on the entire mapping. If the
> irqs are disabled in the guest, is there a need to disable them on the
> host as well? Because the mappings maybe different in the host and the
> guest.

The issue is that interrupts MUST be disabled in code this is
called by zcache_put_page() and by zv_create() because the
called code (tmem_put and xv_malloc) takes locks.  This may
be difficult to reproduce, but if an interrupt occurs during
a critical region, a deadlock is possible.

You don't need to do a spin_lock_irq.  You just need to do a local_irq_save
and restore in zcache_put_page if kvm_tmem_enabled.  Look at zcache_get_page
as an example... the code in zcache_put_page would be something like:

{
	if (kvm_tmem_enabled)
		local_irq_save(flags);
			:
			:
out:
	if (kvm_tmem_enabled)
		local_irq_restore(flags);
	return ret;
}

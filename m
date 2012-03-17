Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402Ab2CQSDG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 14:03:06 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62029 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757207Ab2CQSDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 14:03:04 -0400
Message-ID: <1332007375.2110.8.camel@aks>
Subject: RE: [RFC 1/2] kvm: host-side changes for tmem on KVM
From: Akshay Karle <akshay.a.karle@gmail.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Konrad Wilk <konrad.wilk@oracle.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, ashu tripathi <er.ashutripathi@gmail.com>,
        nishant gulhane <nishant.s.gulhane@gmail.com>,
        Shreyas Mahure <shreyas.mahure@gmail.com>,
        amarmore2006 <amarmore2006@gmail.com>,
        mahesh mohan <mahesh6490@gmail.com>
Date: Sat, 17 Mar 2012 23:32:55 +0530
In-Reply-To: <33e296c5-825f-44a2-8f42-e76caf3715a6@default>
References: <1331225648.2585.27.camel@aks>
	 <20120315165400.GL30250@phenom.dumpdata.com> <1331836868.2215.43.camel@aks>
	 <33e296c5-825f-44a2-8f42-e76caf3715a6@default>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > From: Akshay Karle [mailto:akshay.a.karle@gmail.com]
> > Subject: Re: [RFC 1/2] kvm: host-side changes for tmem on KVM
> > 
> > >> @@ -669,7 +670,6 @@ static struct zv_hdr *zv_create(struct x
> > >>       int chunks = (alloc_size + (CHUNK_SIZE - 1)) >> CHUNK_SHIFT;
> > >>       int ret;
> > >>
> > >> -     BUG_ON(!irqs_disabled());
> > > 
> > > Can you explain why?
> >
> > Zcache is by default used in the non-virtualized environment for page compression. Whenever
> > a page is to be evicted from the page cache the spin_lock_irq is held on the page mapping.
> > To ensure that this is done, the BUG_ON(!irqs_disabled()) was used.
> > But now the situation is different, we are using zcache functions for kvm VM's.
> > So if any page of the guest is to be evicted the irqs should be disabled in just that
> > guest and not the host, so we removed the BUG_ON(!irqs_disabled()); line.
>
> I think irqs may still need to be disabled (in your code by the caller)
> since the tmem code (in tmem.c) takes spinlocks with this assumption.
> I'm not sure since I don't know what can occur with scheduling a
> kvm guest during an interrupt... can a different vcpu of the same guest
> be scheduled on this same host pcpu?
> 
> Dan

The irqs are disabled but only in the guest kernel not in the host. We 
tried adding the spin_lock_irq code into the host but that was resulting
in host panic as the lock is being taken on the entire mapping. If the
irqs are disabled in the guest, is there a need to disable them on the
host as well? Because the mappings maybe different in the host and the
guest.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab2HBImh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 04:42:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752379Ab2HBImK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 04:42:10 -0400
Date: Thu, 2 Aug 2012 11:42:52 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: avi@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jan.kiszka@siemens.com
Subject: Re: [PATCH v7 2/2] kvm: KVM_EOIFD, an eventfd for EOIs
Message-ID: <20120802084252.GC24929@redhat.com>
References: <20120724203628.21081.56884.stgit@bling.home>
 <20120724204320.21081.32333.stgit@bling.home>
 <20120729145452.GD14278@redhat.com>
 <1343665330.8073.108.camel@ul30vt>
 <20120731000100.GA17612@redhat.com>
 <1343694391.8073.227.camel@ul30vt>
 <20120731003636.GC17922@redhat.com>
 <1343697135.8073.245.camel@ul30vt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343697135.8073.245.camel@ul30vt>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 07:12:15PM -0600, Alex Williamson wrote:
> > > > > > >  kvm_eoifd.fd specifies the eventfd used for
> > > > > > > +notification.  KVM_EOIFD_FLAG_DEASSIGN is used to de-assign an eoifd
> > > > > > > +once assigned.  KVM_EOIFD also requires additional bits set in
> > > > > > > +kvm_eoifd.flags to bind to the proper interrupt line.  The
> > > > > > > +KVM_EOIFD_FLAG_LEVEL_IRQFD indicates that kvm_eoifd.key is provided
> > > > > > > +and is a key from a level triggered interrupt (configured from
> > > > > > > +KVM_IRQFD using KVM_IRQFD_FLAG_LEVEL).  The EOI notification is bound
> > > > > > > +to the same GSI and irqchip input as the irqfd.  Both kvm_eoifd.key
> > > > > > > +and KVM_EOIFD_FLAG_LEVEL_IRQFD must be specified on assignment and
> > > > > > > +de-assignment of KVM_EOIFD.  A level irqfd may only be bound to a
> > > > > > > +single eoifd.  KVM_CAP_EOIFD_LEVEL_IRQFD indicates support of
> > > > > > > +KVM_EOIFD_FLAG_LEVEL_IRQFD.
> > > > > > >  
> > > > > > 
> > > > > > Hmm returning the key means we'll need to keep refcounting for source
> > > > > > IDs around forever. I liked passing the fd better: make implementation
> > > > > > match interface and not the other way around.
> > > > > 
> > > > > False, a source ID has a finite lifecycle.  The fd approach was broken.
> > > > > Holding the irqfd context imposed too many dependencies between eoifd
> > > > > and irqfd necessitating things like one interface disabling another.  I
> > > > > thoroughly disagree with that approach.
> > > > 
> > > > You keep saying this but it is still true: once irqfd
> > > > is closed eoifd does not get any more interrupts.
> > > 
> > > How does that matter?
> > 
> > Well if it does not get events it is disabled.
> > so you have one ifc disabling another, anyway.
> 
> And a level irqfd without an eoifd can never be de-asserted.  Either we
> make modular components, assemble them to do useful work, and
> disassemble them independently so they can be used by future interfaces
> or we bundle eoifd as just an option of irqfd.  Which is it gonna be?

I'm fine just making it an option. I think Gleb wanted a separate
EOIFD to handle timedrift but it later seemed that eventfd is not
suitable for that?

-- 
MST

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab2GRK1q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 06:27:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30194 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555Ab2GRK1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 06:27:43 -0400
Date: Wed, 18 Jul 2012 13:27:39 +0300
From: Gleb Natapov <gleb@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, avi@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com
Subject: Re: [PATCH v5 3/4] kvm: Create kvm_clear_irq()
Message-ID: <20120718102739.GB26120@redhat.com>
References: <1342534911.3229.26.camel@ul30vt>
 <20120717145313.GB11516@redhat.com>
 <1342538411.2229.106.camel@bling.home>
 <20120717153620.GB11849@redhat.com>
 <1342540301.2229.117.camel@bling.home>
 <20120717155701.GB12001@redhat.com>
 <1342541301.2229.125.camel@bling.home>
 <20120717161452.GA12114@redhat.com>
 <20120718062742.GH6479@redhat.com>
 <20120718102029.GA4650@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120718102029.GA4650@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 01:20:29PM +0300, Michael S. Tsirkin wrote:
> On Wed, Jul 18, 2012 at 09:27:42AM +0300, Gleb Natapov wrote:
> > On Tue, Jul 17, 2012 at 07:14:52PM +0300, Michael S. Tsirkin wrote:
> > > > _Seems_ racy, or _is_ racy?  Please identify the race.
> > > 
> > > Look at this:
> > > 
> > > static inline int kvm_irq_line_state(unsigned long *irq_state,
> > >                                      int irq_source_id, int level)
> > > {
> > >         /* Logical OR for level trig interrupt */
> > >         if (level)
> > >                 set_bit(irq_source_id, irq_state);
> > >         else
> > >                 clear_bit(irq_source_id, irq_state);
> > > 
> > >         return !!(*irq_state);
> > > }
> > > 
> > > 
> > > Now:
> > > If other CPU changes some other bit after the atomic change,
> > > it looks like !!(*irq_state) might return a stale value.
> > > 
> > > CPU 0 clears bit 0. CPU 1 sets bit 1. CPU 1 sets level to 1.
> > > If CPU 0 sees a stale value now it will return 0 here
> > > and interrupt will get cleared.
> > > 
> > This will hardly happen on x86 especially since bit is set with
> > serialized instruction.
> 
> Probably. But it does make me a bit uneasy.  Why don't we pass
> irq_source_id to kvm_pic_set_irq/kvm_ioapic_set_irq, and move
> kvm_irq_line_state to under pic_lock/ioapic_lock?  We can then use
> __set_bit/__clear_bit in kvm_irq_line_state, making the ordering simpler
> and saving an atomic op in the process.
> 
With my patch I do not see why we can't change them to unlocked variant
without moving them anywhere. The only requirement is to not use RMW
sequence to set/clear bits. The ordering of setting does not matter. The
ordering of reading is.

--
			Gleb.

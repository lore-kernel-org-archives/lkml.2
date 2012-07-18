Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab2GRLIN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 07:08:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57804 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387Ab2GRLIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 07:08:11 -0400
Date: Wed, 18 Jul 2012 14:08:43 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, avi@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com
Subject: Re: [PATCH v5 3/4] kvm: Create kvm_clear_irq()
Message-ID: <20120718110843.GI4700@redhat.com>
References: <20120717155701.GB12001@redhat.com>
 <1342541301.2229.125.camel@bling.home>
 <20120717161452.GA12114@redhat.com>
 <20120718062742.GH6479@redhat.com>
 <20120718102029.GA4650@redhat.com>
 <20120718102739.GB26120@redhat.com>
 <20120718103335.GB4700@redhat.com>
 <20120718103608.GC26120@redhat.com>
 <20120718105105.GG4700@redhat.com>
 <20120718105315.GF26120@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120718105315.GF26120@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 01:53:15PM +0300, Gleb Natapov wrote:
> On Wed, Jul 18, 2012 at 01:51:05PM +0300, Michael S. Tsirkin wrote:
> > On Wed, Jul 18, 2012 at 01:36:08PM +0300, Gleb Natapov wrote:
> > > On Wed, Jul 18, 2012 at 01:33:35PM +0300, Michael S. Tsirkin wrote:
> > > > On Wed, Jul 18, 2012 at 01:27:39PM +0300, Gleb Natapov wrote:
> > > > > On Wed, Jul 18, 2012 at 01:20:29PM +0300, Michael S. Tsirkin wrote:
> > > > > > On Wed, Jul 18, 2012 at 09:27:42AM +0300, Gleb Natapov wrote:
> > > > > > > On Tue, Jul 17, 2012 at 07:14:52PM +0300, Michael S. Tsirkin wrote:
> > > > > > > > > _Seems_ racy, or _is_ racy?  Please identify the race.
> > > > > > > > 
> > > > > > > > Look at this:
> > > > > > > > 
> > > > > > > > static inline int kvm_irq_line_state(unsigned long *irq_state,
> > > > > > > >                                      int irq_source_id, int level)
> > > > > > > > {
> > > > > > > >         /* Logical OR for level trig interrupt */
> > > > > > > >         if (level)
> > > > > > > >                 set_bit(irq_source_id, irq_state);
> > > > > > > >         else
> > > > > > > >                 clear_bit(irq_source_id, irq_state);
> > > > > > > > 
> > > > > > > >         return !!(*irq_state);
> > > > > > > > }
> > > > > > > > 
> > > > > > > > 
> > > > > > > > Now:
> > > > > > > > If other CPU changes some other bit after the atomic change,
> > > > > > > > it looks like !!(*irq_state) might return a stale value.
> > > > > > > > 
> > > > > > > > CPU 0 clears bit 0. CPU 1 sets bit 1. CPU 1 sets level to 1.
> > > > > > > > If CPU 0 sees a stale value now it will return 0 here
> > > > > > > > and interrupt will get cleared.
> > > > > > > > 
> > > > > > > This will hardly happen on x86 especially since bit is set with
> > > > > > > serialized instruction.
> > > > > > 
> > > > > > Probably. But it does make me a bit uneasy.  Why don't we pass
> > > > > > irq_source_id to kvm_pic_set_irq/kvm_ioapic_set_irq, and move
> > > > > > kvm_irq_line_state to under pic_lock/ioapic_lock?  We can then use
> > > > > > __set_bit/__clear_bit in kvm_irq_line_state, making the ordering simpler
> > > > > > and saving an atomic op in the process.
> > > > > > 
> > > > > With my patch I do not see why we can't change them to unlocked variant
> > > > > without moving them anywhere. The only requirement is to not use RMW
> > > > > sequence to set/clear bits. The ordering of setting does not matter. The
> > > > > ordering of reading is.
> > > > 
> > > > You want to use __set_bit/__clear_bit on the same word
> > > > from multiple CPUs, without locking?
> > > > Why won't this lose information?
> > > Because it is not RMW. If it is then yes, you can't do that.
> > 
> > You are saying __set_bit does not do RMW on x86? Interesting.
> I think it doesn't.

Anywhere I can read about this?

> > It's probably not a good idea to rely on this I think.
> > 
> The code is no in arch/x86 so probably no. Although it is used only on
> x86 (and ia64 which has broken kvm anyway).

Yes but exactly the reverse is documented.

/**
 * __set_bit - Set a bit in memory
 * @nr: the bit to set
 * @addr: the address to start counting from
 *
 * Unlike set_bit(), this function is non-atomic and may be reordered.


>>>> pls note the below

 * If it's called on the same region of memory simultaneously, the effect
 * may be that only one operation succeeds.
>>>> until here

 */
static inline void __set_bit(int nr, volatile unsigned long *addr)
{
        asm volatile("bts %1,%0" : ADDR : "Ir" (nr) : "memory");
}




> > > > 
> > > > In any case, it seems simpler and safer to do accesses under lock
> > > > than rely on specific use.
> > > > 
> > > > > --
> > > > > 			Gleb.
> > > 
> > > --
> > > 			Gleb.
> 
> --
> 			Gleb.

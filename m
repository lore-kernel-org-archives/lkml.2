Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab2G3QGe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 12:06:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753073Ab2G3QGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 12:06:33 -0400
Message-ID: <1343664390.8073.93.camel@ul30vt>
Subject: Re: [PATCH v7 1/2] kvm: Extend irqfd to support level interrupts
From: Alex Williamson <alex.williamson@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: avi@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jan.kiszka@siemens.com
Date: Mon, 30 Jul 2012 10:06:30 -0600
In-Reply-To: <20120729150128.GE14278@redhat.com>
References: <20120724203628.21081.56884.stgit@bling.home>
	 <20120724204311.21081.95028.stgit@bling.home>
	 <20120729150128.GE14278@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-07-29 at 18:01 +0300, Michael S. Tsirkin wrote:
> On Tue, Jul 24, 2012 at 02:43:14PM -0600, Alex Williamson wrote:
> > In order to inject a level interrupt from an external source using an
> > irqfd, we need to allocate a new irq_source_id.  This allows us to
> > assert and (later) de-assert an interrupt line independently from
> > users of KVM_IRQ_LINE and avoid lost interrupts.
> > 
> > We also add what may appear like a bit of excessive infrastructure
> > around an object for storing this irq_source_id.  However, notice
> > that we only provide a way to assert the interrupt here.  A follow-on
> > interface will make use of the same irq_source_id to allow de-assert.
> > 
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> 
> I think this tracking of source ids is the root of all the problems
> you see with this patchset.
> 
> A source ID is required for an irqfd to be created.
> But if source ID exists after irqfd is destroyed then
> the next create will fail.

Only if there are no available source IDs.

> So the only sane thing to do is to make irqfd manage this resource,
> clean it up completely when irqfd is gone.
> 
> Not to mention, the patch will be smaller :)

The only sane way to do that is to pull the eoifd into KVM_IRQFD and set
them up together.  That's actually what v1 of this endeavor did.  My
intention with splitting eoifd from irqfd is that I think EOI
notification is potentially useful outside of this usage with irqfds and
I wanted an interface that could be used independently.  Someday, an
irqfd may not be the only way to generate a key.  Userspace may also
wish to register to receive notification-only for the existing user
source ID.

I do not think it's sane to have an eoifd configured using KVM_EOIFD and
destroyed using KVM_IRQFD.  As for smaller patch, I'm not convinced.  We
still have to watch for POLLHUP, which pulls in the bulk of the code.
And using the above approach of pulling eoifd setup into irqfd we have
to address what happens to the combined set when either eventfd is
closed.  By your argument closing the irqfd closes the eoifd, but does
closing the eoifd necessarily close the irqfd.  If not then we end up
with the question of how can an eoifd be added to an existing irqfd.



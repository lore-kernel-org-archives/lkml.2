Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408Ab2GSR3n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 13:29:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46681 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281Ab2GSR3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 13:29:41 -0400
Message-ID: <1342718978.3142.26.camel@ul30vt>
Subject: Re: [PATCH v5 0/4] kvm: level irqfd and new eoifd
From: Alex Williamson <alex.williamson@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: avi@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jan.kiszka@siemens.com
Date: Thu, 19 Jul 2012 11:29:38 -0600
In-Reply-To: <20120719165944.GB17213@redhat.com>
References: <20120716202711.1752.71007.stgit@bling.home>
	 <20120719165944.GB17213@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-19 at 19:59 +0300, Michael S. Tsirkin wrote:
> On Mon, Jul 16, 2012 at 02:33:38PM -0600, Alex Williamson wrote:
> > v5:
> >  - irqfds now have a one-to-one mapping with eoifds to prevent users
> >    from consuming all of kernel memory by repeatedly creating eoifds
> >    from a single irqfd.
> >  - implement a kvm_clear_irq() which does a test_and_clear_bit of
> >    the irq_state, only updating the pic/ioapic if changes and allowing
> >    the caller to know if anything was done.  I added this onto the end
> >    as it's essentially an optimization on the previous design.  It's
> >    hard to tell if there's an actual performance benefit to this.
> >  - dropped eoifd gsi support patch as it was only an FYI.
> > 
> > Thanks,
> > 
> > Alex
> 
> 
> So 3/4, 4/4 are racy and I think you convinced me it's best to drop it for
> now. I hope that fact that we already scan all vcpus under spinlock for
> level interrupts is enough to justify adding a lock here.
> 
> To summarize issues still outstanding with 1/2, 2/2:
(a)
> - source id lingering after irqfd was destroyed/deassigned
>   prevents assigning a new irqfd
(b)
> - if same irqfd is deassigned and re-assigned, this
>   seems to succeed but does not give any more EOIs
(c)
> - document that user needs to re-inject interrupts
>   injected by level IRQFD after migration as they are cleared
> 
> Hope this helps!

Thanks, I'm refining and testing a re-write.  One thing I also noticed
is that we don't do anything when the eoifd is closed.  We'll cleanup
when kvm is closed, but that can leave a lot of stray eoifds, and
therefore used irq_source_ids tied up.  So, I think I need to pull in a
lot of the irqfd code just to be able to catch the POLLHUP and do
cleanup.  Fixing (a) is a simple flush, so I already added that.  To
solve (b), I think that saving the irqfd eventfd ctx was a bad idea.
The new api I will propose to solve it is that kvm_irqfd returns a token
(or key) when used as a level irqfd (actually the irq source id, but the
user shouldn't care what it is).  We pass that into eoifd instead of the
irqfd.  That means that if the irqfd is closed and re-configured, the
user will get a new key and should have no expectation that it's tied to
the previous eoifd.  I'll add a comment for (c).  Thanks,

Alex


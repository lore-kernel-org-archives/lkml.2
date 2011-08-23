Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab1HWOPI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 10:15:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60968 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934Ab1HWOPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 10:15:04 -0400
Date: Tue, 23 Aug 2011 10:14:52 -0400
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        LKML <linux-kernel@vger.kernel.org>, jason.wessel@windriver.com
Subject: Re: [RFC][PATCH 2/6] x86, nmi: create new NMI handler routines
Message-ID: <20110823141452.GL2067@redhat.com>
References: <1313786266-9585-1-git-send-email-dzickus@redhat.com>
 <1313786266-9585-3-git-send-email-dzickus@redhat.com>
 <1314022580.24275.33.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314022580.24275.33.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 04:16:20PM +0200, Peter Zijlstra wrote:
> On Fri, 2011-08-19 at 16:37 -0400, Don Zickus wrote:
> > +static struct nmiaction *__free_nmi(unsigned int type, const char *name)
> > +{
> > +       struct nmi_desc *desc = nmi_to_desc(type);
> > +       struct nmiaction *n, **np = &(desc->head);
> > +       unsigned long flags;
> > +
> > +       spin_lock_irqsave(&desc->lock, flags);
> > +
> ...
> > +
> > +       spin_unlock_irqrestore(&desc->lock, flags);
> > +       synchronize_rcu();
> > +       return *np;
> > +}
> 
> > +void unregister_nmi_handler(unsigned int type, const char *name)
> > +{
> > +       kfree(__free_nmi(type, name));
> > +}
> 
> This code is weird.. why not have the kfree() in __free_nmi(), also why
> use sync_rcu() and not use kfree_rcu()?

I was looking at trying to use kfree_rcu and noticed I would have to add
another element to the nmiaction struct and another function as a callback
to kfree the memory from the device name.  The overhead didn't seem worth
it.  For some reason it just seems simpler to keep it the way it is and
just have

	struct nmiaction *a;

	a = __free_nmi(type, name);
	if (a) {
		kfree(a->name);
		kfree(a);
	}

(side note:  I was keeping the kfree()s in here for symmetry with the
registration handler).

Maybe I don't understand kfree_rcu, but what advantage do I have by
placing rcu_head into nmiaction that never gets used except on unregister
(which rarely happens to begin with)?

Cheers,
Don

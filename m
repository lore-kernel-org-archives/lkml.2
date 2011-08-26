Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846Ab1HZOVt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 10:21:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60785 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710Ab1HZOVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 10:21:48 -0400
Date: Fri, 26 Aug 2011 10:21:04 -0400
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com
Subject: Re: [V3][PATCH 2/6] x86, nmi: create new NMI handler routines
Message-ID: <20110826142104.GW2067@redhat.com>
References: <1314290748-23569-1-git-send-email-dzickus@redhat.com>
 <1314290748-23569-3-git-send-email-dzickus@redhat.com>
 <1314351852.9377.1.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314351852.9377.1.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 11:44:12AM +0200, Peter Zijlstra wrote:
> On Thu, 2011-08-25 at 12:45 -0400, Don Zickus wrote:
> > +static int __setup_nmi(unsigned int type, struct nmiaction *action)
> > +{
> > +       struct nmi_desc *desc = nmi_to_desc(type);
> > +       struct nmiaction **a = &(desc->head);
> > +       unsigned long flags;
> > +
> > +       spin_lock_irqsave(&desc->lock, flags);
> > +
> > +       /*
> > +        * some handlers need to be executed first otherwise a fake
> > +        * event confuses some handlers (kdump uses this flag)
> > +        */
> > +       if (!(action->flags & NMI_FLAG_FIRST))
> > +               while ((*a) != NULL)
> > +                       a = &((*a)->next);
> > +       
> > +       action->next = *a;
> > +       rcu_assign_pointer(*a, action);
> > +
> > +       spin_unlock_irqrestore(&desc->lock, flags);
> > +       return 0;
> > +}
> > +
> > +static struct nmiaction *__free_nmi(unsigned int type, const char *name)
> > +{
> > +       struct nmi_desc *desc = nmi_to_desc(type);
> > +       struct nmiaction *n, **np = &(desc->head);
> > +       unsigned long flags;
> > +
> > +       spin_lock_irqsave(&desc->lock, flags);
> > +
> > +       while ((*np) != NULL) {
> > +               n = *np;
> > +
> > +               /*
> > +                * the name passed in to describe the nmi handler
> > +                * is used as the lookup key
> > +                */
> > +               if (!strcmp(n->name, name)) {
> > +                       WARN(in_nmi(),
> > +                               "Trying to free NMI (%s) from NMI context!\n", n->name);
> > +                       rcu_assign_pointer(*np, n->next);
> > +                       break;
> > +               }
> > +               np = &(n->next);
> > +       }
> > +
> > +       spin_unlock_irqrestore(&desc->lock, flags);
> > +       synchronize_rcu();
> > +       return (*np);
> > +} 
> 
> Probably not worth fixing, but if someone was silly enough to register
> with an already existing name we're up shit creek, right? :-)

Hmm, I thought I put a check in there during registration to prevent that.
Guess not.  But yeah, I thought about doing that just to have one less
thing bite me later.

Cheers,
Don

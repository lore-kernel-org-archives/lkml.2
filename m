Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab1HZJog (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 05:44:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52361 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948Ab1HZJoe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 05:44:34 -0400
Subject: Re: [V3][PATCH 2/6] x86, nmi: create new NMI handler routines
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com
Date: Fri, 26 Aug 2011 11:44:12 +0200
In-Reply-To: <1314290748-23569-3-git-send-email-dzickus@redhat.com>
References: <1314290748-23569-1-git-send-email-dzickus@redhat.com>
	 <1314290748-23569-3-git-send-email-dzickus@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314351852.9377.1.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-25 at 12:45 -0400, Don Zickus wrote:
> +static int __setup_nmi(unsigned int type, struct nmiaction *action)
> +{
> +       struct nmi_desc *desc = nmi_to_desc(type);
> +       struct nmiaction **a = &(desc->head);
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&desc->lock, flags);
> +
> +       /*
> +        * some handlers need to be executed first otherwise a fake
> +        * event confuses some handlers (kdump uses this flag)
> +        */
> +       if (!(action->flags & NMI_FLAG_FIRST))
> +               while ((*a) != NULL)
> +                       a = &((*a)->next);
> +       
> +       action->next = *a;
> +       rcu_assign_pointer(*a, action);
> +
> +       spin_unlock_irqrestore(&desc->lock, flags);
> +       return 0;
> +}
> +
> +static struct nmiaction *__free_nmi(unsigned int type, const char *name)
> +{
> +       struct nmi_desc *desc = nmi_to_desc(type);
> +       struct nmiaction *n, **np = &(desc->head);
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&desc->lock, flags);
> +
> +       while ((*np) != NULL) {
> +               n = *np;
> +
> +               /*
> +                * the name passed in to describe the nmi handler
> +                * is used as the lookup key
> +                */
> +               if (!strcmp(n->name, name)) {
> +                       WARN(in_nmi(),
> +                               "Trying to free NMI (%s) from NMI context!\n", n->name);
> +                       rcu_assign_pointer(*np, n->next);
> +                       break;
> +               }
> +               np = &(n->next);
> +       }
> +
> +       spin_unlock_irqrestore(&desc->lock, flags);
> +       synchronize_rcu();
> +       return (*np);
> +} 

Probably not worth fixing, but if someone was silly enough to register
with an already existing name we're up shit creek, right? :-)

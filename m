Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab2EIFAB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 01:00:01 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41917 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813Ab2EIE76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 00:59:58 -0400
Date: Tue, 8 May 2012 21:59:56 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, penberg@kernel.org, cl@linux.com
Subject: Re: [PATCH] slab/mempolicy: always use local policy from interrupt
 context v3
In-Reply-To: <CAHGf_=p7JbWW8jgzWGHX+xwU8JWzpSMZS0kn-rmP=eg_Uqrgow@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1205082158570.10766@chino.kir.corp.google.com>
References: <1336431315-29736-1-git-send-email-andi@firstfloor.org> <CAHGf_=p7JbWW8jgzWGHX+xwU8JWzpSMZS0kn-rmP=eg_Uqrgow@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="397155492-236837664-1336539597=:10766"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--397155492-236837664-1336539597=:10766
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Mon, 7 May 2012, KOSAKI Motohiro wrote:

> > diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
> > index 7c727a9..7106786 100644
> > --- a/include/linux/mempolicy.h
> > +++ b/include/linux/mempolicy.h
> > @@ -215,7 +215,7 @@ extern struct zonelist *huge_zonelist(struct vm_area_struct *vma,
> >  extern bool init_nodemask_of_mempolicy(nodemask_t *mask);
> >  extern bool mempolicy_nodemask_intersects(struct task_struct *tsk,
> >                                const nodemask_t *mask);
> > -extern unsigned slab_node(struct mempolicy *policy);
> > +extern unsigned slab_node(void);
> >
> >  extern enum zone_type policy_zone;
> >
> > diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> > index cfb6c86..e05e007 100644
> > --- a/mm/mempolicy.c
> > +++ b/mm/mempolicy.c
> > @@ -1586,9 +1586,11 @@ static unsigned interleave_nodes(struct mempolicy *policy)
> >  * task can change it's policy.  The system default policy requires no
> >  * such protection.
> >  */
> > -unsigned slab_node(struct mempolicy *policy)
> > +unsigned slab_node(void)
> >  {
> > -       if (!policy || policy->flags & MPOL_F_LOCAL)
> > +       struct mempolicy *policy = current->mempolicy;
> > +
> > +       if (!in_interrupt() || !policy || policy->flags & MPOL_F_LOCAL)
> >                return numa_node_id();
> 
> I think your patch is correct. but I don't like interrupt context
> dereference current task.
> It would be nice if we only see current->mempolicy when !in_interrupt.
> 
> But this doesn't mean NAK anyway.
> 
>  Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Sigh, this was acked by Christoph and KOSAKI when the logic is reversed 
and does the exact opposite of what's intended?
--397155492-236837664-1336539597=:10766--

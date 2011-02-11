Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937Ab1BKSad (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 13:30:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757888Ab1BKSab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 13:30:31 -0500
Date: Fri, 11 Feb 2011 13:30:25 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Chad Talbott <ctalbott@google.com>
Cc: jaxboe@fusionio.com, guijianfeng@cn.fujitsu.com, mrubin@google.com,
        teravest@google.com, jmoyer@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Avoid preferential treatment of groups that aren't
 backlogged
Message-ID: <20110211183024.GH8773@redhat.com>
References: <20110210013211.21573.69260.stgit@neat.mtv.corp.google.com>
 <20110210040231.GD27040@redhat.com>
 <AANLkTimO+CG_iCHZ+9D1EtrZp+z0k0+xUN_WMsqU3NNk@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimO+CG_iCHZ+9D1EtrZp+z0k0+xUN_WMsqU3NNk@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 11:06:37AM -0800, Chad Talbott wrote:
> On Wed, Feb 9, 2011 at 8:02 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > - What happens when cfqd->active_generation wraps over? Should we use
> >  functions which take care of wrapping.
> 
> To be absolutely correct, you're right.  But even if the service tree
> becomes completely idle every microsecond, we still have 1/2 million
> years before the first wrap.

Ok, so I guess it fine for time being untile and unless we encounter a
really fast device. 

> 
> > - So when generation number changes you want to put the newly backlogged
> >  group at the front of tree and not at the end of it? Though it kind
> >  of make sense as any continuously backlogged groups will be on service
> >  tree for long time and newly backlogged groups are either new IO
> >  starting or some application which high think time and which does IO
> >  one in a while and does not keep disk occupied for very long time. In
> >  such cases it probably is not a bad idea to put newly backlogged
> >  groups at the beginning of the tree.
> 
> Yes, that's it exactly.
> 
> >> @@ -906,6 +905,9 @@ cfq_group_service_tree_del(struct cfq_data *cfqd, struct cfq_group *cfqg)
> >>       if (!RB_EMPTY_NODE(&cfqg->rb_node))
> >>               cfq_rb_erase(&cfqg->rb_node, st);
> >>       cfqg->saved_workload_slice = 0;
> >> +     cfqg->generation_num = cfqd->active_generation;
> >> +     if (RB_EMPTY_ROOT(&st->rb))
> >> +             cfqd->active_generation++;
> >
> > I don't understand that what is the significance behind chaning generation
> > number when tree is idle? When tree is idle does not mean that few
> > recently deleted groups will not get backlogged soon?
> 
> It's a result of being both fair and work conserving.  If *all* the
> queues are without requests, then whoever next has requests should get
> to use the disk fully to be work-conserving.  But if the disk is
> always kept busy (by anyone), then there is competition and we have to
> provide fairness.

Well, service tree being idle does not mean that nobody else is using
disk. We could have the case where service tree is idle in between while
all the readers are in their think time phase. In that case I think one
could further refine the logic where change the generation only if tree is
idle for more than slice_idle time.

But I think we can do that later if we run into some issues. For the
time being I am fine with it as it has been working for you guys.

Can you please update the patch to correct the commit description and
repost. 

Thanks
Vivek

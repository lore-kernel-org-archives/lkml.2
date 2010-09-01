Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313Ab0IAJH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 05:07:57 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39219 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab0IAJHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 05:07:53 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 1 Sep 2010 18:02:43 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Jeff Moyer <jmoyer@redhat.com>, Divyesh Shah <dpshah@google.com>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        Nauman Rafique <nauman@google.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH] cfq-iosched: add cfq group hierarchical
 scheduling support
Message-Id: <20100901180243.fe82cb61.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4C7E1359.9050105@cn.fujitsu.com>
References: <4C7B54C0.7080008@cn.fujitsu.com>
	<20100830203644.GA15903@redhat.com>
	<4C7C4CE0.5080402@cn.fujitsu.com>
	<20100831125737.GA2527@redhat.com>
	<4C7E1359.9050105@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Sep 2010 16:48:25 +0800
Gui Jianfeng <guijianfeng@cn.fujitsu.com> wrote:

> Add Kamezawa
> 
> Vivek Goyal wrote:
> > On Tue, Aug 31, 2010 at 08:29:20AM +0800, Gui Jianfeng wrote:
> >> Vivek Goyal wrote:
> >>> On Mon, Aug 30, 2010 at 02:50:40PM +0800, Gui Jianfeng wrote:
> >>>> Hi All,
> >>>>
> >>>> This patch enables cfq group hierarchical scheduling.
> >>>>
> >>>> With this patch, you can create a cgroup directory deeper than level 1.
> >>>> Now, I/O Bandwidth is distributed in a hierarchy way. For example:
> >>>> We create cgroup directories as following(the number represents weight):
> >>>>
> >>>>             Root grp
> >>>>            /       \
> >>>>        grp_1(100) grp_2(400)
> >>>>        /    \ 
> >>>>   grp_3(200) grp_4(300)
> >>>>
> >>>> If grp_2 grp_3 and grp_4 are contending for I/O Bandwidth,
> >>>> grp_2 will share 80% of total bandwidth.
> >>>> For sub_groups, grp_3 shares 8%(20% * 40%), grp_4 shares 12%(20% * 60%)
> >>>>
> >>>> Design:
> >>>>   o Each cfq group has its own group service tree. 
> >>>>   o Each cfq group contains a "group schedule entity" (gse) that 
> >>>>     schedules on parent cfq group's service tree.
> >>>>   o Each cfq group contains a "queue schedule entity"(qse), it
> >>>>     represents all cfqqs located on this cfq group. It schedules
> >>>>     on this group's service tree. For the time being, root group
> >>>>     qse's weight is 1000, and subgroup qse's weight is 500.
> >>>>   o All gses and qse which belones to a same cfq group schedules
> >>>>     on the same group service tree.
> >>> Hi Gui,
> >>>
> >>> Thanks for the patch. I have few questions.
> >>>
> >>> - So how does the hierarchy look like, w.r.t root group. Something as
> >>>   follows?
> >>>
> >>>
> >>> 			root
> >>> 		       / | \
> >>> 		     q1  q2 G1
> >>>
> >>> Assume there are two processes doin IO in root group and q1 and q2 are
> >>> cfqq queues for those processes and G1 is the cgroup created by user.
> >>>
> >>> If yes, then what algorithm do you use to do scheduling between q1, q2
> >>> and G1? IOW, currently we have two algorithms operating in CFQ. One for
> >>> cfqq and other for groups. Group algorithm does not use the logic of
> >>> cfq_slice_offset().
> >> Hi Vivek,
> >>
> >> This patch doesn't break the original sheduling logic. That is cfqg => st => cfqq.
> >> If q1 and q2 in root group, I treat q1 and q2 bundle as a queue sched entity, and
> >> it will schedule on root group service with G1, as following:
> >>
> >>                          root group
> >>                         /         \
> >>                     qse(q1,q2)    gse(G1)
> >>
> > 
> > Ok. That's interesting. That raises another question that how hierarchy
> > should look like. IOW, how queue and groups should be treated in
> > hierarchy.
> > 
> > CFS cpu scheduler treats queues and group at the same level. That is as
> > follows.
> > 
> > 			root
> > 			/ | \
> > 		       q1 q2 G1
> > 
> > In the past I had raised this question and Jens and corrado liked treating
> > queues and group at same level.
> > 
> > Logically, q1, q2 and G1 are all children of root, so it makes sense to
> > treat them at same level and not group q1 and q2 in to a single entity and
> > group.
> 
> Hi Vivek,
> 
> IMO, this new approach keeps the original scheduling logic, and keep things
> simple. And to me, this approach works for me. So i choose it.
> 
> > 
> > One of the possible way forward could be this.
> > 
> > - Treat queue and group at same level (like CFS)
> > 
> > - Get rid of cfq_slice_offset() logic. That means without idling on, there
> >   will be no ioprio difference between cfq queues. I think anyway as of 
> >   today that logic helps in so little situations that I would not mind
> >   getting rid of it. Just that Jens should agree to it.
> > 
> > - With this new scheme, it will break the existing semantics of root group
> >   being at same level as child groups. To avoid that, we can probably
> >   implement two modes (flat and hierarchical), something similar to what
> >   memory cgroup controller has done. May be one tunable in root cgroup of
> >   blkio "use_hierarchy".  By default everything will be in flat mode and
> >   if user wants hiearchical control, he needs to set user_hierarchy in
> >   root group.
> > 
> >   I think memory controller provides "use_hierarchy" tunable in each
> >   cgroup. I am not sure why do we need it in each cgroup and not just
> >   in root cgroup.
> 
> I think Kamezawa-san should be able to answer this question. :)
> 

At first, please be sure that "hierarchical accounting is _very_ slow".
Please measure how hierarchical accounting (of 4-6 levels) are slow ;)

Then, there are 2 use cases.

 1)  root/to/some/directory/A
                           /B
                           /C
                            ....
     All A, B, C ....are flat cgroup and has no relationship, not sharing limit.
     In this case, hierarchy should not be enabled.

 2)  root/to/some/directory/Gold/A,B,C...
                            Silver/D,E,F

     All A, B, C ....are limited by "Gold" or "Silver".
     But Gold and Silver has no relationthip, they has their own limitations.
     But A, B, C, D, E, F shares limit under Gold or Silver.
     In this case, hierarchy
     "root/to/some/directory" should be disabled.
      Gold/ and Silver should have use_hierarchy=1.

(Assume these Gold and Silver as Container and the user of container
 divides memory into A and B, C...)

For example,  libvirt makes very long "root/to/some/directory" ...
I never want to count-up all counters in the hierarchy even if
we'd like to use some fantasic hierarchical accounting under a container.

I don't like "all or nothing" option (as making use_hierarchy as mount
option or has parameter on root cgroup etc..) Then, allowed mixture.


Thanks,
-Kame




 







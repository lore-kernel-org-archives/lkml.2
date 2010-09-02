Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab0IBCre (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 22:47:34 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47946 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297Ab0IBCrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 22:47:33 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 2 Sep 2010 11:42:27 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Gui Jianfeng <guijianfeng@cn.fujitsu.com>, Jens Axboe <axboe@kernel.dk>,
        Jeff Moyer <jmoyer@redhat.com>, Divyesh Shah <dpshah@google.com>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        Nauman Rafique <nauman@google.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH] cfq-iosched: add cfq group hierarchical
 scheduling support
Message-Id: <20100902114227.34562723.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100902022936.GB7901@redhat.com>
References: <4C7B54C0.7080008@cn.fujitsu.com>
	<20100830203644.GA15903@redhat.com>
	<4C7C4CE0.5080402@cn.fujitsu.com>
	<20100831125737.GA2527@redhat.com>
	<4C7E1359.9050105@cn.fujitsu.com>
	<20100901180243.fe82cb61.kamezawa.hiroyu@jp.fujitsu.com>
	<20100902022936.GB7901@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Sep 2010 22:29:36 -0400
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Wed, Sep 01, 2010 at 06:02:43PM +0900, KAMEZAWA Hiroyuki wrote:
> 
> [..]
> > > > One of the possible way forward could be this.
> > > > 
> > > > - Treat queue and group at same level (like CFS)
> > > > 
> > > > - Get rid of cfq_slice_offset() logic. That means without idling on, there
> > > >   will be no ioprio difference between cfq queues. I think anyway as of 
> > > >   today that logic helps in so little situations that I would not mind
> > > >   getting rid of it. Just that Jens should agree to it.
> > > > 
> > > > - With this new scheme, it will break the existing semantics of root group
> > > >   being at same level as child groups. To avoid that, we can probably
> > > >   implement two modes (flat and hierarchical), something similar to what
> > > >   memory cgroup controller has done. May be one tunable in root cgroup of
> > > >   blkio "use_hierarchy".  By default everything will be in flat mode and
> > > >   if user wants hiearchical control, he needs to set user_hierarchy in
> > > >   root group.
> > > > 
> > > >   I think memory controller provides "use_hierarchy" tunable in each
> > > >   cgroup. I am not sure why do we need it in each cgroup and not just
> > > >   in root cgroup.
> > > 
> > > I think Kamezawa-san should be able to answer this question. :)
> > > 
> > 
> > At first, please be sure that "hierarchical accounting is _very_ slow".
> > Please measure how hierarchical accounting (of 4-6 levels) are slow ;)
> > 
> > Then, there are 2 use cases.
> > 
> >  1)  root/to/some/directory/A
> >                            /B
> >                            /C
> >                             ....
> >      All A, B, C ....are flat cgroup and has no relationship, not sharing limit.
> >      In this case, hierarchy should not be enabled.
> > 
> >  2)  root/to/some/directory/Gold/A,B,C...
> >                             Silver/D,E,F
> > 
> >      All A, B, C ....are limited by "Gold" or "Silver".
> >      But Gold and Silver has no relationthip, they has their own limitations.
> >      But A, B, C, D, E, F shares limit under Gold or Silver.
> >      In this case, hierarchy
> >      "root/to/some/directory" should be disabled.
> >       Gold/ and Silver should have use_hierarchy=1.
> > 
> > (Assume these Gold and Silver as Container and the user of container
> >  divides memory into A and B, C...)
> > 
> > For example,  libvirt makes very long "root/to/some/directory" ...
> > I never want to count-up all counters in the hierarchy even if
> > we'd like to use some fantasic hierarchical accounting under a container.
> > 
> > I don't like "all or nothing" option (as making use_hierarchy as mount
> > option or has parameter on root cgroup etc..) Then, allowed mixture.
> 
> Hi Kame San,
> 
> If you don't want any relationship between Gold and Silver then one can
> make root as unlimited group (limit_in_bytes = -1) and practically Gold
> and Silver have no dependency. There is no need of setting use_hierarchy
> different at root level and inside Gold/ and Silver/ groups?
> 
and counts up 4 levels accounting ? ;)

We allow mixuture of 
	/root/to/some/directory/Gold/
			       /Silver
	     /Extraone

Gold and Silver can be under some limitation, of course.

(For example, Extraone is for system-admin and not-for-user.
 System admin is in another container than users.)



> It sounds like you did it for two reasons.
> 
> - It can potentially provide more flexibility. 
Right.

> - performance reason so that you can stop do hierarchical accounting
>   all the way to root and stop before that (libvirt example).
Yes.


> 
> I think for blkio controller we can probably begin with either a mount
> time option or a use_hierachy file in root group and then later make
> it per group if there are use cases.
> 

I hope something flexible. Complexity to the code is not very big.

Thanks,
-Kame


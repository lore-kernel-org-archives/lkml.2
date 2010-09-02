Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab0IBCaH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 22:30:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323Ab0IBC3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 22:29:55 -0400
Date: Wed, 1 Sep 2010 22:29:36 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Gui Jianfeng <guijianfeng@cn.fujitsu.com>, Jens Axboe <axboe@kernel.dk>,
        Jeff Moyer <jmoyer@redhat.com>, Divyesh Shah <dpshah@google.com>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        Nauman Rafique <nauman@google.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH] cfq-iosched: add cfq group hierarchical scheduling
 support
Message-ID: <20100902022936.GB7901@redhat.com>
References: <4C7B54C0.7080008@cn.fujitsu.com>
 <20100830203644.GA15903@redhat.com>
 <4C7C4CE0.5080402@cn.fujitsu.com>
 <20100831125737.GA2527@redhat.com>
 <4C7E1359.9050105@cn.fujitsu.com>
 <20100901180243.fe82cb61.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100901180243.fe82cb61.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 01, 2010 at 06:02:43PM +0900, KAMEZAWA Hiroyuki wrote:

[..]
> > > One of the possible way forward could be this.
> > > 
> > > - Treat queue and group at same level (like CFS)
> > > 
> > > - Get rid of cfq_slice_offset() logic. That means without idling on, there
> > >   will be no ioprio difference between cfq queues. I think anyway as of 
> > >   today that logic helps in so little situations that I would not mind
> > >   getting rid of it. Just that Jens should agree to it.
> > > 
> > > - With this new scheme, it will break the existing semantics of root group
> > >   being at same level as child groups. To avoid that, we can probably
> > >   implement two modes (flat and hierarchical), something similar to what
> > >   memory cgroup controller has done. May be one tunable in root cgroup of
> > >   blkio "use_hierarchy".  By default everything will be in flat mode and
> > >   if user wants hiearchical control, he needs to set user_hierarchy in
> > >   root group.
> > > 
> > >   I think memory controller provides "use_hierarchy" tunable in each
> > >   cgroup. I am not sure why do we need it in each cgroup and not just
> > >   in root cgroup.
> > 
> > I think Kamezawa-san should be able to answer this question. :)
> > 
> 
> At first, please be sure that "hierarchical accounting is _very_ slow".
> Please measure how hierarchical accounting (of 4-6 levels) are slow ;)
> 
> Then, there are 2 use cases.
> 
>  1)  root/to/some/directory/A
>                            /B
>                            /C
>                             ....
>      All A, B, C ....are flat cgroup and has no relationship, not sharing limit.
>      In this case, hierarchy should not be enabled.
> 
>  2)  root/to/some/directory/Gold/A,B,C...
>                             Silver/D,E,F
> 
>      All A, B, C ....are limited by "Gold" or "Silver".
>      But Gold and Silver has no relationthip, they has their own limitations.
>      But A, B, C, D, E, F shares limit under Gold or Silver.
>      In this case, hierarchy
>      "root/to/some/directory" should be disabled.
>       Gold/ and Silver should have use_hierarchy=1.
> 
> (Assume these Gold and Silver as Container and the user of container
>  divides memory into A and B, C...)
> 
> For example,  libvirt makes very long "root/to/some/directory" ...
> I never want to count-up all counters in the hierarchy even if
> we'd like to use some fantasic hierarchical accounting under a container.
> 
> I don't like "all or nothing" option (as making use_hierarchy as mount
> option or has parameter on root cgroup etc..) Then, allowed mixture.

Hi Kame San,

If you don't want any relationship between Gold and Silver then one can
make root as unlimited group (limit_in_bytes = -1) and practically Gold
and Silver have no dependency. There is no need of setting use_hierarchy
different at root level and inside Gold/ and Silver/ groups?

It sounds like you did it for two reasons.

- It can potentially provide more flexibility. 
- performance reason so that you can stop do hierarchical accounting
  all the way to root and stop before that (libvirt example).

I think for blkio controller we can probably begin with either a mount
time option or a use_hierachy file in root group and then later make
it per group if there are use cases.

Vivek

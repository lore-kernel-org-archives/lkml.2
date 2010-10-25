Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156Ab0JYU7w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 16:59:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64874 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758119Ab0JYU7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 16:59:51 -0400
Date: Mon, 25 Oct 2010 16:59:34 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Richard Kralovic <Richard.Kralovic@dcs.fmph.uniba.sk>
Cc: Milan Broz <mbroz@redhat.com>, linux-kernel@vger.kernel.org,
        device-mapper development <dm-devel@redhat.com>,
        Greg Thelen <gthelen@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: CFQ and dm-crypt
Message-ID: <20101025205934.GC23426@redhat.com>
References: <4CC439ED.8090400@dcs.fmph.uniba.sk>
 <4CC45BAD.2060308@redhat.com>
 <4CC553A3.5070308@dcs.fmph.uniba.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC553A3.5070308@dcs.fmph.uniba.sk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 25, 2010 at 11:53:39AM +0200, Richard Kralovic wrote:
> On 10/24/10 18:15, Milan Broz wrote:
> > On 10/24/2010 03:51 PM, Richard Kralovic wrote:
> >> CFQ io scheduler relies on using task_struct current to determine which
> >> process makes the io request. On the other hand, some dm modules (such
> >> as dm-crypt) use separate threads for doing io. As CFQ sees only these
> >> threads, it provides a very poor performance in such a case.
> >>
> >> IMHO the correct solution for this would be to store, for every io
> >> request, the process that initiated it (and preserve this information
> >> while the request is processed by device mapper). Would that be feasible?
> > 
> > Yes, this seems to be correct solution. I think this should be
> > handled by core device-mapper (as you noted, more dm targets using
> > threads to process.)
> 

Richard,

So what problem are you facing? I know you are referring to CFQ ioprio not
working with dm targets but how does it impact you? So it is not about
overall disk performance or any slow down with dm-crypt target but just
about prioritizing your IO over other?

> Do you think it is possible to handle this in device-mapper, without any
> support from the cfq code?
> 
> I also noticed that a solution for this problem was proposed a few years
> ago by Hirokazu Takahashi (a patch for linux-2.6.25,
> http://lkml.org/lkml/2008/4/22/193), but there was no response to it. Is
> such an approach wrong?

Conceptually it makes sense to put some kind of info in bio so that we
can associate with right context. I think above thread kind of of died
down.

Re-reading the thread now, and it looks like that Hirokazu also planned
to use this info for associating IO to right cgroup for WRITES. There
was alternative approach of "IO tracking" where IO controller cgroup
info was to be put in page_cgroup structure and once the bio is submitted
to CFQ, it will trace the page/page_cgroup for bio and extract the 
cgroup info and attribute IO to right group.

Storing some info in page_cgroup makes it dependent on memory controller
and which should not be a necessary thing for READS. For WRITES it probably
is still a necessary thing as it also provides (work in progress from greg)
per cgroup dirty ratio.

Storing some kind of io context info in bio makes sense to me. Not sure
if Jens has other ideas.

Thanks
Vivek
 

> 
> >> Other possibility is to avoid using separate threads for doing io in dm
> >> modules. The attached patch (against 2.6.36) modifies dm-crypt in this
> >> way, what results into much better behavior of cfq (e.g., io priorities
> >> work correctly).
> > 
> > Sorry, this completely dismantles the way how dm-crypt solves problems
> > with stacking dm devices.
> > Basically it reintroduces possible deadlocks for low memory
> > situations (the reason why there are these threads).
> 
> Would the problem with deadlock be still present if the io worker queue
> was used for writes only, but reads were issued directly? (Even this
> would be a significant improvement for people using cfq and a full-disk
> encryption over dm-crypt, since asynchronous writes are not supported by
> cfq anyway.)
> 
> 	Richard
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453Ab1CKQjp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 11:39:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298Ab1CKQjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 11:39:44 -0500
Date: Fri, 11 Mar 2011 11:39:27 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Justin TerAvest <teravest@google.com>
Cc: m-ikeda@ds.jp.nec.com, jaxboe@fusionio.com, linux-kernel@vger.kernel.org,
        ryov@valinux.co.jp, taka@valinux.co.jp, kamezawa.hiroyu@jp.fujitsu.com,
        righi.andrea@gmail.com, guijianfeng@cn.fujitsu.com,
        balbir@linux.vnet.ibm.com, ctalbott@google.com, nauman@google.com,
        mrubin@google.com
Subject: Re: [RFC] [PATCH 0/6] Provide cgroup isolation for buffered writes.
Message-ID: <20110311163927.GA4104@redhat.com>
References: <1299619256-12661-1-git-send-email-teravest@google.com>
 <20110308224325.GK27455@redhat.com>
 <20110308225059.GL27455@redhat.com>
 <AANLkTinpLiFM2yoMONQYekSd4L1BgzHSUa6F+QGbW8Gr@mail.gmail.com>
 <20110311024732.GB11710@redhat.com>
 <AANLkTimP38a7i2vvUGj6bf+vkw9904SA=buZAm+85-7=@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimP38a7i2vvUGj6bf+vkw9904SA=buZAm+85-7=@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 08:07:17AM -0800, Justin TerAvest wrote:
> On Thu, Mar 10, 2011 at 6:47 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Wed, Mar 09, 2011 at 10:04:11AM -0800, Justin TerAvest wrote:
> >> On Tue, Mar 8, 2011 at 2:50 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >> > On Tue, Mar 08, 2011 at 05:43:25PM -0500, Vivek Goyal wrote:
> >> >> On Tue, Mar 08, 2011 at 01:20:50PM -0800, Justin TerAvest wrote:
> >> >> > This patchset adds tracking to the page_cgroup structure for which cgroup has
> >> >> > dirtied a page, and uses that information to provide isolation between
> >> >> > cgroups performing writeback.
> >> >> >
> >> >>
> >> >> Justin,
> >> >>
> >> >> So if somebody is trying to isolate a workload which does bunch of READS
> >> >> and lots of buffered WRITES, this patchset should help in the sense that
> >> >> all the heavy WRITES can be put into a separate cgroup of low weight?
> >> >>
> >> >> Other application which are primarily doing READS, direct WRITES or little
> >> >> bit of buffered WRITES should still get good latencies if heavy writer
> >> >> is isolated in a separate group?
> >> >>
> >> >> If yes, then this piece standalone can make sense. And once the other
> >> >> piece/patches of memory cgroup dirty ratio and cgroup aware buffered
> >> >> writeout come in, then one will be able to differentiate buffered writes
> >> >> of different groups.
> >> >
> >> > Thinking more about it, currently anyway SYNC preempts the ASYNC. So the
> >> > question would be will it help me enable get better isolation latencies
> >> > of READS agains buffered WRITES?
> >>
> >> Ah! Sorry, I left out a patch that disables cross-group preemption.
> >> I'll add that to the patchset and email out v2 soon.
> >
> > Well, what I was referring to that even in current code sync preempts
> > all async in CFQ. So it looks like this patchset will not help get
> > better latencies in presence of WRITES?
> 
> Hi Vivek,
> 
> I should have been more clear. I forgot to include a patch that
> changes the behavior of that preemption. I haven't mailed out v2 yet
> because I was also writing a change to put the css_id in pc->flags
> instead of its own field.
> 
> The preemption change would look like:
> 
>     Previously, a sync queue in can preempt an async queue in another
>     cgroup. This changes that behavior to disallow such preemption.
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index ab7a216..0494c0c 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -3390,6 +3390,9 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue
>         if (!cfqq)
>                 return false;
> 
> +       if (new_cfqq->cfqg != cfqq->cfqg)
> +               return false;
> +
>         if (cfq_class_idle(new_cfqq))
>                 return false;
> 
> @@ -3409,9 +3412,6 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue
>         if (rq_is_sync(rq) && !cfq_cfqq_sync(cfqq))
>                 return true;
> 
> -       if (new_cfqq->cfqg != cfqq->cfqg)
> -               return false;
> 
> I will include the test results that show that isolation is also
> improved between a reader and a buffered writer.
> 

Justin,

Right now all the async queues go in one cgroup and that is root cgroup.
So it is perfectly fine to let sync preempt async.

I will be interested in seeing the results. But do you have a theoritical
explanation also that why with this patch set we will get better isolation
between READS and WRITES?

Especially after following patch from Shaohua Li.

commit f8ae6e3eb8251be32c6e913393d9f8d9e0609489
Author: Shaohua Li <shaohua.li@intel.com>
Date:   Fri Jan 14 08:41:02 2011 +0100

    block cfq: make queue preempt work for queues from different workload


This patch will make sure that sync always preempt async. So I am not
able to understand that how this patch series provides better latencies
for READS in presence of WRITES.

Thanks
Vivek 

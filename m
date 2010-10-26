Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759991Ab0JZQBl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 12:01:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62234 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759948Ab0JZQBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 12:01:39 -0400
Date: Tue, 26 Oct 2010 11:57:25 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Jens Axboe <axboe@kernel.dk>, Nauman Rafique <nauman@google.com>,
        Chad Talbott <ctalbott@google.com>, Divyesh Shah <dpshah@google.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4 v2] cfq-iosched: add cfq group hierarchical
 scheduling support
Message-ID: <20101026155725.GE31428@redhat.com>
References: <4CBFA64D.6050800@cn.fujitsu.com>
 <4CBFA6C9.3040604@cn.fujitsu.com>
 <20101022205437.GI7020@redhat.com>
 <4CC4EFFE.8040100@cn.fujitsu.com>
 <20101025202010.GB23426@redhat.com>
 <4CC639AD.6090900@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC639AD.6090900@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 26, 2010 at 10:15:09AM +0800, Gui Jianfeng wrote:

[..]
> >>> So I am not yet convinced that we should take the hidden group approach.
> >> Hi Vivek,
> >>
> >> In short, All of the problems are bacause of the fixed weight "Hidden group".
> >> So how about make the "hidden group" weight becoming dynamic according to
> >> the cfqq number and priority. Or whether we can export an new user interface
> >> to make "Hidden group" configurable. Thus, user can configure the "Hidden group".
> > 
> > Gui,
> > 
> > Even if you do that it will still not solve the problem of RT tread in
> > root group getting all the disk.
> 
> Hi Vivek
> 
> Next step, whether we can enable cfq group IO Class and export it in cgroup.
> So that, hidden group might boost to RT if there're RT cfqqs in it.

We can/should export notion of RT group at some point of time but again,
doing this for hidden group, again does not appeal to me.

Another analogy I was thinking about is, files and directories in a filesystem
directory. Here files and directories exist at same level. Now it is not the
case that we have files inside some hidden group which enforces additional
policies on the files and one can control that policy. Kind of sounds odd to
me...

[..]
> >>> Now coming to the question of how to resolve conflict with the cfqq queue
> >>> scheduling algorithm. Can we do following.
> >>>
> >>> - Give some kind of boost to queue entities based on their weight. So when
> >>>   queue and group entities are hanging on a service tree, they are
> >>>   scheduled according to their vdisktime, and vdisktime is calculated
> >>>   based on entitie's weight and how much time entity spent on disk just
> >>>   now.
> >>>
> >>>   Group entities can continue to follow existing method and we can try
> >>>   to reduce the vdisktime of queue entities a bit based on their priority.
> >>>
> >>>   That way, one might see some service differentiation between ioprio
> >>>   of queues and also the relative share between groups does not change.
> >>>   The only problematic part is that when queue and groups are at same
> >>>   level then it is not very predictable that group gets how much share
> >>>   and queues get how much share. But I guess this is lesser of a problem
> >>>   as compared to hidden group approach.
> >>>
> >>> Thoughts?
> >> Do you mean that let cfqq and cfq group schedule at the same service tree. If
> >> we choose a cfq queue, ok let it run. If we choose the cfq group, we should
> >> continue to choose a cfq queue in that group.
> >> If that's the case, I think the original CFQ logic has been broken.
> >> Am I missing something?
> >>
> > 
> > Can you give more details about what's broken in running CFQ queue and
> > CFQ group on same service tree?
> > 
> > To me only thing which was broken is that how to take care of giving
> > higher disk share to higher prio queue when idling is disabled. In that
> > case we don't idle on queue and after request dispatch queue is deleted
> > from service tree and when new request comes in, queue is put at the end
> > of service tree (like other entities). And this happens with queues of
> > all prio and hence the prio difference between queues is lost.
> > 
> > Currently we put all new queues at the end of service tree. If we put
> > some logic to give vdisktime boost based on priority for new queues, 
> > then we should be able to achieve the similar affect as current CFQ. Isn't
> > it?
> 
> I'm wondering if CFQ queue and CFQ group schedule on a same service tree,
> How to deal with workload type(SYNC,SYNC_NOIDLE,ASYNC) and IO Class?  

For queues we continue to derive IO class and workload type as usual. For
group entities, in the first step, we can assume them to be of class BE
and put them probably on SYNC tree. Later we can introduce prio classes
for groups also so that a user can specify RT, BE or IDLE class of groups.

Regaring workload type of group, it is a tricky business. Again, because
we idle on the group and SYNC tree contains the entities which we idle on
it might be the right place to put group entities along with SYNC cfqq
queues.

> Currently, different workload type and IO Class cfqqs are put on different
> trees. If they are scheduling on a same tree, we can't differentiate them.

I meant that we will continue to have multiple service trees per group and
cfq queue entities will continue to go onto respective service tree and
for group entities I think we can assume these to be of type SYNC. If it
becomes a problem may be we can later try to put some logic to determine
the nature of overall traffic in group and classify it as either SYNC or
SYNC-NOIDLE etc.

Thanks
Vivek

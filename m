Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965726Ab0GPOWL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 10:22:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21997 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965664Ab0GPOVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 10:21:54 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Gui Jianfeng <guijianfeng@cn.fujitsu.com>, Jens Axboe <axboe@kernel.dk>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        Shaohua Li <shaohua.li@intel.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [RFC] CFQ: Make prio_trees per cfq group basis to improve IO performance
References: <4C40247C.2010405@cn.fujitsu.com>
	<20100716140034.GC15382@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 16 Jul 2010 10:21:46 -0400
In-Reply-To: <20100716140034.GC15382@redhat.com> (Vivek Goyal's message of
	"Fri, 16 Jul 2010 10:00:34 -0400")
Message-ID: <x49y6dbv75x.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Fri, Jul 16, 2010 at 05:21:00PM +0800, Gui Jianfeng wrote:
>> Currently, prio_trees is global, and we rely on cfqq_close() to search
>> a coorperator. If the returned cfqq and the active cfqq don't belong to
>> the same group, coorperator searching fails. Actually, that's not the case.
>> Even if cfqq_close() returns a cfqq which belong to another cfq group, 
>> it's still likely that a coorperator(same cfqg) resides in prio_trees.
>> This patch introduces per cfq group prio_trees that should solve the above
>> issue.
>> 
>
> Hi Gui,
>
> I am not sure I understand the issue here.  So are you saying that once
> we find a cfqq which is close but belongs to a different group we reject
> it. But there could be another cfqq in the same group which is not as
> close but still close enough.
>
> For example, assume there are two queues q1 and q2 and in group and third
> queue q3 in group B. Assume q1 is active queue and we are searching for
> cooperator. If cooperator code finds q3 as closest then we will not pick
> this queue as it belongs to a different group. But it could happen that
> q2 is also close enough and we never considered that possibility.
>
> If yes, then its a good theoritical concern but I am worried practically
> how often does it happen. Do you have any workload which suffers because
> of this?

That was my reading.  It also means that, in the case that we have
cgroups in use, each rb tree will be smaller.

> I am not too inclined to push more complexity in CFQ until and unless we
> have a good use case.

I don't think this adds complexity, does it?  It simply moves the
priority trees up a level, which is arguably where they belong.

>> +static struct cfq_queue *
>> +cfq_prio_tree_lookup(struct cfq_group *cfqg, struct rb_root *root,
>> +		     sector_t sector, struct rb_node **ret_parent,
>> +		     struct rb_node ***rb_link)
>> +{

You can get rid of the cfqg argument.  I know you're just keeping with
the prior model (where cfqd was passed in and not used), but let's kill
it.

Cheers,
Jeff

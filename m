Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab2LKPOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 10:14:20 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41620 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab2LKPOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 10:14:18 -0500
Date: Tue, 11 Dec 2012 07:14:12 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Zhao Shuai <zhaoshuai@freebsd.org>, axboe@kernel.dk, ctalbott@google.com,
        rni@google.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: performance drop after using blkcg
Message-ID: <20121211151412.GG7084@htj.dyndns.org>
References: <CAFVn34SxqAJe_4P-WT8MOiG-kmKKD7ge96zoHXQuGqHWPgAt+A@mail.gmail.com>
 <20121211142518.GA5580@redhat.com>
 <20121211142742.GE7084@htj.dyndns.org>
 <20121211144336.GB5580@redhat.com>
 <20121211144718.GF7084@htj.dyndns.org>
 <20121211150234.GC5580@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121211150234.GC5580@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Vivek.

On Tue, Dec 11, 2012 at 10:02:34AM -0500, Vivek Goyal wrote:
> cfq_group_served() {
>         if (iops_mode(cfqd))
>                 charge = cfqq->slice_dispatch;
> 	cfqg->vdisktime += cfq_scale_slice(charge, cfqg);
> }
> 
> Isn't it effectively IOPS scheduling. One should get IOPS rate in proportion to
> their weight (as long as they can throw enough traffic at device to keep
> it busy). If not, can you please give more details about your proposal.

The problem is that we lose a lot of isolation w/o idling between
queues or groups.  This is because we switch between slices and while
a slice is in progress only ios belongint to that slice can be issued.
ie. higher priority cfqgs / cfqqs, after dispatching the ios they have
ready, lose their slice immmediately.  Lower priority slice takes over
and when hgiher priority ones get ready, they have to wait for the
lower priority one before submitting the new IOs.  In many cases, they
end up not being able to generate IOs any faster than the ones in
lower priority cfqqs/cfqgs.

This is becase we switch slices rather than iops.  We can make cfq
essentially switch iops by implementing very aggressive preemption but
I really don't see much point in that.  cfq is way too heavy and
ill-suited for high speed non-rot devices which are becoming more and
more consistent in terms of iops they can handle.

I think we need something better suited for the maturing non-rot
devices.  They're becoming very different from what cfq was built for
and we really shouldn't be maintaining several rb trees which need
full synchronization for each IO.  We're doing way too much and it
just isn't scalable.

Thanks.

-- 
tejun

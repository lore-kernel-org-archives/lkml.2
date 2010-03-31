Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932668Ab0CaXDO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 19:03:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5302 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932330Ab0CaXDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 19:03:09 -0400
Date: Thu, 1 Apr 2010 01:00:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, anfei <anfei.zhou@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       nishimura@mxp.nes.nec.co.jp,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] proc: don't take ->siglock for /proc/pid/oom_adj
Message-ID: <20100331230032.GB4025@redhat.com>
References: <20100328145528.GA14622@desktop> <20100328162821.GA16765@redhat.com> <alpine.DEB.2.00.1003281341590.30570@chino.kir.corp.google.com> <20100329112111.GA16971@redhat.com> <alpine.DEB.2.00.1003291302170.14859@chino.kir.corp.google.com> <20100330163909.GA16884@redhat.com> <20100330174337.GA21663@redhat.com> <alpine.DEB.2.00.1003301329420.5234@chino.kir.corp.google.com> <20100331185950.GB11635@redhat.com> <alpine.DEB.2.00.1003311408520.31252@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1003311408520.31252@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31, David Rientjes wrote:
>
> On Wed, 31 Mar 2010, Oleg Nesterov wrote:
>
> > David, I just can't understand why
> > 	oom-badness-heuristic-rewrite.patch
> > duplicates the related code in fs/proc/base.c and why it preserves
> > the deprecated signal->oom_adj.
>
> You could combine the two write functions together and then two read
> functions together if you'd like.

Yes,

> > 	static ssize_t oom_any_adj_write(struct file *file, const char __user *buf,
> > 						size_t count, bool deprecated_mode)
> > 	{
> >
> > 		if (depraceted_mode) {
> > 			 if (oom_score_adj == OOM_ADJUST_MAX)
> > 				oom_score_adj = OOM_SCORE_ADJ_MAX;
>
> ???

What?

> > 			 else
> > 				oom_score_adj = (oom_score_adj * OOM_SCORE_ADJ_MAX) /
> > 						-OOM_DISABLE;
> > 		}
> >
> > 		if (oom_score_adj < OOM_SCORE_ADJ_MIN ||
> > 				oom_score_adj > OOM_SCORE_ADJ_MAX)
>
> That doesn't work for depraceted_mode (sic), you'd need to test for
> OOM_ADJUST_MIN and OOM_ADJUST_MAX in that case.

Yes, probably "if (depraceted_mode)" should do more checks, I didn't try
to verify that MIN/MAX are correctly converted. I showed this code to explain
what I mean.

> There have been efforts to reuse as much of this code as possible for
> other sysctl handlers as well, you might be better off looking for

David, sorry ;) Right now I'd better try to stop the overloading of
->siglock. And, I'd like to shrink struct_signal if possible, but this
is minor.

Oleg.


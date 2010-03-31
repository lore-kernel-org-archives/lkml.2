Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509Ab0CaXdj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 19:33:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842Ab0CaXdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 19:33:37 -0400
Date: Thu, 1 Apr 2010 01:30:58 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, anfei <anfei.zhou@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       nishimura@mxp.nes.nec.co.jp,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] oom: give current access to memory reserves if it has
	been killed
Message-ID: <20100331233058.GA6081@redhat.com>
References: <20100328145528.GA14622@desktop> <20100328162821.GA16765@redhat.com> <alpine.DEB.2.00.1003281341590.30570@chino.kir.corp.google.com> <20100329112111.GA16971@redhat.com> <alpine.DEB.2.00.1003291302170.14859@chino.kir.corp.google.com> <20100330154659.GA12416@redhat.com> <alpine.DEB.2.00.1003301320020.5234@chino.kir.corp.google.com> <20100331175836.GA11635@redhat.com> <alpine.DEB.2.00.1003311342410.25284@chino.kir.corp.google.com> <20100331224904.GA4025@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100331224904.GA4025@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01, Oleg Nesterov wrote:
>
> On 03/31, David Rientjes wrote:
> >
> > On Wed, 31 Mar 2010, Oleg Nesterov wrote:
> >
> > > On 03/30, David Rientjes wrote:
> > > >
> > > > On Tue, 30 Mar 2010, Oleg Nesterov wrote:
> > > >
> > > > > Note that __oom_kill_task() does force_sig(SIGKILL) which assumes that
> > > > > ->sighand != NULL. This is not true if out_of_memory() is called after
> > > > > current has already passed exit_notify().
> > > >
> > > > We have an even bigger problem if current is in the oom killer at
> > > > exit_notify() since it has already detached its ->mm in exit_mm() :)
> > >
> > > Can't understand... I thought that in theory even kmalloc(1) can trigger
> > > oom.
> >
> > __oom_kill_task() cannot be called on a task without an ->mm.
>
> Why? You ignored this part:
>
> 	Say, right after exit_mm() we are doing acct_process(), and f_op->write()
> 	needs a page. So, you are saying that in this case __page_cache_alloc()
> 	can never trigger out_of_memory() ?
>
> why this is not possible?
>
> David, I am not arguing, I am asking.

In case I wasn't clear...

Yes, currently __oom_kill_task(p) is not possible if p->mm == NULL.

But your patch adds

	if (fatal_signal_pending(current))
		__oom_kill_task(current);

into out_of_memory().

Oleg.


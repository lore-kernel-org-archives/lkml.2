Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965895Ab0CPAFJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 20:05:09 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34460 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965855Ab0CPAFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 20:05:00 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 16 Mar 2010 09:01:24 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "kirill@shutemov.name" <kirill@shutemov.name>
Subject: Re: [PATCH 1/3] memcg: oom wakeup filter
Message-Id: <20100316090124.ab20e093.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100315145013.ee5919fd.akpm@linux-foundation.org>
References: <20100312143137.f4cf0a04.kamezawa.hiroyu@jp.fujitsu.com>
	<20100315145013.ee5919fd.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Mar 2010 14:50:13 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 12 Mar 2010 14:31:37 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > +static int memcg_oom_wake_function(wait_queue_t *wait,
> > +	unsigned mode, int sync, void *arg)
> > +{
> > +	struct mem_cgroup *wake_mem = (struct mem_cgroup *)arg;
> > +	struct oom_wait_info *oom_wait_info;
> > +
> > +	/* both of oom_wait_info->mem and wake_mem are stable under us */
> > +	oom_wait_info = container_of(wait, struct oom_wait_info, wait);
> > +
> > +	if (oom_wait_info->mem == wake_mem)
> > +		goto wakeup;
> > +	/* if no hierarchy, no match */
> > +	if (!oom_wait_info->mem->use_hierarchy || !wake_mem->use_hierarchy)
> > +		return 0;
> > +	/* check hierarchy */
> > +	if (!css_is_ancestor(&oom_wait_info->mem->css, &wake_mem->css) &&
> > +	    !css_is_ancestor(&wake_mem->css, &oom_wait_info->mem->css))
> > +		return 0;
> > +
> > +wakeup:
> > +	return autoremove_wake_function(wait, mode, sync, arg);
> > +}
> 
> What are the locking rules for calling css_is_ancestor()?

css_is_ancestor is checking css->id (and hierarchy stack). What we need here is
to guarantee css is valid object.

Here, we have reference count of both of oom_wait_info->mem and wake_mem.
Then, ->css is always vaild and it's "id" is stable under us.

Hmm, maybe this comment is too short.
/* both of oom_wait_info->mem and wake_mem are stable under us */
I'll prepare some update.


Thanks,
-Kame




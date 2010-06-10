Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758553Ab0FJCxx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 22:53:53 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:41972 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab0FJCxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 22:53:52 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 10 Jun 2010 11:49:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] memcg remove css_get/put per pages v2
Message-Id: <20100610114929.1f3fc130.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100610113424.d1037621.nishimura@mxp.nes.nec.co.jp>
References: <20100608121901.3cab9bdf.kamezawa.hiroyu@jp.fujitsu.com>
	<20100609155940.dd121130.kamezawa.hiroyu@jp.fujitsu.com>
	<20100610113424.d1037621.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jun 2010 11:34:24 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> I can't find any trivial bugs from my review at the moment.
> I'll do some tests.
> 

Thank you for review.

> Some minor commens.
> 
> On Wed, 9 Jun 2010 15:59:40 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > Still RFC, added lkml to CC: list.
> > ==
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > Now, memory cgroup increments css(cgroup subsys state)'s reference
> > count per a charged page. And the reference count is kept until
> > the page is uncharged. But this has 2 bad effect. 
> > 
> >  1. Because css_get/put calls atoimic_inc()/dec, heavy call of them
> >     on large smp will not scale well.
> >  2. Because css's refcnt cannot be in a state as "ready-to-release",
> >     cgroup's notify_on_release handler can't work with memcg.
> > 
> > This is a trial to remove css's refcnt per a page. Even if we remove
> > refcnt, pre_destroy() does enough synchronization.
> > 
> > After this patch, it seems css_get() is still called in try_charge().
> > But the logic is.
> > 
> >   1. task_lock(mm->owner)
> There is no task_lock() in this version :)
> 
yes.


> (snip)
> > @@ -4219,7 +4252,6 @@ static int mem_cgroup_do_precharge(unsig
> >  		mc.precharge += count;
> >  		VM_BUG_ON(test_bit(CSS_ROOT, &mem->css.flags));
> >  		WARN_ON_ONCE(count > INT_MAX);
> > -		__css_get(&mem->css, (int)count);
> >  		return ret;
> >  	}
> >  one_by_one:
> You can remove VM_BUG_ON() and WARN_ON_ONCE() here, too.
> 
ok.


> > @@ -4469,8 +4501,6 @@ static void mem_cgroup_clear_mc(void)
> >  			 */
> >  			res_counter_uncharge(&mc.to->res,
> >  						PAGE_SIZE * mc.moved_swap);
> > -			VM_BUG_ON(test_bit(CSS_ROOT, &mc.to->css.flags));
> > -			__css_put(&mc.to->css, mc.moved_swap);
> >  		}
> >  		/* we've already done mem_cgroup_get(mc.to) */
> >  
> > 
> And, you can remove "WARN_ON_ONCE(mc.moved_swap > INT_MAX)" at the beginning
> of this block, too.
> 
Hmm. ok.
Ah...them, this patch fixes the limitation by "css's refcnt is int" problem.
sounds nice.

Thanks,
-Kmae


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab2JRQKe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 12:10:34 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33623 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992Ab2JRQKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 12:10:32 -0400
Subject: Re: [PATCH] rcu: restore correct batch limiting
From: Eric Dumazet <eric.dumazet@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20121018152543.GI2518@linux.vnet.ibm.com>
References: <1350458052.26103.31.camel@edumazet-glaptop>
	 <20121018115859.GH2518@linux.vnet.ibm.com>
	 <1350564290.26103.1496.camel@edumazet-glaptop>
	 <20121018152543.GI2518@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Oct 2012 18:10:28 +0200
Message-ID: <1350576628.32642.14.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-18 at 08:25 -0700, Paul E. McKenney wrote:
> On Thu, Oct 18, 2012 at 02:44:50PM +0200, Eric Dumazet wrote:

> > 
> > Having 2 billions callbacks on one cpu would be problematic, I really
> > hope nobody relies on this ;)
> 
> Fair point!  ;-)
> 
> But just making everything long makes it quite easy to analyze.
> 
> > I guess the 10/infinity switch should be smarter.
> > 
> > something like the following maybe :
> > 
> > rdp->blimit = max(blimit, rdp->qlen >> 6);
> > 
> > (if queue is big, dont wait to hit 10000 before allowing more items to
> > be handled per round)
> 
> The -rt guys would not be amused.  :-(
> 
> But for non-realtime use, increasing rcutree.blimit either at boot or
> via sysfs could make sense.  It is also likely that I will move callback
> processing to a kthread at some point, which would allow some additional
> flexibility.
> 

Ah, I now realize the loop can exceed blimit, but is it true for BH
variant ? (Not really a problem for 3.6/3.7 kernels, but prior ones)

if (++count >= bl &&
    (need_resched() ||
     (!is_idle_task(current) && !rcu_is_callbacks_kthread())))
        break;

I wonder if ksoftirqd should be included as well...

> Furthermore, it would be easy to have one default for non-rt and another
> for -rt, if that would help.
> 
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > 
> > Please dont forget stable teams.  (3.2 + )
> 
> Added both, please see below!
> 

Seems fine to me, thanks Paul !



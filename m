Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab1DTBuz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 21:50:55 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43336 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493Ab1DTBuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 21:50:54 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] break out page allocation warning code
Cc: kosaki.motohiro@jp.fujitsu.com, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Stultz <johnstul@us.ibm.com>
In-Reply-To: <1303263673.5076.612.camel@nimitz>
References: <alpine.DEB.2.00.1104191419470.510@chino.kir.corp.google.com> <1303263673.5076.612.camel@nimitz>
Message-Id: <20110420105059.460C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Wed, 20 Apr 2011 10:50:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

(Cc to  John Stultz who/proc/<pid>/comm author. I think we need to hear his opinion)

> On Tue, 2011-04-19 at 14:21 -0700, David Rientjes wrote:
> > On Tue, 19 Apr 2011, KOSAKI Motohiro wrote:
> > > The rule is,
> > > 
> > > 1) writing comm
> > > 	need task_lock
> > > 2) read _another_ thread's comm
> > > 	need task_lock
> > > 3) read own comm
> > > 	no need task_lock
> > 
> > That was true a while ago, but you now need to protect every thread's 
> > ->comm with get_task_comm() or ensuring task_lock() is held to protect 
> > against /proc/pid/comm which can change other thread's ->comm.  That was 
> > different before when prctl(PR_SET_NAME) would only operate on current, so 
> > no lock was needed when reading current->comm.
> 
> Everybody still goes through set_task_comm() to _set_ it, though.  That
> means that the worst case scenario that we get is output truncated
> (possibly to nothing).  We already have at least one existing user in
> mm/ (kmemleak) that thinks this is OK.  I'd tend to err in the direction
> of taking a truncated or empty task name to possibly locking up the
> system.
> 
> There are also plenty of instances of current->comm going in to the
> kernel these days.  I count 18 added since 2.6.37.
> 
> As for a long-term fix, locks probably aren't the answer.  Would
> something like this completely untested patch work?  It would have the
> added bonus that it keeps tsk->comm users working for the moment.  We
> could eventually add an rcu_read_lock()-annotated access function.

The concept is ok to me. but AFAIK some caller are now using ARRAY_SIZE(tsk->comm).
or sizeof(tsk->comm). Probably callers need to be changed too.

Thanks.



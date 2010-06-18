Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab0FRVIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 17:08:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22862 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420Ab0FRVIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 17:08:51 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, Don Zickus <dzickus@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jerome Marchand <jmarchan@redhat.com>,
       Mandeep Singh Baines <msb@google.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: while_each_thread() under rcu_read_lock() is broken?
In-Reply-To: Oleg Nesterov's message of  Friday, 18 June 2010 21:34:03 +0200 <20100618193403.GA17314@redhat.com>
References: <20100618190251.GA17297@redhat.com>
	<20100618193403.GA17314@redhat.com>
X-Shopping-List: (1) Peppermint inquisitions
   (2) Incredulous goiter perplexers
   (3) Facetious credulous retention promotions
   (4) Chemical balls
Message-Id: <20100618210801.61B4540162@magilla.sf.frob.com>
Date: Fri, 18 Jun 2010 14:08:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think you're right.  I can't see what would prevent that race.  

So for_each_process and do_each_thread are safe only under
read_lock(&tasklist_lock) and while_each_thread is only safe under
either that or siglock.  (Also a few places using next_thread in
similar loops outside those macros.)

Perhaps we could move those del's from __unhash_process to
__put_task_struct (or just delayed_put_task_struct?) and then
they wouldn't need to be rculist.h calls after all.  But we
would a need careful audit to figure out the assumptions about
being on the list meaning not reaped yet.

I think de_thread() in exec-by-nonleader is the only case where this
can happen, right?  So then perhaps we could make it call release_task
only via call_rcu?


Thanks,
Roland

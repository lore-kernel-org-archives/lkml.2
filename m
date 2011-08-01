Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab1HAPOI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 11:14:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50564 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862Ab1HAPOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 11:14:05 -0400
Date: Mon, 1 Aug 2011 17:13:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] Networking
Message-ID: <20110801151308.GA31256@elte.hu>
References: <20110722.073339.1236244143490935644.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110722.073339.1236244143490935644.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

>       forcedeth: do vlan cleanup

Trying to bring latest -git into latest -tip today i managed to 
bisect back to a pretty bad networking breakage on one of my 
testboxes back to this commit - where i have discovered that it has 
been fixed freshly.

This bug cost me multiple days of debugging so here's a bit of a post 
mortem.

The bit that IMO wasnt very optimal was the timing of the merge path:

 -                  AuthorDate: Wed Jul 20 04:54:38 2011 +0000
 -                  CommitDate: Thu Jul 21 13:47:57 2011 -0700
 - tree Linus merge CommitDate: Fri Jul 22 14:43:13 2011 -0700
 -        first lkml bugreport: Sun Jul 24 16:10:59 2011 -0700
 -              fix CommitDate: Wed Jul 27 22:39:30 2011 -0700
 - fix  Linus merge CommitDate: Thu Jul 28 05:58:19 2011 -0700

So you can see that the commit was committed to net-next within 24 
hours of it being submitted, the (bad) breakage was not discovered 
until 4 days down the road.

I submit that *no one* with real forcedeth hardware actually tested 
this commit before it hit upstream. It has not touched linux-next 
before going to Linus and it took 8 days for the fix to get upstream.

If the latency of common driver bugfixes is on the order of 1 week 
then the golden rule is that commits must be tested for at least 1 
week as well. One day of testing was *way* too short.

Furthermore, the changelog of the fix:

 0891b0e08937: forcedeth: fix vlans

Doesn't contain any reference to the bisection work done by
walt <w41ter@gmail.com> nor by any of the other bugreporters.

So this really sucked all around - could we please improve on it?

Thanks,

	Ingo

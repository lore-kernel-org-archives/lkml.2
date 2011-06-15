Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab1FOV2J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 17:28:09 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47283 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab1FOV2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 17:28:04 -0400
References: <1308097798.17300.142.camel@schen9-DESK> <1308134200.15315.32.camel@twins> <1308135495.15315.38.camel@twins> <BANLkTikt88KnxTy8TuGGVrBVnXvsnL7nMQ@mail.gmail.com> <20110615201216.GA4762@elte.hu> <35c0ff16-bd58-4b9c-9d9f-d1a4df2ae7b9@email.android.com> <20110615211517.GI2267@linux.vnet.ibm.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <20110615211517.GI2267@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] Re: REGRESSION: Performance regressions from switching anon_vma->lock to mutex
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 15 Jun 2011 14:27:42 -0700
To: paulmck@linux.vnet.ibm.com
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <rmk@arm.linux.org.uk>, Paul Mundt <lethal@linux-sh.org>,
        Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Tony Luck <tony.luck@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@kernel.dk>,
        Namhyung Kim <namhyung@gmail.com>, ak@linux.intel.com,
        shaohua.li@intel.com, alex.shi@intel.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Message-ID: <75bf3621-4ab8-4c16-8301-5bb82d14d703@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
>
>  The time will still be consumed, but in softirq
>context, though of course with many fewer context switches.

So the problem with threads goes way beyond just the context switches, or even just the problem with tracing.

Threads change the batching behavior, for example. That is *especially* true with background threads or with realtime threads. Both end up having high priority -either because they are realtime, or because they've been sleeping and thus have been building up extra priority that way.

So when you wake up such a thread, suddenly you get preemption behaviour, or you get the semaphores deciding to break out of their busy loops due to need_resched being set etc.

In contrast, softirqs don't have those kinds of side effects. They have a much smaller effect on system behavior and just run the code we ask them to.

                Linus

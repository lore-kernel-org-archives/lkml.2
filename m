Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932710Ab1FQSsv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 14:48:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52871 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932429Ab1FQSst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 14:48:49 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTimStT22tA2YkeuYBzarnnWTnMjiKQ@mail.gmail.com>
References: <1308097798.17300.142.camel@schen9-DESK> <1308101214.15392.151.camel@sli10-conroe>
 <1308138750.15315.62.camel@twins> <20110615161827.GA11769@tassilo.jf.intel.com>
 <1308156337.2171.23.camel@laptop> <1308163398.17300.147.camel@schen9-DESK>
 <1308169937.15315.88.camel@twins> <4DF91CB9.5080504@linux.intel.com>
 <1308172336.17300.177.camel@schen9-DESK> <1308173849.15315.91.camel@twins>
 <BANLkTim5TPKQ9RdLYRxy=mphOVKw5EXvTA@mail.gmail.com> <1308255972.17300.450.camel@schen9-DESK>
 <BANLkTinptaydNvK4ZvGvy0KVLnRmmza7tA@mail.gmail.com> <BANLkTi=GPtwjQ-bYDNUYCwzW5h--y86Law@mail.gmail.com>
 <BANLkTim-dBjva9w7AajqggKT3iUVYG2euQ@mail.gmail.com> <BANLkTimLV8aCZ7snXT_Do+f4vRY0EkoS4A@mail.gmail.com>
 <BANLkTinUBTYWxrF5TCuDSQuFUAyivXJXjQ@mail.gmail.com> <1308310080.2355.19.camel@twins>
 <BANLkTim2bmPfeRT1tS7hx2Z85QHjPHwU3Q@mail.gmail.com> <alpine.LSU.2.00.1106171040460.7018@sister.anvils>
 <BANLkTim3vo0vpovV=5sU=GLxkotheB=Ryg@mail.gmail.com> <1308334688.12801.19.camel@laptop>
 <1308335557.12801.24.camel@laptop> <BANLkTimStT22tA2YkeuYBzarnnWTnMjiKQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 17 Jun 2011 11:41:55 -0700
Message-ID: <BANLkTinu=m-Ox9zEwguzth+2H_=MBGvS+Q@mail.gmail.com>
Subject: Re: REGRESSION: Performance regressions from switching anon_vma->lock
 to mutex
To: Peter Zijlstra <peterz@infradead.org>
Cc: Hugh Dickins <hughd@google.com>, Tim Chen <tim.c.chen@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, Shaohua Li <shaohua.li@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <rmk@arm.linux.org.uk>, Paul Mundt <lethal@linux-sh.org>,
        Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        "Luck, Tony" <tony.luck@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@kernel.dk>,
        Namhyung Kim <namhyung@gmail.com>, "Shi, Alex" <alex.shi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 11:39 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Having gone over it a bit more, I actually think I prefer to just
> special-case the allocation instead.

Just to explain my thinking: the thing I disliked most about doing an
allocation while holding the lock wasn't that I thought we would
deadlock on page reclaim. I don't claim that kind of far-sight.

No, the thing I disliked was that if we're low on memory and actually
have to wait, I disliked having the lack of concurrency. I'm ok with
holding the mutex over a few more CPU cycles, but anything longer
might actually hurt throughput. So the patch I just sent out should
fix both the page reclaim deadlock, and avoid any problems with delays
due to holding the critical lock over an expensive allocation.

                         Linus

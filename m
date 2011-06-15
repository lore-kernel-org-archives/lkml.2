Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab1FOU5b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 16:57:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:25025 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752251Ab1FOU5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 16:57:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,371,1304319600"; 
   d="scan'208";a="13990858"
Message-ID: <4DF91CB9.5080504@linux.intel.com>
Date: Wed, 15 Jun 2011 13:57:29 -0700
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Tim Chen <tim.c.chen@linux.intel.com>, Shaohua Li <shaohua.li@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
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
Subject: Re: REGRESSION: Performance regressions from switching anon_vma->lock
 to mutex
References: <1308097798.17300.142.camel@schen9-DESK>	 <1308101214.15392.151.camel@sli10-conroe> <1308138750.15315.62.camel@twins>	 <20110615161827.GA11769@tassilo.jf.intel.com>	 <1308156337.2171.23.camel@laptop>  <1308163398.17300.147.camel@schen9-DESK> <1308169937.15315.88.camel@twins>
In-Reply-To: <1308169937.15315.88.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>       7.44%        exim  [kernel.kallsyms]              [k] format_decode
>                    |
>                    --- format_decod


This is a glibc issue. exim calls libdb and libdb asks sysconf for the 
number of CPUs to tune
its locking, and glibc reads /proc/stat.  And /proc/stat is incredible slow.

I would blame glibc, but in this case it's really the kernel to blame 
for not providing proper
interface.

This was my motivation for the sysconf() syscall I submitted some time ago.
https://lkml.org/lkml/2011/5/13/455

Anyways a quick workaround is to use this LD_PRELOAD: 
http://halobates.de/smallsrc/sysconf.c
But it's not 100% equivalent.

-Andi




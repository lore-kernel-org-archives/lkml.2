Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375Ab1EJIMF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:12:05 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33781 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128Ab1EJIMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:12:00 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: CAI Qian <caiqian@redhat.com>
Subject: OOM Killer don't works at all if the system have >gigabytes memory (was Re: [PATCH] mm: check zone->all_unreclaimable in all_unreclaimable())
Cc: kosaki.motohiro@jp.fujitsu.com, avagin@gmail.com,
        Andrey Vagin <avagin@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Minchan Kim <minchan.kim@gmail.com>,
        David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>,
        Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <20110509182110.167F.A69D9226@jp.fujitsu.com>
References: <1491537913.283996.1304930866703.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com> <20110509182110.167F.A69D9226@jp.fujitsu.com>
Message-Id: <20110510171335.16A7.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Tue, 10 May 2011 17:11:56 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc to oom interested people)

> > > > I have tested this for the latest mainline kernel using the
> > > > reproducer
> > > > attached, the system just hung or deadlock after oom. The whole oom
> > > > trace is here.
> > > > http://people.redhat.com/qcai/oom.log
> > > >
> > > > Did I miss anything?
> > > 
> > > Can you please try commit 929bea7c714220fc76ce3f75bef9056477c28e74?
> > As I have mentioned that I have tested the latest mainline which have
> > already included that fix. Also, does this problem only for x86? The
> > testing was done using x86_64. Not sure if that would be a problem.
> 
> No. I'm also using x86_64 and my machine completely works on current
> latest linus tree. I confirmed it today.

> 4194288 pages RAM

You have 16GB RAM.

> Out of memory: Kill process 1175 (dhclient) score 1 or sacrifice child
> Out of memory: Kill process 1247 (rsyslogd) score 1 or sacrifice child
> Out of memory: Kill process 1284 (irqbalance) score 1 or sacrifice child
> Out of memory: Kill process 1303 (rpcbind) score 1 or sacrifice child
> Out of memory: Kill process 1321 (rpc.statd) score 1 or sacrifice child
> Out of memory: Kill process 1333 (mdadm) score 1 or sacrifice child
> Out of memory: Kill process 1365 (rpc.idmapd) score 1 or sacrifice child
> Out of memory: Kill process 1403 (dbus-daemon) score 1 or sacrifice child
> Out of memory: Kill process 1438 (acpid) score 1 or sacrifice child
> Out of memory: Kill process 1447 (hald) score 1 or sacrifice child
> Out of memory: Kill process 1447 (hald) score 1 or sacrifice child
> Out of memory: Kill process 1487 (hald-addon-inpu) score 1 or sacrifice child
> Out of memory: Kill process 1488 (hald-addon-acpi) score 1 or sacrifice child
> Out of memory: Kill process 1507 (automount) score 1 or sacrifice child

Oops.

OK. That's known issue. Current OOM logic doesn't works if you have
gigabytes RAM. because _all_ process have the exactly same score (=1).
then oom killer just fallback to random process killer. It was made
commit a63d83f427 (oom: badness heuristic rewrite). I pointed out
it at least three times. You have to blame Google folks. :-/


The problems are three.

1) if two processes have the same oom score, we should kill younger process.
   but current logic kill older. Oldest processes are typicall system daemons.
2) Current logic use 'unsigned int' for internal score calculation. (exactly says,
   it only use 0-1000 value). its very low precision calculation makes a lot of
   same oom score and kill an ineligible process.
3) Current logic give 3% of SystemRAM to root processes. It obviously too big
   if you have plenty memory. Now, your fork-bomb processes have 500MB OOM immune
   bonus. then your fork-bomb never ever be killed.


CAI-san: I've made fixing patches. Can you please try them?




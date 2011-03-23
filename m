Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab1CWB1o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 21:27:44 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37341 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab1CWB1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 21:27:41 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 3/5] oom: create oom autogroup
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-mm <linux-mm@kvack.org>, Andrey Vagin <avagin@openvz.org>,
        Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mike Galbraith <efault@gmx.de>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
In-Reply-To: <AANLkTikN835dfU9xozTWbOh6cjSEG0XgU_Ayn+dRqDug@mail.gmail.com>
References: <20110322200759.B067.A69D9226@jp.fujitsu.com> <AANLkTikN835dfU9xozTWbOh6cjSEG0XgU_Ayn+dRqDug@mail.gmail.com>
Message-Id: <20110323102738.1AC2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Wed, 23 Mar 2011 10:27:35 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Mar 22, 2011 at 8:08 PM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
> > When plenty processes (eg fork bomb) are running, the TIF_MEMDIE task
> > never exit, at least, human feel it's never. therefore kernel become
> > hang-up.
> >
> > "perf sched" tell us a hint.
> >
> >  ------------------------------------------------------------------------------
> >  Task                  |   Runtime ms  | Average delay ms | Maximum delay ms |
> >  ------------------------------------------------------------------------------
> >  python:1754           |      0.197 ms | avg: 1731.727 ms | max: 3433.805 ms |
> >  python:1843           |      0.489 ms | avg: 1707.433 ms | max: 3622.955 ms |
> >  python:1715           |      0.220 ms | avg: 1707.125 ms | max: 3623.246 ms |
> >  python:1818           |      2.127 ms | avg: 1527.331 ms | max: 3622.553 ms |
> >  ...
> >  ...
> >
> > Processes flood makes crazy scheduler delay. and then the victim process
> > can't run enough. Grr. Should we do?
> >
> > Fortunately, we already have anti process flood framework, autogroup!
> > This patch reuse this framework and avoid kernel live lock.
> 
> That's cool idea but I have a concern.
> 
> You remove boosting priority in [2/5] and move victim tasks into autogroup.
> If I understand autogroup right, victim process and threads in the
> process take less schedule chance than now.

Right. Icky cpu-cgroup rt-runtime default enforce me to seek another solution.
Today, I got private mail from Luis and he seems to have another improvement
idea. so, I might drop this patch if his one works fine.

> Could it make unnecessary killing of other tasks?
> I am not sure. Just out of curiosity.

If you are talking about OOM serialization, It isn't. I don't change
OOM serialization stuff. at least for now.
If you are talking about scheduler fairness, both current and this patch
have scheduler unfairness. But that's ok. 1) When OOM situation, scheduling
fairness has been broken already by heavy memory reclaim effort 2) autogroup
mean to change scheduling grouping *automatically*. then, the patch change it
again for exiting memory starvation.

> 
> Thanks for nice work, Kosaki.







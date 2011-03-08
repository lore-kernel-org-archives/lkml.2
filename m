Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405Ab1CHBY5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 20:24:57 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40685 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427Ab1CHBY4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 20:24:56 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Vagin <avagin@gmail.com>
Subject: Re: [PATCH] mm: skip zombie in OOM-killer
Cc: kosaki.motohiro@jp.fujitsu.com, David Rientjes <rientjes@google.com>,
        Andrey Vagin <avagin@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTi=d+eZxg_NgNWa7roo=1YQS06=EaWJzjseL_Hhs@mail.gmail.com>
References: <alpine.DEB.2.00.1103061400170.23737@chino.kir.corp.google.com> <AANLkTi=d+eZxg_NgNWa7roo=1YQS06=EaWJzjseL_Hhs@mail.gmail.com>
Message-Id: <20110308102147.7E96.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  8 Mar 2011 10:24:52 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 2011/3/7 David Rientjes <rientjes@google.com>:
> > On Sun, 6 Mar 2011, KOSAKI Motohiro wrote:
> >
> >> > When we check that task has flag TIF_MEMDIE, we forgot check that
> >> > it has mm. A task may be zombie and a parent may wait a memor.
> >> >
> >> > v2: Check that task doesn't have mm one time and skip it immediately
> >> >
> >> > Signed-off-by: Andrey Vagin <avagin@openvz.org>
> >>
> >> This seems incorrect. Do you have a reprodusable testcasae?
> >> Your patch only care thread group leader state, but current code
> >> care all thread in the process. Please look at oom_badness() and
> >> find_lock_task_mm().
> >>
> >
> > That's all irrelevant, the test for TIF_MEMDIE specifically makes the oom
> > killer a complete no-op when an eligible task is found to have been oom
> > killed to prevent needlessly killing additional tasks.  oom_badness() and
> > find_lock_task_mm() have nothing to do with that check to return
> > ERR_PTR(-1UL) from select_bad_process().
> >
> > Andrey is patching the case where an eligible TIF_MEMDIE process is found
> > but it has already detached its ->mm.  In combination with the patch
> > posted to linux-mm, oom: prevent unnecessary oom kills or kernel panics,
> > which makes select_bad_process() iterate over all threads, it is an
> > effective solution.
> 
> Probably you said about the first version of my patch.
> This version is incorrect because of
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=dd8e8f405ca386c7ce7cbb996ccd985d283b0e03
> 
> but my first patch is correct and it has a simple reproducer(I
> attached it). You can execute it and your kernel hangs up, because the
> parent doesn't wait children, but the one child (zombie) will have
> flag TIF_MEMDIE, oom_killer will kill nobody
> 
> 
> The link on the first patch:
> http://groups.google.com/group/linux.kernel/browse_thread/thread/b9c6ddf34d1671ab/2941e1877ca4f626?lnk=raot&pli=1

OK. I can ack this.
TIF_MEMDIE  mean the process have been receive SIGKILL therefore we can assume it
as per process flag.




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009Ab0CaCP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 22:15:58 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53332 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972Ab0CaCP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 22:15:56 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 31 Mar 2010 11:12:02 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Michael S. Tsirkin" <mst@redhat.com>, cl@linux-foundation.org,
       lee.schermerhorn@hp.com, rientjes@google.com,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       "David S. Miller" <davem@davemloft.net>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Troels Liebe Bentsen <tlb@rapanden.dk>,
       linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH] exit: fix oops in sync_mm_rss
Message-Id: <20100331111202.a94b233a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <z2t28c262361003301857l77db88dbv7d025b5c5947ad72@mail.gmail.com>
References: <20100316170808.GA29400@redhat.com>
	<20100330135634.09e6b045.akpm@linux-foundation.org>
	<20100331092815.c8b9d89c.kamezawa.hiroyu@jp.fujitsu.com>
	<20100330173721.cbd442cb.akpm@linux-foundation.org>
	<20100331094124.43c49290.kamezawa.hiroyu@jp.fujitsu.com>
	<z2t28c262361003301857l77db88dbv7d025b5c5947ad72@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Mar 2010 10:57:18 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> On Wed, Mar 31, 2010 at 9:41 AM, KAMEZAWA Hiroyuki

> > Doesn't make sense ?
> >
> 
> Nitpick.
> How about moving sync_mm_rss into after check !mm of exit_mm?
> 
Hmm.
==
        sync_mm_rss(tsk, tsk->mm);
        group_dead = atomic_dec_and_test(&tsk->signal->live);
        if (group_dead) {
                hrtimer_cancel(&tsk->signal->real_timer);
                exit_itimers(tsk->signal);
                if (tsk->mm)
                        setmax_mm_hiwater_rss(&tsk->signal->maxrss, tsk->mm); ---(**)
        }
        acct_collect(code, group_dead);
        if (group_dead)
                tty_audit_exit();
        if (unlikely(tsk->audit_context))
                audit_free(tsk);

        tsk->exit_code = code;
        taskstats_exit(tsk, group_dead); --------(*)
	
        exit_mm(tsk);
==
task_acct routine has to handle mm information (*).
So, we have to sync somewhere before exit_mm() or tsk->mm goes to NULL.

I think taskstat is an only acct hook which gatheres mm's rss information
but I placed sync_mm_rss() before all accounting routine.
Anyway, sync_mm_rss() should be before (**)
setmax_mm_hiwater_rss(&tsk->signal->maxrss, tsk->mm);

Thanks,
-Kame 





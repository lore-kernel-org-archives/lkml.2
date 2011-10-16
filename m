Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026Ab1JPUl2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 16:41:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434Ab1JPUlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 16:41:00 -0400
From: Andrea Arcangeli <aarcange@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Michel Lespinasse <walken@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Shaohua Li <shaohua.li@intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: thp: gup_fast ppc tail refcounting [was Re: [PATCH] thp: tail page refcounting fix #6]
Date: Sun, 16 Oct 2011 22:40:35 +0200
Message-Id: <1318797639-26962-1-git-send-email-aarcange@redhat.com>
In-Reply-To: <1316793432.9084.47.camel@twins>
References: <1316793432.9084.47.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

so I reviewed the ppc gup_fast hugetlbfs code a bit, fixed the
longstanding memory corrupting bugs (could trigger if mmremap
functions run under gup_fast) and I fixed the code that was supposed
to make it work with thp introduction in 2.6.38 and more recently with
the tail refcounting race fixes in -mm. This is incremental with the
thp refcoutning race fixes merged in -mm.

To me those rollbacking if the pte changed that ppc is doing looks
unnecessary, the speculative access also looks unnecessary (there is
no way the page_count of the head or regular pages can be zero
there). x86 doesn't do any specualtive refcounting and it won't care
if the pte changed (we know the page can't go away from under us
because irqs are disabled). If tlb flushing code works on ppc like x86
there should be no need of that.

However I didn't remove those two rollback conditions, in theory it
shouldn't hurt (well not anymore, after fixing the two corrupting
bugs...). I just tried to make the minimal changes required because I
didn't test it. It'd be nice if ppc users could test it with O_DIRECT
on top of hugetlbfs and report if this works. I build-tested it
though, so it should build just fine at least.

s390x should be the only other arch that needs revisiting to make
gup_fast + hugetlbfs to work properly. I'll do that next.

[PATCH 1/4] powerpc: remove superfluous PageTail checks on the pte gup_fast
[PATCH 2/4] powerpc: get_hugepte() don't put_page() the wrong page
[PATCH 3/4] powerpc: gup_hugepte() avoid to free the head page too many times
[PATCH 4/4] powerpc: gup_hugepte() support THP based tail recounting

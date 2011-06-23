Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932467Ab1FWMK6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 08:10:58 -0400
Received: from DMZ-MAILSEC-SCANNER-2.MIT.EDU ([18.9.25.13]:52169 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757947Ab1FWMK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 08:10:57 -0400
X-AuditID: 1209190d-b7bdeae0000004f8-99-4e032d043fa9
Subject: Re: [PATCH v2] fadvise: move active pages to inactive list with POSIX_FADV_DONTNEED
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <1308810981-5286-1-git-send-email-andrea@betterlinux.com>
Date: Thu, 23 Jun 2011 08:10:47 -0400
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>, Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>,
        Jerry James <jamesjer@betterlinux.com>,
        Marcus Sorensen <marcus@bluehost.com>, Matt Heaton <matt@bluehost.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <E03B7391-C7D0-4EBE-96FE-C7537F9E353B@mit.edu>
References: <1308810981-5286-1-git-send-email-andrea@betterlinux.com>
To: Andrea Righi <andrea@betterlinux.com>
X-Mailer: Apple Mail (2.1084)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMKsWRmVeSWpSXmKPExsUixG6nosuiy+xn8O2GpsWC9UvZLeasX8Nm
	8XxWI5PF6k2+Fk8/9bFY/L57jMli5uzZTBZtx/6xWFzeNYfN4t6a/6wWE54uYLS4OPkgi0Xf
	jO1MFsd7DzBZ/L2ynsWB3+P33BVsHk3fO5k9Dr95z+yxc9Zddo8Fm0o9Nq/Q8jjx5BKbx6ZP
	k9g9Tsz4zeLxft9VNo/Pm+QCuKO4bFJSczLLUov07RK4MjYv6GIuuM5eMenKFbYGxja2LkZO
	DgkBE4nl/5uhbDGJC/fWA9lcHEIC+xglDj08CeVsYJT4efwdE4Rzmkni+5EmZpAWYYEYieU7
	z7KD2LwChhJLN7WD2cwCWhI3/r1kArHZBJQk7nzazwJicwq4SXy+9RnMZhFQldi8dzoryFBm
	gT8sErMW/2aGaJaX2P52DjPEUCuJbUdPgzUICbhK/Jt7gxHEFhHQlLh/+DjQeRxAd8tKNC3L
	mMAoOAvJGbOQnDELydQFjMyrGGVTcqt0cxMzc4pTk3WLkxPz8lKLdI30cjNL9FJTSjcxguKS
	U5J3B+O7g0qHGAU4GJV4eE94MvkJsSaWFVfmHmKU5GBSEuXN02H2E+JLyk+pzEgszogvKs1J
	LT7EKMHBrCTCy/IDqJw3JbGyKrUoHyYlzcGiJM6r5v3fV0ggPbEkNTs1tSC1CCYrw8GhJMFb
	AjJUsCg1PbUiLTOnBCHNxMEJMpwHaHghSA1vcUFibnFmOkT+FKOilDhvDEhCACSRUZoH1wtL
	m68YxYFeEeYtAqniAaZcuO5XQIOZgAbzPgW5urgkESEl1cBoZfikzfs2c8XOvPpl31RV17g1
	buoPSLRM8whLSAuf6HXnl7y32kqt22KSM7akH3XMM+iKuPhS2ajqZwN/1ySGBoarprnxaut1
	A+MZN1mqTrXJz7wUs6Vs3hm5td11nV172Ja0PL61T1oxuT0lk+W60MlSjbPctw0eNGp9aLuU
	o3Pc4cz1M0osxRmJhlrMRcWJAB9GHvJ2AwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 23, 2011, at 2:36 AM, Andrea Righi wrote:

> 
> With the following solution when posix_fadvise(POSIX_FADV_DONTNEED) is
> called for an active page instead of removing it from the page cache it
> is added to the tail of the inactive list. Otherwise, if it's already in
> the inactive list the page is removed from the page cache.


Have you thought about this heuristic?   If the page is active, try to
remove it from the current process's page table.  If that drops the
use count of the page to zero, then drop it from the page cache;
otherwise, leave it alone.

That way, if the page is being used by anyone else, we don't touch
the page at all.   fadvise() should only affect the current process; if
it's available to non-root users, it shouldn't be affecting other
processes, and if it is being actively used by some other process,
removing it from their page tables so it can be put on the inactive
list counts as interference, doesn't it?

-- Ted


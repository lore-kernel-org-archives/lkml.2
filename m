Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425Ab2K0Utm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 15:49:42 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:35191 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755605Ab2K0Utl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 15:49:41 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        George Spelvin <linux@horizon.com>,
        Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
        Tomas Racek <tracek@redhat.com>, Jan Kara <jack@suse.cz>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Josh Boyer <jwboyer@gmail.com>,
        Valdis.Kletnieks@vt.edu, Jiri Slaby <jslaby@suse.cz>,
        Thorsten Leemhuis <fedora@leemhuis.info>,
        Zdenek Kabelac <zkabelac@redhat.com>, Bruno Wolff III <bruno@wolff.to>,
        Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: kswapd craziness in 3.7
Date: Tue, 27 Nov 2012 15:48:34 -0500
Message-Id: <1354049315-12874-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

I hope I included everybody that participated in the various threads
on kswapd getting stuck / exhibiting high CPU usage.  We were looking
at at least three root causes as far as I can see, so it's not really
clear who observed which problem.  Please correct me if the
reported-by, tested-by, bisected-by tags are incomplete.

One problem was, as it seems, overly aggressive reclaim due to scaling
up reclaim goals based on compaction failures.  This one was reverted
in 9671009 mm: revert "mm: vmscan: scale number of pages reclaimed by
reclaim/compaction based on failures".

Another one was an accounting problem where a freed higher order page
was underreported, and so kswapd had trouble restoring watermarks.
This one was fixed in ef6c5be fix incorrect NR_FREE_PAGES accounting
(appears like memory leak).

The third one is a problem with small zones, like the DMA zone, where
the high watermark is lower than the low watermark plus compaction gap
(2 * allocation size).  The zonelist reclaim in kswapd would do
nothing because all high watermarks are met, but the compaction logic
would find its own requirements unmet and loop over the zones again.
Indefinitely, until some third party would free enough memory to help
meet the higher compaction watermark.  The problematic code has been
there since the 3.4 merge window for non-THP higher order allocations
but has been more prominent since the 3.7 merge window, where kswapd
is also woken up for the much more common THP allocations.

The following patch should fix the third issue by making both reclaim
and compaction code in kswapd use the same predicate to determine
whether a zone is balanced or not.

Hopefully, the sum of all three fixes should tame kswapd enough for
3.7.

Johannes


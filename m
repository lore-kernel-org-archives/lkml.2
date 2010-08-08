Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab0HHKFW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 06:05:22 -0400
Received: from smtp.nokia.com ([192.100.122.230]:29974 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349Ab0HHKFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 06:05:18 -0400
Subject: Re: [PATCH 0/6] improve list_sort test
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Don Mullis <don.mullis@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
        Dave Chinner <david@fromorbit.com>
In-Reply-To: <1281168645-18413-1-git-send-email-dedekind1@gmail.com>
References: <1281168645-18413-1-git-send-email-dedekind1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 08 Aug 2010 13:03:09 +0300
Message-ID: <1281261789.2384.11.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 08 Aug 2010 10:04:50.0864 (UTC) FILETIME=[23EFA300:01CB36E1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-08-07 at 11:10 +0300, Artem Bityutskiy wrote:
> Hi,
> 
> while hunting a non-existing bug in 'list_sort()', I've improved the
> 'list_sort_test()' function which tests the 'list_sort()' library call. Although
> at the end I found a bug in my code, but not in 'list_sort()', I think my
> clean-ups and improvements are worth merging because they make the test function
> better.

Actually, your 'list_sort()' version does have a problem. I found out
that it calls 'cmp(priv, a, b)' with 'a = b' sometimes, and in these
cases 'a' and 'b' can point to something which is not a valid element of
the original list. Probably a senitel or something like that.

It is easy to work around this by adding:

if (a == b)
	return 0;

in the 'cmp()' function, but this is nevertheless a bug (not too bad,
though) and should be fixed. Also, the fact that 'cmp()' is called with
'a==b' sometimes should be documented.

I'm CC-ing 2 other users of 'list_sort()' for head-ups (xfs, drm).

I've fixed assertions in UBIFS using the following patch:

===========================================================================

>From 3ea1708e2d0462dc8eaf1076ebf973d82700952b Mon Sep 17 00:00:00 2001
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Date: Sun, 8 Aug 2010 12:45:23 +0300
Subject: [PATCHv2 8/9] UBIFS: fix assertion warnings in comparison function

When running the integrity test ('integck' from mtd-utils) on current
UBIFS on 2.6.35, I see that assertions in UBIFS 'list_sort()' comparison
functions trigger sometimes, e.g.:

UBIFS assert failed in data_nodes_cmp at 132 (pid 28311)

My investigation showed that this happens when 'list_sort()' calls the 'cmp()'
function with equivalent arguments. In this case, the 'struct list_head'
parameter, passed to 'cmp()' is bogus, and it does not belong to any element in
the original list.

And this issue seems to be introduced by commit:

commit 835cc0c8477fdbc59e0217891d6f11061b1ac4e2
Author: Don Mullis <don.mullis@gmail.com>
Date:   Fri Mar 5 13:43:15 2010 -0800

It is easy to work around the issue by doing:

if (a == b)
	return 0;

in UBIFS. It works, but 'lib_sort()' should nevertheless be fixed. Although it
is harmless to have this piece of code in UBIFS.

This patch adds that code to both UBIFS 'cmp()' functions:
'data_nodes_cmp()' and 'nondata_nodes_cmp()'.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/ubifs/gc.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/ubifs/gc.c b/fs/ubifs/gc.c
index 8dbe36f..84ab9aa 100644
--- a/fs/ubifs/gc.c
+++ b/fs/ubifs/gc.c
@@ -125,6 +125,9 @@ int data_nodes_cmp(void *priv, struct list_head *a, struct list_head *b)
 	struct ubifs_scan_node *sa, *sb;
 
 	cond_resched();
+	if (a == b)
+		return 0;
+
 	sa = list_entry(a, struct ubifs_scan_node, list);
 	sb = list_entry(b, struct ubifs_scan_node, list);
 
@@ -165,6 +168,9 @@ int nondata_nodes_cmp(void *priv, struct list_head *a, struct list_head *b)
 	struct ubifs_scan_node *sa, *sb;
 
 	cond_resched();
+	if (a == b)
+		return 0;
+
 	sa = list_entry(a, struct ubifs_scan_node, list);
 	sb = list_entry(b, struct ubifs_scan_node, list);
 
-- 
1.7.1.1



-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)


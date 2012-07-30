Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab2G3ReE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 13:34:04 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44548 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103Ab2G3Rd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 13:33:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Dave Chinner <david@fromorbit.com>, Mel Gorman <mgorman@suse.de>
Subject: [ 41/41] vmscan: fix initial shrinker size handling
Date: Mon, 30 Jul 2012 10:31:40 -0700
Message-Id: <20120730172904.512570228@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120730172901.306897424@linuxfoundation.org>
References: <20120730172901.306897424@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Khlebnikov <khlebnikov@openvz.org>

commit 635697c663f38106063d5659f0cf2e45afcd4bb5 upstream.

Stable note: The commit [acf92b48: vmscan: shrinker->nr updates race and
	go wrong] aimed to reduce excessive reclaim of slab objects but
	had bug in how it treated shrinker functions that returned -1.

A shrinker function can return -1, means that it cannot do anything
without a risk of deadlock.  For example prune_super() does this if it
cannot grab a superblock refrence, even if nr_to_scan=0.  Currently we
interpret this -1 as a ULONG_MAX size shrinker and evaluate `total_scan'
according to this.  So the next time around this shrinker can cause
really big pressure.  Let's skip such shrinkers instead.

Also make total_scan signed, otherwise the check (total_scan < 0) below
never works.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/vmscan.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -248,12 +248,16 @@ unsigned long shrink_slab(struct shrink_
 
 	list_for_each_entry(shrinker, &shrinker_list, list) {
 		unsigned long long delta;
-		unsigned long total_scan;
-		unsigned long max_pass;
+		long total_scan;
+		long max_pass;
 		int shrink_ret = 0;
 		long nr;
 		long new_nr;
 
+		max_pass = do_shrinker_shrink(shrinker, shrink, 0);
+		if (max_pass <= 0)
+			continue;
+
 		/*
 		 * copy the current shrinker scan count into a local variable
 		 * and zero it so that other concurrent shrinker invocations
@@ -264,7 +268,6 @@ unsigned long shrink_slab(struct shrink_
 		} while (cmpxchg(&shrinker->nr, nr, 0) != nr);
 
 		total_scan = nr;
-		max_pass = do_shrinker_shrink(shrinker, shrink, 0);
 		delta = (4 * nr_pages_scanned) / shrinker->seeks;
 		delta *= max_pass;
 		do_div(delta, lru_pages + 1);



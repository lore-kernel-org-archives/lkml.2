Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab0KZOqG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 09:46:06 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60108 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab0KZOqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 09:46:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=X7+Du6oGqvZBNINrx1Nf8mLeblLkSoeDIN9V/XhmB7EwSkUorfEOv7wCBhc6Ulw6jU
         8HvVXmN1EG/EK0prWu1FOLSwZrUt6QwqyhKT9FGa3xb5NSrxBMGoZ9pY3KjrRgP8iOm0
         rzQTyj0RC5dgM8cGaCpzd4xjaIgFD5DJ5b+5s=
MIME-Version: 1.0
Date: Fri, 26 Nov 2010 22:46:01 +0800
Message-ID: <AANLkTi=aqMR0uNCgz40pdUG1288CMxLRnZdVxzZuBzGw@mail.gmail.com>
Subject: [PATCH] maximize dispatching in block throttle
From: Hillf Danton <dhillf@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When dispatching bio, the quantum is divided into read/write budgets,
and dispatching for write could not exceed the write budget even if
the read budget is not exhausted, either dispatching for read.

It is changed to exhaust the quantum, if possible, in this work for
dispatching bio.

Though it is hard to understand that 50/50 division is not selected,
the difference between divisions could impact little on dispatching as
much as quantum allows then.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/block/blk-throttle.c	2010-11-01 19:54:12.000000000 +0800
+++ b/block/blk-throttle.c	2010-11-26 21:49:00.000000000 +0800
@@ -647,11 +647,16 @@ static int throtl_dispatch_tg(struct thr
 	unsigned int max_nr_reads = throtl_grp_quantum*3/4;
 	unsigned int max_nr_writes = throtl_grp_quantum - nr_reads;
 	struct bio *bio;
+	int read_throttled = 0, write_throttled = 0;

 	/* Try to dispatch 75% READS and 25% WRITES */
-
+ try_read:
 	while ((bio = bio_list_peek(&tg->bio_lists[READ]))
-		&& tg_may_dispatch(td, tg, bio, NULL)) {
+		&& ! read_throttled) {
+		if (! tg_may_dispatch(td, tg, bio, NULL)) {
+			read_throttled = 1;
+			break;
+		}

 		tg_dispatch_one_bio(td, tg, bio_data_dir(bio), bl);
 		nr_reads++;
@@ -659,9 +664,15 @@ static int throtl_dispatch_tg(struct thr
 		if (nr_reads >= max_nr_reads)
 			break;
 	}
-
+	if (! bio)
+		read_throttled = 1;
+ try_write:
 	while ((bio = bio_list_peek(&tg->bio_lists[WRITE]))
-		&& tg_may_dispatch(td, tg, bio, NULL)) {
+		&& ! write_throttled) {
+		if (! tg_may_dispatch(td, tg, bio, NULL)) {
+			write_throttled = 1;
+			break;
+		}

 		tg_dispatch_one_bio(td, tg, bio_data_dir(bio), bl);
 		nr_writes++;
@@ -669,7 +680,23 @@ static int throtl_dispatch_tg(struct thr
 		if (nr_writes >= max_nr_writes)
 			break;
 	}
+	if (! bio)
+		write_throttled = 1;
+
+	if (write_throttled && read_throttled)
+		goto out;

+	if (! (throtl_grp_quantum > nr_writes + nr_reads))
+		goto out;
+		
+	if (read_throttled) {
+		max_nr_writes = throtl_grp_quantum - nr_reads;
+		goto try_write;
+	} else {
+		max_nr_reads = throtl_grp_quantum - nr_writes;
+		goto try_read;
+	}
+ out:
 	return nr_reads + nr_writes;
 }

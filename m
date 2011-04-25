Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670Ab1DYUX6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:23:58 -0400
Received: from 1wt.eu ([62.212.114.60]:33855 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756534Ab1DYUXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:23:55 -0400
Message-Id: <20110425200234.858723976@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:03:15 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>,
        maximilian attems <max@stro.at>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 043/173] dm raid1: fail writes if errors are not handled and log fails
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 5528d17de1cf1462f285c40ccaf8e0d0e4c64dc0 upstream.

If the mirror log fails when the handle_errors option was not selected
and there is no remaining valid mirror leg, writes return success even
though they weren't actually written to any device.  This patch
completes them with EIO instead.

This code path is taken:
do_writes:
	bio_list_merge(&ms->failures, &sync);
do_failures:
	if (!get_valid_mirror(ms)) (false)
	else if (errors_handled(ms)) (false)
	else bio_endio(bio, 0);

The logic in do_failures is based on presuming that the write was already
tried: if it succeeded at least on one leg (without handle_errors) it
is reported as success.

Reference: https://bugzilla.redhat.com/show_bug.cgi?id=555197

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-raid1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -659,7 +659,7 @@ static void do_writes(struct mirror_set
 	/*
 	 * Dispatch io.
 	 */
-	if (unlikely(ms->log_failure)) {
+	if (unlikely(ms->log_failure) && errors_handled(ms)) {
 		spin_lock_irq(&ms->lock);
 		bio_list_merge(&ms->failures, &sync);
 		spin_unlock_irq(&ms->lock);



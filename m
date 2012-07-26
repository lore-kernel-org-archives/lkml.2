Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab2GZVWE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:22:04 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:45953 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966Ab2GZVV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:21:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mikulas Patocka <mpatocka@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>
Subject: [ 21/23] dm raid1: set discard_zeroes_data_unsupported
Date: Thu, 26 Jul 2012 14:20:00 -0700
Message-Id: <20120726211407.793383426@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120726211405.959857593@linuxfoundation.org>
References: <20120726211420.GA7678@kroah.com>
 <20120726211405.959857593@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 7c8d3a42fe1c58a7e8fd3f6a013e7d7b474ff931 upstream.

We can't guarantee that REQ_DISCARD on dm-mirror zeroes the data even if
the underlying disks support zero on discard.  So this patch sets
ti->discard_zeroes_data_unsupported.

For example, if the mirror is in the process of resynchronizing, it may
happen that kcopyd reads a piece of data, then discard is sent on the
same area and then kcopyd writes the piece of data to another leg.
Consequently, the data is not zeroed.

The flag was made available by commit 983c7db347db8ce2d8453fd1d89b7a4bb6920d56
(dm crypt: always disable discard_zeroes_data).

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-raid1.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -1084,6 +1084,7 @@ static int mirror_ctr(struct dm_target *
 	ti->split_io = dm_rh_get_region_size(ms->rh);
 	ti->num_flush_requests = 1;
 	ti->num_discard_requests = 1;
+	ti->discard_zeroes_data_unsupported = 1;
 
 	ms->kmirrord_wq = alloc_workqueue("kmirrord",
 					  WQ_NON_REENTRANT | WQ_MEM_RECLAIM, 0);



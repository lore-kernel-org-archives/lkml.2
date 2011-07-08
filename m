Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab1GIGBV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 02:01:21 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:58362 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753975Ab1GIGBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 02:01:17 -0400
X-Sasl-enc: 9r2pHOO+cHEAF+VaiSH172KcfkEKDX6ZqVKmJfn5uEuu 1310191276
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Jul  8 16:01:12 2011
Message-Id: <20110708230112.313966917@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 08 Jul 2011 16:00:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [28/35] PM / Hibernate: Fix free_unnecessary_pages()
In-Reply-To: <20110708230122.GA18807@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: "Rafael J. Wysocki" <rjw@sisk.pl>

commit 4d4cf23cdde2f8f9324f5684a7f349e182039529 upstream.

There is a bug in free_unnecessary_pages() that causes it to
attempt to free too many pages in some cases, which triggers the
BUG_ON() in memory_bm_clear_bit() for copy_bm.  Namely, if
count_data_pages() is initially greater than alloc_normal, we get
to_free_normal equal to 0 and "save" greater from 0.  In that case,
if the sum of "save" and count_highmem_pages() is greater than
alloc_highmem, we subtract a positive number from to_free_normal.
Hence, since to_free_normal was 0 before the subtraction and is
an unsigned int, the result is converted to a huge positive number
that is used as the number of pages to free.

Fix this bug by checking if to_free_normal is actually greater
than or equal to the number we're going to subtract from it.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Reported-and-tested-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/power/snapshot.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -1193,7 +1193,11 @@ static void free_unnecessary_pages(void)
 		to_free_highmem = alloc_highmem - save;
 	} else {
 		to_free_highmem = 0;
-		to_free_normal -= save - alloc_highmem;
+		save -= alloc_highmem;
+		if (to_free_normal > save)
+			to_free_normal -= save;
+		else
+			to_free_normal = 0;
 	}
 
 	memory_bm_position_reset(&copy_bm);



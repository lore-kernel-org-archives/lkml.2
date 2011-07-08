Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab1GHFE6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:04:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42429 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754798Ab1GHFEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:04:54 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:17:00 2011
Message-Id: <20110708001700.626965535@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:16:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [081/107] PM / Hibernate: Fix free_unnecessary_pages()
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

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
@@ -1199,7 +1199,11 @@ static void free_unnecessary_pages(void)
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



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301Ab1EFAw2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:52:28 -0400
Received: from kroah.org ([198.145.64.141]:36850 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932288Ab1EFAZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:25:04 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:11 2011
Message-Id: <20110506002211.824512687@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:20:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Abhi Das <adas@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [067/143] GFS2: BUG in gfs2_adjust_quota
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Abhijith Das <adas@redhat.com>

commit 8b4216018bdbfbb1b76150d202b15ee68c38e991 upstream.

HighMem pages on i686 do not get mapped to the buffer_heads and this was
causing a NULL pointer dereference when we were trying to memset page buffers
to zero.
We now use zero_user() that kmaps the page and directly manipulates page data.
This patch also fixes a boundary condition that was incorrect.

Signed-off-by: Abhi Das <adas@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
[Adjusted to apply to 2.6.32 by dann frazier <dannf@debian.org>]
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/gfs2/quota.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -679,10 +679,8 @@ get_a_page:
 		if (!buffer_mapped(bh))
 			goto unlock_out;
 		/* If it's a newly allocated disk block for quota, zero it */
-		if (buffer_new(bh)) {
-			memset(bh->b_data, 0, bh->b_size);
-			set_buffer_uptodate(bh);
-		}
+		if (buffer_new(bh))
+			zero_user(page, pos - blocksize, bh->b_size);
 	}
 
 	if (PageUptodate(page))
@@ -708,7 +706,7 @@ get_a_page:
 
 	/* If quota straddles page boundary, we need to update the rest of the
 	 * quota at the beginning of the next page */
-	if (offset != 0) { /* first page, offset is closer to PAGE_CACHE_SIZE */
+	if ((offset + sizeof(struct gfs2_quota)) > PAGE_CACHE_SIZE) {
 		ptr = ptr + nbytes;
 		nbytes = sizeof(struct gfs2_quota) - nbytes;
 		offset = 0;



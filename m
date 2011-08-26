Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116Ab1H0O7Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 10:59:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47103 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755109Ab1H0O7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 10:59:14 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 26 14:50:53 2011
Message-Id: <20110826215053.713459107@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 26 Aug 2011 14:49:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Boaz Harrosh <bharrosh@panasas.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [08/35] pnfs-obj: Bug when we are running out of bio
In-Reply-To: <20110826215139.GA11498@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Boaz Harrosh <bharrosh@panasas.com>

commit 20618b21da0796115e81906d24ff1601552701b7 upstream.

When we have a situation that the number of pages we want
to encode is bigger then the size of the bio. (Which can
currently happen only when all IO is going to a single device
.e.g group_width==1) then the IO is submitted short and we
report back only the amount of bytes we actually wrote/read
and all is fine. BUT ...

There was a bug that the current length counter was advanced
before the fail to add the extra page, and we come to a situation
that the CDB length was one-page longer then the actual bio size,
which is of course rejected by the osd-target.

While here also fix the bio size calculation, in the case
that we received more then one group of devices.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/objlayout/objio_osd.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/fs/nfs/objlayout/objio_osd.c
+++ b/fs/nfs/objlayout/objio_osd.c
@@ -587,22 +587,19 @@ static void _calc_stripe_info(struct obj
 }
 
 static int _add_stripe_unit(struct objio_state *ios,  unsigned *cur_pg,
-		unsigned pgbase, struct _objio_per_comp *per_dev, int cur_len,
+		unsigned pgbase, struct _objio_per_comp *per_dev, int len,
 		gfp_t gfp_flags)
 {
 	unsigned pg = *cur_pg;
+	int cur_len = len;
 	struct request_queue *q =
 			osd_request_queue(_io_od(ios, per_dev->dev));
 
-	per_dev->length += cur_len;
-
 	if (per_dev->bio == NULL) {
-		unsigned stripes = ios->layout->num_comps /
-						     ios->layout->mirrors_p1;
-		unsigned pages_in_stripe = stripes *
+		unsigned pages_in_stripe = ios->layout->group_width *
 				      (ios->layout->stripe_unit / PAGE_SIZE);
 		unsigned bio_size = (ios->ol_state.nr_pages + pages_in_stripe) /
-				    stripes;
+				    ios->layout->group_width;
 
 		if (BIO_MAX_PAGES_KMALLOC < bio_size)
 			bio_size = BIO_MAX_PAGES_KMALLOC;
@@ -630,6 +627,7 @@ static int _add_stripe_unit(struct objio
 	}
 	BUG_ON(cur_len);
 
+	per_dev->length += len;
 	*cur_pg = pg;
 	return 0;
 }



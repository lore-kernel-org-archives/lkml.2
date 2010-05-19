Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab0ESVvp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 17:51:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752275Ab0ESVvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 17:51:43 -0400
Date: Wed, 19 May 2010 17:51:31 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: Nikanth Karthikesan <knikanth@suse.de>, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC PATCH 2/2] dm: only initialize full request_queue for
 request-based device
Message-ID: <20100519215130.GA32301@redhat.com>
References: <4BEA659F.9050206@ct.jp.nec.com>
 <20100513035750.GA25523@redhat.com>
 <4BED049C.5040409@ct.jp.nec.com>
 <20100514140852.GA10373@redhat.com>
 <4BF10BF1.3040108@ct.jp.nec.com>
 <20100517172737.GA24591@redhat.com>
 <4BF25091.3000507@ct.jp.nec.com>
 <20100518134639.GA27582@redhat.com>
 <4BF37DD5.9050409@ct.jp.nec.com>
 <AANLkTinndXq8DkMBOUf5z8R_8lWRoRbDuOZ1LEmWeI21@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinndXq8DkMBOUf5z8R_8lWRoRbDuOZ1LEmWeI21@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19 2010 at  8:01am -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Wed, May 19, 2010 at 1:57 AM, Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
> > Also, your patch changes the queue configuration even when a table is
> > already active and used.  (e.g. Loading bio-based table to a mapped_device
> > which is already active/used as request-based sets q->requst_fn in NULL.)
> > That could cause some critical problems.
> 
> Yes, that is possible and I can add additional checks to prevent this.
> But this speaks to a more general problem with the existing DM code.
> 
> dm_swap_table() has the negative check to prevent such table loads, e.g.:
> /* cannot change the device type, once a table is bound */
> 
> This check should come during table_load, as part of
> dm_table_set_type(), rather than during table resume.

FYI, the following patch is the relevant portion of the v6 patch that
addresses the issue discussed above.

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 990cf17..62ebd94 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -782,6 +782,7 @@ int dm_table_set_type(struct dm_table *t)
 {
 	unsigned i;
 	unsigned bio_based = 0, request_based = 0;
+	struct dm_table *live_table = NULL;
 	struct dm_target *tgt;
 	struct dm_dev_internal *dd;
 	struct list_head *devices;
@@ -803,7 +804,7 @@ int dm_table_set_type(struct dm_table *t)
 	if (bio_based) {
 		/* We must use this table as bio-based */
 		t->type = DM_TYPE_BIO_BASED;
-		return 0;
+		goto finish;
 	}
 
 	BUG_ON(!request_based); /* No targets in this table */
@@ -831,6 +832,18 @@ int dm_table_set_type(struct dm_table *t)
 
 	t->type = DM_TYPE_REQUEST_BASED;
 
+finish:
+	/* cannot change the device type, once a table is bound */
+	live_table = dm_get_live_table(t->md);
+	if (live_table) {
+		if (dm_table_get_type(live_table) != dm_table_get_type(t)) {
+			DMWARN("can't change the device type after a table is bound");
+			dm_table_put(live_table);
+			return -EINVAL;
+		}
+		dm_table_put(live_table);
+	}
+
 	return 0;
 }
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index a47f0b8..923b662 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2470,13 +2470,6 @@ struct dm_table *dm_swap_table(struct mapped_device *md, struct dm_table *table)
 		goto out;
 	}
 
-	/* cannot change the device type, once a table is bound */
-	if (md->map &&
-	    (dm_table_get_type(md->map) != dm_table_get_type(table))) {
-		DMWARN("can't change the device type after a table is bound");
-		goto out;
-	}
-
 	map = __bind(md, table, &limits);
 
 out:

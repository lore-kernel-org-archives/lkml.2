Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab1H0O7O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 10:59:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47088 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755092Ab1H0O7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 10:59:11 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 26 14:50:53 2011
Message-Id: <20110826215053.609833031@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 26 Aug 2011 14:49:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Boaz Harrosh <bharrosh@panasas.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [07/35] pnfs-obj: Fix the comp_index != 0 case
In-Reply-To: <20110826215139.GA11498@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Boaz Harrosh <bharrosh@panasas.com>

commit 9af7db3228acc286c50e3a0f054ec982efdbc6c6 upstream.

There were bugs in the case of partial layout where olo_comp_index
is not zero. This used to work and was tested but one of the later
cleanup SQUASHMEs broke it and was not tested since.

Also add a dprint that specify those received layout parameters.
Everything else was already printed.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/objlayout/objio_osd.c        |   16 +++++++---------
 fs/nfs/objlayout/pnfs_osd_xdr_cli.c |    3 +++
 2 files changed, 10 insertions(+), 9 deletions(-)

--- a/fs/nfs/objlayout/objio_osd.c
+++ b/fs/nfs/objlayout/objio_osd.c
@@ -479,7 +479,6 @@ static int _io_check(struct objio_state
 	for (i = 0; i <  ios->numdevs; i++) {
 		struct osd_sense_info osi;
 		struct osd_request *or = ios->per_dev[i].or;
-		unsigned dev;
 		int ret;
 
 		if (!or)
@@ -500,9 +499,8 @@ static int _io_check(struct objio_state
 
 			continue; /* we recovered */
 		}
-		dev = ios->per_dev[i].dev;
-		objlayout_io_set_result(&ios->ol_state, dev,
-					&ios->layout->comps[dev].oc_object_id,
+		objlayout_io_set_result(&ios->ol_state, i,
+					&ios->layout->comps[i].oc_object_id,
 					osd_pri_2_pnfs_err(osi.osd_err_pri),
 					ios->per_dev[i].offset,
 					ios->per_dev[i].length,
@@ -650,7 +648,7 @@ static int _prepare_one_group(struct obj
 	int ret = 0;
 
 	while (length) {
-		struct _objio_per_comp *per_dev = &ios->per_dev[dev];
+		struct _objio_per_comp *per_dev = &ios->per_dev[dev - first_dev];
 		unsigned cur_len, page_off = 0;
 
 		if (!per_dev->length) {
@@ -670,8 +668,8 @@ static int _prepare_one_group(struct obj
 				cur_len = stripe_unit;
 			}
 
-			if (max_comp < dev)
-				max_comp = dev;
+			if (max_comp < dev - first_dev)
+				max_comp = dev - first_dev;
 		} else {
 			cur_len = stripe_unit;
 		}
@@ -806,7 +804,7 @@ static int _read_mirrors(struct objio_st
 	struct _objio_per_comp *per_dev = &ios->per_dev[cur_comp];
 	unsigned dev = per_dev->dev;
 	struct pnfs_osd_object_cred *cred =
-			&ios->layout->comps[dev];
+			&ios->layout->comps[cur_comp];
 	struct osd_obj_id obj = {
 		.partition = cred->oc_object_id.oid_partition_id,
 		.id = cred->oc_object_id.oid_object_id,
@@ -904,7 +902,7 @@ static int _write_mirrors(struct objio_s
 	for (; cur_comp < last_comp; ++cur_comp, ++dev) {
 		struct osd_request *or = NULL;
 		struct pnfs_osd_object_cred *cred =
-					&ios->layout->comps[dev];
+					&ios->layout->comps[cur_comp];
 		struct osd_obj_id obj = {
 			.partition = cred->oc_object_id.oid_partition_id,
 			.id = cred->oc_object_id.oid_object_id,
--- a/fs/nfs/objlayout/pnfs_osd_xdr_cli.c
+++ b/fs/nfs/objlayout/pnfs_osd_xdr_cli.c
@@ -170,6 +170,9 @@ int pnfs_osd_xdr_decode_layout_map(struc
 	p = _osd_xdr_decode_data_map(p, &layout->olo_map);
 	layout->olo_comps_index = be32_to_cpup(p++);
 	layout->olo_num_comps = be32_to_cpup(p++);
+	dprintk("%s: olo_comps_index=%d olo_num_comps=%d\n", __func__,
+		layout->olo_comps_index, layout->olo_num_comps);
+
 	iter->total_comps = layout->olo_num_comps;
 	return 0;
 }



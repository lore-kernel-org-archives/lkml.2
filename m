Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537Ab3AAChc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 21:37:32 -0500
Received: from nigelcunningham.com.au ([178.79.133.97]:37349 "EHLO
	nigelcunningham.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab3AACh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 21:37:29 -0500
Message-ID: <50E24BE4.5040704@nigelcunningham.com.au>
Date: Tue, 01 Jan 2013 13:37:24 +1100
From: Nigel Cunningham <nigel@nigelcunningham.com.au>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] Re: New Defect(s) reported by Coverity Scan
References: <C0A4ACBB26D853488EA0C68388B70268168CDC32@BLUPRD0511MB401.namprd05.prod.outlook.com>
In-Reply-To: <C0A4ACBB26D853488EA0C68388B70268168CDC32@BLUPRD0511MB401.namprd05.prod.outlook.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From b41864867464bfe0e2d114528bc9b39e2d9f546e Mon Sep 17 00:00:00 2001
From: Nigel Cunningham <nigel@nigelcunningham.com.au>
Date: Tue, 1 Jan 2013 13:03:50 +1100
Subject: [PATCH] Fix rbd use after free.

This patch addresses Coverity #753114.

The use of ceph_opts in rbd_add is currently confusing - there
are three possible outcomes of the call to rbd_get_client:

1) An existing, matching and usable rdb client is found and returned by
    rbd_client_find. ceph_opts is freed by rbd_get_client and should not
    be freed by rbd_add. This the code path triggering the Coverity
    warning.
2) An existing, matching and usable rdb client is NOT found and returned
    by rbd_client_find. rbd_client_create successfully executes, passing
    responsibility for ceph_opts to the newly created client. It should
    not be freed by rbd_add.
3) An existing, matching and usable rdb client is NOT found and returned
    by rbd_client_find. rbd_client_create fails to create a new client,
    freeing ceph_opts in its error path. It should not be freed by rbd_add.

So then, regardless of the outcome of rbd_get_client, if it is called, we
should not attempt to free ceph_opts. The solution is then simple: there
is no need to seek to free ceph_opts in rbd_add (or do anything with it)
because rbd_get_client is called immediately after the structure is
allocated by rbd_add_parse_args.

Signed-off-by: Nigel Cunningham <nigel@nigelcunningham.com.au>
---
  drivers/block/rbd.c |    3 ---
  1 file changed, 3 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 89576a0..dfb7ef8 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -3629,7 +3629,6 @@ static ssize_t rbd_add(struct bus_type *bus,
          rc = PTR_ERR(rbdc);
          goto err_out_args;
      }
-    ceph_opts = NULL;    /* rbd_dev client now owns this */

      /* pick the pool */
      osdc = &rbdc->client->osdc;
@@ -3658,8 +3657,6 @@ err_out_rbd_dev:
  err_out_client:
      rbd_put_client(rbdc);
  err_out_args:
-    if (ceph_opts)
-        ceph_destroy_options(ceph_opts);
      kfree(rbd_opts);
      rbd_spec_put(spec);
  err_out_module:
-- 
1.7.10.4


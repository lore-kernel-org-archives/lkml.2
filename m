Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172Ab1IWGgj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 02:36:39 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:65527 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab1IWGgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 02:36:38 -0400
Date: Fri, 23 Sep 2011 09:25:48 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Tim Waugh <tim@cyberelk.net>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] paride: potential information leak in pg_read()
Message-ID: <20110923062548.GK4387@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4E7C28F3.00BE:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Smatch has a new check for Rosenberg type information leaks where
structs are copied to the user with uninitialized stack data in them.
i
In this case, the pg_write_hdr struct has a hole in it.

struct pg_write_hdr {
        char                       magic;                /*     0     1 */
        char                       func;                 /*     1     1 */
        /* XXX 2 bytes hole, try to pack */
        int                        dlen;                 /*     4     4 */

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/block/paride/pg.c b/drivers/block/paride/pg.c
index 6b9a200..a79fb4f 100644
--- a/drivers/block/paride/pg.c
+++ b/drivers/block/paride/pg.c
@@ -630,6 +630,7 @@ static ssize_t pg_read(struct file *filp, char __user *buf, size_t count, loff_t
 		if (dev->status & 0x10)
 			return -ETIME;
 
+	memset(&hdr, 0, sizeof(hdr));
 	hdr.magic = PG_MAGIC;
 	hdr.dlen = dev->dlen;
 	copy = 0;


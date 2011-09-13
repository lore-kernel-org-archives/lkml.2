Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab1IMRh4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 13:37:56 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:59103 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755823Ab1IMRhy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 13:37:54 -0400
MIME-Version: 1.0
Message-ID: <2ca31b06-eef9-49e4-beba-4959471b45d2@default>
Date: Tue, 13 Sep 2011 10:37:23 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Greg KH <greg@kroah.com>
Cc: Francis Moreau <francis.moro@gmail.com>, gregkh@suse.de,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        devel@driverdev.osuosl.org, linux-mm@kvack.org,
        Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org
Subject: [REVERT for 3.1-rc7] staging: zcache: revert "fix crash on high
 memory swap"
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4E6F94E8.00FD:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg --

Please revert the following commit, hopefully before 3.1 is released.
Although it fixes a crash in 32-bit systems with high memory,
the fix apparently *causes* crashes on 64-bit systems.  Not sure why
my testing didn't catch it before but it has now been observed in
the wild in 3.1-rc4 and I can reproduce it now fairly easily.
3.1-rc3 works fine, 3.1-rc4 fails, and 3.1-rc3 plus only this
commit fails.  Let's revert it before 3.1 and Seth and Nitin and I
will sort out a better fix later.

Reported-by: Francis Moreau <francis.moro@gmail.com>
Reproduced-by: Dan Magenheimer <dan.magenheimer@oracle.com>

Thanks,
Dan

commit c5f5c4db393837ebb2ae47bf061d70e498f48f8c
Author: Seth Jennings <sjenning@linux.vnet.ibm.com>
Date:   Wed Aug 10 12:56:49 2011 -0500

    staging: zcache: fix crash on high memory swap
    
    zcache_put_page() was modified to pass page_address(page) instead of the
    actual page structure. In combination with the function signature changes
    to tmem_put() and zcache_pampd_create(), zcache_pampd_create() tries to
    (re)derive the page structure from the virtual address.  However, if the
    original page is a high memory page (or any unmapped page), this
    virt_to_page() fails because the page_address() in zcache_put_page()
    returned NULL.
    
    This patch changes zcache_put_page() and zcache_get_page() to pass
    the page structure instead of the page's virtual address, which
    may or may not exist.
    
    Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
    Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index 855a5bb..a3f5162 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -1158,7 +1158,7 @@ static void *zcache_pampd_create(char *data, size_t size, bool raw, int eph,
 	size_t clen;
 	int ret;
 	unsigned long count;
-	struct page *page = virt_to_page(data);
+	struct page *page = (struct page *)(data);
 	struct zcache_client *cli = pool->client;
 	uint16_t client_id = get_client_id_from_client(cli);
 	unsigned long zv_mean_zsize;
@@ -1227,7 +1227,7 @@ static int zcache_pampd_get_data(char *data, size_t *bufsize, bool raw,
 	int ret = 0;
 
 	BUG_ON(is_ephemeral(pool));
-	zv_decompress(virt_to_page(data), pampd);
+	zv_decompress((struct page *)(data), pampd);
 	return ret;
 }
 
@@ -1539,7 +1539,7 @@ static int zcache_put_page(int cli_id, int pool_id, struct tmem_oid *oidp,
 		goto out;
 	if (!zcache_freeze && zcache_do_preload(pool) == 0) {
 		/* preload does preempt_disable on success */
-		ret = tmem_put(pool, oidp, index, page_address(page),
+		ret = tmem_put(pool, oidp, index, (char *)(page),
 				PAGE_SIZE, 0, is_ephemeral(pool));
 		if (ret < 0) {
 			if (is_ephemeral(pool))
@@ -1572,7 +1572,7 @@ static int zcache_get_page(int cli_id, int pool_id, struct tmem_oid *oidp,
 	pool = zcache_get_pool_by_id(cli_id, pool_id);
 	if (likely(pool != NULL)) {
 		if (atomic_read(&pool->obj_count) > 0)
-			ret = tmem_get(pool, oidp, index, page_address(page),
+			ret = tmem_get(pool, oidp, index, (char *)(page),
 					&size, 0, is_ephemeral(pool));
 		zcache_put_pool(pool);
 	}

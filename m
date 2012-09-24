Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab2IXOiw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 10:38:52 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:51225 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab2IXOiv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 10:38:51 -0400
Subject: Re: [PATCH v2] Persistent grant maps for xen blk drivers
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Andres Lagar-Cavilla <andreslc@gridcentric.ca>
In-Reply-To: <20120921204646.GB30614@phenom.dumpdata.com>
Date: Mon, 24 Sep 2012 10:38:48 -0400
Cc: Oliver Chick <oliver.chick@citrix.com>, xen-devel@lists.xen.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <43E8FEC9-DE7D-4352-87F2-63FB8984D556@gridcentric.ca>
References: <1348242767-23732-1-git-send-email-oliver.chick@citrix.com> <20120921184123.GA27502@phenom.dumpdata.com> <20120921185622.GA5042@phenom.dumpdata.com> <20120921204646.GB30614@phenom.dumpdata.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 21, 2012, at 4:46 PM, Konrad Rzeszutek Wilk wrote:

> On Fri, Sep 21, 2012 at 02:56:22PM -0400, Konrad Rzeszutek Wilk wrote:
>>> *: With a PVHVM guest I get
>>> 
>>> [  261.927218] privcmd_fault: vma=ffff88002a31dce8 7f4edc095000-7f4edc195000, pgoff=c8, uv=00007f4edc15d000
>>> 
>>> thought if I applied your patch on top of v3.6-rc6 I didn't see the privcmd_fault but
>>> I did see the guest crash.
>> 
>> And that is due to c571898ffc24a1768e1b2dabeac0fc7dd4c14601 which I've reverted in my
>> #linux-next branch
> 
> Nevermind. Andres' patch by itself (so without yours) works just fine. There is
> something your patch and his aren't agreeing on.

Apart from interacting badly in combination, would either patch in isolation work well?

I can think of only one hunk in my patch disagreeing with blkback stuff:
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index eea81cf..f5681c8 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -836,6 +883,12 @@ int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
 	if (ret)
 		return ret;
 
+	/* Retry eagain maps */
+	for (i = 0; i < count; i++)
+		if (map_ops[i].status == GNTST_eagain)
+			gnttab_retry_eagain_gop(GNTTABOP_map_grant_ref, map_ops + i,
+                                    &map_ops[i].status, __func__);
+
 	if (xen_feature(XENFEAT_auto_translated_physmap))
 		return ret;
 
How would you like to proceed?
Andres

> 


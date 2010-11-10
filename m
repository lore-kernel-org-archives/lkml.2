Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab0KJOIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 09:08:42 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46870 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756097Ab0KJOIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 09:08:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=oQY17XBNE6IaQoyHIzPe+EwUrIyFKD20EvhzSpKWmdrBChw0MmWOgrgOKk88YQiWC6
         NWMtjGPAbLyloqV++rovxcoLdha017S0YsT/2qgTchz7zQf5sytcosBRwglJ6A3eMxtp
         Pl7exErq0er85+FKfTiayJ0y03d5twIfNkozw=
MIME-Version: 1.0
Date: Wed, 10 Nov 2010 22:08:37 +0800
Message-ID: <AANLkTikbkhHmsVAdGrY0OTnH=gUZW5igjsWSF9y=Ub1u@mail.gmail.com>
Subject: [PATCH] fix vulnerability of the release method of file operations in
 Block layer SCSI generic driver
From: Hillf Danton <dhillf@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, "Zou, Yi" <yi.zou@intel.com>,
        Joe Eykholt <jeykholt@cisco.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The computation context setup by previous opening the bsg file could
not survive following open/release operations upon the same file
object.

The vulnerability is fixed by deferring the cleanup operation until necessary.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/block/bsg.c	2010-09-13 07:07:38.000000000 +0800
+++ b/block/bsg.c	2010-11-10 21:43:58.000000000 +0800
@@ -858,7 +858,8 @@ static int bsg_release(struct inode *ino
 {
 	struct bsg_device *bd = file->private_data;

-	file->private_data = NULL;
+	if (1 == atomic_read(&bd->ref_count))
+		file->private_data = NULL;
 	return bsg_put_device(bd);
 }

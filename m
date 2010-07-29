Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371Ab0G2NXD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 09:23:03 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50527 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012Ab0G2NXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 09:23:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=hd7uRz9cyjBRBUCM3N20yk+8kvC8dDX9XtGOv1u42+gsNx2eY+xMtMBhyF+y+U1+nB
         KmCuWAE3aXJSuTDkeyLnrhFmnTIwnZ0CM58MbwPBi5nNj1uM5ZyaWzLSh30dfuVRVNm0
         mrRaZ8OhJfeoj7MxgptF2eOjcSNFJ8pEun9lE=
Date: Thu, 29 Jul 2010 17:22:23 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
To: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Nicolas Pitre <nico@fluxnic.net>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Jiri Slaby <jslaby@suse.cz>, Stefani Seibold <stefani@seibold.net>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [bug] Fixing mutex_lock() under held spinlock
Message-ID: <20100729132223.GA19715@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've found that cfi_cmdset and lpddr_cmds call mutex_lock() under held
spinlock(). Maybe it was designed as a special locking scheme, so I
don't try to fix it as I might create new complex locking problem.


--- ./drivers/mtd/chips/cfi_cmdset_0001.c	2010-07-06 16:45:43.000000000 +0400
+++ /tmp/cocci-output-8818-2d9c62-cfi_cmdset_0001.c	2010-07-29 16:30:47.000000000 +0400
@@ -959,14 +959,12 @@ static void put_chip(struct map_info *ma
 
 	if (chip->priv) {
 		struct flchip_shared *shared = chip->priv;
-		spin_lock(&shared->lock);
 		if (shared->writing == chip && chip->oldstate == FL_READY) {
 			/* We own the ability to write, but we're done */
 			shared->writing = shared->erasing;
 			if (shared->writing && shared->writing != chip) {
 				/* give back ownership to who we loaned it from */
 				struct flchip *loaner = shared->writing;
-				mutex_lock(&loaner->mutex);
 				spin_unlock(&shared->lock);
 				mutex_unlock(&chip->mutex);
 				put_chip(map, loaner, loaner->start);
--- ./drivers/mtd/lpddr/lpddr_cmds.c	2010-07-06 16:45:43.000000000 +0400
+++ /tmp/cocci-output-8953-56b3dd-lpddr_cmds.c	2010-07-29 16:30:57.000000000 +0400
@@ -348,14 +348,12 @@ static void put_chip(struct map_info *ma
 {
 	if (chip->priv) {
 		struct flchip_shared *shared = chip->priv;
-		spin_lock(&shared->lock);
 		if (shared->writing == chip && chip->oldstate == FL_READY) {
 			/* We own the ability to write, but we're done */
 			shared->writing = shared->erasing;
 			if (shared->writing && shared->writing != chip) {
 				/* give back the ownership */
 				struct flchip *loaner = shared->writing;
-				mutex_lock(&loaner->mutex);
 				spin_unlock(&shared->lock);
 				mutex_unlock(&chip->mutex);
 				put_chip(map, loaner);


thanks,
Vasiliy

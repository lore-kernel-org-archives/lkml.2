Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824Ab2FGEPF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:15:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62777 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab2FGEPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:15:02 -0400
Message-Id: <20120607040336.654920240@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:03:37 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Johannes Schild <JSchild@gmx.de>,
        Boaz Harrosh <bharrosh@panasas.com>
Subject: [ 01/82] exofs: Fix CRASH on very early IO errors.
In-Reply-To: <20120607041406.GA13233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boaz Harrosh <bharrosh@panasas.com>

commit 6abe4a87f7bc7978705c386dbba0ca0c7790b3ec upstream.

If at exofs_fill_super() we had an early termination
do to any error, like an IO error while reading the
super-block. We would crash inside exofs_free_sbi().

This is because sbi->oc.numdevs was set to 1, before
we actually have a device table at all.

Fix it by moving the sbi->oc.numdevs = 1 to after the
allocation of the device table.

Reported-by: Johannes Schild <JSchild@gmx.de>

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/exofs/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/exofs/super.c
+++ b/fs/exofs/super.c
@@ -745,7 +745,6 @@ static int exofs_fill_super(struct super
 	sbi->one_comp.obj.partition = opts->pid;
 	sbi->one_comp.obj.id = 0;
 	exofs_make_credential(sbi->one_comp.cred, &sbi->one_comp.obj);
-	sbi->oc.numdevs = 1;
 	sbi->oc.single_comp = EC_SINGLE_COMP;
 	sbi->oc.comps = &sbi->one_comp;
 
@@ -804,6 +803,7 @@ static int exofs_fill_super(struct super
 			goto free_sbi;
 
 		ore_comp_set_dev(&sbi->oc, 0, od);
+		sbi->oc.numdevs = 1;
 	}
 
 	__sbi_read_stats(sbi);



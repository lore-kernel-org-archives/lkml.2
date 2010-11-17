Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967Ab0KQFIi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 00:08:38 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49369 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab0KQFIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 00:08:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=rTTSDQZX2H6/dd70Im26BvZ8CAobyjp3z4Ip7F3gjEzrnht1TVDz3kVLH3Onfbtebz
         eNy4kz3ggSuKFft6znX8tuXNU2Ux0xKfodKXzMTFALJRXPyfQTI7QzNZhxIoxUgheLxQ
         8BMulH0+774dwJOo7mUgc8vEC9piu23rJWA98=
Date: Wed, 17 Nov 2010 08:07:32 +0300
From: Dan Carpenter <error27@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Lukas Czerner <lczerner@redhat.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] ext4: missing unlock in ext4_clear_request_list()
Message-ID: <20101117050732.GB31724@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Theodore Ts'o <tytso@mit.edu>, Lukas Czerner <lczerner@redhat.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the the li_request_list was empty then it returned with the lock
held.  Instead of adding a "goto unlock" I just removed that special
case and let it go past the empty list_for_each_safe().

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
This is a static checker patch.

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 61182fe..ef09d14 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2799,9 +2799,6 @@ static void ext4_clear_request_list(void)
 	struct ext4_li_request *elr;
 
 	mutex_lock(&ext4_li_info->li_list_mtx);
-	if (list_empty(&ext4_li_info->li_request_list))
-		return;
-
 	list_for_each_safe(pos, n, &ext4_li_info->li_request_list) {
 		elr = list_entry(pos, struct ext4_li_request,
 				 lr_request);

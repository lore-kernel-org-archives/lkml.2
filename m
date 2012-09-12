Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267Ab2IMAdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 20:33:15 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37074 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932279Ab2ILXdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:33:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [ 036/108] UBIFS: fix crash on error path
Date: Wed, 12 Sep 2012 16:28:34 -0700
Message-Id: <20120912232454.322374429@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912232450.500619493@linuxfoundation.org>
References: <20120912232816.GA1655@kroah.com>
 <20120912232450.500619493@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

commit 11e3be0be2a1314e0861304857e7efcaed5d3e54 upstream.

This patch fixes a regression introduced by
"4994297 UBIFS: make ubifs_lpt_init clean-up in case of failure" which
I've hit while running the 'integck -p' test. When remount the file-system
from R/O mode to R/W mode and 'lpt_init_wr()' fails, we free _all_ LPT
resources by calling 'ubifs_lpt_free(c, 0)', even those needed for R/O
mode. This leads to subsequent crashes, e.g., if we try to unmount
the file-system.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ubifs/lpt.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/ubifs/lpt.c
+++ b/fs/ubifs/lpt.c
@@ -1749,7 +1749,10 @@ int ubifs_lpt_init(struct ubifs_info *c,
 	return 0;
 
 out_err:
-	ubifs_lpt_free(c, 0);
+	if (wr)
+		ubifs_lpt_free(c, 1);
+	if (rd)
+		ubifs_lpt_free(c, 0);
 	return err;
 }
 



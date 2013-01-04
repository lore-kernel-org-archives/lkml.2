Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399Ab3ADTML (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 14:12:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754013Ab3ADTMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 14:12:10 -0500
Date: Fri, 4 Jan 2013 14:12:05 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, dhowells@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] MODSIGN: Don't taint unless signature enforcing is enabled
Message-ID: <20130104191205.GD27554@hansolo.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With module signing enabled but not in enforcing mode, we don't consider
unsigned modules to be an error.  However, we only mark sig_ok as true if
a signature verified.  This causes the module to be tainted with the
TAINT_FORCED_MODULE flag.  That in turn taints the kernel, which also
disables lockdep.

Tainting the module and kernel when we don't consider something to be an
error seems excessive.  This marks sig_ok as true if we aren't in enforcing
mode.

Reported-by: Frank Ch. Eigler <fche@redhat.com>
Signed-off-by: Josh Boyer <jwboyer@redhat.com>
---
 kernel/module.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/module.c b/kernel/module.c
index 250092c..a50172e 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2443,8 +2443,10 @@ static int module_sig_check(struct load_info *info)
 	if (err < 0 && fips_enabled)
 		panic("Module verification failed with error %d in FIPS mode\n",
 		      err);
-	if (err == -ENOKEY && !sig_enforce)
+	if (err == -ENOKEY && !sig_enforce) {
+		info->sig_ok = true;
 		err = 0;
+	}
 
 	return err;
 }
-- 
1.8.0.1

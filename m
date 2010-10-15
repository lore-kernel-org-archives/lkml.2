Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab0JOMyP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 08:54:15 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:56501 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754331Ab0JOMyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 08:54:13 -0400
From: Julia Lawall <julia@diku.dk>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: kernel-janitors@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] drivers/staging: Clean up error-handling code
Date: Fri, 15 Oct 2010 15:00:10 +0200
Message-Id: <1287147610-8041-7-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

In the first hunk, 0 is returned on memory allocation failure, even though
other failures return -ENOMEM or other similar values.

In the second hunk, there was error handling code that returned without
freeing psz_path_name.

A simplified version of the semantic match that finds the first problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression ret;
expression x,e1,e2,e3;
@@

ret = 0
... when != ret = e1
*x = \(kmalloc\|kcalloc\|kzalloc\)(...)
... when != ret = e2
if (x == NULL) { ... when != ret = e3
  return ret;
}
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/staging/tidspbridge/pmgr/dspapi.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -u -p a/drivers/staging/tidspbridge/pmgr/dspapi.c b/drivers/staging/tidspbridge/pmgr/dspapi.c
--- a/drivers/staging/tidspbridge/pmgr/dspapi.c
+++ b/drivers/staging/tidspbridge/pmgr/dspapi.c
@@ -493,8 +493,10 @@ u32 mgrwrap_register_object(union trappe
 				args->args_mgr_registerobject.psz_path_name) +
 	    1;
 	psz_path_name = kmalloc(path_size, GFP_KERNEL);
-	if (!psz_path_name)
+	if (!psz_path_name) {
+		status = -ENOMEM;
 		goto func_end;
+	}
 	ret = strncpy_from_user(psz_path_name,
 				(char *)args->args_mgr_registerobject.
 				psz_path_name, path_size);
@@ -503,8 +505,10 @@ u32 mgrwrap_register_object(union trappe
 		goto func_end;
 	}
 
-	if (args->args_mgr_registerobject.obj_type >= DSP_DCDMAXOBJTYPE)
-		return -EINVAL;
+	if (args->args_mgr_registerobject.obj_type >= DSP_DCDMAXOBJTYPE) {
+		status = -EINVAL;
+		goto func_end;
+	}
 
 	status = dcd_register_object(&uuid_obj,
 				     args->args_mgr_registerobject.obj_type,


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933703Ab1ERTUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 15:20:50 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:39924 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933641Ab1ERTUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 15:20:48 -0400
From: Julia Lawall <julia@diku.dk>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: kernel-janitors@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Ramesh Agarwal <ramesh.agarwal@intel.com>,
        Dan Carpenter <error27@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/staging/cptm1217/clearpad_tm1217.c: Correct call to input_free_device
Date: Wed, 18 May 2011 21:20:43 +0200
Message-Id: <1305746443-694-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

This code is in a loop that currently is only executed once.  Because of
this property, the first block of code is currently actually correct.
Nevertheless, the comments associated with the code suggest that the loop
is planned to take more than one iteration in the future, and thus this
patch is made with that case in mind.

In the first block of code, there is currently an immediate abort from the
function.  It is changed to jump to the error handling code at fail, to be
able to unregister and free the resources allocated on previous iterations.

In the second block of code, the input_dev for the current iteration has
been allocated, but has not been registered.  It has also not been stored
in ts->cp_input_info[i].input.  Thus on jumping to fail, it will not be
freed.  In this case, we want to free, but not unregister, so the free for
this most recently allocated resource is put before the jump.

A simplified version of the semantic match that finds this problem is:
(http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
local idexpression struct input_dev * x;
expression ra,rr;
position p1,p2;
@@

x = input_allocate_device@p1(...)
...  when != x = rr
     when != input_free_device(x,...)
     when != if (...) { ... input_free_device(x,...) ...}
if(...) { ... when != x = ra
     when forall
     when != input_free_device(x,...)
 \(return <+...x...+>; \| return@p2...; \) }

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

cocci.print_main("input_allocate_device",p1)
cocci.print_secs("input_free_device",p2)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
Only compile tested.

 drivers/staging/cptm1217/clearpad_tm1217.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/cptm1217/clearpad_tm1217.c b/drivers/staging/cptm1217/clearpad_tm1217.c
index 0fe713e..5456f82 100644
--- a/drivers/staging/cptm1217/clearpad_tm1217.c
+++ b/drivers/staging/cptm1217/clearpad_tm1217.c
@@ -462,8 +462,8 @@ static int cp_tm1217_probe(struct i2c_client *client,
 		if (input_dev == NULL) {
 			dev_err(ts->dev,
 				"cp_tm1217:Input Device Struct alloc failed\n");
-			kfree(ts);
-			return -ENOMEM;
+			retval = -ENOMEM;
+			goto fail;
 		}
 		input_info = &ts->cp_input_info[i];
 		snprintf(input_info->name, sizeof(input_info->name),
@@ -486,6 +486,7 @@ static int cp_tm1217_probe(struct i2c_client *client,
 			dev_err(ts->dev,
 				"Input dev registration failed for %s\n",
 					input_dev->name);
+			input_free_device(input_dev);
 			goto fail;
 		}
 		input_info->input = input_dev;


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757760Ab1ENOTO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 10:19:14 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:41706 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755496Ab1ENOTB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 10:19:01 -0400
From: Julia Lawall <julia@diku.dk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: kernel-janitors@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
        Joe Perches <joe@perches.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] drivers/media/rc/imon.c: Correct call to input_free_device
Date: Sat, 14 May 2011 16:18:55 +0200
Message-Id: <1305382735-11474-2-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

ictx->touch is intialied in imon_init_intf1, to the result of calling the
function that contains this code.  Thus, in this code, input_free_device
should be called on touch itself.

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
 drivers/media/rc/imon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 8fc0f08..c400318 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -1982,7 +1982,7 @@ static struct input_dev *imon_init_touch(struct imon_context *ictx)
 	return touch;
 
 touch_register_failed:
-	input_free_device(ictx->touch);
+	input_free_device(touch);
 
 touch_alloc_failed:
 	return NULL;


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab0EOJqo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 05:46:44 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:53951 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090Ab0EOJql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 05:46:41 -0400
Date: Sat, 15 May 2010 11:46:36 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 3/4] drivers/hid: Eliminate use after free
Message-ID: <Pine.LNX.4.64.1005151146120.15566@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The skip label frees resp, which has not been allocated at the point of
this goto and then does a break, based on the fact that err is non-zero.
This is replaced by a break directly.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@free@
expression E;
position p;
@@
kfree@p(E)

@@
expression free.E, subE<=free.E, E1;
position free.p;
@@

  kfree@p(E)
  ...
(
  subE = E1
|
* E
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/hid/hid-picolcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-picolcd.c b/drivers/hid/hid-picolcd.c
index 95253b3..7aabf65 100644
--- a/drivers/hid/hid-picolcd.c
+++ b/drivers/hid/hid-picolcd.c
@@ -1616,7 +1616,7 @@ static ssize_t _picolcd_flash_write(struct picolcd_data *data, int report_id,
 		raw_data[len_off] = s > 32 ? 32 : s;
 		if (copy_from_user(raw_data+len_off+1, u, raw_data[len_off])) {
 			err = -EFAULT;
-			goto skip;
+			break;
 		}
 		resp = picolcd_send_and_wait(data->hdev, report_id, raw_data,
 				len_off+1+raw_data[len_off]);

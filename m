Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933499Ab1FWSGd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:06:33 -0400
Received: from mail.windriver.com ([147.11.1.11]:34736 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933234Ab1FWRg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:36:59 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Jochen Friedrich <jochen@scram.de>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 138/247] mfd: Fix NULL pointer due to non-initialized ucb1x00-ts absinfo
Date: Thu, 23 Jun 2011 13:33:26 -0400
Message-Id: <1308850515-15242-79-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jochen Friedrich <jochen@scram.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 9063f1f15eec35e5fd608879cef8be5728f2d12a upstream.

Call input_set_abs_params instead of manually setting absbit only.
This fixes this oops:

Unable to handle kernel NULL pointer dereference at virtual address 00000024
Internal error: Oops: 41b67017 [#1]
CPU: 0    Not tainted  (2.6.37 #4)
pc : [<c016d1fc>]    lr : [<00000000>]    psr: 20000093
sp : c19e5f30  ip : c19e5e6c  fp : c19e5f58
r10: 00000000  r9 : c19e4000  r8 : 00000003
r7 : 000001e4  r6 : 00000001  r5 : c1854400  r4 : 00000003
r3 : 00000018  r2 : 00000018  r1 : 00000018  r0 : c185447c
Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: c1b6717f  Table: c1b6717f  DAC: 00000017
Stack: (0xc19e5f30 to 0xc19e6000)
5f20:                                     00000003 00000003 c1854400 00000013
5f40: 00000001 000001e4 000001c5 c19e5f80 c19e5f5c c016d5e8 c016cf5c 000001e4
5f60: c1854400 c18b5860 00000000 00000171 000001e4 c19e5fc4 c19e5f84 c01559a4
5f80: c016d584 c18b5868 00000000 c1bb5c40 c0035afc c18b5868 c18b5868 c1a55d54
5fa0: c18b5860 c0155750 00000013 00000000 00000000 00000000 c19e5ff4 c19e5fc8
5fc0: c0050174 c015575c 00000000 c18b5860 00000000 c19e5fd4 c19e5fd4 c1a55d54
5fe0: c00500f0 c003b464 00000000 c19e5ff8 c003b464 c00500fc 04000400 04000400
Backtrace:
Function entered at [<c016cf50>] from [<c016d5e8>]
Function entered at [<c016d578>] from [<c01559a4>]
 r8:000001e4 r7:00000171 r6:00000000 r5:c18b5860 r4:c1854400
Function entered at [<c0155750>] from [<c0050174>]
Function entered at [<c00500f0>] from [<c003b464>]
 r6:c003b464 r5:c00500f0 r4:c1a55d54
Code: e59520fc e1a03286 e0433186 e0822003 (e592000c)

>>PC;  c016d1fc <input_handle_event+2ac/5a0>   <=====

Trace; c016cf50 <input_handle_event+0/5a0>
Trace; c016d5e8 <input_event+70/88>
Trace; c016d578 <input_event+0/88>
Trace; c01559a4 <ucb1x00_thread+254/2dc>
Trace; c0155750 <ucb1x00_thread+0/2dc>
Trace; c0050174 <kthread+84/8c>
Trace; c00500f0 <kthread+0/8c>
Trace; c003b464 <do_exit+0/624>

Signed-off-by: Jochen Friedrich <jochen@scram.de>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/mfd/ucb1x00-ts.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/ucb1x00-ts.c b/drivers/mfd/ucb1x00-ts.c
index 000cb41..92b85e2 100644
--- a/drivers/mfd/ucb1x00-ts.c
+++ b/drivers/mfd/ucb1x00-ts.c
@@ -385,12 +385,18 @@ static int ucb1x00_ts_add(struct ucb1x00_dev *dev)
 	idev->close      = ucb1x00_ts_close;
 
 	__set_bit(EV_ABS, idev->evbit);
-	__set_bit(ABS_X, idev->absbit);
-	__set_bit(ABS_Y, idev->absbit);
-	__set_bit(ABS_PRESSURE, idev->absbit);
 
 	input_set_drvdata(idev, ts);
 
+	ucb1x00_adc_enable(ts->ucb);
+	ts->x_res = ucb1x00_ts_read_xres(ts);
+	ts->y_res = ucb1x00_ts_read_yres(ts);
+	ucb1x00_adc_disable(ts->ucb);
+
+	input_set_abs_params(idev, ABS_X, 0, ts->x_res, 0, 0);
+	input_set_abs_params(idev, ABS_Y, 0, ts->y_res, 0, 0);
+	input_set_abs_params(idev, ABS_PRESSURE, 0, 0, 0, 0);
+
 	err = input_register_device(idev);
 	if (err)
 		goto fail;
-- 
1.7.4.4


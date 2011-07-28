Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab1G1Vt4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 17:49:56 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:14189 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143Ab1G1Vtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 17:49:53 -0400
Date: Thu, 28 Jul 2011 23:49:51 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Jarod Wilson <jarod@wilsonet.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Andy Walls <awalls@md.metrocast.net>, devel@driverdev.osuosl.org,
        Gerd Knorr <kraxel@goldbach.in-berlin.de>,
        Michal Kochanowicz <mkochano@pld.org.pl>,
        Christoph Bartelmus <lirc@bartelmus.de>,
        Ulrich Mueller <ulrich.mueller42@web.de>,
        Stefan Jahn <stefan@lkcc.org>,
        Jerome Brock <jbrock@users.sourceforge.net>,
        Thomas Reitmayr <treitmayr@yahoo.com>, Mark Weaver <mark@npsl.co.uk>,
        Jarod Wilson <jarod@redhat.com>
Subject: [PATCH] staging; lirc, zilog: put_ir_rx may free 'rx' which can lead
 to double free
Message-ID: <alpine.LNX.2.00.1107282345540.20477@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If calling put_ir_rx(rx, true); in
drivers/staging/lirc/lirc_zilog.c::ir_probe() returns true (1) then it
means that it has freed it's first argument. Subsequently jumping to
'out_put_xx' will cause us to call put_ir_rx() once more since 'rx' is
not zero - leading to a double free.
To fix this, test the return value of 'put_ir_rx()' and if it is true
(1), zero 'rx' so that we won't do it again.

I'm not familiar with this code, so this may not be the best fix, and
I also don't have the hardware to test it properly, so this patch is
compile tested only and someone who knows this code should probably
ACK it before it's merged.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/lirc/lirc_zilog.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/lirc/lirc_zilog.c b/drivers/staging/lirc/lirc_zilog.c
index 0302d82..51ded22 100644
--- a/drivers/staging/lirc/lirc_zilog.c
+++ b/drivers/staging/lirc/lirc_zilog.c
@@ -1577,7 +1577,8 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 			put_ir_device(ir, true);
 			/* Failure exit, so put back rx ref from i2c_client */
 			i2c_set_clientdata(client, NULL);
-			put_ir_rx(rx, true);
+			if (put_ir_rx(rx, true))
+				rx = NULL;
 			ir->l.features &= ~LIRC_CAN_REC_LIRCCODE;
 			goto out_put_xx;
 		}
-- 
1.7.6


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.


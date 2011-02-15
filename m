Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab1BOJUX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 04:20:23 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50848 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974Ab1BOJUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 04:20:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=F7g6ZxQ2Qss6HICbcP6InaNYVfAcQHSexfIanOA8IHorhKJC0QTBOK8KstWtQW8cTN
         NK1PySdJicfHx6xHw0r6KwZEXTsvEXYItUOPxS8vt5k1h8ALHXJepteGal5aCaz6KxxZ
         PINUynJODmcivg4453Xn+tY4ezfiji6K7OprM=
Date: Tue, 15 Feb 2011 10:20:12 +0100
From: Tejun Heo <tj@kernel.org>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, stoth@kernellabs.com,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH] cx23885: restore flushes of cx23885_dev work items
Message-ID: <20110215092012.GE3160@htj.dyndns.org>
References: <1297647322.19186.61.camel@localhost>
 <20110214043355.GA28090@core.coreip.homeip.net>
 <20110214110339.GC18742@htj.dyndns.org>
 <1297731276.2394.19.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297731276.2394.19.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 8c71778c (media/video: don't use flush_scheduled_work())
dropped flush_scheduled_work() from cx23885_input_ir_stop()
incorrectly assuming that it didn't use any work item; however,
cx23885_dev makes use of three work items - cx25840_work and
ir_{r|t}x_work.

Make cx23885_input_ir_stop() sync flush all three work items before
returning.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Andy Walls <awalls@md.metrocast.net>
Reviewed-by: Andy Walls <awalls@md.metrocast.net>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/video/cx23885/cx23885-input.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/video/cx23885/cx23885-input.c b/drivers/media/video/cx23885/cx23885-input.c
index 199b996..e27cedb 100644
--- a/drivers/media/video/cx23885/cx23885-input.c
+++ b/drivers/media/video/cx23885/cx23885-input.c
@@ -229,6 +229,9 @@ static void cx23885_input_ir_stop(struct cx23885_dev *dev)
 		v4l2_subdev_call(dev->sd_ir, ir, rx_s_parameters, &params);
 		v4l2_subdev_call(dev->sd_ir, ir, rx_g_parameters, &params);
 	}
+	flush_work_sync(&dev->cx25840_work);
+	flush_work_sync(&dev->ir_rx_work);
+	flush_work_sync(&dev->ir_tx_work);
 }
 
 static void cx23885_input_ir_close(struct rc_dev *rc)

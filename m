Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936048Ab2C3VZR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:25:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54199 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966284Ab2C3VXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:23:01 -0400
Message-Id: <20120330194850.627915339@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:50:28 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 123/175] [media] au8522: bug-fix: enable modulation AFTER tune (instead of before tuning)
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Krufky <mkrufky@kernellabs.com>

commit ef3d2dc366c8c32d58dbbf9898cfd4f853ff8fe0 upstream.

The au8522 driver programs the tuner after programming the demodulator,
but the tuner should be programmed first. This patch fixes this behavior.

EDIT: Apparantly Devin created a similar patch some time ago, but hasn't
submitted it for merge.  I never saw his patch, but I thank him anyhow
for his efforts.  In addition, Devin pointed out a flaw in my patch:

This newly generated patch takes Devin's comments into account.

Thanks-to: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/dvb/frontends/au8522_dig.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/media/dvb/frontends/au8522_dig.c
+++ b/drivers/media/dvb/frontends/au8522_dig.c
@@ -588,11 +588,6 @@ static int au8522_set_frontend(struct dv
 	    (state->current_modulation == c->modulation))
 		return 0;
 
-	au8522_enable_modulation(fe, c->modulation);
-
-	/* Allow the demod to settle */
-	msleep(100);
-
 	if (fe->ops.tuner_ops.set_params) {
 		if (fe->ops.i2c_gate_ctrl)
 			fe->ops.i2c_gate_ctrl(fe, 1);
@@ -604,6 +599,11 @@ static int au8522_set_frontend(struct dv
 	if (ret < 0)
 		return ret;
 
+	/* Allow the tuner to settle */
+	msleep(100);
+
+	au8522_enable_modulation(fe, c->modulation);
+
 	state->current_frequency = c->frequency;
 
 	return 0;



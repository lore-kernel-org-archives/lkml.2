Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750950Ab1GMEXX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 00:23:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51052 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706Ab1GMEXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 00:23:21 -0400
Message-ID: <4E1D1DAF.4060900@redhat.com>
Date: Wed, 13 Jul 2011 01:23:11 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Simon Arlott <simon@fire.lp0.eu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: 2.6.39 "tuner-core: remove usage of DIGITAL_TV" breaks saa7134
 with mt2050
References: <4E1CBAC8.2030404@simon.arlott.org.uk>
In-Reply-To: <4E1CBAC8.2030404@simon.arlott.org.uk>
X-Enigmail-Version: 1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 12-07-2011 18:21, Simon Arlott escreveu:
> commit ad020dc2fe9039628cf6cef42cd1b76531ee8411
> Author: Mauro Carvalho Chehab <mchehab@redhat.com>
> Date:   Tue Feb 15 09:30:50 2011 -0200
> 
>     [media] tuner-core: remove usage of DIGITAL_TV
>     
>     tuner-core has no business to do with digital TV. So, don't use
>     T_DIGITAL_TV on it, as it has no code to distinguish between
>     them, and nobody fills T_DIGITAL_TV right.
>     
>     Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> 
> This breaks my Pinnacle PCTV 300i DVB-T cards as they can no longer tune
> DVB-T.
> 
> [  540.010030] tuner 3-0043: Tuner doesn't support mode 3. Putting tuner to sleep
> [  540.011017] tuner 2-0043: Tuner doesn't support mode 3. Putting tuner to sleep
> [  540.012012] tuner 3-0060: Tuner doesn't support mode 3. Putting tuner to sleep
> [  540.013029] tuner 2-0060: Tuner doesn't support mode 3. Putting tuner to sleep
> 
> saa7134 needs to indicate digital TV tuning to mt20xx but it looks like
> tuner-core no longer has any way to allow a tuner to indicate support
> for this?
> 
> (mt2050_set_tv_freq in mt20xx.c uses V4L2_TUNER_DIGITAL_TV)
> 

Could you please try the enclosed patch? It should fix the issue.
I should probably rename T_ANALOG_TV to just T_TV, but I'll do it on
a next patch if this one works ok, as we don't want to send a renaming
patch to -stable.

---
[media] Fix Digital TV breakage with mt20xx tuner

The mt20xx tuner passes V4L2_TUNER_DIGITAL_TV to tuner core. However, the
check_mode code now doesn't handle it well. Change the logic there to
avoid the breakage, and fix a test for analog-only at g_tuner.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
index 5748d04..aa45952 100644
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -732,10 +732,19 @@ static int tuner_remove(struct i2c_client *client)
  * returns 0.
  * This function is needed for boards that have a separate tuner for
  * radio (like devices with tea5767).
+ * NOTE: mt20xx uses V4L2_TUNER_DIGITAL_TV and calls set_tv_freq to
+ *       select a TV frequency. So, t_mode = T_ANALOG_TV could actually
+ *	 be used to represent a Digital TV too.
  */
 static inline int check_mode(struct tuner *t, enum v4l2_tuner_type mode)
 {
-	if ((1 << mode & t->mode_mask) == 0)
+	int t_mode;
+	if (mode == V4L2_TUNER_RADIO)
+		t_mode = T_RADIO;
+	else
+		t_mode = T_ANALOG_TV;
+
+	if ((t_mode & t->mode_mask) == 0)
 		return -EINVAL;
 
 	return 0;
@@ -1034,7 +1043,7 @@ static void tuner_status(struct dvb_frontend *fe)
 	case V4L2_TUNER_RADIO:
 		p = "radio";
 		break;
-	case V4L2_TUNER_DIGITAL_TV:
+	case V4L2_TUNER_DIGITAL_TV: /* Used by mt20xx */
 		p = "digital TV";
 		break;
 	case V4L2_TUNER_ANALOG_TV:
@@ -1166,9 +1175,8 @@ static int tuner_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 	vt->type = t->mode;
 	if (analog_ops->get_afc)
 		vt->afc = analog_ops->get_afc(&t->fe);
-	if (t->mode == V4L2_TUNER_ANALOG_TV)
-		vt->capability |= V4L2_TUNER_CAP_NORM;
 	if (t->mode != V4L2_TUNER_RADIO) {
+		vt->capability |= V4L2_TUNER_CAP_NORM;
 		vt->rangelow = tv_range[0] * 16;
 		vt->rangehigh = tv_range[1] * 16;
 		return 0;

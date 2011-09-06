Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404Ab1IFDhS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 23:37:18 -0400
Received: from emcscan.emc.com.tw ([192.72.220.5]:3730 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab1IFDhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 23:37:13 -0400
From: JJ Ding <jj_ding@emc.com.tw>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Aaron Huang <aaron_huang@emc.com.tw>, Tom Lin <tom_lin@emc.com.tw>,
        =?utf-8?Q?=C3=89ric?= Piel <E.A.B.Piel@tudelft.nl>,
        Chase Douglas <chase.douglas@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Alessandro Rubini <rubini@cvml.unipv.it>
Subject: Re: [PATCH v5 7/8] Input: elantech - add v3 hardware support
In-Reply-To: <CAGS+omDHEYL8camJ+=z5enBgKNJGWokCV8avzH8b18uLQsg38g@mail.gmail.com>
References: <1315189007-2179-1-git-send-email-jj_ding@emc.com.tw> <1315189007-2179-8-git-send-email-jj_ding@emc.com.tw> <CAGS+omCTDb-y7Gut=KgU5wz70R9=75gkmruYpOOS5JUECOK_UA@mail.gmail.com> <874o0rqxbq.fsf@emc.com.tw> <CAGS+omBeU1XczFgp23c+cPKAHn5EqOp1AbxYXuJQ55TKYGO7Fw@mail.gmail.com> <CAGS+omDHEYL8camJ+=z5enBgKNJGWokCV8avzH8b18uLQsg38g@mail.gmail.com>
User-Agent: Notmuch/0.7 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Tue, 06 Sep 2011 11:39:28 +0800
Message-ID: <877h5ml4pb.fsf@emc.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Mon, 5 Sep 2011 16:47:40 +0800, Daniel Kurtz <djkurtz@chromium.org> wrote:
> Hi JJ,
> 
> On Mon, Sep 5, 2011 at 4:39 PM, Daniel Kurtz <djkurtz@chromium.org> wrote:
> > Hi JJ,
> >
> > On Mon, Sep 5, 2011 at 3:10 PM, JJ Ding <jj_ding@emc.com.tw> wrote:
> >> Hi Daniel,
> >>
> >> On Mon, 5 Sep 2011 12:35:28 +0800, Daniel Kurtz <djkurtz@chromium.org> wrote:
> >>> Hi JJ,
> >>>
> >>> On Mon, Sep 5, 2011 at 10:16 AM, JJ Ding <jj_ding@emc.com.tw> wrote:
> >>>
> >>> Originally, v3 was using semi-mt, which reported corner coordinates of
> >>> a box containing at least two of the N touches on the touchpad.  I
> >>> thought this was due to hardware limitation.
> >>>
> >>> If the hardware really can report true positions for (up to) 3
> >>> contacts, then using pure MT-B is a good approach.  This driver still
> >>> seems to mix semi-mt and MT-B together a bit.
> >>>
> >>> Can you report all three contacts in their own slots, 0, 1 and 2,
> >>> instead of just reoprting two of them with 0,1?
> >>>
> >>> Also, when reporting the 'legacy single touch' coordinate (ABS_X,
> >>> ABS_Y), please use:
> >>> input_mt_report_pointer_emulation(), instead of always reporting the
> >>> last (x1,y1).  Otherwise the single touch point will bounce back and
> >>> forth between 1st and 3rd touch.
> >>
> >> v3 can only track the true positions of two fingers. With 3 finger
> >> touch, it reports the lowest value of x and the biggest value of y,
> >> among the three fingers. v3 changed the protocol so it could report
> >> 2-finger touch data w/o reduced resolution and improved the hardware to
> >> truly track 2 fingers independently, otherwise it's pretty much the same
> >> as v2.
> >
> >
> > If I read this code correctly, it looks like in the 3-finger case,
> > (x1,y1) as reported in the (ABS_X, ABS_Y), and in the call to
> > elantech_report_semi_mt_data() will bounce back and forth between the
> > 1st finger and 3rd finger ("lowest value of x and the biggest value of
> > y").  Won't this be very confusing for userspace (i.e.
> > xf86-input=synaptics)?
> 
> Oh, never mind.  Sorry for the confusion.  I guess in the 3-finger
> case, you only get "3-finger" packets containing the single ("lowest
> value of x and the biggest value of y") bounding box coordinate, not
> V3_HEAD/V3_TAIL packets.

Yes, that's what I mean. Sorry for not being clear enough.
> I believe this shouldn't be reported as MT-B slot 0, though.  If
> anything, perhaps you should use MT-B slot 2 for this coordinate?
> It's not really the third finger, but at least it won't be considered
> a continuation of the motion of the first finger.
> I guess you really have no choice but to use it as the (ABS_X, ABS_Y)
> coordinate.
Is the following what you mean, Daniel?

I tested the follwing patch (against patch #8) with multitouch X input
driver. 2-finger scrolling is affected by this change. The scrollbar
always jumps back to where it started. I don't really know what's causing
this. If someone knows what I did wrong, please correct me. Maybe after
fixing this misbehavior, we can start using
input_mt_report_pointer_emulation() for v2 and v3 hardware, too.

Thank you.

jj
---
diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
index 38fb155..1249392 100644
--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -298,8 +298,9 @@ static void elantech_report_semi_mt_data(struct input_dev *dev,
 					 unsigned int x1, unsigned int y1,
 					 unsigned int x2, unsigned int y2)
 {
-	elantech_set_slot(dev, 0, num_fingers != 0, x1, y1);
+	elantech_set_slot(dev, 0, num_fingers != 3, x1, y1);
 	elantech_set_slot(dev, 1, num_fingers == 2, x2, y2);
+	elantech_set_slot(dev, 2, num_fingers == 3, x1, y1);
 }
 
 /*
@@ -372,8 +373,8 @@ static void elantech_report_absolute_v2(struct psmouse *psmouse)
 	if (fingers != 0) {
 		input_report_abs(dev, ABS_X, x1);
 		input_report_abs(dev, ABS_Y, y1);
+		elantech_report_semi_mt_data(dev, fingers, x1, y1, x2, y2);
 	}
-	elantech_report_semi_mt_data(dev, fingers, x1, y1, x2, y2);
 	input_report_key(dev, BTN_TOOL_FINGER, fingers == 1);
 	input_report_key(dev, BTN_TOOL_DOUBLETAP, fingers == 2);
 	input_report_key(dev, BTN_TOOL_TRIPLETAP, fingers == 3);
@@ -453,8 +454,8 @@ static void elantech_report_absolute_v3(struct psmouse *psmouse,
 	if (fingers != 0) {
 		input_report_abs(dev, ABS_X, x1);
 		input_report_abs(dev, ABS_Y, y1);
+		elantech_report_semi_mt_data(dev, fingers, x1, y1, x2, y2);
 	}
-	elantech_report_semi_mt_data(dev, fingers, x1, y1, x2, y2);
 	input_report_key(dev, BTN_TOOL_FINGER, fingers == 1);
 	input_report_key(dev, BTN_TOOL_DOUBLETAP, fingers == 2);
 	input_report_key(dev, BTN_TOOL_TRIPLETAP, fingers == 3);
@@ -926,7 +927,7 @@ static int elantech_set_input_params(struct psmouse *psmouse)
 			input_set_abs_params(dev, ABS_TOOL_WIDTH, ETP_WMIN_V2,
 					     ETP_WMAX_V2, 0, 0);
 		}
-		input_mt_init_slots(dev, 2);
+		input_mt_init_slots(dev, 3);
 		input_set_abs_params(dev, ABS_MT_POSITION_X, x_min, x_max, 0, 0);
 		input_set_abs_params(dev, ABS_MT_POSITION_Y, y_min, y_max, 0, 0);
 		break;
---
> -Dan

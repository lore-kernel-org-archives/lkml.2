Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453Ab1HSI1j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 04:27:39 -0400
Received: from emcscan.emc.com.tw ([192.72.220.5]:49100 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab1HSI1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 04:27:37 -0400
From: JJ Ding <jj_ding@emc.com.tw>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Aaron Huang <aaron_huang@emc.com.tw>, Tom Lin <tom_lin@emc.com.tw>,
        Eric Piel <E.A.B.Piel@tudelft.nl>, Daniel Kurtz <djkurtz@chromium.org>,
        Chase Douglas <chase.douglas@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Alessandro Rubini <rubini@cvml.unipv.it>
Subject: Re: [PATCH 6/6] Input: elantech - add v3 hardware support
In-Reply-To: <20110818173959.GE28313@thinkpad-t410>
References: <1313632629-23603-1-git-send-email-jj_ding@emc.com.tw> <1313632629-23603-7-git-send-email-jj_ding@emc.com.tw> <20110818173959.GE28313@thinkpad-t410>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Fri, 19 Aug 2011 16:29:57 +0800
Message-ID: <87hb5ddcsa.fsf@emc.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Seth,

On Thu, 18 Aug 2011 12:39:59 -0500, Seth Forshee <seth.forshee@canonical.com> wrote:
> On Thu, Aug 18, 2011 at 09:57:09AM +0800, JJ Ding wrote:
> > @@ -352,6 +374,94 @@ static void elantech_report_absolute_v2(struct psmouse *psmouse)
> >  	input_sync(dev);
> >  }
> >  
> > +/*
> > + * firmware tells us there's noise.
> > + */
> > +static inline int debounce(unsigned int x, unsigned int y)
> > +{
> > +	return (x == 0xfff) && (y == 0xfff);
> > +}
> 
> This is problematic in my testing, in two ways.
> 
> First, it never actually triggers, because the y values passed to it are
> not the raw data from the packets and as such are not 0xfff anymore in
> the cases you're trying to detect.
> 
> Second, I get these packets with 1 and 2 finger touches on the Samsung
> NF310, but you only check it in the 3 finger case.
> 
> As a result, I'm getting some reports with negative values for the y
> position.
Thank you for reporting this bug.
As for now, the following should fix this issue.
I will correct this in v2.
---
diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
index e13a719..fa842f7 100644
--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -410,11 +410,12 @@ static void elantech_report_absolute_v3(struct psmouse *psmouse,
                 * byte 4:  .   .   .   .  y11 y10 y9  y8
                 * byte 5: y7  y6  y5  y4  y3  y2  y1  y0
                 */
-               y1 = etd->y_max - (((packet[4] & 0x0f) << 8) | packet[5]);
+               y1 = ((packet[4] & 0x0f) << 8) | packet[5];
 
                if (fingers == 3 && debounce(x1, y1))
                        return;
 
+               y1 = etd->y_max - y1;
                break;
 
        case 2:
---
> > +
> > +/*
> > + * Interpret complete data packets and report absolute mode input events for
> > + * hardware version 3. (12 byte packets for two fingers)
> > + */
> > +static void elantech_report_absolute_v3(struct psmouse *psmouse,
> > +					int packet_type)
> > +{
> > +	struct input_dev *dev = psmouse->dev;
> > +	struct elantech_data *etd = psmouse->private;
> > +	unsigned char *packet = psmouse->packet;
> > +	unsigned int fingers = 0, x1 = 0, y1 = 0, x2 = 0, y2 = 0;
> > +	unsigned int width = 0, pres = 0;
> > +
> > +	/* byte 0: n1  n0   .   .   .   .   R   L */
> > +	fingers = (packet[0] & 0xc0) >> 6;
> > +
> > +	switch (fingers) {
> > +	case 3:
> > +	case 1:
> > +		/*
> > +		 * byte 1:  .   .   .   .  x11 x10 x9  x8
> > +		 * byte 2: x7  x6  x5  x4  x4  x2  x1  x0
> > +		 */
> > +		x1 = ((packet[1] & 0x0f) << 8) | packet[2];
> > +		/*
> > +		 * byte 4:  .   .   .   .  y11 y10 y9  y8
> > +		 * byte 5: y7  y6  y5  y4  y3  y2  y1  y0
> > +		 */
> > +		y1 = etd->y_max - (((packet[4] & 0x0f) << 8) | packet[5]);
> > +
> > +		if (fingers == 3 && debounce(x1, y1))
> > +			return;
> > +
> > +		break;
> > +
> > +	case 2:
> > +		if (packet_type == PACKET_V3_HEAD) {
> > +			/*
> > +			 * byte 1:   .    .    .    .  ax11 ax10 ax9  ax8
> > +			 * byte 2: ax7  ax6  ax5  ax4  ax3  ax2  ax1  ax0
> > +			 */
> > +			etd->prev_x = ((packet[1] & 0x0f) << 8) | packet[2];
> > +			/*
> > +			 * byte 4:   .    .    .    .  ay11 ay10 ay9  ay8
> > +			 * byte 5: ay7  ay6  ay5  ay4  ay3  ay2  ay1  ay0
> > +			 */
> > +			etd->prev_y = etd->y_max -
> > +				(((packet[4] & 0x0f) << 8) | packet[5]);
> > +			/*
> > +			 * wait for next packet
> > +			 */
> > +			return;
> > +		}
> > +
> > +		/* packet_type == PACKET_V3_TAIL */
> > +		x1 = etd->prev_x;
> > +		y1 = etd->prev_y;
> > +		x2 = ((packet[1] & 0x0f) << 8) | packet[2];
> > +		y2 = etd->y_max - (((packet[4] & 0x0f) << 8) | packet[5]);
> > +		break;
> > +	}
> > +
> > +	pres = (packet[1] & 0xf0) | ((packet[4] & 0xf0) >> 4);
> > +	width = ((packet[0] & 0x30) >> 2) | ((packet[3] & 0x30) >> 4);
> > +
> > +	input_report_key(dev, BTN_TOUCH, fingers != 0);
> > +	input_report_abs(dev, ABS_X, x1);
> > +	input_report_abs(dev, ABS_Y, y1);
> 
> You should only report the ABS_[XY] coordinates when fingers != 0. The
> xorg synaptics module sees the values reported in that case as
> legitimate. This is causing me to see strange behaviors when scrolling
> with two-finger drags.
AFAIK, though v2 and v3 differ in packet format, they really report the
same data to the userspace. In this version of v3 support, I even try to
make v2 and v3 report all the data in the same sequnce. If you're seeing
this issue, maybe we should do the same with v2?

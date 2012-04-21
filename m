Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab2DUARB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 20:17:01 -0400
Received: from gate.crashing.org ([63.228.1.57]:44142 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403Ab2DUAQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 20:16:59 -0400
Message-ID: <1334967400.3312.4.camel@pasglop>
Subject: Re: Multitouch regression in 3.3 on thinkpad X220 clickpad
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Daniel Drake <dsd@laptop.org>, Peter Hutterer <peter.hutterer@who-t.net>,
        "X.Org Devel List" <xorg-devel@lists.freedesktop.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Sat, 21 Apr 2012 10:16:40 +1000
In-Reply-To: <20120420170132.GA32261@core.coreip.homeip.net>
References: <1334906476.3197.11.camel@pasglop>
	 <CAMLZHHTpNPbbMwrNmZf5Japk2b3gNZ7eAhU5xoG+a1jEPk96ig@mail.gmail.com>
	 <20120420170132.GA32261@core.coreip.homeip.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-20 at 10:01 -0700, Dmitry Torokhov wrote:

> It looks we lost a condition in synaptics_set_advanced_gesture_mode().
> It used to be:
> 
> 
> 	if (!(SYN_CAP_ADV_GESTURE(priv->ext_cap_0c) ||
> 			SYN_CAP_IMAGE_SENSOR(priv->ext_cap_0c)))
> 		return 0;
> 
> and now simply is:
> 
> 	if (!SYN_CAP_ADV_GESTURE(priv->ext_cap_0c))
> 		return 0;
> 
> Could you try restoring the condition and see if it fixes the
> regression?

Yes, that's it. Please shoot the patch below to Linus.

Thanks,
Ben.

input/synaptics: Fix regression with "image sensor" trackpads

commit 7968a5dd492ccc38345013e534ad4c8d6eb60ed1
Input: synaptics - add support for Relative mode

Accidentally broke support for advanced gestures (multitouch)
on some trackpads such as the one in my ThinkPad X220 by
incorretly changing the condition for enabling them. This
restores it.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: stable@kernel.org [3.3]

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index a3bb49c..37b3792 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -273,7 +273,8 @@ static int synaptics_set_advanced_gesture_mode(struct psmouse *psmouse)
 	static unsigned char param = 0xc8;
 	struct synaptics_data *priv = psmouse->private;
 
-	if (!SYN_CAP_ADV_GESTURE(priv->ext_cap_0c))
+	if (!(SYN_CAP_ADV_GESTURE(priv->ext_cap_0c) ||
+	      SYN_CAP_IMAGE_SENSOR(priv->ext_cap_0c)))
 		return 0;
 
 	if (psmouse_sliced_command(psmouse, SYN_QUE_MODEL))



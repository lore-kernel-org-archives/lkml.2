Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759601Ab1IISE0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 14:04:26 -0400
Received: from mail-gw0-f42.google.com ([74.125.83.42]:49578 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759479Ab1IISEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 14:04:25 -0400
Date: Fri, 9 Sep 2011 11:04:19 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: John Sung <penmount.touch@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Input: penmount - add PenMount 6250 support
Message-ID: <20110909180419.GC32383@core.coreip.homeip.net>
References: <1315555667-5893-1-git-send-email-penmount.touch@gmail.com>
 <1315555667-5893-3-git-send-email-penmount.touch@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315555667-5893-3-git-send-email-penmount.touch@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 09, 2011 at 04:07:47PM +0800, John Sung wrote:
> Add multi touch support for PenMount 6250 touch controller.
> 

Given the changes to previous patches, this one turns into:


Input: penmount - add PenMount 6250 support

From: John Sung <penmount.touch@gmail.com>

Add multi touch support for PenMount 6250 touch controller.

Signed-off-by: John Sung <penmount.touch@gmail.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/touchscreen/penmount.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)


diff --git a/drivers/input/touchscreen/penmount.c b/drivers/input/touchscreen/penmount.c
index 86e0612..df42519 100644
--- a/drivers/input/touchscreen/penmount.c
+++ b/drivers/input/touchscreen/penmount.c
@@ -37,6 +37,7 @@ MODULE_LICENSE("GPL");
 #define	PM_MAX_LENGTH	6
 #define	PM_MAX_MTSLOT	16
 #define	PM_3000_MTSLOT	2
+#define	PM_6250_MTSLOT	12
 
 /*
  * Multi-touch slot
@@ -150,6 +151,21 @@ static irqreturn_t pm_interrupt(struct serio *serio,
 			}
 		}
 		break;
+
+	case 0x6250:
+		if ((pm->data[0] & 0xb0) == 0x30) {
+			if (pm->packetsize == ++pm->idx) {
+				if (pm_checkpacket(pm->data)) {
+					int slotnum = pm->data[0] & 0x0f;
+					pm->slots[slotnum].active = pm->data[0] & 0x40;
+					pm->slots[slotnum].x = pm->data[2] * 256 + pm->data[1];
+					pm->slots[slotnum].y = pm->data[4] * 256 + pm->data[3];
+					pm_mtevent(pm, dev);
+				}
+				pm->idx = 0;
+			}
+		}
+		break;
 	}
 
 	return IRQ_HANDLED;
@@ -227,6 +243,13 @@ static int pm_connect(struct serio *serio, struct serio_driver *drv)
 		max_x = max_y = 0x7ff;
 		pm->maxcontacts = PM_3000_MTSLOT;
 		break;
+
+	case 3:
+		pm->packetsize = 6;
+		input_dev->id.product = 0x6250;
+		max_x = max_y = 0x3ff;
+		pm->maxcontacts = PM_6250_MTSLOT;
+		break;
 	}
 
 	input_set_abs_params(pm->dev, ABS_X, 0, max_x, 0, 0);

Thanks.

-- 
Dmitry

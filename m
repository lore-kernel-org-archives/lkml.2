Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab0HUNqD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 09:46:03 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41060 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab0HUNp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 09:45:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=u+HWMK5LksUNimMLhLL/smZzamGBpcLfnhABqUr3FRRxUeY67ETmHg1c/Jq5Ka0lHK
         BSoxzDTRn19QAM9OzWiMDB6yD8MYqhjCEJULh/2uKlP/CpjGFqSnF79E1SGPxMfumF3K
         8elFypG6OMK7DzKzZdUDS2XfxHlrE1SuXjM3w=
Date: Sat, 21 Aug 2010 15:50:03 +0200
From: Christoph Fritz <chf.fritz@googlemail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
        Daniel Mack <daniel@caiaq.de>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Input: mousedev - fix regression of inverting axes
Message-ID: <20100821135002.GA3357@lovely.krouter>
References: <20100820223316.4f6ac734@neptune.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100820223316.4f6ac734@neptune.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 10:33:16PM +0200, Bruno Prémont wrote:
> Somewhere between 2.6.35 and Linus's tree as of this writing gpm
> started moving its cursor to the opposite direction of mouse movement.
> 
> e.g. moving mouse up causes cursor to move down, moving mouse left
>      causes cursor to go right
> 
> Under 2.6.35 the cursor moved into the same direction as the mouse.
> 
> Note, mouse is synaptics touchpad (Acer TravelMate660):
>   Synaptics Touchpad, model: 1, fw: 5.8, id: 0x9d48b1, caps: 0x904713/0x4006/0x0
> 
> 
> When I get around to it I will try to get more precise information as
> to when this regression got introduced, eventually bisecting.
> 
> Bruno

Thanks Bruno,
 I successfully tested the patch below with gpm.

---
Introduced by 987a6c0298260b7aa40702b349282554d6180e4b a swap in max/min
calculation gets fixed by this patch.

Reported-by: Bruno Prémont <bonbons@linux-vserver.org>
Signed-off-by: Christoph Fritz <chf.fritz@googlemail.com>
---
 drivers/input/mousedev.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/input/mousedev.c b/drivers/input/mousedev.c
index 83c24cc..d528a2d 100644
--- a/drivers/input/mousedev.c
+++ b/drivers/input/mousedev.c
@@ -138,8 +138,8 @@ static void mousedev_touchpad_event(struct input_dev *dev,
 
 		fx(0) = value;
 		if (mousedev->touch && mousedev->pkt_count >= 2) {
-			size = input_abs_get_min(dev, ABS_X) -
-					input_abs_get_max(dev, ABS_X);
+			size = input_abs_get_max(dev, ABS_X) -
+					input_abs_get_min(dev, ABS_X);
 			if (size == 0)
 				size = 256 * 2;
 
@@ -155,8 +155,8 @@ static void mousedev_touchpad_event(struct input_dev *dev,
 		fy(0) = value;
 		if (mousedev->touch && mousedev->pkt_count >= 2) {
 			/* use X size for ABS_Y to keep the same scale */
-			size = input_abs_get_min(dev, ABS_X) -
-					input_abs_get_max(dev, ABS_X);
+			size = input_abs_get_max(dev, ABS_X) -
+					input_abs_get_min(dev, ABS_X);
 			if (size == 0)
 				size = 256 * 2;
 
-- 
1.7.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952Ab0HQQ0e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 12:26:34 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44390 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757866Ab0HQQ0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 12:26:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=OaQ/2zPPWxMFPayticwD5FQYtmtqZCPb9l8TQjE6iF2o5GEXBd2ucELmYA+9uoR0Ow
         QG882dFoqUdEgppSb6s5cIBpA6NrM8ntYHGull0rLxdnmvklkfA7mdTdtoiKlDEyI26D
         0ASBseOPONBwATRWO0If9kVUL1dAu9rM++BqA=
Date: Tue, 17 Aug 2010 09:26:25 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Input: fix faulty XXinput_* calls
Message-ID: <20100817162625.GA13896@core.coreip.homeip.net>
References: <20100812162218.GA21286@core.coreip.homeip.net>
 <AANLkTikj2kqifwYo1c47+9knVejny1bR=Oe5yOkAchCk@mail.gmail.com>
 <20100817143851.GW10432@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100817143851.GW10432@buzzloop.caiaq.de>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 04:38:51PM +0200, Daniel Mack wrote:
> On Sat, Aug 14, 2010 at 11:52:13PM +0200, Geert Uytterhoeven wrote:
> > On Thu, Aug 12, 2010 at 18:22, Dmitry Torokhov
> > <dmitry.torokhov@gmail.com> wrote:
> > > From: Daniel Mack <daniel@caiaq.de>
> > >
> > > They've been introduced by 987a6c02 ("Input: switch to input_abs_*()
> > > access functions") and they appear to be some kind of debug left-over.
> > >
> > > [Dmitry Torokhov: these are my fault - I added XX prefixes in places where
> > >  I wanted to do additional review of the code but failed to actually do
> > >  that in these particular instances.]
> > >
> > > Signed-off-by: Daniel Mack <daniel@caiaq.de>
> > > Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> > > ---
> > >
> > >  drivers/input/joystick/amijoy.c  |    2 +-
> > 
> > Thanks, amijoy.c compiles now.
> > 
> > But hil_kbd.c still doesn't compile:
> > 
> > > diff --git a/drivers/input/keyboard/hil_kbd.c b/drivers/input/keyboard/hil_kbd.c
> > > index ddd5afd..dcc86b9 100644
> > > --- a/drivers/input/keyboard/hil_kbd.c
> > > +++ b/drivers/input/keyboard/hil_kbd.c
> > > @@ -235,7 +235,7 @@ static void hil_dev_handle_ptr_events(struct hil_dev *ptr)
> > >                        if (val < input_abs_min(dev, ABS_X + i))
> > >                                input_abs_set_min(dev, ABS_X + i, val);
> > >                        if (val > input_abs_max(dev, ABS_X + i))
> > 
> > error: implicit declaration of function ‘input_abs_max’.
> > 
> > And indeed, input_abs_max() does not exist, while hil_kbd.c has 4 callers.
> 
> Sorry about that. hil_kbd wasn't built on my system with an
> allmodconfig, as I just got to know. Below is a fix for this unfortunate
> trouble.
> 

I think there still a couple of spots need to be adjusted. How about
this one? (Sorry for the silence, I'm in the middle of a vacation).

-- 
Dmitry

Input: hil_kbd - fix compile error

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/keyboard/hil_kbd.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)


diff --git a/drivers/input/keyboard/hil_kbd.c b/drivers/input/keyboard/hil_kbd.c
index dcc86b9..0eddb43 100644
--- a/drivers/input/keyboard/hil_kbd.c
+++ b/drivers/input/keyboard/hil_kbd.c
@@ -232,13 +232,13 @@ static void hil_dev_handle_ptr_events(struct hil_dev *ptr)
 		if (absdev) {
 			val = lo + (hi << 8);
 #ifdef TABLET_AUTOADJUST
-			if (val < input_abs_min(dev, ABS_X + i))
+			if (val < input_abs_get_min(dev, ABS_X + i))
 				input_abs_set_min(dev, ABS_X + i, val);
-			if (val > input_abs_max(dev, ABS_X + i))
+			if (val > input_abs_get_max(dev, ABS_X + i))
 				input_abs_set_max(dev, ABS_X + i, val);
 #endif
 			if (i % 3)
-				val = input_abs_max(dev, ABS_X + i) - val;
+				val = input_abs_get_max(dev, ABS_X + i) - val;
 			input_report_abs(dev, ABS_X + i, val);
 		} else {
 			val = (int) (((int8_t) lo) | ((int8_t) hi << 8));
@@ -388,11 +388,11 @@ static void hil_dev_pointer_setup(struct hil_dev *ptr)
 
 #ifdef TABLET_AUTOADJUST
 		for (i = 0; i < ABS_MAX; i++) {
-			int diff = input_abs_max(input_dev, ABS_X + i) / 10;
+			int diff = input_abs_get_max(input_dev, ABS_X + i) / 10;
 			input_abs_set_min(input_dev, ABS_X + i,
-				input_abs_min(input_dev, ABS_X + i) + diff)
+				input_abs_get_min(input_dev, ABS_X + i) + diff)
 			input_abs_set_max(input_dev, ABS_X + i,
-				input_abs_max(input_dev, ABS_X + i) - diff)
+				input_abs_get_max(input_dev, ABS_X + i) - diff)
 		}
 #endif
 

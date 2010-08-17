Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579Ab0HQOu7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 10:50:59 -0400
Received: from defer-dn03.ocn.ad.jp ([125.170.100.156]:53518 "EHLO
	defer-dn03.ocn.ad.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380Ab0HQOuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 10:50:54 -0400
X-Greylist: delayed 2629 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Aug 2010 10:50:54 EDT
Date: Tue, 17 Aug 2010 23:05:31 +0900 (JST)
Message-Id: <20100817.230531.95061739.anemo@mba.ocn.ne.jp>
To: mcuos.com@gmail.com
Cc: geert@linux-m68k.org, akpm@linux-foundation.org, a.zummo@towertech.it,
        linux-kernel@vger.kernel.org
Subject: Re: rtc/m41t80: use rtc_valid_tm() to check returned tm
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <AANLkTimbtkvrE0Lhk4vcq-4N3Sr8T84zD7-pkSotO66L@mail.gmail.com>
References: <201008111659.o7BGxn4g029524@hera.kernel.org>
	<AANLkTin7+UPYJ5tsyrbUhxcEfbHLMVJQOSrV1_3zQ0V3@mail.gmail.com>
	<AANLkTimbtkvrE0Lhk4vcq-4N3Sr8T84zD7-pkSotO66L@mail.gmail.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o7HEp3oN008983

On Fri, 13 Aug 2010 09:43:38 +0800, Wan ZongShun <mcuos.com@gmail.com> wrote:
> 2010/8/13 Geert Uytterhoeven <geert@linux-m68k.org>:
> >> - Â  Â  Â  return 0;
> >> + Â  Â  Â  return rtc_valid_tm(t);
> >
> > warning: passing argument 1 of â€˜rtc_valid_tmâ€™ from incompatible pointer type
> >
> > `t' is of type `struct rtc_wkalrm *', not `struct rtc_time *'.
> > Probably the intention was:
> >
> > Â  Â  Â  Â return rtc_valid_tm(&t->time);
> 
> Okay, thank you point this warning.
> 
> Andrew ,
> 
> Could you please fix this warning directly for me?
> 'return rtc_valid_tm(t)' should be insteaded by 'return
> rtc_valid_tm(&t->time);'.

No, t->time does not contain complete date/time.  It just holds some
alarm settings and -1 for some fields.

So rtc_valid_tm(&t->time) will always returns -EINVAL.
The correct fix would be just reverting rtc_valid_tm here.

------------------------------------------------------
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Subject: [PATCH] rtc: m41t80: do not use rtc_valid_tm in m41t80_rtc_read_alarm

The commit b485fe5ea ("rtc/m41t80: use rtc_valid_tm() to check
returned tm") added rtc_valid_tm to m41t80_rtc_read_alarm() but it was
wrong while the t->time does not contain complete date/time.

This patch also fix a warning:
warning: passing argument 1 of â€˜rtc_valid_tmâ€™ from incompatible pointer type

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
 drivers/rtc/rtc-m41t80.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-m41t80.c b/drivers/rtc/rtc-m41t80.c
index 66377f3..d60557c 100644
--- a/drivers/rtc/rtc-m41t80.c
+++ b/drivers/rtc/rtc-m41t80.c
@@ -364,7 +364,7 @@ static int m41t80_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *t)
 	t->time.tm_isdst = -1;
 	t->enabled = !!(reg[M41T80_REG_ALARM_MON] & M41T80_ALMON_AFE);
 	t->pending = !!(reg[M41T80_REG_FLAGS] & M41T80_FLAGS_AF);
-	return rtc_valid_tm(t);
+	return 0;
 }
 
 static struct rtc_class_ops m41t80_rtc_ops = {
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

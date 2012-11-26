Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455Ab2KZIKA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 03:10:00 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:32049 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030Ab2KZIJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 03:09:59 -0500
From: "Wang, Warner" <warner.wang@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Edward Donovan <edward.donovan@numble.net>
CC: "Wang, Song-Bo (Stoney)" <song-bo.wang@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: need help on a DEADLOCK problem related to function
 try_one_irq()
Thread-Topic: need help on a DEADLOCK problem related to function
 try_one_irq()
Thread-Index: Ac3IBGPSFwpPXxP1Qcivc476N7zSdgAlyqwAAC+lMgAAlBlVYA==
Date: Mon, 26 Nov 2012 08:09:28 +0000
Message-ID: <DAE2ECFDBE54434BA3014E0CC0F2A1E877000F52@G4W3211.americas.hpqcorp.net>
References: <DAE2ECFDBE54434BA3014E0CC0F2A1E87700075B@G4W3211.americas.hpqcorp.net>
 <alpine.LFD.2.02.1211221120580.2701@ionos>
 <alpine.LFD.2.02.1211231008060.2701@ionos>
In-Reply-To: <alpine.LFD.2.02.1211231008060.2701@ionos>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.28]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qAQ8A535022774

Hi Thomas and Edward,

This patch works fine for our problems, but I'm not sure if it works for the recent submit "genirq: fix regression in irqfixup, irqpoll" "52553ddffad76ccf192d4dd9ce88d5818f57f62a", which submitted by Edward Donovan.

Edward can you help verify it on your environment?


Thanks,
-Warner

-----Original Message-----
From: Thomas Gleixner [mailto:tglx@linutronix.de] 
Sent: 2012Äê11ÔÂ23ÈÕ PM 5:09
To: Wang, Warner
Cc: Wang, Song-Bo (Stoney)
Subject: Re: need help on a DEADLOCK problem related to function try_one_irq()

On Thu, 22 Nov 2012, Thomas Gleixner wrote:

> Warner,
> 
> On Thu, 22 Nov 2012, Wang, Warner wrote:
> 
> please send such bug reports to the kernel mailinglist in the future.
> 
> > We met a problem on some of our x86 server and after a few weeks 
> > trace-down effort, we believe the problem is in the file 
> > "linux/kernel/irq/spurious.c".  We created a patch but we are not 
> > 100% sure if it is correct or complete.  That is why we want to 
> > consult you.
> 
> You spotted the problem right, but I'm not sure at the first glance, 
> whether this is correct. I need to go back into history and figure out 
> why we added that call in the first place. It looks fundamentally 
> wrong.
> 
> Thanks for analyzing it. I'll keep you posted on my findings.

Can you try the patch below ?

Thanks,

	tglx

---
 kernel/irq/spurious.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

Index: tip/kernel/irq/spurious.c
===================================================================
--- tip.orig/kernel/irq/spurious.c
+++ tip/kernel/irq/spurious.c
@@ -80,13 +80,11 @@ static int try_one_irq(int irq, struct i
 
 	/*
 	 * All handlers must agree on IRQF_SHARED, so we test just the
-	 * first. Check for action->next as well.
+	 * first.
 	 */
 	action = desc->action;
 	if (!action || !(action->flags & IRQF_SHARED) ||
-	    (action->flags & __IRQF_TIMER) ||
-	    (action->handler(irq, action->dev_id) == IRQ_HANDLED) ||
-	    !action->next)
+	    (action->flags & __IRQF_TIMER))
 		goto out;
 
 	/* Already running on another processor */ @@ -104,7 +102,7 @@ static int try_one_irq(int irq, struct i
 	do {
 		if (handle_irq_event(desc) == IRQ_HANDLED)
 			ret = IRQ_HANDLED;
-		action = desc->action;
+		action = action->next;
 	} while ((desc->istate & IRQS_PENDING) && action);
 	desc->istate &= ~IRQS_POLL_INPROGRESS;
 out:
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

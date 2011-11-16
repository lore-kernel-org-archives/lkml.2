Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab1KPWlZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 17:41:25 -0500
Received: from mail132.messagelabs.com ([216.82.242.115]:47718 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab1KPWlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 17:41:24 -0500
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-132.messagelabs.com!1321483202!22154251!23
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "jamie@jamieiles.com" <jamie@jamieiles.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "rmk+kernel@arm.linux.org.uk" <rmk+kernel@arm.linux.org.uk>
Date: Wed, 16 Nov 2011 16:41:11 -0600
Subject: RE: basic_mmio_gpio: Add hook for simple debounce register
Thread-Topic: basic_mmio_gpio: Add hook for simple debounce register
Thread-Index: AcykqFLzbfG14FU2RjSs/lUk2YRcyAAB5lSA
Message-ID: <ADE657CA350FB648AAC2C43247A983F001F3E93FE16A@AUSP01VMBX24.collaborationhost.net>
References: <201111161202.15485.hartleys@visionengravers.com>
 <20111116214007.GA26380@oksana.dev.rtsoft.ru>
In-Reply-To: <20111116214007.GA26380@oksana.dev.rtsoft.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pAGMfXNv000783

On Wednesday, November 16, 2011 2:40 PM, Anton Vorontsov wrote:
> 
> Hello,
> 
> On Wed, Nov 16, 2011 at 12:02:15PM -0700, H Hartley Sweeten wrote:
>> Some platforms using the basic memory-mapped GPIO library have
>> simple input debounce support that is enabled/disabled, per-input,
>> by setting/clearing bits in a control register. Add a hook in the
>> bgpio_chip structure to hold the void __iomem * for this register.
>> 
>> This register, and the gc.set_debounce callback should set by the
>> platform after calling bgpio_init() and before calling gpiochip_add().
>
> I think it is possible to add 'reg_db' into the device-specific
> (private) structure, so no need to add it into the generic one
> (the fact that the generic gpio code does not use it at all, is a
> sign that you should place it into a private struct).

Good point.

I'm working on converting the gpio-ep93xx driver's interrupt support
over to genirq.  The debounce register was the only thing hanging this
up.

> I.e. something like this:
> 
> struct foo_chip {
> 	struct bgpio_chip bgc;
> 	void __iomem *reg_db;
> };
> 
> static struct foo_chip *to_foo_chip(struct bgpio_chip *bgc)
> {
> 	return container_of(bgc, struct foo_chip, bgc);
> }
> 
> static void foo_gpio_set_debounce(struct gpio_chip *gc, ...)
> {
> 	struct bgpio_chip *bgc = to_bgpio_chip(gc);
> 	struct foo_chip *fgc = to_foo_chip(bgc);
> 
> 	writel(..., fgc->reg_db);
> }
> 
> 
> Or, if the generic code will use that register, then please introduce
> the code at the same time you introduce reg_db.

Currently the reg_db usage is outside the generic code.

I'll modify the gpio-ep93xx driver using something like you have shown
above.  If it looks reasonable to add to gpio-generic we can move it later.

Thanks,
Hartley
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

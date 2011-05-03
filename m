Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab1ECPiS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 11:38:18 -0400
Received: from nm7-vm1.bullet.mail.ird.yahoo.com ([77.238.189.223]:24928 "HELO
	nm7-vm1.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752751Ab1ECPiR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 11:38:17 -0400
X-Yahoo-Newman-Property: ymail-5
X-Yahoo-Newman-Id: 609217.66447.bm@omp1006.mail.ird.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=f05mZ2QQqSug8kcgP0qa4m9m6sRhc4FuUjDF9MJ1g8UTeu34ogRiGOBGW/leLBYx8U8w7Nck6OeLciT2j2E0wQFqymLiOur/WS+kFicjSps3kKd7xnEMdqlxM0r6Ejp+ZzSTj56dUaRVzmQNe5B2UgwU0+qpShOZsidS+zOQO98=;
Message-ID: <482414.94626.qm@web29014.mail.ird.yahoo.com>
X-YMail-OSG: ktQXEOEVM1kQjnqbgIJOouKHNdP3glyDLRuBwixGJr0YAWA
 6K46qHcWpILJPZc8taNulJ8AIdYDRKNTrCzxqrpk6OU.TA824R7_t.wYtqfB
 YGGY96FDMOeCdQaYoLsSeaPRc4T2YSLU.oFPMYmyWRE2HXlWtnQc3vfJxtAO
 Nt6_GuZyD7EQTiFHh5PtK9yUAVEAD.KDV0wx6W3Ixymhf3W62WBjN9iTyIpK
 eD6gKyr2x.ByJokkxppOS2xHndDtSHlVwVp5WsydFyvWaqpJSLmRIgusJ.6S
 z.PZYjQUDNl5O4TISjny0pBJfPmhJmYIB5ca5cloSOm4hSrmIE8T.QHaiTg-
 -
X-Mailer: YahooMailClassic/12.0.2 YahooMailWebService/0.8.110.299900
Date: Tue, 3 May 2011 16:38:15 +0100 (BST)
From: Paul Parsons <lost.distance@yahoo.com>
Subject: Re: [PATCH 1/2] mfd: Add ASIC3 LED support
To: Philipp Zabel <philipp.zabel@gmail.com>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com
In-Reply-To: <1304419612.13769.17.camel@flow>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

--- On Tue, 3/5/11, Philipp Zabel <philipp.zabel@gmail.com> wrote:
> This patch reverts your ASIC3_GPIOC?_LED? changes to keep
> the gpios as
> outputs and informs the led driver via struct asic3_led of
> the gpio to
> toggle in the brightness_set and blink_set callbacks.
> 
> Does this work for you?

Well, it works in the sense that the LEDs still operate as before. In other words, calling gpio_set_value() has made no difference to the driver's behaviour.

So I'm confused as to what the patch is intended to demonstrate. Surely we want to use the LED GPIOs instead of the TimeBase enable bit, not in addition to it.

As a quick experiment, I modified the driver again to clear the TimeBase enable bit:

--- leds-asic3.c	2011-05-03 15:58:18.372196585 +0100
+++ drivers/leds/leds-asic3.c	2011-05-03 16:12:33.832902946 +0100
@@ -50,7 +50,7 @@ static void brightness_set(struct led_cl
 	if (value != LED_OFF)
 		gpio_set_value(led->gpio, 1);
 
-	timebase = (value == LED_OFF) ? 0 : (LED_EN|0x4);
+	timebase = (value == LED_OFF) ? 0 : (0|0x4);
 
 	base = led_n_base[cell->id];
 	asic3_write_register(asic, (base + ASIC3_LED_PeriodTime), 32);
@@ -94,7 +94,7 @@ static int blink_set(struct led_classdev
 	asic3_write_register(asic, (base + ASIC3_LED_PeriodTime), (on + off));
 	asic3_write_register(asic, (base + ASIC3_LED_DutyTime), on);
 	asic3_write_register(asic, (base + ASIC3_LED_AutoStopCount), 0);
-	asic3_write_register(asic, (base + ASIC3_LED_TimeBase), (LED_EN|0x4));
+	asic3_write_register(asic, (base + ASIC3_LED_TimeBase), (0|0x4));
 
 	*delay_on = CLK_TO_MS(on);
 	*delay_off = CLK_TO_MS(off);

This was to check whether the LED GPIOs performed the same function as the TimeBase enable bit, which would be a useful result. But they didn't; the LEDs stopped working.

So I must conclude that there is still no evidence that the LED GPIOs work as outputs. They do work as inputs however, per my previous observations.

Maybe there exists an ASIC3 control register which can change the direction of the LED GPIOs from inputs to outputs?

Regards,
Paul

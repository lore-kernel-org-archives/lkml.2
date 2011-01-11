Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227Ab1AKCQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 21:16:58 -0500
Received: from adelie.canonical.com ([91.189.90.139]:37624 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800Ab1AKCQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 21:16:53 -0500
From: Jeremy Kerr <jeremy.kerr@canonical.com>
To: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Locking in the clk API
Date: Tue, 11 Jan 2011 10:16:42 +0800
User-Agent: KMail/1.13.5 (Linux/2.6.35-24-generic; KDE/4.5.1; x86_64; ; )
Cc: Ben Herrenschmidt <benh@kernel.crashing.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "Uwe =?utf-8?q?Kleine-K=C3=B6nig?=" <u.kleine-koenig@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201101111016.42819.jeremy.kerr@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'd like to define some locking semantics for the clk API, so that device 
driver can have some assurance about when it is safe to call various clk_ 
functions from atomic contexts.

Vincent - you mentioned in a conversation that your code had some specific 
requirements for clock enable/disable at interrupt time - could you reply with 
an outline of this? Also, Sascha and Uwe: do you have any thoughts from your 
work with the common struct clk?

== Requirements ==

To get things started, here are some basic requirements from the external API 
side:

1) clk_enable: the clock should be outputting a valid clock signal before
   returning from this function.

    - drivers may require valid clock signal to be present for subsequent
      device interactions.

3) clk_disable: may be called from atomic context

    - Vincent: this is what I recall from our conversation, is it still true?

4) clk_set_rate: clock should change to the new rate before this returns

5) clk_get_rate: may be called from atomic context

6) in general, drivers shouldn't require details about the clock
   implementation

And from the clock implementation side:

7) interactions with clock hardware may require sleeping (eg, clocks on an i2c
   bus)

8) clk_enable() may require enabling a parent, which may also require
   sleeping. Ideally, we shouldn't have to care about the parent's
   implementation.

I'm sure there are others, please feel free to add to this list.

== Implementation ==

At present, we can satisfy these with:

* clk_enable: may sleep

* clk_disable: may not sleep, but it's possible to make the global
  clk_disable() atomic and defer the actual disable (clk->ops.disable()) to a
  non-atomic context.

* clk_get_rate: may not sleep

* clk_set_rate: may sleep

As we build up our requirements, we can adjust as suitable.

I'm excluding clk_{get,set}_parent at present, as I'm not sure we want these 
as part of the device-driver API (ie, they require knowledge of the platform 
clock infrastructure).

Thanks,


Jeremy

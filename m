Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934189Ab1ESSMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:12:21 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:44368 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934094Ab1ESSJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:09:24 -0400
X-Sasl-enc: ptY3QOiQSEIcGoYjXJwXomj00wDqN0YF1nbilZDKQVVY 1305828563
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:06:00 2011
Message-Id: <20110519180600.092444592@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:05:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [61/71] [media] Fix cx88 remote control input
In-Reply-To: <20110519180626.GA16555@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Lawrence Rust <lvr@softsystem.co.uk>

commit 2a164d02dd34c6b49a3f0995900e0f8af102b804 upstream.

In the IR interrupt handler of cx88-input.c there's a 32-bit multiply
overflow which causes IR pulse durations to be incorrectly calculated.

This is a regression caused by commit 2997137be8eba.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/cx88/cx88-input.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/video/cx88/cx88-input.c
+++ b/drivers/media/video/cx88/cx88-input.c
@@ -523,7 +523,7 @@ void cx88_ir_irq(struct cx88_core *core)
 	for (todo = 32; todo > 0; todo -= bits) {
 		ev.pulse = samples & 0x80000000 ? false : true;
 		bits = min(todo, 32U - fls(ev.pulse ? samples : ~samples));
-		ev.duration = (bits * NSEC_PER_SEC) / (1000 * ir_samplerate);
+		ev.duration = (bits * (NSEC_PER_SEC / 1000)) / ir_samplerate;
 		ir_raw_event_store_with_filter(ir->dev, &ev);
 		samples <<= bits;
 	}



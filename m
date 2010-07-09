Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab0GIK2u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 06:28:50 -0400
Received: from khc.piap.pl ([195.187.100.11]:57428 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754063Ab0GIK2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 06:28:49 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Ben Collins <bcollins@bluecherry.net>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Solo6010 staging driver - kernel panic
Date: Fri, 09 Jul 2010 12:28:46 +0200
Message-ID: <m3ocehdk4h.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ben,

I'm trying to use your solo6x10 driver with a card based on 6010 chip.
The driver seems to detect the card correctly, but when I open
/dev/video0 and then close it, I got a kernel panic. I traced the
problem to invalid pointers in q->bufs[i]->queue in a call to
videobuf_queue_cancel().

The kernel is current Linus' tip (.35-rc4+) + your "staging solo6x10".
The same seems to happen with 2.6.34 + the driver included "manually".
x86-64. The card is Commell's MP-6010.

It goes like this:

# modprobe solo6x10 video_type=1

solo6x10: module is from the staging directory, the quality is unknown,
you have been warned.
solo6010 0000:08:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
solo6010 0000:08:00.0: Enabled 2 i2c adapters
solo6010 0000:08:00.0: Initialized 1 tw28xx chip: tw2815[1]
solo6010 0000:08:00.0: Display as /dev/video0 with 4 inputs (1 extended)
solo6010 0000:08:00.0: Encoders as /dev/video1-4
solo6010 0000:08:00.0: Alsa sound card as Softlogic0

# cat /dev/video0 > /dev/null ^C

- videobuf_queue_cancel() called
- about to call list_del(&q->bufs[i]->queue) with:
  i = 0
  &q->bufs[i]->queue is a valid pointer = 0xffff88033cf97c00
  q->bufs[i]->queue.prev = 0xdead000000200200
  q->bufs[i]->queue.next = 0xdead000000100100

The backtrace is:
videobuf_queue_cancel()
__videobuf_read_stop()
videobuf_stop()
solo_v4l2_release()
v4l2_release()
fput()
filp_close()
...

Any ideas?
-- 
Krzysztof Halasa

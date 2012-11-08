Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab2KHAcq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 19:32:46 -0500
Received: from mail.atsec.com ([195.30.99.214]:39276 "EHLO mail.atsec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754653Ab2KHAco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 19:32:44 -0500
Message-ID: <509AFDA6.7070005@atsec.com>
Date: Thu, 08 Nov 2012 01:32:38 +0100
From: Stephan Mueller <stephan.mueller@atsec.com>
Organization: atsec information security GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: drivers/char/random.c: variable type mismatch
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the function add_timer_randomness currently defines:

        struct {
...
                unsigned cycles;
...
        } sample;

Cycles used to be of type cycles_t. The inline get_cycles that fills
cycles is still of type cycles_t.

Unsigned is 32 bit whereas get_cycles is 64 bit. This means that only
the lower 32 bits of get_cycles is used.

However, due to the fact that jiffies provides very few entropy, the
event value provides (almost) none, the majority of entropy comes from
the processor cycles. Assuming that the processor cycles increase once
per nanosecond, after 2**32 cycles (about 4 seconds), the counter wraps.

This now means that on a 32 bit system, the maximum theoretical entropy
that can be added by one event is always 32 bit. But it used to be
higher due to the 64 bit type.

Now granted, the entropy estimator only assigns 11 bits of heuristic
entropy per event as a maximum.

But why weaken the RNG? Unless there is a technical problem, I would
suggest changing the variable type of cycles into unsigned long, or
better back to cycles_t.

Ciao
Stephan


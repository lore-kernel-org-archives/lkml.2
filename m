Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124Ab0HRU03 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 16:26:29 -0400
Received: from smtp-out.google.com ([74.125.121.35]:50232 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab0HRU02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 16:26:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:cc:
	content-type:x-system-of-record;
	b=FszuI1kRTf40S832AyKYUzhF2sDj4Q05VNiHwUgpmFEDVbO2/7oBEffgJLO2gtUC8
	PEMRq6puWjTGB7PDYEV/g==
MIME-Version: 1.0
Date: Wed, 18 Aug 2010 22:26:24 +0200
Message-ID: <AANLkTimdnYjDsr4GYgw=M74hH0hzyRDeb7WqfiE8-BT1@mail.gmail.com>
Subject: [BUG] perf_events: NMI watchdog event cannot be throttled
From: Stephane Eranian <eranian@google.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
        "David S. Miller" <davem@davemloft.net>,
        Paul Mackerras <paulus@samba.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        eranian@gmail.com, perfmon2-devel@lists.sf.net
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I ran into some issue  with the NMI watchdog not firing in a deadlock
situation. After some debugging I found the source of the problem.

The NMI watchdog is currently subject, like any other events, to interrupt
throttling. The heart of the problem is that if you are deadlocked on a CPU
with interrupts masked, the timer interrupt won't fire, therefore the
hwc->interrupts
field won't be reset. Then, depending on the max sampling rate, you
could eventually
fail the max interrupt rate test in __pfm_overflow_handler() and
perf_events would
throttle, i.e., stop, the NMI watchdog event before the 5s delay to panic.
Thus, you would never get the panic. I ran into this problem myself.

This is a serious issue because perf_events must ensure the watchdog can
always fire, regardless of the interrupt masking situation.

Look like one way of solving the problem would be to mark the NMI watchdog
event as immune to throttling. The event being internal to the kernel we could
trust the event setup from perf_event_create_kernel_counter().

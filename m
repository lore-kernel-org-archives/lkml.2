Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab1EEMjL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 08:39:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:43483 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635Ab1EEMjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 08:39:10 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=ctMo2oRLta0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=a4yXl0JuvHy9lFArwU0A:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] trace: Check for waiting readers before calling
 wakeup()
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Ingo Molnar <mingo@redhat.com>, Michael Rubin <mrubin@google.com>,
        David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org
In-Reply-To: <BANLkTimMvEyzG-S=S6R4fVsui-9ok63jwg@mail.gmail.com>
References: <1304467520-31530-1-git-send-email-vnagarnaik@google.com>
	 <BANLkTimorXOLcvB2dwXMAH8n2UU-C2ntcA@mail.gmail.com>
	 <20110504212635.GE1804@nowhere>
	 <BANLkTimMvEyzG-S=S6R4fVsui-9ok63jwg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 05 May 2011 08:39:06 -0400
Message-ID: <1304599146.25414.2484.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-04 at 20:53 -0700, Linus Torvalds wrote:

> I dunno. It's sometimes safe, but it's equally often not safe unless
> there is some other locking around the thing. So I'd be a bit nervous.
> The tracer people would need to do some serious thinking about it.

The problem with tracing is that it can be very intrusive. We want the
data but we also do not want to affect the system either. We are
constantly fighting with Heissenberg on this.

Perhaps we could do what perf currently does and use irq_work() instead.
This should be lighter weight. The wakeup should not be at the tracing
event itself as the wakeup is too invasive.

Maybe we could use bitmasks in this case, but I would also hate to use
memory barriers here, although a memory barrier might be much lighter
weight than spinlocks that we currently are fighting with.

If irq_work() doesn't work, perhaps just have something like:

event() {
	write_data();
	smp_mb();
	if (test_and_clear_bit())
		wakeup();
}

reader() {
	set_bit();	
	smp_mb();
	if (data_empty())
		schedule();
	clear_bit();
	smp_mb();
	wake_up_other_readers_if_needed()
}

This is probably better than a spinlock.

-- Steve



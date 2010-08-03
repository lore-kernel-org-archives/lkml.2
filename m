Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab0HCIQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 04:16:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:60981 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106Ab0HCIQU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 04:16:20 -0400
Subject: Re: periods and deadlines in SCHED_DEADLINE
From: Peter Zijlstra <peterz@infradead.org>
To: Bjoern Brandenburg <bbb@email.unc.edu>
Cc: Raistlin <raistlin@linux.it>, linux-kernel <linux-kernel@vger.kernel.org>,
        Song Yuan <song.yuan@ericsson.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Luca Abeni <lucabe72@email.it>,
        Claudio Scordino <claudio@evidence.eu.com>,
        Harald Gustafsson <harald.gustafsson@ericsson.com>, bastoni@cs.unc.edu,
        Giuseppe Lipari <lipari@retis.sssup.it>, rostedt <rostedt@goodmis.org>,
        Gregory Haskins <ghaskins@novell.com>
In-Reply-To: <21AA2C13-8831-47A2-9464-28E84DBD72B0@email.unc.edu>
References: <1278682707.6083.227.camel@Palantir>
	 <1278685133.1900.201.camel@laptop>
	 <51F8E441-58D7-45E1-B7A0-7A717EDF08B5@email.unc.edu>
	 <1278745706.4390.2.camel@Palantir>
	 <21AA2C13-8831-47A2-9464-28E84DBD72B0@email.unc.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 03 Aug 2010 10:16:00 +0200
Message-ID: <1280823360.1923.419.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-07-11 at 08:46 +0200, Bjoern Brandenburg wrote:
> I'd be hesitant to just assume that it "approximates G-EDF"
> sufficiently well to apply any of the published G-EDF tests.

OK, suppose that for each cpu we keep the earliest and next-earliest
deadline in a table. Then on wakeup (job release) we pick the cpu with
the currently last deadline to preempt (we push the task).

On sleep (job completion) we look for the earliest among all
next-earliest deadlines to select the next runnable task (we pull the
task).

If we serialize all this using one big lock around this [ {earliest,
next-earliest} ] table, we've basically implemented G-EDF, agreed?

Now replace that global lock with an algorithm that looks at the table,
finds the last-earliest or earliest-next-earliest in a lock-less
fashion, then locks the target cpu's rq->lock, verifies the result and
either continues or tries again.

So we replace the global lock with cmpxchg like loops using 2 per-cpu
locks. Our current SCHED_FIFO balancer does just this and is found to be
a very good approximation of global-fifo (iirc there's one funny case,
but I can't remember, maybe Steve or Gregory can remember the details).



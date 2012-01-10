Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932685Ab2AJRvE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 12:51:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24206 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756511Ab2AJRvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 12:51:02 -0500
Date: Tue, 10 Jan 2012 18:45:09 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] tracing: make signal tracepoints more useful
Message-ID: <20120110174509.GA30802@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Linus, I am asking you to review (and hopefully apply) these
changes, I do not know who else can do this. I do not mean the
implementation, the patches are simple. Just the behavioural
change.

2/2 looks like a bugfix to me, but 1/2 changes the output from
trace_signal_generate() and removes trace_signal_overflow_fail.
In essence the change is:

	-       TP_printk("sig=%d errno=%d code=%d comm=%s pid=%d",
	+       TP_printk("sig=%d errno=%d code=%d comm=%s pid=%d grp=%d res=%d",

where
	- grp=0/1 means private or shared

	- res is enum {
			TRACE_SIGNAL_DELIVERED,
			TRACE_SIGNAL_IGNORED,
			TRACE_SIGNAL_ALREADY_PENDING,
			TRACE_SIGNAL_OVERFLOW_FAIL,
			TRACE_SIGNAL_LOSE_INFO,
		};

Obviously this is the user visible change. But personally I do
agree with Seiji who requested this feature. Currently
trace_signal_generate() just records the fact that __send_signal()
was called, you can't know whether the signal was actually sent
or not.

 include/trace/events/signal.h |   85 +++++++++++------------------------------
 kernel/signal.c               |   28 +++++++++----
 2 files changed, 41 insertions(+), 72 deletions(-)


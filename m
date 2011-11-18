Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449Ab1KRJ7u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 04:59:50 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:57011 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab1KRJ7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 04:59:47 -0500
Subject: tracing vs. string formatting
From: Johannes Berg <johannes@sipsolutions.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Nov 2011 10:59:42 +0100
Message-ID: <1321610382.10266.19.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm thinking about adding tracing to all debug messages in our driver
(iwlwifi) so we can ask people to record all debug messages (which are
way too many, some can be removed), and then we could post-process it
and only show selectively the ones we care about.

Converting all the messages and/or adding tracing at all the points
where we have messages now would be a huge effort, and sometimes the
messages are all that we can get from users, so we wouldn't want to get
rid of them either.

Therefore I was thinking we should just trace the messages.

The issue I ran into is that obviously almost all messages need string
formatting. But to put them into the trace, we have two choices now that
I can see:

1) format the messages into a temporary buffer, then copy into the trace
2) format the messages into the ringbuffer, reserving the max length we
   think we might need

Both have obvious problems: The trivial implementation of 1) is stupid
if tracing is disabled and at least incurs an extra copy. 2) means that
I need to reserve say 200 bytes for each entry and then will end up not
using a large chunk of it in most cases.

Is there any way to reserve those 200 bytes, but then when we commit
update the trace entry length and also un-reserve whatever size we
didn't need? Then we could directly vsnprintf into the ring-buffer and
use the return value to update from 200 bytes reserved to say 20.

The API I'm envisioning would look a bit like this:

TRACE_EVENT(foo_dbg,
        TP_PROTO(const char *fmt, va_list args),
        TP_ARGS(fmt, args),
        TP_STRUCT__entry(
		/* 200 is the max length we expect/reserve */
                __fmt_string(msg, 200)
        ),
        TP_fast_assign(
                __vprint_str(msg, fmt, args);
        ),
        TP_printk("%s", __get_str(msg))
);


Behind the scenes somehow the 200 would get reserved, propagated,
__vprint_str would call something like
	r = vsnprintf(__get_str(msg), 200, fmt, args);

and use r to shrink the entry if possible.



Now obviously I have no idea if it's even possible to shrink an entry
afterwards :-) It seems like it should be since the local CPU buffer is
locked in some way, but ... what do I know. Interrupts coming in would
probably have to make it not shrink the entry, but that seems feasible
too -- in that case you'd just have the 200 bytes used but not filled
except for the message (though then maybe you have to memset the
remainder to 0).


Does this sound completely stupid? Yes maybe adding tracing (is there a
way to cause certain tracepoints to be printk'ed?) would be better but
converting all the messages to like a few hundred tracepoints would be a
huge waste as well.


If you made it this far -- thanks! :-)

johannes


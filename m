Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757779Ab1BQS7X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 13:59:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29192 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757412Ab1BQS7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 13:59:19 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Jan Kratochvil <jan.kratochvil@redhat.com>,
        Denys Vlasenko <vda.linux@googlemail.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
	PTRACE_ATTACH
In-Reply-To: Oleg Nesterov's message of  Thursday, 17 February 2011 17:49:06 +0100 <20110217164906.GA5167@redhat.com>
References: <20110204105343.GA12133@htj.dyndns.org>
	<20110207174821.GA1237@redhat.com>
	<20110209141803.GH3770@htj.dyndns.org>
	<201102132325.55353.vda.linux@googlemail.com>
	<20110214151340.GP18742@htj.dyndns.org>
	<AANLkTi=Djwcf9YoUrGtTEOp8W_YhsefzrNhMxVhtw_Lp@mail.gmail.com>
	<20110216215157.GA6054@host1.dyn.jankratochvil.net>
	<20110217164906.GA5167@redhat.com>
X-Zippy-Says: After this, I'm going to BURN some RUBBER!!
Message-Id: <20110217185847.5E9D31806EE@magilla.sf.frob.com>
Date: Thu, 17 Feb 2011 10:58:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> OK... Yes, perhaps PTRACE_{DETACH,CONT}(SIGCONT) should override
> SIGNAL_STOP_STOPPED too. This makes sense, and this connects to
> the problem with SIGNAL_STOP_DEQUEUED I mentioned above.

It's not at all clear this really does make sense.  I think this may
reflect a (common) misunderstanding of what the SIGCONT semantics are
(aside from ptrace).  Resuming the process is not the action of
delivering SIGCONT.  Rather, *generating* SIGCONT is what resumes the
process--it does so immediately, and regardless of whether SIGCONT is
blocked or ignored.  (It's also at generation-time that its other
magical semantics apply, of clearing all pending stop signals.)  
By the time SIGCONT is actually delivered, it is no different than
SIGWINCH.  (Conversely, with stop signals, generation time is when
the magic semantics of clearing pending SIGCONT occur, but the actual
stopping is indeed the delivery-time action.)

In ptrace, the report of a signal to the tracer is that it is about to
be delivered, not that it was just generated.  e.g., it won't be
reported immediately if it was blocked, only when it's unblocked and
being delivered.  Likewise, a signal given to PTRACE_CONT et al is not
generating a signal, it is continuing the delivery path of a signal.
So IMHO what makes most sense given what all the normal semantics are
is that PTRACE_CONT,SIGCONT does nothing magical, and generating a
fresh SIGCONT (i.e. kill) is the way you resume from job control stop.
If ptrace is involved, that will mean waking up long enough to dequeue
the SIGCONT and get a new ptrace stop for that.  (Things are a bit
more subtle if there are multiple threads.)


Thanks,
Roland

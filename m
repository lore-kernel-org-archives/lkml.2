Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217Ab0GIAxI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 20:53:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988Ab0GIAxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 20:53:04 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: ebiederm@xmission.com (Eric W. Biederman)
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@redhat.com>, Chris Friesen <chris.friesen@genband.com>,
       paulmck@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Don Zickus <dzickus@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jerome Marchand <jmarchan@redhat.com>,
       Mandeep Singh Baines <msb@google.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: while_each_thread() under rcu_read_lock() is broken?
In-Reply-To: Eric W. Biederman's message of  Thursday, 24 June 2010 17:08:10 -0700 <m1sk4c7z4l.fsf@fess.ebiederm.org>
References: <20100618190251.GA17297@redhat.com>
	<20100618193403.GA17314@redhat.com>
	<20100618223354.GL2365@linux.vnet.ibm.com>
	<20100621170919.GA13826@redhat.com>
	<20100621205128.GI2354@linux.vnet.ibm.com>
	<20100622212357.GA19670@redhat.com>
	<20100622221226.GP2290@linux.vnet.ibm.com>
	<20100623152421.GA8445@redhat.com>
	<20100624180726.GK2373@linux.vnet.ibm.com>
	<4C23A90A.9040303@genband.com>
	<20100624220007.GB21360@redhat.com>
	<m1sk4c7z4l.fsf@fess.ebiederm.org>
X-Windows: dissatisfaction guaranteed.
Message-Id: <20100709005222.EFED64A967@magilla.sf.frob.com>
Date: Thu,  8 Jul 2010 17:52:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That we don't cleanup that zombie leaders is unfortunate really, it
> means we have the entire de_thread special case.  But short fixing
> libpthread to not make bad assumptions there is little we can do about
> it really.

To be fair (perish the thought!), the semantics for these things were
clearly specified in POSIX-1996 years before we had made any attempt in
Linux at implementing them in the current fashion or any other, so we have
no one but ourselves to blame for our current implementation choices.

There are no required semantics about "zombie leaders".  The semantics are
that wait* calls refer to the whole process (thread group) and those wait
events don't occur until all threads (the initial thread or others) are
dead (or all stopped).

Nothing really says we have to keep the leader's task_struct around, we
just need to keep the tgid assigned.  We could have the signal_struct be
the thing that holds the tgid and is on the children list that wait looks
at, and let dead leaders "self-reap" like other threads do.

Since we've already separated the ptrace list and pseudo-wait from the
proper children/wait list, it's only some of these existing implementation
assumptions and perhaps some /proc vagaries that prevent us doing that.

> I'm only half following this conversation.

Going for a third here.


Thanks,
Roland

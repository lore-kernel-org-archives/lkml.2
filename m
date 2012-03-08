Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967Ab2CHS2T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 13:28:19 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51088 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab2CHS2S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 13:28:18 -0500
Message-ID: <1331231287.11248.396.camel@twins>
Subject: Re: [ANNOUNCE] 3.2.9-rt17
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Thu, 08 Mar 2012 19:28:07 +0100
In-Reply-To: <1331230991.25686.452.camel@gandalf.stny.rr.com>
References: <alpine.LFD.2.02.1203072225020.2742@ionos>
	 <1331230991.25686.452.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-08 at 13:23 -0500, Steven Rostedt wrote:
> So basically what you tried to do was just set the owner of the lock to
> have the priority of the task that wants the lock, until it releases it?
> But by doing it without having this task sleep? 

No, by having it sleep ;-)

So you do the full PI sleeping lock thing, except you return fail if you
loose the acquisition race on wakeup and you mark this waiter as
'special'.

Then on every rt_mutex block you have to do a deadlock analysis on the
PI blocking chain (preferably shared with PI boost traversal of said
chain), during that scan you collect all special tagged waiters.

If you find a deadlock, wake all these special waiters and have them
return -EDEADLK.

I guess you could also do the full spin_deadlock() and do away with the
try part and purely rely on the deadlock detection.

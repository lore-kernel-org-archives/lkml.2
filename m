Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413Ab2FYNUB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 09:20:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:44775 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756023Ab2FYNT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 09:19:59 -0400
Subject: Re: deferring __fput()
From: Peter Zijlstra <peterz@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ". James Morris" <jmorris@namei.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, David Miller <davem@davemloft.net>
In-Reply-To: <20120625121436.GU14083@ZenIV.linux.org.uk>
References: <1340369098.2464.20.camel@falcor>
	 <20120623092049.GH14083@ZenIV.linux.org.uk>
	 <20120623194505.GI14083@ZenIV.linux.org.uk>
	 <20120623205755.GJ14083@ZenIV.linux.org.uk>
	 <1340625805.2507.56.camel@laptop>
	 <20120625121436.GU14083@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Jun 2012 15:19:56 +0200
Message-ID: <1340630396.2507.66.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-25 at 13:14 +0100, Al Viro wrote:

> You mean, doing that from RCU callbacks?

Indirectly, yeah, but the RCU callback would schedule it or whatever.

>   Still a bad idea, IMO; you will end up with a context
> switch and unpleasantness with delayed user-visible effects of syscalls.  With aio we did have
> a delayed execution of fput() anyway; all that has changed there is that we use generic
> mechanism instead of home-grown analog thereof.

Right, the delayed effect is the main concern. The example in the
referred thread was unmount() returning -EBUSY after the last
close()/munmap().

> I'll need to reread that thread to comment on the specifics (had been too long ago; I don't
> remember the details), but...  See Linus' objections to full-async fput() circa this April
> or March.  There's a reason why this patchset uses task_work_add() whenever possible.

Ok, I'll try and find that thread, so the advantage of task_work_add()
is that you'll keep the work in the task that caused it wherever
possible, right -- provided its actually sitll around.

If we make fput() deferable in general we'll be sure to grow some 'fun'
cases. So are we going to add a sync against unmount someplace to avoid
these un-expected -EBUSY things?


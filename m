Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038Ab2FYNyN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 09:54:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43365 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756990Ab2FYNyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 09:54:05 -0400
Date: Mon, 25 Jun 2012 14:53:57 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ". James Morris" <jmorris@namei.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, David Miller <davem@davemloft.net>
Subject: Re: deferring __fput()
Message-ID: <20120625135357.GV14083@ZenIV.linux.org.uk>
References: <1340369098.2464.20.camel@falcor>
 <20120623092049.GH14083@ZenIV.linux.org.uk>
 <20120623194505.GI14083@ZenIV.linux.org.uk>
 <20120623205755.GJ14083@ZenIV.linux.org.uk>
 <1340625805.2507.56.camel@laptop>
 <20120625121436.GU14083@ZenIV.linux.org.uk>
 <1340630396.2507.66.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340630396.2507.66.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 03:19:56PM +0200, Peter Zijlstra wrote:

> > I'll need to reread that thread to comment on the specifics (had been too long ago; I don't
> > remember the details), but...  See Linus' objections to full-async fput() circa this April
> > or March.  There's a reason why this patchset uses task_work_add() whenever possible.
> 
> Ok, I'll try and find that thread, so the advantage of task_work_add()
> is that you'll keep the work in the task that caused it wherever
> possible, right -- provided its actually sitll around.
> 
> If we make fput() deferable in general we'll be sure to grow some 'fun'
> cases. So are we going to add a sync against unmount someplace to avoid
> these un-expected -EBUSY things?

No.  We are not.  And I don't care how tasty some application might be -
this way madness lies.  If you have _anything_ doing async fput() (which is
perfectly possible with the current mainline), you have to live with the
fact that yes, filesystem will be busy while your mechanism, whatever it
might be, is in use.

BTW, you do realize that delayed fput() may mean delayed fs shutdown?
Think of umount -l while you have an opened file...

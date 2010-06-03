Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775Ab0FCXYH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 19:24:07 -0400
Received: from smtp-out.google.com ([216.239.44.51]:19365 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907Ab0FCXYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 19:24:05 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=l7fuMtQwcJy0ULN+U/qr3oB7l0iH8saZS+fkV8rBPz+6RCtSxkY1c27PVllG8oBOo
	VhvJC9cl/4GqAVAAyZueA==
Date: Thu, 3 Jun 2010 16:23:57 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Oleg Nesterov <oleg@redhat.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 09/12] oom: remove PF_EXITING check completely
In-Reply-To: <20100603221145.GB8511@redhat.com>
Message-ID: <alpine.DEB.2.00.1006031618230.30302@chino.kir.corp.google.com>
References: <20100603135106.7247.A69D9226@jp.fujitsu.com> <20100603152436.7262.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1006022332320.22441@chino.kir.corp.google.com> <20100603140008.GA3548@redhat.com> <alpine.DEB.2.00.1006031313040.10856@chino.kir.corp.google.com>
 <20100603221145.GB8511@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jun 2010, Oleg Nesterov wrote:

> > > > > Currently, PF_EXITING check is completely broken. because 1) It only
> > > > > care main-thread and ignore sub-threads
> > > >
> > > > Then check the subthreads.
> > > >
> >
> > Did you want to respond to this?
> 
> Please explain what you mean. There were already a lot of discussions
> about mt issues, I do not know what you have in mind.
> 

Can you check the subthreads to see if they are not PF_EXITING?

> > I'm guessing at the relevancy here because the changelog is extremely
> > poorly worded (if I were Andrew I would have no idea how important this
> > patch is based on the description other than the alarmist words of "... is
> > completely broken)", but if we're concerned about the coredumper not being
> > able to find adequate resources to allocate memory from, we can give it
> > access to reserves specifically,
> 
> I don't think so. If oom-kill wants to kill the task which dumps the
> code, it should stop the coredumping and exit.
> 

That's a coredump change, not an oom killer change.  If the coredumper 
needs memory and runs into the oom killer, this PF_EXITING check, which 
you want to remove, gives it access to memory reserves by setting 
TIF_MEMDIE so it can quickly finish and die.  This allows it to exit 
without oom killing anything else because the tasklist scan in the oom 
killer is not preempted by finding a TIF_MEMDIE task.

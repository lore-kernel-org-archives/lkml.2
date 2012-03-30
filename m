Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761253Ab2C3RWN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 13:22:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9733 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761241Ab2C3RWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 13:22:09 -0400
Date: Fri, 30 Mar 2012 19:14:30 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Karl Pickett <kjp@ci.uchicago.edu>
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
        Lennart Poettering <lennart@poettering.net>
Subject: Re: Is prctl(PR_SET_CHILD_SUBREAPER) going to break my code which
	checks getppid == 1?
Message-ID: <20120330171430.GA5865@redhat.com>
References: <46799FA3-D575-4A2D-8DEB-CE5149A4110D@ci.uchicago.edu> <20120330124426.GA13811@redhat.com> <376EB22C-893C-4AF8-81DC-3A7687B1AE1B@ci.uchicago.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <376EB22C-893C-4AF8-81DC-3A7687B1AE1B@ci.uchicago.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30, Karl Pickett wrote:
>
> On Mar 30, 2012, at 7:44 AM, Oleg Nesterov wrote:
>
> > Perhaps you can do something like
> >
> > 	ppid_for_child = getpid();
> >
> > 	if (!fork()) {
> > 		// Child
> > 		prctl(PR_SET_PDEATHSIG);
> > 		if (getppid() != ppid_for_child)
> > 			return;
> > 		...
> > 	}
>
> There are two problems with that.  1., I don't think TCL/TK lets me access
> the parent pre-fork env like that - all I can change is the execed code.

Can't comment this, I do not know tcl/tk

> 2., That has a clear race with pid wrap around.

Not really. This ppid_for_child can be re-used, yes. But the new process
which gets this pid can't become the parent, getppid() can't return this
number.

Btw, PR_SET_PDEATHSIG + getppid() check is racy anyway (with or without
PR_SET_CHILD_SUBREAPER), it can race with reparenting. But the window is
tiny and the problem is purely theoretical I think.

> You really need a
> prctl(PR_DID_MY_REAL_PARENT_DIE) function to be safe.

Oh, I don't know. Sure, PR_SET_CHILD_SUBREAPER can confuse the child.
Just suppose it does daemonize() + assert(getppid() == 1). But this
is not the kernel problem.

Oleg.


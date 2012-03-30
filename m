Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760837Ab2C3NKn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 09:10:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8661 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760384Ab2C3NKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 09:10:36 -0400
Date: Fri, 30 Mar 2012 14:44:26 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Karl Pickett <kjp@ci.uchicago.edu>
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
        Lennart Poettering <lennart@poettering.net>
Subject: Re: Is prctl(PR_SET_CHILD_SUBREAPER) going to break my code which
	checks getppid == 1?
Message-ID: <20120330124426.GA13811@redhat.com>
References: <46799FA3-D575-4A2D-8DEB-CE5149A4110D@ci.uchicago.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46799FA3-D575-4A2D-8DEB-CE5149A4110D@ci.uchicago.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29, Karl Pickett wrote:
>
> Re: http://thread.gmane.org/gmane.linux.kernel/1236479
>
> I'm wondering if this is going to break code that checks getppid() == 1?
>
> I have a TCL/TK GUI app that spawns ssh.  I want the ssh to die
> immediately if the GUI process crashes, so ssh is launched with a wrapper
> c program that does:
>
>    prctl(PR_SET_PDEATHSIG, SIGHUP);
>    if (getppid() == 1) /* parent died already? */
>        return 0;

Yes, this won't work if the parent of this app does PR_SET_CHILD_SUBREAPER.

> So what is getppid() going to return for some user using this new
> 'session manager reaper'?

The new parent's pid ;)

Perhaps you can do something like

	ppid_for_child = getpid();

	if (!fork()) {
		// Child
		prctl(PR_SET_PDEATHSIG);
		if (getppid() != ppid_for_child)
			return;
		...
	}

Just in case, I do not know how PR_SET_CHILD_SUBREAPER will be really used.
I do not know if systemd will run the "normal" user applications under
PR_SET_CHILD_SUBREAPER. Probably yes, but this is the question to Kay.

Oleg.


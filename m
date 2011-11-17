Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822Ab1KQLl6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 06:41:58 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:29934 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756760Ab1KQLl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 06:41:57 -0500
Message-ID: <4EC4F2FB.408@parallels.com>
Date: Thu, 17 Nov 2011 15:41:47 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, Roland McGrath <roland@hack.frob.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        James Bottomley <jbottomley@parallels.com>
Subject: [RFC][PATCH 0/3] fork: Add the ability to create tasks with given
 pids
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gentlemen, please, find some time for this, your ACK/NACK on the API proposal
is required badly.


There's currently a work in progress with checkpoint-restore functionality
in the userspace. Most of the API for doing this kernel already provides, but
sometimes it's not enough. One of the required things is the ability to
create a process with its pids (in different pid namespaces) set to some
given values, rather than generated. Currently kernel doesn't allow for this,
so an API extension is required.

The proposal is to introduce the CLONE_CHILD_USEPIDS flag for clone() syscall
and pass the pids values in the child_tidptr. In order not to introduce the
hole for the pid-reuse attack, using this flag will result in EPERM in case
the pid namespace we're trying to create pid in has at least one pid (except
for the init's one) generated with regular fork()/clone().

Currently Tejun and Oleg are worrying only about the intrusiveness of this
approach, although Oleg agrees, that it solves all the problems it should. The
previous attempts to implement the similar stuff stopped, but no objections
against this were expressed. So the decision of whether it's OK to go this
way or not is required.


The API will be used like in the code below

	/* restore new pid namespace with an init in it */
	pid = clone(CLONE_NEWPID);
	if (pid)
		return 0;

	/*
	 * init of a new pid namespace.
	 * recreate the process tree
	 */

restore_children:
	while (1) {
		pid = next_pid_from_image();
		if (!pid)
			/* no more children */
			break;

		pid = clone(CLONE_CHILD_USEPIDS, &pid);
		if (pid == 0)
			goto restore_children;
	}

	/*
	 * the process tree is recreated, can proceed with restoring
	 * other stuff
	 */


Thanks,
Pavel

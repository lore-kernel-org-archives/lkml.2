Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943Ab2GVPrI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 11:47:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42538 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233Ab2GVPrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 11:47:07 -0400
Date: Sun, 22 Jul 2012 16:47:05 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org
Subject: kcmp() races?
Message-ID: <20120722154705.GA31729@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	I don't know how much of that is by design, but at the very least
it needs to be clearly documented in manpage: kcmp() can give false
positives.  Very easily.  There is nothing to prevent the objects
being compared from getting freed and reused; consider unshare(2), for
example.  Or close(2), for that matter.  Suppose we look at the descriptor
table for task1 just as it (or somebody sharing that table) closes the
descriptor we are after.  We got struct file *; it'll stay allocated
until we do rcu_read_unlock().  Which we promptly do and turn to
examining the descriptor table of task2.  Which is doing e.g. pipe(2)
at the moment (or somebody sharing its descriptor table is).  It
allocates struct file, getting the one that just had been freed by
task1.  And puts a reference to it into its descriptor table, which
is where we find it.  And we see the same pointer...

	Sure, if the processes are stopped, we are fine (except that
we need to stop everybody sharing the descriptor table with either
of our processes as well).  *IF* that is the intended behaviour
(and it could be argued that way - after all, if we want the values
we get to stay valid long enough for us to do sorting, we'd better
make sure that these guys won't get changed between the calls of
kcmp(2)), then we'd better document that in the manpage...

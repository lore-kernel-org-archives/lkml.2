Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244Ab2GVRa6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 13:30:58 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56043 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158Ab2GVRa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 13:30:57 -0400
Date: Sun, 22 Jul 2012 21:30:53 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>
Subject: Re: kcmp() races?
Message-ID: <20120722173053.GA19964@moon>
References: <20120722154705.GA31729@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120722154705.GA31729@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22, 2012 at 04:47:05PM +0100, Al Viro wrote:
>   I don't know how much of that is by design, but at the very least
> it needs to be clearly documented in manpage: kcmp() can give false
> positives.  Very easily.  There is nothing to prevent the objects
> being compared from getting freed and reused; consider unshare(2), for
> example.  Or close(2), for that matter.  Suppose we look at the descriptor
> table for task1 just as it (or somebody sharing that table) closes the
> descriptor we are after.  We got struct file *; it'll stay allocated
> until we do rcu_read_unlock().  Which we promptly do and turn to
> examining the descriptor table of task2.  Which is doing e.g. pipe(2)
> at the moment (or somebody sharing its descriptor table is).  It
> allocates struct file, getting the one that just had been freed by
> task1.  And puts a reference to it into its descriptor table, which
> is where we find it.  And we see the same pointer...
> 
>   Sure, if the processes are stopped, we are fine (except that
> we need to stop everybody sharing the descriptor table with either
> of our processes as well).  *IF* that is the intended behaviour
> (and it could be argued that way - after all, if we want the values
> we get to stay valid long enough for us to do sorting, we'd better
> make sure that these guys won't get changed between the calls of
> kcmp(2)), then we'd better document that in the manpage...

Hi Al,

yes, good point, this might result false positives if tasks are not
stopped (or it's not guaranteed on userspace level that say files
being compared are not closed when kcmp runs). I'll update man-page.
And yes this was intentional (I tried to keep task-locks/rcu-locks
as minimum time as possible).

	Cyrill

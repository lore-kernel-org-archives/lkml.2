Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105Ab2BVDQl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 22:16:41 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:35442 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab2BVDQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 22:16:40 -0500
Date: Tue, 21 Feb 2012 22:16:09 -0500 (EST)
Message-Id: <20120221.221609.218135609185671883.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, autofs@linux.kernel.org,
        thomas@m3y3r.de, viro@zeniv.linux.org.uk
Subject: Re: compat: autofs v5 packet size ambiguity - update
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+55aFzhS69QSoN1j+Z2md116u+3OfniAoE0QMo6xyBjDyjbEw@mail.gmail.com>
References: <CA+55aFzhS69QSoN1j+Z2md116u+3OfniAoE0QMo6xyBjDyjbEw@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 21 Feb 2012 19:16:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 21 Feb 2012 18:24:10 -0800

> No, the problem is that "is_compat_task()" is not the right check.
> It's not the task that *waits* for autofs that matters, it's that damn
> autofs daemon task.
> 
> IOW, what we actually want to test is whether the other end of that
> autofs sbi->pipe is a compat task or not.
> 
> And I have no idea how to do that.

It's just a real fd, and there is no way to tell the compat'ness for
that.  The mount operation literally passes in an integer attribute as
the pipefd mount option, and that's what it seems to use to send these
events.

And that fd can be dup()'d, exec()'d into compat and non-compat tasks,
passed around as SCM credentials between arbitrary processes, etc.

It's a real mess.

The only way to fix this cess pool completely is to override the
read() fop on that pipe, and translate the event stream in-situ.

What we could do is just manage the autofs messages as a linked list
of events, f.e. the packets in native format, then in the overridden
read() handler we either pass it along as is (for non-compat tasks) or
translate to compat format and copy that to userspace instead.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759825Ab1IKCiu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 22:38:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43904 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758946Ab1IKCit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 22:38:49 -0400
Date: Sun, 11 Sep 2011 03:38:40 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Lockdep and rw_semaphores
Message-ID: <20110911023840.GZ2203@ZenIV.linux.org.uk>
References: <4E6C1016.8030703@vlnb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E6C1016.8030703@vlnb.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 10, 2011 at 09:34:14PM -0400, Vladislav Bolkhovitin wrote:
> Hello,
> 
> Looks like lockdep somehow over-restrictive for rw_semaphores in case when they
> are taken for read (down_read()) and requires them to follow the same inner-outer
> rules as for plain locks.
> 
> For instance, code like:
> 
> DECLARE_RWSEM(QQ_sem);
> DECLARE_RWSEM(QQ1_sem);
> 
> thread1:
> 
>         down_read(&QQ_sem);
>         down_read(&QQ1_sem);

> thread2:
> 
> 	down_read(&QQ1_sem);
> 	down_read(&QQ_sem);

> Is it by design or just something overlooked? I don't see how reverse order of
> down_read()'s can lead to any deadlock. Or am I missing anything?

thread1: got QQ
thread2: got QQ1
thread3: tries to do down_write() on QQ, gets blocked
thread4: tries to do down_write() on QQ1, gets blocked

Now we have thread1 that can't get QQ1 once the threads trying to get it
exclusive get a shot at it.  Thread2 is blocked in the same way on QQ.
And neither is going to release the (shared) lock they are holding, so
thread3 and thread4 are not going to get anywhere either.

IOW, ordering *is* needed there.  Note that for the same reason trying to
grab the same lock shared twice is a deadlock:

A: already holds X shared
B: blocks trying to grab it exclusive
A: tries to grab it shared again and gets stuck, since there is a pending
down_write() and we are guaranteed that writer will get served as soon
as all current readers are through; no new readers are allowed to starve it.

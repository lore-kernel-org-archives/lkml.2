Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab2DZHPc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 03:15:32 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:52951 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab2DZHPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 03:15:30 -0400
Date: Thu, 26 Apr 2012 09:15:19 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, Tejun Heo <tj@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Roland McGrath <roland@hack.frob.com>
Subject: Re: [RFC] TIF_NOTIFY_RESUME, arch/*/*/*signal*.c and all such
Message-ID: <20120426091519.49eef9aa@de.ibm.com>
In-Reply-To: <20120425175113.GI6871@ZenIV.linux.org.uk>
References: <20120424072617.GB6871@ZenIV.linux.org.uk>
	<20120425030659.GE6871@ZenIV.linux.org.uk>
	<20120425123746.GA15560@redhat.com>
	<20120425125042.GF6871@ZenIV.linux.org.uk>
	<20120425130329.GA16413@redhat.com>
	<20120425133238.GG6871@ZenIV.linux.org.uk>
	<20120425145239.GA21386@redhat.com>
	<20120425154611.GA23672@redhat.com>
	<20120425161002.GH6871@ZenIV.linux.org.uk>
	<20120425170230.GA24977@redhat.com>
	<20120425175113.GI6871@ZenIV.linux.org.uk>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12042607-1948-0000-0000-000001A12C81
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2012 18:51:13 +0100
Al Viro <viro@ZenIV.linux.org.uk> wrote:

> do_signal()
> {
> 	if (we have any business doing restarts)
> 		// note: we won't get here on subsequent calls of do_signal()
> 		// due to the checks above; same logics that currently prevents
> 		// double restarts
> 		set NEED_RESTART flag
> 	sig = get_signal_to_deliver(...)
> 	if (sig) {
> 		if (NEED_RESTART set) {
> 			clear NEED_RESTART
> 			same thing we do at that spot now - restart or EINTR
> 			handle_signal(...)
> 			...
> 			return;
> 		}
> 	}
> 	/* no handler */
> 	if (test_and_clear_...(RESTORE_SIGMASK))
> 		set_current_blocked(&current->saved_sigmask);
> }
> and in asm glue, *after* checking for SIGPENDING/NOTIFY_RESUME, check
> NEED_RESTART and if it's set do what we currently do for restarts on
> handlerless signal.

You need to be careful with inferior calls there. gdb likes to play games
with the registers inside the get_signal_to_deliver call, it wants to be
able to jump out of an interrupted system call, do its inferior call in
the debugee and then return to the interrupted system call.
You would have to to read, modify & restore the NEED_RESTART flag in gdb
over an inferior call.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.


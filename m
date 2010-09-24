Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826Ab0IXPwj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 11:52:39 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38842 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab0IXPwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 11:52:38 -0400
Date: Fri, 24 Sep 2010 16:52:31 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: what's papered over by set_fs(USER_DS) in amd64 signal delivery?
Message-ID: <20100924155231.GQ19804@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	What the hell is going on in amd64 handle_signal()?  We do

#ifdef CONFIG_X86_64
        /*
         * This has nothing to do with segment registers,
         * despite the name.  This magic affects uaccess.h
         * macros' behavior.  Reset it to the normal setting.
         */
        set_fs(USER_DS);
#endif

in the end of sigframe creation; first of all, we'd just done a bunch of
copying to user-controlled addresses, protected only by access_ok(), so
if we *did* have something different we are already fucked badly.  Moreover,
if we had been on our way to userland (and we wouldn't have reached that
code otherwise) with wrong ->addr_limit and would *not* get a signal, we'd
be left with the same ->addr_limit for the next syscall to be done.  Fucked
again?

I've tried to find amd64-specific magic that would require that, but so far
I've found nothing of that kind.  It looks like until the i386/amd64 merge
*both* used to have that thing and during the merge it has suddenly grown
that ifdef, so another way to put it is "why the reasons allowing to kill
it on i386 do not apply to amd64?"

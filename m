Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933713Ab2FBVhq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 17:37:46 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54514 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932536Ab2FBVhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 17:37:45 -0400
Date: Sat, 2 Jun 2012 22:37:28 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Breeds <tony@bakeyournoodle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] h8300/signal: Fix typo "statis"
Message-ID: <20120602213728.GO30000@ZenIV.linux.org.uk>
References: <1338669339-23214-1-git-send-email-geert@linux-m68k.org>
 <1338669339-23214-3-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338669339-23214-3-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 02, 2012 at 10:35:36PM +0200, Geert Uytterhoeven wrote:
> The keyword is "static", not "statis":
> 
> arch/h8300/kernel/signal.c:455:8: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'void'
> arch/h8300/kernel/signal.c: In function 'do_notify_resume':
> arch/h8300/kernel/signal.c:511:3: error: implicit declaration of function 'do_signal' [-Werror=implicit-function-declaration]
> arch/h8300/kernel/signal.c: At top level:
> arch/h8300/kernel/signal.c:414:1: warning: 'handle_signal' defined but not used [-Wunused-function]
> 
> Introduced in commit 7ae4e32a65148353db3458e3eb87117f25620ac5 ("h8300: switch
> to saved_sigmask-based sigsuspend/rt_sigsuspend")

Sigh...  This one I don't even have a cross-toolchain for (ICEs galore),
nevermind the setup to test on ;-/

FWIW, there's a potential unpleasant bug in h8300 signal handling -
the check for return to user mode is in the wrong place; doing that
in do_signal() is pointless, since if you ever get there with both
TIF_SIGPENDING set and regs such that we are about to return to kernel,
you'll just keep looping.

That check belongs in the loop in entry.S, if anywhere (i.e. if that loop
can be reached when returning to kernel mode; AFAICS, the only plausible
way for that to happen is failing kernel_execve() leaving us on the exit
from system_call, about to return to kernel).  It might or might not be
worth doing more or less what arm does in its kernel_execve(); then that
check could be simply removed.  In any case, do_signal() is definitely the
wrong place for that check - if anything, it needs to be done before hitting
do_notify_resume, breaking the loop if we are returning to kernel.

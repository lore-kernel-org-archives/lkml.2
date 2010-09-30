Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab0I3L4s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 07:56:48 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:53709 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485Ab0I3L4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 07:56:47 -0400
Date: Thu, 30 Sep 2010 15:56:45 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Michael Cree <mcree@orcon.net.nz>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Al Viro <viro@ftp.linux.org.uk>,
        linux-kernel@vger.kernel.org, mattst88@gmail.com,
        torvalds@linux-foundation.org, linux-alpha@vger.kernel.org
Subject: Re: [PATCH 1/2] alpha: switch osf_sigprocmask() to use of
	sigprocmask()
Message-ID: <20100930115645.GA6037@jurassic.park.msu.ru>
References: <E1OzvxM-0002ng-B5@ZenIV.linux.org.uk> <4CA1B7DF.10202@orcon.net.nz> <20100929010738.GJ19804@ZenIV.linux.org.uk> <4CA43E95.5040301@orcon.net.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CA43E95.5040301@orcon.net.nz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 08:39:01PM +1300, Michael Cree wrote:
> It appears to be worse than that.  It introduces a regression.  On boot up 
> on a Compaq Alpha XP1000 the system appears to freeze at the point of 
> mounting swap.  It eventually resumes after almost three minutes and 
> continues to boot.  A bisection returned this very commit as the first bad 
> commit.  With a kernel without this commit the (truncated) bootup log is:

Confirmed, I see some processes get stuck, apparently waiting for signals.

Looks like yet another typo - _BLOCKABLE is defined as
(~(sigmask(SIGKILL) | sigmask(SIGSTOP))), so (newmask & ~_BLOCKABLE)
clears everything but SIGKILL and SIGSTOP.

Ivan.

diff --git a/arch/alpha/kernel/signal.c b/arch/alpha/kernel/signal.c
index d290845..6f7feb5 100644
--- a/arch/alpha/kernel/signal.c
+++ b/arch/alpha/kernel/signal.c
@@ -48,7 +48,7 @@ SYSCALL_DEFINE2(osf_sigprocmask, int, how, unsigned long, newmask)
 	sigset_t mask;
 	unsigned long res;
 
-	siginitset(&mask, newmask & ~_BLOCKABLE);
+	siginitset(&mask, newmask & _BLOCKABLE);
 	res = sigprocmask(how, &mask, &oldmask);
 	if (!res) {
 		force_successful_syscall_return();

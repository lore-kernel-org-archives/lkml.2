Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053Ab1BJGiy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 01:38:54 -0500
Received: from smtp.outflux.net ([198.145.64.163]:52695 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788Ab1BJGiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 01:38:52 -0500
Date: Wed, 9 Feb 2011 22:38:42 -0800
From: Kees Cook <kees.cook@canonical.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
        Al Viro <viro@ftp.linux.org.uk>, Stephen Smalley <sds@tycho.nsa.gov>,
        linux-security-module@vger.kernel.org
Subject: Re: [SECURITY] /proc/$pid/ leaks contents across setuid exec
Message-ID: <20110210063842.GD1457@outflux.net>
References: <20110207231416.GD1457@outflux.net>
 <alpine.LRH.2.00.1102081127330.3342@tundra.namei.org>
 <20110208011445.GF1457@outflux.net>
 <alpine.LRH.2.00.1102081437430.3879@tundra.namei.org>
 <20110208042708.GG1457@outflux.net>
 <m1ipwu5lj2.fsf@fess.ebiederm.org>
 <alpine.LRH.2.00.1102101337100.19432@tundra.namei.org>
 <m1r5bglfnu.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1r5bglfnu.fsf@fess.ebiederm.org>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 09, 2011 at 07:41:41PM -0800, Eric W. Biederman wrote:
> James Morris <jmorris@namei.org> writes:
> 
> > On Tue, 8 Feb 2011, Eric W. Biederman wrote:
> >
> >> Kees Cook <kees.cook@canonical.com> writes:
> >> 
> >> > On Tue, Feb 08, 2011 at 02:43:15PM +1100, James Morris wrote:
> >
> >> >> > I don't think /proc/$pid/* needs to stay open across execs, does it? Or at
> >> >> > least the non-0444 files should be handled separately.
> >> >> 
> >> >> Actually, this seems like a more general kind of bug in proc rather than a 
> >> >> leaked fd.  Each child task should only see its own /proc/[pid] data.
> >> >
> >> > Right, that's precisely the problem. The unprivileged process can read
> >> > the setuid process's /proc files.
> >> 
> >> If these are things that we actually care about we should sprinkle in a
> >> few more ptrace_may_access calls into implementations of the relevant
> >> proc files.
> >
> > This seems to be papering over a bug.
> >
> > It is plainly broken to return an access error to a task which is 
> > legitimately accessing a file.  The task should not receive the wrong 
> > information from /proc/[pid]/* .
> 
> Per task files are special because of exec.  The permission needed
> change dynamically.  The common solution to this problem (see ttys) is
> to revoke anyone who has file descriptors open.  Proc does something a
> little different and simply gives you a permission error when you read
> or write if it would be a problem.
> 
> We happen to call the test to see if you should have permission
> security_may_ptrace because ptrace lets you get the information anyway
> so we might as well allow the information from /proc.
> 
> Given that security_may_ptrace is the existing model, and that we don't
> return wrong data, but a clear an unambiguous error I don't see problems
> with the approach.
> 
> The practical question is, is the data sensitive enough that we want
> this protection.

This seems reasonable; they're mode 0400 for a reason. The auxv file
alone is a nearly total ASLR offset leak. The may_ptrace() worked well
for /proc/$pid/maps, and it started as 0444 historically and had a lot
of additional carefully managed requirements. Adding the same restriction
to all the already-mode-0400 files seems logical.

-Kees

-- 
Kees Cook
Ubuntu Security Team

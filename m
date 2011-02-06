Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab1BFQvf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 11:51:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753232Ab1BFQvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 11:51:33 -0500
Subject: Re: Using ftrace/perf as a basis for generic seccomp
From: Eric Paris <eparis@redhat.com>
To: Stefan Fritsch <sf@sfritsch.de>
Cc: linux-kernel@vger.kernel.org, morgan@kernel.org, serge@canonical.com
Date: Sun, 06 Feb 2011 11:51:02 -0500
In-Reply-To: <alpine.DEB.1.10.1102051226110.26628@eru.sfritsch.de>
References: <1294867725.3237.230.camel@localhost.localdomain>
	  <1296665124.3145.17.camel@localhost.localdomain>
	  <20110203190643.GC1769@nowhere> <201102032306.34251.sf@sfritsch.de>
	 <1296837393.3145.80.camel@localhost.localdomain>
	 <alpine.DEB.1.10.1102051226110.26628@eru.sfritsch.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1297011064.2530.17.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dropped a lot of people and added 2 more.  I'm going to try to shift the
direction of this thread to discuss how to handle suid apps in a
potential sandbox solution (and remember, I don't consider an extended
seccomp to be a sandbox, it's just a tool to help create a sandbox)

Stefan would like to be able to prevent SETUID programs and programs
with fcaps from executing.  I suggested (below) that he play with prctl,
drop things from bset, pP, pE, pI, and then remove the suid(2) syscall
from the set of allowed syscalls.  He had some concerns:

On Sat, 2011-02-05 at 12:42 +0100, Stefan Fritsch wrote:
> On Fri, 4 Feb 2011, Eric Paris wrote:
> > On Thu, 2011-02-03 at 23:06 +0100, Stefan Fritsch wrote:

> >> - deny exec of setuid/setgid binaries
> >> - deny exec of binaries with filesystem capabilities
> >
> > I think both of these are wrong to try to address here.  The right way
> > to handle these is to
> >
> > 1) set prctl(SECBIT_NOROOT)
> > 2) drop all caps from the bset, pP, pE, and pI
> > 3) make sure the setuid(2) syscall (not to be confused with SETUID
> > filesystem bit) is not in the set of allowed syscalls.  Thus rendering
> > suid and file with fcaps irrelevant.
> 
> I think that's a bad idea. Some programs may get confused if run as root 
> but without capabilities (think sendmail). If a setuid root binary gets 
> confused enough to write arbitrary files as root, you get all capabilities 
> again by writing to /etc/crontab or /root/.ssh/authorized_keys. I admit 
> that this is very unlikely if setuid(2)/setgid(2) lead to the process 
> being killed, but better to be save and disallow the user change for 
> SETUID binaries completely. And the simplest way to do that seemed to me 
> to disallow exec'ing of SETUID binaries.

I believe that my method should be safe for fcaps.  I believe the fcaps
code will kill any process that is unable to get the caps it claims to
need.  But I believe he's right about SUID apps with SECBIT_NOROOT.
sendmail (unless it was smart) wouldn't know it didn't have permissions
to do what it needed to do and would thus, likely break.  Anyone have
thoughts on that?  I've thought a couple of times about adding a new LSM
hook security_exec_suid() which would just be a big hammer blocking the
execution of suid root files.  How can we safely and sanely prevent the
execution of suid root files?

-Eric


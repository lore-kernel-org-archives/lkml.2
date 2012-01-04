Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856Ab2ADUcU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 15:32:20 -0500
Received: from relais.videotron.ca ([24.201.245.36]:27089 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab2ADUcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 15:32:18 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Wed, 04 Jan 2012 15:32:13 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Subject: Re: ZenIV (was: Re: Status of arm-soc.git for 3.2)
In-reply-to: <20120104200447.GC11810@n2100.arm.linux.org.uk>
Message-id: <alpine.LFD.2.02.1201041520380.2907@xanadu.home>
References: <201201032243.06440.arnd@arndb.de>
 <20120104100016.GK2914@n2100.arm.linux.org.uk>
 <20120104181703.GA11810@n2100.arm.linux.org.uk>
 <alpine.LFD.2.02.1201041337370.2907@xanadu.home>
 <20120104191042.GB11810@n2100.arm.linux.org.uk>
 <20120104200447.GC11810@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jan 2012, Russell King - ARM Linux wrote:

> On Wed, Jan 04, 2012 at 07:10:42PM +0000, Russell King - ARM Linux wrote:
> > On Wed, Jan 04, 2012 at 01:55:48PM -0500, Nicolas Pitre wrote:
> > > On Wed, 4 Jan 2012, Russell King - ARM Linux wrote:
> > > > I've now disabled all access to my git tree there, and restarted apache.
> > > > We will see whether that improves stability - I suspect it will do because
> > > > I reckon that the problem is that the smart git stuff is what's killing
> > > > the machine.
> > > 
> > > I'm sure that is the case.  However faulty hardware could still be the 
> > > root cause, but without the load from Git the machine might become 
> > > loaded lightly enough you might not see any ill effects before quite a 
> > > while.
> > 
> > When it's serving the next Fedora release (it's one of the official
> > mirrors) I'm sure any problems like that would become noticable - but
> > they haven't yet.  It purely seems to be something git is doing which
> > is killing the machine.
> 
> I think we've just found the issue causing httpd to die:
> 
> - Fedora systems set a limit at login time on the number of processes a
>   user can run - which is set to a soft limit of 1024.
> 
> - When someone logs in, their shell inherits this soft rlimit.  This
>   gets inherited by all sub-processes, including through a su to their
>   root shell.
> 
> - When they restart httpd, httpd also inherits this limit.
> 
> - httpd's own internal limits are set to a max clients of 1024.
> 
> The problem comes when httpd hits 1024 processes - as it forks as root,
> this succeeds (root is not subjected to this rlimit), and then a
> subsequent setuid() fails with -EAGAIN, causing httpd to experience a
> fatal error.
> 
> Obviously, this is not a good combination of things to happen.  It's
> also completely unnoticable to anyone who restarts apache.

Nasty.

> So, I've 'fixed' it by raising the rlimit in the httpd startup scripts,
> which should keep it fixed whenever anyone else restarts httpd.
> 
> The problem should be solved, and as such I've re-enabled access to
> the git tree.

OK, let's hope things will hold up.

I suspect this might not be correlated to the memory exhaustion ZenIV 
experienced in the past though.  That might require another kind of 
solution if that comes again.


Nicolas

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab1BMBWh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 20:22:37 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:43477 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250Ab1BMBWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 20:22:31 -0500
Date: Sat, 12 Feb 2011 20:22:27 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Florian Weimer <fw@deneb.enyo.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, martin capitanio <m@capitanio.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: mmap, the language go, problems with the linux kernel
Message-ID: <20110213012227.GC2598@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Florian Weimer <fw@deneb.enyo.de>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	martin capitanio <m@capitanio.org>, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org
References: <1297168678.2190.21.camel@marvin>
 <20110208132657.1cf55782@lxorguk.ukuu.org.uk>
 <87sjvtba3u.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sjvtba3u.fsf@mid.deneb.enyo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 12, 2011 at 03:28:37PM +0100, Florian Weimer wrote:
> * Alan Cox:
> 
> > Linux implements virtual address space limits, and enforces them. The go
> > language stuff wants to allocate huge amounts of virtual space so you
> > need to tell the OS you want to allow it to do crazy stuff, which you can
> > do so. But virtual address space is not free - it has to be tracked and
> > if the application suddenely tries to fill all of it what will happen ?
> >
> > You'll hit problems if the kernel is running with vm overcommit disabled
> > (as well configured servers do),
> 
> The odd thing is that prot==0 does *not* count against the
> vm.overcommit_memory=2 limit, only against ulimit -v.  The limit is
> only enforced for the parts on which mprotect is called.  I think this
> should really be part of the public API (I'm not sure if it is right
> now, it could well be an accident), to avoid the problems you
> describe.

The overcommit_memory logic does not include any pages which are
mapped read-only.  Technically that's not quite enough --- in theory
you could have a debugging attach to every single read-only text page
and set breakpoints on every single page.  Digital's OSF/1 operating
system went to such lengths, which meant that you if you were running
(say) an FTP server where you might have hundreds of connections at
the same time, you would need to have enough swap space for every
single ftpd's text page as if they had been modified --- even though
in practice that never happened.

So it's not just prot==0 pages which are not counted; read-only pages
are not counted, either.  This probably falls in the category of
"implementation detail", though.  If and when we start having
instances where huge number of breakpoints of userspace kprobes get
set (say, if Systemtap actually gets wide use and the userspace probes
patch actually makes it into mainline), we might have to change the
details of how we deal with the accounting.  I'm not sure it's worth
it to specify in great detail how things are done at this point, since
in the future it's possible that we might want to change them.

       	      	   	    	    	       - Ted

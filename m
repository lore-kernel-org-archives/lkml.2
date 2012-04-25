Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759060Ab2DYMut (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 08:50:49 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39082 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580Ab2DYMur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 08:50:47 -0400
Date: Wed, 25 Apr 2012 13:50:42 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Roland McGrath <roland@hack.frob.com>
Subject: Re: [RFC] TIF_NOTIFY_RESUME, arch/*/*/*signal*.c and all such
Message-ID: <20120425125042.GF6871@ZenIV.linux.org.uk>
References: <20120420080914.GF6871@ZenIV.linux.org.uk>
 <CA+55aFxia+u3VAf0qN-2wv7DyAQZK-Z8=n=cqUvo--+C905aFg@mail.gmail.com>
 <20120420160848.GG6871@ZenIV.linux.org.uk>
 <20120420164239.GH6871@ZenIV.linux.org.uk>
 <CA+55aFzuTspDyyLaOA-g-dTWydaUeeWo9uVGR+rZ=ZJzPW_Ocw@mail.gmail.com>
 <20120420180748.GI6871@ZenIV.linux.org.uk>
 <20120423180150.GA6871@ZenIV.linux.org.uk>
 <20120424072617.GB6871@ZenIV.linux.org.uk>
 <20120425030659.GE6871@ZenIV.linux.org.uk>
 <20120425123746.GA15560@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120425123746.GA15560@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 02:37:46PM +0200, Oleg Nesterov wrote:
> As for sys_sigsuspend() and this race in particular:
> 
> > Arrival of a signal that has userland handler
> > and that isn't blocked by the mask given to sigsuspend() should terminate
> > sigsuspend().
> 
> Yes. But note that do_signal() restores the old sigmask. This means that
> the signal we get after the first do_signal() was not blocked before
> sigsuspend() was called. So, to some extent, we can pretend that the
> handler was executed before sigsuspend() and it was never restarted.

Signal might have already arrived by the time we restore sigmask.  So no,
it might have been blocked prior to sigsuspend().

I agree that relying on disabled interrupts doesn't work - objection would
have worked if it was just "what if we get NEED_RESCHED and while we are
scheduled away a signal arrives", but this scenario doesn't depend on
that.  We definitely want interrupts enabled before we start playing with
do_notify_resume(), especially if things like deferred fput, etc. end up
there as well.

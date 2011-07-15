Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751617Ab1GOVjv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 17:39:51 -0400
Received: from smtp-out.google.com ([74.125.121.67]:24857 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab1GOVjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 17:39:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:sender:date:from:to:cc:subject:message-id:
	references:mime-version:content-type:content-disposition:in-reply-to:
	x-operating-system:user-agent:x-system-of-record;
	b=TUZsCLaukfaVK+hIwQFihz37eTnUWCkyrWiW4KYUIib240RxcWzdrP+UsnHEz+3iO
	bLejv5gPuDecDNYLsSGUQ==
Date: Fri, 15 Jul 2011 14:39:27 -0700
From: Mandeep Singh Baines <msb@chromium.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Mandeep Singh Baines <msb@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>, Andi Kleen <ak@linux.intel.com>,
        Hugh Dickins <hughd@google.com>, Olaf Hering <olaf@aepfle.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] panic, vt: do not force oops output when panic_timeout
 < 0
Message-ID: <20110715213927.GD17254@google.com>
References: <1308612129-12488-1-git-send-email-msb@chromium.org>
 <1308612129-12488-2-git-send-email-msb@chromium.org>
 <20110622223039.GA13916@google.com>
 <20110707085341.200a3c2b@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110707085341.200a3c2b@lxorguk.ukuu.org.uk>
X-Operating-System: Linux/2.6.32-gg426-generic (x86_64)
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
> > a serial port. When I disabled the serial out, my machine started to
> > get wedged on a panic. I guess screen_unblank was in bust_spinlocks
> > for a reason. It probably bust some spin_locks somewhere.
> 
> No something else is wrong here. The console panic should be reliably
> breaking the locks but a quick test of taking the console lock and BUG()
> on a current kernel shows something has broken this.
> 

Root caused to the issue I reported earlier with unblank_screen:

http://lkml.org/lkml/2011/6/20/394

console_unblank()
  -> c_unblank()
    -> unblank_screen()
      -> ...
        -> mutex_lock()

> > Below is a replacement for this patch which calls screen_unblank but
> > does not force output when the panic timeout is negative (no wait).
> 
> The on screen console is not always just a vt, and some people log remote
> management console output so we really really don't want to do this.
> 

In this patch, I'm disabling the functionality enabled by
vc->vc_panic_force_write if panic_timeout < 0 (i.e. no timeout).
vc_panic_force_write is only enabled for fb video consoles if the
FBINFO_CAN_FORCE_OUTPUT flag is set.

For our application, we're using ram_oops to preserved the panic in memory.
We want to reliably, and as fast as possible, machine_restart. The
vc_panic_force_write flag results in a bunch of graphics driver code to be
invoked which slows down restart and decreases reliability. Since we're
already storing the panic in RAM and are going to reboot immediately, there
is no benefit in mode switching back to the vc in order to display the panic
output. The log buffer will get flushed by the console_unblank() call so
remote management consoles should see all output.

> Instead the bug in the lock busting needs fixing. To start with it will
> be hiding a ton of other oopses/bugs as hangs.
> 
> Alan

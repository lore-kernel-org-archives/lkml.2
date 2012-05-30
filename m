Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128Ab2E3Ux0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 16:53:26 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48589 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab2E3UxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 16:53:25 -0400
Date: Wed, 30 May 2012 21:53:20 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Eric Paris <eparis@parisplace.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mimi Zohar <zohar@us.ibm.com>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: fix IMA lockdep circular locking dependency
Message-ID: <20120530205320.GX11775@ZenIV.linux.org.uk>
References: <CA+55aFzOtY7tBw4YNH+QX+6L4opMsJ=sN4DfJURMv_yBTWqL1w@mail.gmail.com>
 <20120516004251.GO22082@ZenIV.linux.org.uk>
 <CA+55aFy0wJdq+-OAkUBsrkQogF5-N0P4DBQ+6-LXjBGscRQFNw@mail.gmail.com>
 <20120516021828.GP22082@ZenIV.linux.org.uk>
 <1337807899.15138.31.camel@falcor>
 <20120530043443.GA3200@ZenIV.linux.org.uk>
 <20120530163605.GV11775@ZenIV.linux.org.uk>
 <1338406967.2257.24.camel@localhost>
 <20120530202427.GW11775@ZenIV.linux.org.uk>
 <1338410016.2659.6.camel@falcor.watson.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338410016.2659.6.camel@falcor.watson.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 04:33:36PM -0400, Mimi Zohar wrote:
> On Wed, 2012-05-30 at 21:24 +0100, Al Viro wrote:
> > On Wed, May 30, 2012 at 03:42:47PM -0400, Eric Paris wrote:
> > > security_file_mmap() would pretty much only be used in do_mmap_pgoff()
> > > (or validate_mmap_request)
> > 
> > Callers, actually - the whole point is to lift it out of under ->mmap_sem.
> > The tricky part is reqprot vs. prot mess.
> 
> Linus already addressed it in the original patch, which I split into two
> as you suggested:
> 733559f - "security: move security_file_mmap() and rename to security_mmap_file()" 
> b3649e9 security: define and use the new security_mmap_addr() hook

Ehh...

* elf_map() should just be using vm_map/vm_unmap (see vfs.git#for-next)
* that goto out; in sys_mmap_pgooff() is an instant leak - you miss
fput() that way
* again, prot handling for !MMU case differs from MMU one.  Sure, we
can duplicate both, but it's getting seriously ugly ;-/
* while we are at it, checking address in validate_mmap_request() is
really odd, seeing that we have the only call to validate_mmap_request()
followed by
        /* we ignore the address hint */
        addr = 0;
        len = PAGE_ALIGN(len);

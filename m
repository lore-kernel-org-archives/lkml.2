Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab2E3UYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 16:24:44 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37253 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab2E3UYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 16:24:41 -0400
Date: Wed, 30 May 2012 21:24:27 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Eric Paris <eparis@parisplace.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mimi Zohar <zohar@us.ibm.com>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: fix IMA lockdep circular locking dependency
Message-ID: <20120530202427.GW11775@ZenIV.linux.org.uk>
References: <1337112446.20904.50.camel@falcor>
 <CA+55aFxRRuWGD-4LYzO-T8eg22goKpej5AV36ALL8GaLP56oRA@mail.gmail.com>
 <CA+55aFzOtY7tBw4YNH+QX+6L4opMsJ=sN4DfJURMv_yBTWqL1w@mail.gmail.com>
 <20120516004251.GO22082@ZenIV.linux.org.uk>
 <CA+55aFy0wJdq+-OAkUBsrkQogF5-N0P4DBQ+6-LXjBGscRQFNw@mail.gmail.com>
 <20120516021828.GP22082@ZenIV.linux.org.uk>
 <1337807899.15138.31.camel@falcor>
 <20120530043443.GA3200@ZenIV.linux.org.uk>
 <20120530163605.GV11775@ZenIV.linux.org.uk>
 <1338406967.2257.24.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338406967.2257.24.camel@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 03:42:47PM -0400, Eric Paris wrote:
> security_file_mmap() would pretty much only be used in do_mmap_pgoff()
> (or validate_mmap_request)

Callers, actually - the whole point is to lift it out of under ->mmap_sem.
The tricky part is reqprot vs. prot mess.

In all cases, we need current to be READ_IMPLIES_EXEC and prot to contain
PROT_READ for any changes to happen.  Assuming that both conditions are
met, we have the following:
file == NULL:
	add PROT_EXEC in !MMU case, don't do that for MMU.
file != NULL, lives on fs mounted noexec: don't modify prot
file != NULL, lives on fs mounted without noexec:
	MMU - add PROT_EXEC; !MMU - add it only if we have BDI_CAP_EXEC_MAP on
that file.

AFAICS, the least painful way of dealing with that would be to have
something like
mangle_prot(struct file *file, unsigned long *prot, unsigned long flags)

that would handle that logics and call security_file_mmap().  With separate
instances in MMU and !MMU cases ;-/  However, there's an extra fun in there -
consider fs/aio.c caller of do_mmap().  For MMU case we don't really care.
But what about !MMU?  Should that guy get PROT_EXEC slapped on it?

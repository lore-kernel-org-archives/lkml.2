Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684Ab2JKJBJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 05:01:09 -0400
Received: from ozlabs.org ([203.10.76.45]:57066 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777Ab2JKJBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 05:01:05 -0400
Date: Thu, 11 Oct 2012 20:00:23 +1100
From: Paul Mackerras <paulus@samba.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arch@vger.kernel.org, David Miller <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC][CFT][CFReview] execve and kernel_thread unification work
Message-ID: <20121011090023.GA28427@bloggs.ozlabs.ibm.com>
References: <20121001213809.GA31155@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121001213809.GA31155@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just looked through the "powerpc: split ret_from_fork" commit in
your for-next branch, and I have a couple of comments.

First, on 64-bit powerpc, if kernel_thread() is called on a function
in a module, and that function returns, we'll then jump to do_exit
with r2 pointing to the module's TOC rather than the main kernel's
TOC, with disastrous results.  It would be easily solved by adding a

	ld	r2,PACATOC(r13)

before the branch to .do_exit in the 64-bit ret_from_kernel_thread().
Maybe no-one ever calls kernel_thread() on a function in a module
today, but I don't want to rely on that being true forever, especially
since it's only one more instruction to guard against the possibility.

Secondly, while the code as you have it is correct, to my mind it
would be cleaner to put the function descriptor address in r14 on
64-bit, rather than the function text address, and then dereference it
to get the TOC and text address at the point of doing the call.  That
would reduce the differences between 32-bit and 64-bit in
copy_thread() and make it more obvious that ret_from_kernel_thread()
is setting the right TOC value in r2.

In fact copy_thread() doesn't need to set r2 in the 32-bit case, since
_switch() sets r2 to the task_struct for the task it's switching to,
and ignores the r2 value in the stack frame.  So with my suggestion
copy_thread() wouldn't need to set childregs->gpr[2] at all (for the
kernel thread case).

Paul.

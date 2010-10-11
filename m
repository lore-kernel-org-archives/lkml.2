Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723Ab0JKWCe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 18:02:34 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48891 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756470Ab0JKWCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 18:02:32 -0400
Date: Mon, 11 Oct 2010 23:02:24 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Thorsten Glaser <tg@mirbsd.de>, linux-kernel@vger.kernel.org,
        linux-m68k@vger.kernel.org
Subject: Re: aranym bug, manifests as "ida_remove called for id=13" on recent
 kernels
Message-ID: <20101011220224.GM19804@ZenIV.linux.org.uk>
References: <20101010144952.GF19804@ZenIV.linux.org.uk>
 <AANLkTinuA3AzMoJ82pvCuhmo59DZxL2F1j3xhXUkjj7z@mail.gmail.com>
 <20101010235256.GG19804@ZenIV.linux.org.uk>
 <20101011024103.GH19804@ZenIV.linux.org.uk>
 <20101011043632.GA2566@cynthia.pants.nu>
 <20101011044808.GI19804@ZenIV.linux.org.uk>
 <Pine.BSM.4.64L.1010111218040.23471@herc.mirbsd.org>
 <20101011133545.GJ19804@ZenIV.linux.org.uk>
 <m3wrpo24u0.fsf@hase.home>
 <20101011142428.GK19804@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101011142428.GK19804@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 11, 2010 at 03:24:28PM +0100, Al Viro wrote:

> BTW, any comments on signal patchset?  Seems to work here, including the
> stack expansion fixes, but that's on aranym.  I'll try to resurrect the
> real hardware, but that may take a while.  If somebody could give it a beating
> in the meanwhile...

Oh, lovely...  One more signal bug (and a lot more on m68knommu): if we
strace a process and signal is delivered during pagefault handling, you'll
lose the second call of syscall_trace() on sigreturn().  If the signal
is delivered during a syscall or during an interrupt, syscall_trace() is
called twice on sigreturn() (as it does on all platforms).  Fortunately,
that's easy to fix - same as on alpha (calling syscall_trace in ret_from_signal
if we are getting traced, just before doing RESTORE_SWITCH_STACK).  Will test
and post...

FWIW, on other targets we either have sys_{rt,}_sigreturn() done as normal
functons (in which case the normal logics will take care of that), or
have them return to place in (common) syscall exit path earlier than
conditional call of syscall trace (mips, score), or check flags and do
call ourselves (sparc, alpha since it had been fixed).  AFAICS, m68k and
m68knommu are the only ones buggered that way.  On alpha we used to have
it even worse - there we did only one call on sigreturn() unconditionally...

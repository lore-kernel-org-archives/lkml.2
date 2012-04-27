Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211Ab2D0XPc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 19:15:32 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33450 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab2D0XPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 19:15:30 -0400
Date: Sat, 28 Apr 2012 00:15:26 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Roland McGrath <roland@hack.frob.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] TIF_NOTIFY_RESUME, arch/*/*/*signal*.c and all such
Message-ID: <20120427231526.GP6871@ZenIV.linux.org.uk>
References: <20120420180748.GI6871@ZenIV.linux.org.uk>
 <20120423180150.GA6871@ZenIV.linux.org.uk>
 <20120424072617.GB6871@ZenIV.linux.org.uk>
 <20120426183742.GA324@redhat.com>
 <20120426231942.GJ6871@ZenIV.linux.org.uk>
 <20120427172444.GA30267@redhat.com>
 <20120427184528.GL6871@ZenIV.linux.org.uk>
 <20120427202002.8ED632C0BF@topped-with-meat.com>
 <20120427211244.GO6871@ZenIV.linux.org.uk>
 <20120427212729.652542C0AF@topped-with-meat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120427212729.652542C0AF@topped-with-meat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 02:27:29PM -0700, Roland McGrath wrote:
> The expectation was that every arch would eventually switch on
> CORE_DUMP_USE_REGSET.  (Looks like so far 12 do and so ~16 don't.)
> Certainly avoiding the overhead of user_regset for core dumping is not
> worth any new code complexity or extra arch hooks, since that overhead
> even on the worst-case arch (ia64) has got to be marginal in comparison
> to all the memory-copying and i/o going on.  For imagined potential
> tracing/fancier-debugging cases that might be used in high-throughput
> ways the question would be different, but such uses still remain to be
> implemented.

BTW, speaking of tracehook - you do realize that there are some
architectures where check for user_mode() in do_signal() is not
useless?  I.e. there do_notify_resume() _can_ be called when
returning to kernel mode.  And that'll get you tracehook_notify_resume()
called when you probably wouldn't want it to be; key_replace_session_keyring()
call is not desirable in that situation and the stuff Oleg wants
to add in tracehook_notify_resume() won't be happy with that either...

I think all such architectures need that check lifted to do_notify_resume()
(and the rest needs it killed, of course).  Including x86, by the look
of it - we _probably_ can't get there with TIF_NOTIFY_RESUME and
!user_mode(regs), but I'm not entirely sure of that.  arm is in about the
same situation; alpha, ppc{32,64}, sparc{32,64} and m68k really can't get
there like that (they all check it in the asm glue).  mips probably might,
unless I'm misreading their ret_from_fork()...  Fun.

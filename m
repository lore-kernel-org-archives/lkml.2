Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582Ab2D2S0B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 14:26:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864Ab2D2SZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 14:25:59 -0400
Date: Sun, 29 Apr 2012 20:25:10 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Roland McGrath <roland@hack.frob.com>
Subject: Re: [RFC] TIF_NOTIFY_RESUME, arch/*/*/*signal*.c and all such
Message-ID: <20120429182510.GA23107@redhat.com>
References: <CA+55aFzuTspDyyLaOA-g-dTWydaUeeWo9uVGR+rZ=ZJzPW_Ocw@mail.gmail.com> <20120420180748.GI6871@ZenIV.linux.org.uk> <20120423180150.GA6871@ZenIV.linux.org.uk> <20120424072617.GB6871@ZenIV.linux.org.uk> <20120426183742.GA324@redhat.com> <20120426231942.GJ6871@ZenIV.linux.org.uk> <20120427172444.GA30267@redhat.com> <20120427184528.GL6871@ZenIV.linux.org.uk> <20120429164155.GC15792@redhat.com> <20120429180926.GA6871@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120429180926.GA6871@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29, Al Viro wrote:
>
> On Sun, Apr 29, 2012 at 06:41:55PM +0200, Oleg Nesterov wrote:
> >
> > Besides, at least on x86 tracehook_signal_handler's logic is not exactly
> > right and should be fixed.
>
> Details, please...

See http://marc.info/?t=127550678000005 and
https://bugzilla.kernel.org/show_bug.cgi?id=16061

	- the tracee reports a signal SIG

	- the tracer does ptrace(SINGLESTEP, SIG), this approves the signal
	  and also sets TF

	- the tracee dequeues the signal, changes its IP to sig_handler().

	  then it notices TIF_SINGLESTEP and notifies the tracer without
	  return to user-space _and_ without clearing TF or TIF_SINGLESTEP

	- the tracer does ptrace(SINGLESTEP) again, but now enable_single_step()
	  looses TIF_FORCED_TF.

	- the tracer does ptrace(CONT), but user_disable_single_step() doesn't
	  clear TF since TIF_FORCED_TF is not set

	- the tracee returns to user-space with X86_EFLAGS_TF in eflags

Somehow we forgot about this bug...

Oleg.


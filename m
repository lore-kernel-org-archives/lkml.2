Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab2KJS7I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 13:59:08 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:46254 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab2KJS7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 13:59:06 -0500
Date: Sat, 10 Nov 2012 18:59:03 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Michel Lespinasse <walken@google.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>
Subject: Re: Issues with "x86, um: switch to generic fork/vfork/clone" commit
Message-ID: <20121110185903.GQ2616@ZenIV.linux.org.uk>
References: <CANN689FmsFBjfiD8V-nQyDh+GtTF5B3SDUcuXc=3OeeN6JW0kw@mail.gmail.com>
 <20121110045104.GN2616@ZenIV.linux.org.uk>
 <CANN689GetguA+1bqKXC=Cq0SLcLqaqLsn5XGBZYVbWeBogX+zA@mail.gmail.com>
 <20121110053334.GO2616@ZenIV.linux.org.uk>
 <CANN689G+j0VS5JcFDx08XexZmqZ95YUPMVRd+3ji=8Fr3Q2R=Q@mail.gmail.com>
 <20121110073338.GP2616@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121110073338.GP2616@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 10, 2012 at 07:33:39AM +0000, Al Viro wrote:
> I think I see what's going on there.  It's PTREGSCALL blindly used for
> clone wrapper in ia32entry.S.  FWIW, it's wrong for all of those
> suckers, anyway:
> 	* fork/clone/vfork need to save extra registers, but don't need
> to restore them; after unification we don't need pt_regs argument for any
> of those - for fork/vfork it's useless, for clone it breaks things.
> 	* execve doesn't need pt_regs argument; harmless, but useless.
> 	* for sigaltstack() we simply need to get rid of stupid pt_regs
> argument, along with the wrapper; current_pt_regs()->sp is all it needs.
> 	* for sigreturn/rt_sigreturn we need to restore extra registers,
> but we do *not* need to save them; just leave the space on stack.  And
> no need to pass pt_regs either - it'll be current_pt_regs() anyway.
> 	* iopl() doesn't need to save/restore extras and it doesn't need
> pt_regs argument - it's going to be current_pt_regs().

Alas, sigaltack() and iopl() do need a bit of a wrapper; they don't care
about extras, but they wants ->sp and ->flags resp., which means needing
to go through FIXUP_TOP_OF_STACK on amd64 ;-/

> On top of all that, there's an extra piece of crap - different order of
> arguments for native and compat clone.

... and the same commit slightly buggers clone(2) on amd64 as well.  Grr...
Anyway, fixed and pushed; please, test for-next when it propagates, head
should be at fae45353de587ae6a949dbf21ee06d5dd652248c

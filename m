Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759020Ab1JFSjG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 14:39:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18872 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758926Ab1JFSjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 14:39:03 -0400
Date: Thu, 6 Oct 2011 14:38:41 -0400
From: Jason Baron <jbaron@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        peterz@infradead.org, rth@redhat.com
Subject: Re: [PATCH RFC V2 3/5] jump_label: if a key has already been
 initialized, don't nop it out
Message-ID: <20111006183841.GC2505@redhat.com>
References: <20111003150205.GB2462@redhat.com>
 <4E89E28C.7010700@goop.org>
 <20111004141011.GA2520@redhat.com>
 <4E8B3489.60902@zytor.com>
 <4E8CF348.4080405@goop.org>
 <4E8CF385.2080804@zytor.com>
 <4E8DEB19.1050509@goop.org>
 <20111006181055.GA2505@redhat.com>
 <1317925615.4729.14.camel@gandalf.stny.rr.com>
 <4E8DF385.3070009@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E8DF385.3070009@zytor.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 06, 2011 at 11:29:25AM -0700, H. Peter Anvin wrote:
> On 10/06/2011 11:26 AM, Steven Rostedt wrote:
> > On Thu, 2011-10-06 at 14:10 -0400, Jason Baron wrote:
> > 
> >>> Looks like jmp2 is about 5% faster than jmp5 on Sandybridge with this
> >>> benchmark.
> >>>
> >>> But insignificant difference on Nehalem.
> >>>
> >>>     J
> >>
> >> It would be cool if we could make the total width 2-bytes, when
> >> possible.  It might be possible by making the initial 'JUMP_LABEL_INITIAL_NOP'
> >> as a 'jmp' to the 'l_yes' label. And then patching that with a no-op at boot
> >> time or link time - letting the compiler pick the width. In that way we could
> >> get the optimal width...
> > 
> > Why not just do it?
> > 
> > jump_label is encapsulated in arch_static_branch() which on x86 looks
> > like:
> > 
> > static __always_inline bool arch_static_branch(struct jump_label_key *key)
> > {
> > 	asm goto("1:"
> > 		JUMP_LABEL_INITIAL_NOP
> > 		".pushsection __jump_table,  \"aw\" \n\t"
> > 		_ASM_ALIGN "\n\t"
> > 		_ASM_PTR "1b, %l[l_yes], %c0 \n\t"
> > 		".popsection \n\t"
> > 		: :  "i" (key) : : l_yes);
> > 	return false;
> > l_yes:
> > 	return true;
> > }
> > 
> > 
> > That jmp to l_yes should easily be a two byte jump.

remember the compiler is moving the l_yes out of line, so its not
necessarily always a two byte jump. Also, I plan to look at a possible
'cold' label for the 'l_yes' branch, so that it can moved to a separate
'cold' section, but we might only want that for some cases...

> > 
> > If not I'm sure it would be easy to catch it before modifying the code.
> > And then complain real loudly about it.
> > 
> 
> The important thing is that it requires the build-time elimination of
> jumps.  It's just work.
> 
> 	-hpa
> 

Right, its certainly doable, but I'm not sure its so simple, since we'll
need a pass to eliminate the jumps - which can be keyed off the
'__jump_table' section. 

thanks,

-Jason

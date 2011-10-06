Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759191Ab1JFUeV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 16:34:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31335 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757235Ab1JFUeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 16:34:20 -0400
Date: Thu, 6 Oct 2011 16:33:58 -0400
From: Jason Baron <jbaron@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
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
Message-ID: <20111006203358.GA5985@redhat.com>
References: <20111004141011.GA2520@redhat.com>
 <4E8B3489.60902@zytor.com>
 <4E8CF348.4080405@goop.org>
 <4E8CF385.2080804@zytor.com>
 <4E8DEB19.1050509@goop.org>
 <20111006181055.GA2505@redhat.com>
 <1317925615.4729.14.camel@gandalf.stny.rr.com>
 <4E8DF385.3070009@zytor.com>
 <20111006183841.GC2505@redhat.com>
 <1317929656.4729.22.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317929656.4729.22.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 06, 2011 at 03:34:13PM -0400, Steven Rostedt wrote:
> On Thu, 2011-10-06 at 14:38 -0400, Jason Baron wrote:
> 
> > Right, its certainly doable, but I'm not sure its so simple, since we'll
> > need a pass to eliminate the jumps - which can be keyed off the
> > '__jump_table' section. 
> 
> Look at the code of scripts/recordmcount.c and friends.
> 
> It does two things.
> 
> 1) find all the callers of mcount and make a section for it.
> 
> 2) For those callers of mcount that is in sections that are not
> whitelisted, and therefor will not be patched, to replace the call to
> mcount with a nop.
> 
> 
> We can use this code, or a copy of it, to do the same with jump_label.
> Have the x86 jump_label be:
> 
> 
> static __always_inline bool arch_static_branch(struct jump_label_key
> *key)
> {
> 	asm goto("1:"
> 		"jmp l_yes\n"
> 		".pushsection __jump_table,  \"aw\" \n\t"
> 		_ASM_ALIGN "\n\t"
> 		_ASM_PTR "1b, %l[l_yes], %c0 \n\t"
> 		".popsection \n\t"
> 		: :  "i" (key) : : l_yes);
> 	return false;
> l_yes:
> 	return true;
> }
> 
> Then have the record_jumplabel.c (or whatever it's called) find all the
> jmps at run time, and convert them into the appropriate nop.
> 

I'd prefer to do this at build-time as hpa said. We don't want there to
be some race b/w patching in the no-ops and taking an incorrect branch.

> Then at runtime patching, the jumplabel code could figure out what size
> jump it needs to replace it.
> 
> -- Steve
> 
> 

sounds like a good plan. thanks for the pointers!

-Jason

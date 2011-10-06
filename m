Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965313Ab1JFSuo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 14:50:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965275Ab1JFSum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 14:50:42 -0400
Message-ID: <4E8DF870.6010000@redhat.com>
Date: Thu, 06 Oct 2011 11:50:24 -0700
From: Richard Henderson <rth@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Jason Baron <jbaron@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        peterz@infradead.org
Subject: Re: [PATCH RFC V2 3/5] jump_label: if a key has already been initialized,
 don't nop it out
References: <cover.1317506051.git.jeremy.fitzhardinge@citrix.com>  <477dead9647029012f93c651f2892ed0e86b89e7.1317506051.git.jeremy.fitzhardinge@citrix.com>  <20111003150205.GB2462@redhat.com> <4E89E28C.7010700@goop.org>  <20111004141011.GA2520@redhat.com> <4E8B3489.60902@zytor.com>  <4E8CF348.4080405@goop.org> <4E8CF385.2080804@zytor.com>  <4E8DEB19.1050509@goop.org> <20111006181055.GA2505@redhat.com> <1317925615.4729.14.camel@gandalf.stny.rr.com>
In-Reply-To: <1317925615.4729.14.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2011 11:26 AM, Steven Rostedt wrote:
> On Thu, 2011-10-06 at 14:10 -0400, Jason Baron wrote:
> 
>>> Looks like jmp2 is about 5% faster than jmp5 on Sandybridge with this
>>> benchmark.
>>>
>>> But insignificant difference on Nehalem.
>>>
>>>     J
>>
>> It would be cool if we could make the total width 2-bytes, when
>> possible.  It might be possible by making the initial 'JUMP_LABEL_INITIAL_NOP'
>> as a 'jmp' to the 'l_yes' label. And then patching that with a no-op at boot
>> time or link time - letting the compiler pick the width. In that way we could
>> get the optimal width...
> 
> Why not just do it?
> 
> jump_label is encapsulated in arch_static_branch() which on x86 looks
> like:
> 
> static __always_inline bool arch_static_branch(struct jump_label_key *key)
> {
> 	asm goto("1:"
> 		JUMP_LABEL_INITIAL_NOP
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
> 
> That jmp to l_yes should easily be a two byte jump.

Until the compiler decides to re-order the code.  That's the problem --
in the general case you do not know how far away the destination is really
going to be.

There are a couple of possibilities for improvement:

(1) Do as Jason suggests above and let the assembler figure out the size
of the branch that is needed.  Without adding more data to __jump_table,
you'll want to be extremely careful about checking the two pointers to 
see what size branch has been installed.

(2) Always reserve 5 bytes of space, but if the distance is small enough
patch in a 2-byte jump.  That doesn't help with the icache footprint.

(3) There is no 3.  I was going to say something clever about gas .ifne
conditionals, but a quick test revealed they don't work for forward
declarations.



r~


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758976Ab1JFSaU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 14:30:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51275 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965277Ab1JFS37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 14:29:59 -0400
Message-ID: <4E8DF385.3070009@zytor.com>
Date: Thu, 06 Oct 2011 11:29:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Jason Baron <jbaron@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        peterz@infradead.org, rth@redhat.com
Subject: Re: [PATCH RFC V2 3/5] jump_label: if a key has already been initialized,
 don't nop it out
References: <cover.1317506051.git.jeremy.fitzhardinge@citrix.com>  <477dead9647029012f93c651f2892ed0e86b89e7.1317506051.git.jeremy.fitzhardinge@citrix.com>  <20111003150205.GB2462@redhat.com> <4E89E28C.7010700@goop.org>  <20111004141011.GA2520@redhat.com> <4E8B3489.60902@zytor.com>  <4E8CF348.4080405@goop.org> <4E8CF385.2080804@zytor.com>  <4E8DEB19.1050509@goop.org> <20111006181055.GA2505@redhat.com> <1317925615.4729.14.camel@gandalf.stny.rr.com>
In-Reply-To: <1317925615.4729.14.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=UTF-8
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
> 
> If not I'm sure it would be easy to catch it before modifying the code.
> And then complain real loudly about it.
> 

The important thing is that it requires the build-time elimination of
jumps.  It's just work.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


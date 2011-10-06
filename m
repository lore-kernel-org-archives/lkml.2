Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759044Ab1JFTeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 15:34:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53451 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756795Ab1JFTeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 15:34:16 -0400
X-Authority-Analysis: v=1.1 cv=lfM0d0QHaVz67dfwwr9cyIw6NbaGR/pZhMD6XWNi0kk= c=1 sm=0 a=msyzJTVhAHgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=VKzB9fIMzP--0FXAUagA:9 a=yuKKYf7CDWY9T4GQFk8A:7 a=PUjeQqilurYA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [PATCH RFC V2 3/5] jump_label: if a key has already been
 initialized, don't nop it out
From: Steven Rostedt <rostedt@goodmis.org>
To: Jason Baron <jbaron@redhat.com>
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
Date: Thu, 06 Oct 2011 15:34:13 -0400
In-Reply-To: <20111006183841.GC2505@redhat.com>
References: <20111003150205.GB2462@redhat.com> <4E89E28C.7010700@goop.org>
	 <20111004141011.GA2520@redhat.com> <4E8B3489.60902@zytor.com>
	 <4E8CF348.4080405@goop.org> <4E8CF385.2080804@zytor.com>
	 <4E8DEB19.1050509@goop.org> <20111006181055.GA2505@redhat.com>
	 <1317925615.4729.14.camel@gandalf.stny.rr.com> <4E8DF385.3070009@zytor.com>
	 <20111006183841.GC2505@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1317929656.4729.22.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-06 at 14:38 -0400, Jason Baron wrote:

> Right, its certainly doable, but I'm not sure its so simple, since we'll
> need a pass to eliminate the jumps - which can be keyed off the
> '__jump_table' section. 

Look at the code of scripts/recordmcount.c and friends.

It does two things.

1) find all the callers of mcount and make a section for it.

2) For those callers of mcount that is in sections that are not
whitelisted, and therefor will not be patched, to replace the call to
mcount with a nop.


We can use this code, or a copy of it, to do the same with jump_label.
Have the x86 jump_label be:


static __always_inline bool arch_static_branch(struct jump_label_key
*key)
{
	asm goto("1:"
		"jmp l_yes\n"
		".pushsection __jump_table,  \"aw\" \n\t"
		_ASM_ALIGN "\n\t"
		_ASM_PTR "1b, %l[l_yes], %c0 \n\t"
		".popsection \n\t"
		: :  "i" (key) : : l_yes);
	return false;
l_yes:
	return true;
}

Then have the record_jumplabel.c (or whatever it's called) find all the
jmps at run time, and convert them into the appropriate nop.

Then at runtime patching, the jumplabel code could figure out what size
jump it needs to replace it.

-- Steve



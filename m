Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab0KXAKV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 19:10:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:56213 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690Ab0KXAKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 19:10:19 -0500
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=dloADZ4KP7gA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=3C5KqkU7oq1yFZnwMNQA:9 a=RIMNgDGKp6Q7h8AeEjcA:7 a=EyMPkj05_EB4Mr9a2ZUJdy-C-YsA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 0/3] jump label: updates for 2.6.37
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jason Baron <jbaron@redhat.com>, mingo@elte.hu, peterz@infradead.org,
        mathieu.desnoyers@polymtl.ca, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
In-Reply-To: <4CEC4EF3.4000304@zytor.com>
References: <cover.1290546539.git.jbaron@redhat.com>
	 <4CEC33F6.9090808@zytor.com>
	 <1290553914.30543.408.camel@gandalf.stny.rr.com>
	 <4CEC4EF3.4000304@zytor.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 23 Nov 2010 19:10:16 -0500
Message-ID: <1290557416.30543.420.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-23 at 15:32 -0800, H. Peter Anvin wrote:
> On 11/23/2010 03:11 PM, Steven Rostedt wrote:
> >> I would also like to see a change in the API, preferrably something
> >> closer to the "SWITCH_POINT" interface I discussed with Stephen before
> >> Kernel Summit.
> > 
> > Could you explain in more detail what you would like to see.
> 
> The JUMP_LABEL() macro is rather ugly, and I found from the
> static_cpu_has() work that inlines like (somewhat pseudocode here):
> 
> static inline bool SWITCH_POINT(void *metadata)
> {
> 	asm goto("1: <5 byte nop>\n"
> 	         ".section \".metadata\",\"a\"\n"
> 		 ".long 1b, %p0\n"
> 		 ".previous\n"
> 	         : : "i" (metadata)
> 		 : : l_yes);
> 	return false;
> l_yes:
> 	return true;
> }
> 
> ... work quite well; with the resulting SWITCH_POINT() being usable like
> any other boolean expression in the kernel, i.e. as part of if, while,
> etc.  Most of the time, gcc is smart enough to just use the flow of
> control provided, and it also permits backwards compatibility with older
> gcc by patching in a one-byte immediate instead.
> 
> There are some instances where it double-jumps; those can be avoided by
> always jumping (allowing the patch code to replace the jump with a
> 5-byte NOP opportunistically a posteori) but unfortunately current gcc
> tends to not order the sequentially next code afterwards if one does that.
> 

So you would rather have it as an if statement? Something like this:

	if (unlikely(JUMP_LABEL(key)))
		__DO_TRACE(....);

(Note, I like the above better too)

-- Steve



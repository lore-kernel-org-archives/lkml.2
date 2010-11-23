Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab0KWXeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 18:34:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55600 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754061Ab0KWXeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 18:34:20 -0500
Message-ID: <4CEC4EF3.4000304@zytor.com>
Date: Tue, 23 Nov 2010 15:32:03 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Thunderbird/3.1.6
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Jason Baron <jbaron@redhat.com>, mingo@elte.hu, peterz@infradead.org,
        mathieu.desnoyers@polymtl.ca, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] jump label: updates for 2.6.37
References: <cover.1290546539.git.jbaron@redhat.com>	 <4CEC33F6.9090808@zytor.com> <1290553914.30543.408.camel@gandalf.stny.rr.com>
In-Reply-To: <1290553914.30543.408.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2010 03:11 PM, Steven Rostedt wrote:
>> I would also like to see a change in the API, preferrably something
>> closer to the "SWITCH_POINT" interface I discussed with Stephen before
>> Kernel Summit.
> 
> Could you explain in more detail what you would like to see.

The JUMP_LABEL() macro is rather ugly, and I found from the
static_cpu_has() work that inlines like (somewhat pseudocode here):

static inline bool SWITCH_POINT(void *metadata)
{
	asm goto("1: <5 byte nop>\n"
	         ".section \".metadata\",\"a\"\n"
		 ".long 1b, %p0\n"
		 ".previous\n"
	         : : "i" (metadata)
		 : : l_yes);
	return false;
l_yes:
	return true;
}

... work quite well; with the resulting SWITCH_POINT() being usable like
any other boolean expression in the kernel, i.e. as part of if, while,
etc.  Most of the time, gcc is smart enough to just use the flow of
control provided, and it also permits backwards compatibility with older
gcc by patching in a one-byte immediate instead.

There are some instances where it double-jumps; those can be avoided by
always jumping (allowing the patch code to replace the jump with a
5-byte NOP opportunistically a posteori) but unfortunately current gcc
tends to not order the sequentially next code afterwards if one does that.

	-hpa

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304Ab2EHNE6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 09:04:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22458 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809Ab2EHNE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 09:04:57 -0400
X-Authority-Analysis: v=2.0 cv=OMylLFmB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=QVz34xbDK3MA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=CjxXgO3LAAAA:8 a=4cKv_Weqv5ZKf3A5wTAA:9 a=KWWT3aF88Er1eI_m_FkA:7 a=PUjeQqilurYA:10 a=Efwj4qSePvMA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1336482295.14207.172.camel@gandalf.stny.rr.com>
Subject: Re: Re: Re: [PATCH 6/9][RFC] kprobes: Allow probe on ftrace
 reserved text (but move it)
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, yrl.pp-manager.tt@hitachi.com
Date: Tue, 08 May 2012 09:04:55 -0400
In-Reply-To: <4FA88E1B.1020708@hitachi.com>
References: <20120502192418.024103772@goodmis.org>
	   <20120502193237.321234712@goodmis.org> <y0mhavyl3kg.fsf@fche.csb>
	  <1336002032.14207.52.camel@gandalf.stny.rr.com>
	  <4FA7B410.1000804@hitachi.com>
	 <1336394603.14207.117.camel@gandalf.stny.rr.com>
	 <4FA88E1B.1020708@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-08 at 12:08 +0900, Masami Hiramatsu wrote:
> (2012/05/07 21:43), Steven Rostedt wrote:
> > On Mon, 2012-05-07 at 20:37 +0900, Masami Hiramatsu wrote:
> > 
> >> By the way, there is another way to do that transparently which
> >> we add a "real_addr" member to struct kprobes and put the real
> >> probed address to the member (without changing kp->addr). This
> >> will keep API compatibility.
> > 
> > I like this a lot. Perhaps we don't need a flag at all, and just use
> > these two addrs instead?
> 
> Yes, just replacing all "*p->addr" and "kp.addr" with real_addr
> and copying addr to real_addr when registering. That's the basic
> idea.
> 
> I just concern about the cost balance... this is feasible, but
> we need to change many arch-dependent parts. Do we really need to
> pay that cost just for the backward compatibility?
> 
> I mean, the kprobes itself can be changed because we don't ensure
> the stability of kernel APIs. If so, it looks enough to change the
> behavior of kprobes and give an upgrade hint for users (current patch),
> isn't it?
> 
> Thank you,

I guess the question is what's best long term. That's what I would like
to do. If a flag is "good enough" for both now and long term, than
that's fine with me. But if we find that it would be better to have a
"real_addr" then we should do it now and bite the bullet with all archs.

Otherwise, we'll have all the archs doing something special with the
MOVE flag and that would cause even more pain to update it later.

I also like the real addr because it helps with the optimize probes. We
only need to search one location. This doesn't matter with this patch
set, but with the code I have that uses ftrace hooks. One solution with
that is to have the optimize code see that the probe was moved, (or its
real addr was on a ftrace nop) and then just use the ftrace code on
optimization instead of normal optimizations (replacing with a jump).

Note, the big difference with using ftrace optimization and normal
kprobe jump optimization is that the ftrace one can be used on a preempt
kernel. But this code is still under development. I want to get a
solution for the current code (this patch set) now. It would be nice if
it was ready for 3.5.


-- Steve



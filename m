Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab1ARRbC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 12:31:02 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63243 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab1ARRbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 12:31:00 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=44vUGAvzfu8A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=z535ck_rp2hYom-GMYUA:9 a=xnCV3-hW4E0lKxRtkqYA:7 a=PPYM95O3msjrbAkCPW0uIGdYK0oA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: Bug#609371: linux-image-2.6.37-trunk-sparc64: module scsi_mod:
 Unknown relocation: 36
From: Steven Rostedt <rostedt@goodmis.org>
To: David Miller <davem@davemloft.net>
Cc: richm@oldelvet.org.uk, 609371@bugs.debian.org, ben@decadent.org.uk,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@redhat.com, Jesper.Nilsson@axis.com,
        jeffm@suse.com, mathieu.desnoyers@efficios.com
In-Reply-To: <20110117.223513.183031917.davem@davemloft.net>
References: <20110116.220755.179947617.davem@davemloft.net>
	 <1295259761.32152.20.camel@duncow>
	 <1295273741.16479.19.camel@gandalf.stny.rr.com>
	 <20110117.223513.183031917.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 18 Jan 2011 12:30:56 -0500
Message-ID: <1295371856.12215.29.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-17 at 22:35 -0800, David Miller wrote:
> From: Steven Rostedt <rostedt@goodmis.org>
> Date: Mon, 17 Jan 2011 09:15:41 -0500
> 
> > Again, this is to help the linker keep arrays in tacked. Tracepoints are
> > allocated into the tracepoint section, and then read like an array. If
> > the linker adds holes as it links sections into one big one, then the
> > reading of the array breaks.
> > 
> > We either need to compact it (with the align(4)) which is undesirable,
> > or add our own holes like the above does.
> 
> Just take away all of the align directives, it should just work.

If that was the case, we would have never added it :-)

> 
> If it doesn't, then we should investigate to find out the real reason
> why.

OK, we can remove it and I can see what breaks.

> 
> The linker has no reason to add holes, and in fact if we are to believe
> the commit message for 86c38a31aa7f2dd6e74a262710bf8ebf7455acc5
> ("tracing: Fix ftrace_event_call alignment for use with gcc 4.5"), with
> gcc-4.x where x < 5, it did work even though some ftrace_event_call
> declarations lacked the align directive.
> 
> If this align thing is so critical, why don't we need it for the
> exception table entries which live in the "__ex_table" section in the
> kernel?  It's the same _exact_ kind of thing, and the asm sequence we
> use to populate it is identical to what GCC emits for the tracing
> object declarations in question.

But aren't the __ex_table entries just two words? Which would align
nicely regardless.

The ftrace_event_call is a relatively large structure, as it may end on
a 4 byte alignement, the linker may start the next section with more
space to get it back to a 8 byte alignment. This is assuming that x86_64
packs the array in 4 bytes.

Hmm, perhaps changing the alignment in vmlinux.lds.h would fix that.

Anyway, I'll revert that commit and see if I can break it again. If so,
then I'll look for other solutions.

Thanks!

-- Steve



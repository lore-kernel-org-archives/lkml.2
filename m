Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab2EaSuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 14:50:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21107 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237Ab2EaSuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 14:50:20 -0400
X-Authority-Analysis: v=2.0 cv=PqgRnnw3 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=nA43mK65oyIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=3fDLGaNrAO2W2NZQ5RsA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1338490218.13348.379.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 1/5] ftrace: Synchronize variable setting with
 breakpoints
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Date: Thu, 31 May 2012 14:50:18 -0400
In-Reply-To: <1338487413.28384.103.camel@twins>
References: <20120531012829.160060586@goodmis.org>
	 <20120531020440.476352979@goodmis.org> <1338462398.28384.52.camel@twins>
	 <1338473302.13348.336.camel@gandalf.stny.rr.com>
	 <1338486029.28384.93.camel@twins>
	 <1338486820.13348.366.camel@gandalf.stny.rr.com>
	 <1338487413.28384.103.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-31 at 20:03 +0200, Peter Zijlstra wrote:
> On Thu, 2012-05-31 at 13:53 -0400, Steven Rostedt wrote:
> > On Thu, 2012-05-31 at 19:40 +0200, Peter Zijlstra wrote:
> > > On Thu, 2012-05-31 at 10:08 -0400, Steven Rostedt wrote:
> > > > > Also, why does this stuff live in ftrace? I always thought you were
> > > > > going to replace text_poke() so everybody that uses cross-modifying code
> > > > > could profit?
> > > > 
> > > > I discussed this with Masami at Collaboration Summit. The two are
> > > > similar but also very different. But we want to start merging the two
> > > > together where it makes sense. 
> > > 
> > > Argh,. I so disagree. You're doing it backwards.
> > > 
> > > First you merge whatever is there, regardless of who came first.
> > 
> > The comment about coming first was more about 're-inventing' then about
> > merging. You can't reinvent something that didn't exist.
> > 
> > That said, I didn't even think about text poke while doing this.
> 
> Well, the fail is before that, how could we grow two pieces of code
> doing similar things in the first place? 

Again, ftrace is slightly different as it does 30,000 changes at once,
on top of known nops. This was done through stop_machine(), thus any
slowdown was a large hit to system performance. text_poke() took the way
of mapping a page to do the change, and Mathieu didn't want to change
that (IIRC). But now we want the two to be similar.


> 
> >  I was
> > just simply thinking about removing stop_machine from ftrace, that
> > required this. It was only a after thought that text_poke() could do the
> > same. And this came up at Collab, where I thought, oh yeah! we can
> > incorporate this with text poke.
> 
> But but but but.. the thing far back when Mathieu proposed the int3
> scheme it was text_poke().. how.. did you not think of it this time!?

Right, but we disagreed on its implementation, and yes, the idea came
from that, but I thought text_poke() was so different that it wouldn't
apply. It wasn't until Masami suggested changing text_poke() to be more
like what ftrace does, that I really took thought into it.

> 
> > 
> > > Then, when everybody doing text modification is using the same
> > > interface, do a second implementation using a Kconfig knob. If the scary
> > > new one breaks, no sweat, flip the config. If its proven stable, kill
> > > off the old one.
> > 
> > What do you suggest then? To revert the code and rewrite it so that
> > text_poke() does a similar thing?
> 
> Too late for that now I guess.. I just wonder why you all thought it was
> a good idea to have two pieces of code doing cross-modifying-code. I
> always assumed ftrace used text_poke().

Well, it was more of two different people working on two different
things. We really didn't look too closely at each others work. It was
more a social failure than a technical one.

> 
> I hardly ever use dyn-ftrace but I do use some text_poke() through
> jump_labels.

You don't use function tracer? That's dyn-ftrace.

But still, we need to keep the record as small as possible because it is
persistent throughout the life of the system running. Every location
must be recorded, and maintain a state (flags).

Text_poke() mostly grew out of the jump-label work. But yes, there's
still a lot that can be shared. The actual code modification may be.

> 
> I would still like to end up with one code base doing CMC with two
> implementations depending on a Kconfig knob.

You mean keep stop_machine around?

-- Steve



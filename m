Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469Ab2EaUtb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 16:49:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31922 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757975Ab2EaUt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 16:49:29 -0400
X-Authority-Analysis: v=2.0 cv=ae7jbGUt c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=nA43mK65oyIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=5AuAxu6qg7pH1YH4f-gA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1338497360.13348.438.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 1/5] ftrace: Synchronize variable setting with
 breakpoints
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, acme <acme@ghostprotocols.net>
Date: Thu, 31 May 2012 16:49:20 -0400
In-Reply-To: <1338496857.28384.124.camel@twins>
References: <20120531012829.160060586@goodmis.org>
	 <20120531020440.476352979@goodmis.org> <1338462398.28384.52.camel@twins>
	 <1338473302.13348.336.camel@gandalf.stny.rr.com>
	 <1338486029.28384.93.camel@twins>
	 <1338486820.13348.366.camel@gandalf.stny.rr.com>
	 <1338487413.28384.103.camel@twins>
	 <1338490218.13348.379.camel@gandalf.stny.rr.com>
	 <1338491176.28384.114.camel@twins> <20120531195529.GA22976@Krystal>
	 <1338495006.13348.418.camel@gandalf.stny.rr.com>
	 <1338495969.28384.119.camel@twins>
	 <1338496676.13348.430.camel@gandalf.stny.rr.com>
	 <1338496857.28384.124.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-31 at 22:40 +0200, Peter Zijlstra wrote:
> On Thu, 2012-05-31 at 16:37 -0400, Steven Rostedt wrote:
> > On Thu, 2012-05-31 at 22:26 +0200, Peter Zijlstra wrote:
> > 
> > > Right, but when you loose stop-machine you could simply do 30k
> > > kmap_atomic/kunmap_atomic's consecutively since you're not holding
> > > anybody up.
> > 
> > It requires 3 IPIs per update too. Thus that's 90,000 IPIs you are
> > blasting^Wsending to all CPUs.
> 
> Uhm, no. 
> 

----------------------------------+
> for_each() {			|
>   kmap_atomic()			|
>   frob int3			|
>   kunmap_atomic();		|
> }				|
> 				|
> sync-ipi-broadcast();		+--- Break points applied
> 				|
> for_each() {			|
>   kmap_atomic();		|
>   frob tail			|
>   kunmap_atomic();		|
> }				|
----------------------------------+

Note, for the above time, the entire kernel has breakpoints added, and
every function is taking a hit due to it. By slowing down this process,
the rest of the system *will* be impacted. Ideally, we want to finish it
as quick as possible. Not to mention, the kmap_atomics will be slowed
down by the breakpoints that are attached to them.

-- Steve

> 
> sync-ipi-broadcast();
> 
> for_each() {
>   kmap_atomic();
>   frob head
>   kunmap_atomic();
> };
> 
> sync-ipi-broadcast();
> 
> How is that sending 90k ipis?



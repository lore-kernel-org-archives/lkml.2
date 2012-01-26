Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370Ab2AZOEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 09:04:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:38450 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab2AZOEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 09:04:30 -0500
X-Authority-Analysis: v=2.0 cv=fNy7LOme c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=0LOP1KteNnsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=70fqYcBpVrWJcohhfMQA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1327586669.22710.89.camel@gandalf.stny.rr.com>
Subject: Re: [RFC][PATCH] tracing/module: Move tracepoint out of module.h
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>
Date: Thu, 26 Jan 2012 09:04:29 -0500
In-Reply-To: <20120126135504.GA13107@elte.hu>
References: <1326754637.7642.177.camel@gandalf.stny.rr.com>
	 <20120117095418.GG10397@elte.hu>
	 <1326807145.17534.26.camel@gandalf.stny.rr.com>
	 <20120118120711.GB14863@elte.hu>
	 <1326909412.17534.91.camel@gandalf.stny.rr.com>
	 <877h0jgx80.fsf@rustcorp.com.au>
	 <1327545664.22710.78.camel@gandalf.stny.rr.com>
	 <20120126102836.GD3853@elte.hu>
	 <1327585945.22710.87.camel@gandalf.stny.rr.com>
	 <20120126135504.GA13107@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Added Li who added the original tracepoint ]

On Thu, 2012-01-26 at 14:55 +0100, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Thu, 2012-01-26 at 11:28 +0100, Ingo Molnar wrote:
> > 
> > > How much more do we save if we move all of try_module_get() out 
> > > of line? It still seems a rather thick inline function with 
> > > preempt section and all. I'd *really* suggest that it should all 
> > > be uninlined.
> > > 
> > 
> > Here's the #'s
> > 
> >    text	   data	    bss	    dec	    hex	filename
> > 7489488	2249584	9719808	19458880	128eb40	vmlinux-prepatch
> >    text	   data	    bss	    dec	    hex	filename
> > 7482458	2248048	9719808	19450314	128c9ca	vmlinux-postpatch
> >    text	   data	    bss	    dec	    hex	filename
> > 7477393	2248080	9719808	19445281	128b621	vmlinux-updatedpatch
> > 
> > Thus we get an additional 5k it seems, for a total of 13k savings.
> > 
> > The below patch is what I used. Note, since the tracepoint 
> > requires the instruction pointer, I created stub versions that 
> > call a "do_" version of the function to pass in the local 
> > instruction counter.
> 
> Hm, why does this tracepoint include a flat RIP? It's pretty 
> superfluous as there's various other (orghogonal) ways to get at 
> the RIP.
> 
> If the field is needed for compatibility then lets set it to 
> zero at the tracepoint level and not burden the module.h 
> hotpath.

Perhaps I could use "__builtin_return_address(0)" instead. I'll try that
out. That way, we don't burden the module hotpath, and we keep the old
behavior.

-- Steve



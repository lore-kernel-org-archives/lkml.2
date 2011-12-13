Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab1LMXIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 18:08:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39279 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab1LMXIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 18:08:19 -0500
X-Authority-Analysis: v=2.0 cv=FIuZNpUs c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=eGShEhoz2TEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=0EZq9VWvxx3k974Oz1IA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1323817697.23971.5.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 2/3] DEBUGFS: Add per cpu counters
From: Steven Rostedt <rostedt@goodmis.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date: Tue, 13 Dec 2011 18:08:17 -0500
In-Reply-To: <20111213225617.GC7633@tassilo.jf.intel.com>
References: <1323812733-7520-1-git-send-email-andi@firstfloor.org>
	 <1323812733-7520-2-git-send-email-andi@firstfloor.org>
	 <alpine.LFD.2.02.1112132336440.3020@ionos>
	 <20111213225617.GC7633@tassilo.jf.intel.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-13 at 14:56 -0800, Andi Kleen wrote:
>  
> > > +struct debugfs_counter {
> > > +	unsigned __percpu *ptr;
> > > +	const char *fn;
> > > +	const char *name;
> > > +} __attribute__((aligned(sizeof(char *))));
> > > +

> > 
> > See commit 654986462 for details.
> 
> Doesn't give a lot of details actually. Which target?
> 
> Note that my structure only has pointers, so there is not a lot 
> of potential for "evil" alignment.

We hit this with trace events as well, and your structure does have an
evil alignment, it's 3 pointers, which is not a base 2 number. Thus,
there were some compilers that liked to add padding to make the
alignment a power of 2. That is, between two sections of files we ended
up with something like:


.section file1
.ptra1
.ptra2
.ptra3
.ptrb1
.ptrb2
.ptrb3
.ptrc1
.ptrc2
.ptrc3
.ptrd1
.ptrd2
.ptrd3
.ptre1
.ptre2
.ptre3
<space>
.section file2
.ptrf1
.ptrf2
.ptrf3
[...]



It didn't happen often, heck, trace events and tracepoints were like
this for sometime before this blew up in our faces.

>From what I've seen is that 1 or 2 longs will pack nicely, but anything
else (except for maybe 4, 8, 16, etc) will run a risk of crashing.

-- Steve



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab0FONFH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 09:05:07 -0400
Received: from adelie.canonical.com ([91.189.90.139]:54540 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab0FONFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 09:05:05 -0400
Subject: Re: [PATCH] trace-cmd: prevent print_graph_duration buffer overflow
From: Chase Douglas <chase.douglas@canonical.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <srostedt@redhat.com>, Valdis.Kletnieks@vt.edu,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100615124953.GB5342@nowhere>
References: <1276449108-21328-1-git-send-email-chase.douglas@canonical.com>
	 <1276449108-21328-2-git-send-email-chase.douglas@canonical.com>
	 <40245.1276462373@localhost> <1276462894.2356.6.camel@cndougla-ubuntu>
	 <15749.1276551633@localhost>
	 <1276560963.13426.54.camel@localhost.localdomain>
	 <20100615124953.GB5342@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Jun 2010 09:04:58 -0400
Message-ID: <1276607098.3452.5.camel@cndougla-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-15 at 14:49 +0200, Frederic Weisbecker wrote:
> On Mon, Jun 14, 2010 at 08:16:03PM -0400, Steven Rostedt wrote:
> > On Mon, 2010-06-14 at 17:40 -0400, Valdis.Kletnieks@vt.edu wrote:
> > > On Sun, 13 Jun 2010 17:01:34 EDT, Chase Douglas said:
> > > > On Sun, 2010-06-13 at 16:52 -0400, Valdis.Kletnieks@vt.edu wrote:
> > > > > On Sun, 13 Jun 2010 13:11:48 EDT, Chase Douglas said:
> > > > > > Passing n > sizeof(string) to snprintf can cause a glibc buffer overflow
> > > > > > condition. We know the exact size of nsecs_str, so use it instead of
> > > > > > math that may overflow.
> > > > > 
> > > > > >  	/* Print nsecs (we don't want to exceed 7 numbers) */
> > > > > >  	if ((s->len - len) < 7) {
> > > > > > -		snprintf(nsecs_str, 8 - (s->len - len), "%03lu", nsecs_rem);
> > > > > > +		snprintf(nsecs_str, sizeof(nsecs_str), "%03lu", nsecs_rem);
> > > > > 
> > > > > We only get into this code after we've checked that the length is under 7
> > > > > characters.  How much overflow can happen as long as the sizeof(nsecs_str) is a
> > > > > sane size (like at least 8 chars)?  Probably a better bet would be doing the
> > > > > right thing and 'BUILD_BUG_ON(sizeof(nsecs_str) < 8);'?
> > > > 
> > > > nsecs_str is a local variable defined just above this block of code as:
> > > > 
> > > > 	char nsecs_str[5];
> > > > 
> > > > I was hitting cases where s->len == 64 and len == 63, leading to the
> > > > size argument of snprintf being 7 on a 5 byte string. I didn't delve too
> > > > much into the reasoning for the if statement, but I think it's math is
> > > > not actually related to the size of nsecs_rem but to some other string
> > > > length.
> > > 
> > > This is starting to smell like that patch is just papering over a bug...
> > > 
> > > I saw that '8 -' and made the rash assumption that was the size of the array.
> > > Is 5 in fact big enough and the  's->len - len' calculation is broken, or
> > > should it be bigger?  As you noted, that length calculation is looking a tad
> > > sketchy.  (And if we're stuck with '5' because it's a magic number for
> > > somebody's formatting purposes, maybe it needs to be a #define?)
> > > 
> > 
> > Ouch, this is worse than that. this code was cut & pasted almost
> > directly from the Linux kernel (kernel/trace/trace_function_graph.c).
> > And it looks like any bug here is also a bug there. The difference is
> > that if we trigger the bug there we crash the kernel :-p
> 
> 
> I must be missing the purpose of this patch.
> 
> log10(nsecs_rem) can't exceed 3 characters as it is the rest of
> a division per 1000.
> 
> The goal of this:
> 
> 	if (len < 7) {
> 		snprintf(nsecs_str, 8 - len, "%03lu", nsecs_rem)
> 
> is to avoid having a duration that exceeds 7 characters, so formatted nsecs
> be shrinked on need.
> 
> For example:
> 
> 	75000.567
> 
> would be shrinked to 75000.56, and that's the point.
> 
> if (len < 7) is not a security guard, it is a formatting convenience
> to get a fixed column length.
> 
> The security guard is the mathematics that tells us log10(n % 1000) < 4.
> In fact nsecs_str could be even of size 4 rather than 5.

I agree that there is no *real* security issue here because of the
length of the string that snprintf would generate. However, glibc still
barfs when you pass in a size parameter larger than the string. Without
this patch, trace-cmd is unusable for me; glibc aborts as soon as the
condition is hit. I found this as I was packaging trace-cmd for Ubuntu,
so maybe glibc in other distributions is behaving differently?

-- Chase


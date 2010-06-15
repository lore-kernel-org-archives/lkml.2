Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748Ab0FOAQP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 20:16:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756607Ab0FOAQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 20:16:14 -0400
Subject: Re: [PATCH] trace-cmd: prevent print_graph_duration buffer overflow
From: Steven Rostedt <srostedt@redhat.com>
To: Valdis.Kletnieks@vt.edu
Cc: Chase Douglas <chase.douglas@canonical.com>, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <15749.1276551633@localhost>
References: <1276449108-21328-1-git-send-email-chase.douglas@canonical.com>
	 <1276449108-21328-2-git-send-email-chase.douglas@canonical.com>
	 <40245.1276462373@localhost> <1276462894.2356.6.camel@cndougla-ubuntu>
	 <15749.1276551633@localhost>
Content-Type: text/plain
Organization: Red Hat
Date: Mon, 14 Jun 2010 20:16:03 -0400
Message-Id: <1276560963.13426.54.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-14 at 17:40 -0400, Valdis.Kletnieks@vt.edu wrote:
> On Sun, 13 Jun 2010 17:01:34 EDT, Chase Douglas said:
> > On Sun, 2010-06-13 at 16:52 -0400, Valdis.Kletnieks@vt.edu wrote:
> > > On Sun, 13 Jun 2010 13:11:48 EDT, Chase Douglas said:
> > > > Passing n > sizeof(string) to snprintf can cause a glibc buffer overflow
> > > > condition. We know the exact size of nsecs_str, so use it instead of
> > > > math that may overflow.
> > > 
> > > >  	/* Print nsecs (we don't want to exceed 7 numbers) */
> > > >  	if ((s->len - len) < 7) {
> > > > -		snprintf(nsecs_str, 8 - (s->len - len), "%03lu", nsecs_rem);
> > > > +		snprintf(nsecs_str, sizeof(nsecs_str), "%03lu", nsecs_rem);
> > > 
> > > We only get into this code after we've checked that the length is under 7
> > > characters.  How much overflow can happen as long as the sizeof(nsecs_str) is a
> > > sane size (like at least 8 chars)?  Probably a better bet would be doing the
> > > right thing and 'BUILD_BUG_ON(sizeof(nsecs_str) < 8);'?
> > 
> > nsecs_str is a local variable defined just above this block of code as:
> > 
> > 	char nsecs_str[5];
> > 
> > I was hitting cases where s->len == 64 and len == 63, leading to the
> > size argument of snprintf being 7 on a 5 byte string. I didn't delve too
> > much into the reasoning for the if statement, but I think it's math is
> > not actually related to the size of nsecs_rem but to some other string
> > length.
> 
> This is starting to smell like that patch is just papering over a bug...
> 
> I saw that '8 -' and made the rash assumption that was the size of the array.
> Is 5 in fact big enough and the  's->len - len' calculation is broken, or
> should it be bigger?  As you noted, that length calculation is looking a tad
> sketchy.  (And if we're stuck with '5' because it's a magic number for
> somebody's formatting purposes, maybe it needs to be a #define?)
> 

Ouch, this is worse than that. this code was cut & pasted almost
directly from the Linux kernel (kernel/trace/trace_function_graph.c).
And it looks like any bug here is also a bug there. The difference is
that if we trigger the bug there we crash the kernel :-p

-- Steve



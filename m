Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab2INULp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 16:11:45 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:40000 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab2INULn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 16:11:43 -0400
Date: Fri, 14 Sep 2012 22:11:38 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [PATCH 3/3 v2] perf tool: give user better message if precise is
 not supported
Message-ID: <20120914201138.GA17024@gmail.com>
References: <1347569955-54626-1-git-send-email-dsahern@gmail.com>
 <1347569955-54626-4-git-send-email-dsahern@gmail.com>
 <20120914054344.GB9043@gmail.com>
 <50531151.9020202@gmail.com>
 <20120914113617.GA13299@gmail.com>
 <5053186E.6000302@gmail.com>
 <20120914180013.GA27766@ghostprotocols.net>
 <1347646039.7172.66.camel@twins>
 <20120914200518.GA16872@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120914200518.GA16872@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Fri, 2012-09-14 at 11:00 -0700, Arnaldo Carvalho de Melo wrote:
> > > > Understood and there have been suggestions on how to definitely state
> > > > what the kernel side did not like. I like Peter's last suggestion --
> > > > something along the lines of clearing attr on a failure except the
> > > > offending setting.
> > > 
> > > I think ws need to use a new bit 
> > 
> > Quite so, for all the reasons you list. But you like the 
> > general idea? I wasn't sure I did, but it was the only thing I 
> > could come up with that would sort of do what we need it to.
> > 
> > The fact that you destroy the user input is awkward, I don't 
> > think there's another syscall that behaves in this fashion.
> 
> Destroying/clearing stuff looks really hacky.
> 
> Why not use a single error status field, set via a long list 
> of enum error constants, a 'perf errnos'?
> 
> The only real problem with the kernel's syscall error code is 
> that it's not wide enough for historic reasons, so we cannot 
> just create our own errnos. But we can create our errors in 
> the attr just fine and make them finegrained enough so that 
> tooling can figure out what happened exactly when it gets a 
> syscall error.
> 
> Yes, that's old-fashioned technology, but it works. With time 
> we could put some structure into the list of error IDs, to 
> make it easily extensible yet grouped in some fashion, etc.

And we could start this small: just covering the problem at hand 
or so, with proper tooling side support - and then extend it as 
needed. I.e. have something in place that we could ask people 
adding new kernel side error paths to use - and with time old 
code could be enriched with better error codes as well.

perf could in fact internally standardize on a 32-bit wide error 
code, and translate it to -EINVAL at the syscall return level. 
That way we could keep all the simple error paths as they are 
today, with a very little syscall level logic (triggered in 
error cases only, so no overhead in the regular case).

I.e.:

  return -EPERF_CPU_PRECISE_EV_NOTSUPP;

would result in that error code being available to new, improved 
tooling that knows about the new attr field. Old tooling would 
still work as well, it would only see the -EINVAL of the 
syscall.

Or something like this - simple and using existing patterns and 
practices. Anything else will likely fail due to non-use.

Thanks,

	Ingo

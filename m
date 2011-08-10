Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211Ab1HJROZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 13:14:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20480 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409Ab1HJROY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 13:14:24 -0400
Date: Wed, 10 Aug 2011 13:14:15 -0400
From: Jason Baron <jbaron@redhat.com>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: Bart Van Assche <bvanassche@acm.org>, joe@perches.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, gnb@fmeh.org
Subject: Re: [PATCH 03/25] dynamic_debug: use pr_debug instead of pr_info
Message-ID: <20110810171415.GA2988@redhat.com>
References: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
 <1311630170-26057-4-git-send-email-jim.cromie@gmail.com>
 <CAO+b5-rpXrAZ6bAtWiy+rCaWEmRCwzMmNrqsRWQChM9nkdofiw@mail.gmail.com>
 <CAJfuBxzq67UM7i+EmDzdFCWfbEPM2cGad1Ed4cfCP5+v2QVgwg@mail.gmail.com>
 <CAO+b5-qoMiuOSga_fnzMfKsGDDkBAY7oLoJK1xk+XvvbT21OwQ@mail.gmail.com>
 <20110728182427.GD2659@redhat.com>
 <CAJfuBxwS0rQG=REt9wwYde7d=j1a4z1JdV3fiJ2UexHychCbcw@mail.gmail.com>
 <20110803182709.GA2462@redhat.com>
 <CAJfuBxyPtxxCvA4LBx8J+6ADgj1ah4nroM30uYS880pJN+eGxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfuBxyPtxxCvA4LBx8J+6ADgj1ah4nroM30uYS880pJN+eGxA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 03, 2011 at 01:52:33PM -0600, Jim Cromie wrote:
> On Wed, Aug 3, 2011 at 12:27 PM, Jason Baron <jbaron@redhat.com> wrote:
> > On Thu, Jul 28, 2011 at 03:15:35PM -0600, Jim Cromie wrote:
> >> On Thu, Jul 28, 2011 at 12:24 PM, Jason Baron <jbaron@redhat.com> wrote:
> >> > On Thu, Jul 28, 2011 at 11:18:56AM +0200, Bart Van Assche wrote:
> >> >> On Wed, Jul 27, 2011 at 11:34 PM, Jim Cromie <jim.cromie@gmail.com> wrote:
> >> >> > On Tue, Jul 26, 2011 at 1:08 AM, Bart Van Assche <bvanassche@acm.org> wrote:
> >> >> >> Changing pr_info() into pr_debug() inside the dynamic_debug
> >> >> >> implementation seems like a really bad idea to me. Such changes make
> >> >> >> it hard to find out via source code reading whether or not there is a
> >> >> >> risk that invoking one of these pr_debug() macros will cause infinite
> >> >> >> recursion.
> >> >> >
> >> >> > WRT earlier discussion (Joe, Jason):
> >> >> >
> >> >> >> I think these should be pr_debug.
> >> >> >> I know you're only using the current style.
> >> >> >>
> >> >> >> Jason, any reason these can not be converted?
> >> >> >
> >> >> > it should be ok, although we have to be careful not to use them in the
> >> >> > printing path, since that will cause a recursion.
> >> >> >
> >> >> > Also, if there is an issue with the dynamic debug code, it makes it more
> >> >> > of a pain to debug :)
> >> >>
> >> >> With this approach enabling all debug printing in the dynamic_debug
> >> >> implementation requires both echoing into .../dynamic_debug/control
> >> >> and setting the "verbose" module parameter. That's not something I
> >> >> would call "elegant", but after all, I'm not the dynamic debug
> >> >> maintainer ...
> >> >>
> >> >> Bart.
> >> >
> >> > we certainly don't want to make ppl do both. why is the verbose param
> >> > still required?
> >> >
> >>
> >> Its needed to selectively enable pr_info()s,
> >> which I use cuz they happen too early for pr_debug() to be enabled.
> 
> ie: during init.  ddebug_add_module happens for everything in the
> _ddebug table, and THEN ddebug_query is parsed and executed,
> which enables the callsites.
> I could parse 1st, and put them on pending-list, but then all parsing
> is done before the callsites are enabled, defeating the purpose.
> 
> >
> > ok, then I would suggest we just stay with the verbose flag, since we
> > don't want make ppl jump through two hoops, and as a bonus we avoid any
> > potential recursive issue.
> >
> > thanks,
> >
> > -Jason
> >
> 
> 
> alright, I can live with that, but Id like to note the loss of selectivity
> in the verbose-only approach before capitulating:
> 
> the pr_info()s in _proc_ routines are quite noisy when enabled.
> 
> in my current config, which has 537 callsites,
> enabling all those pr_debug()s unselectively, ie:
> 
> Kernel command line: ... ddebug_query="module dynamic_debug +pflt; "
> loglevel=8 dynamic_debug.verbose=1
> 
> and doing : ~# cat /dbg/dynamic_debug/control
> logs 836 lines like
> [2573] ddebug_proc_next:866: called m=c6f99a40 p=c88955d0 *pos=427
> [2573] ddebug_proc_show:888: called m=c6f99a40 p=c88955e8
> 
> Not completely overwhelming perhaps, but nice to silence.
> 
> Before switching to pr_debug, I had changed those proc pr_infos to:
> if (verbose >= 10)
>     pr_info(...)
> 
> that quiets things nicely, and is knowable via modinfo,
> is that addition acceptable ?
> 

why do you have '10' here, isn't it just, if (verbose) ? 

> BTW, are you aiming for tip tree ?

The dynamic debug patches have been going in via Greg KH's device
tree. Now that the merge window has closed, I going to re-send the patch
series that I had pending. You can then send your series on top of that,
if you'd like.

Thanks,

-Jason

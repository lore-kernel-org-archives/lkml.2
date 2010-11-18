Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006Ab0KRO1H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 09:27:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52569 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757377Ab0KRO1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 09:27:05 -0500
Date: Thu, 18 Nov 2010 09:26:23 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Jon Masters <jcm@redhat.com>, corbet <corbet@lwn.net>,
        Jake Edge <jake@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>, lmr@redhat.com,
        Greg Kroah-Hartman <gregkh@suse.de>, autotest@test.kernel.org,
        Clark Williams <williams@redhat.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tim Bird <tim.bird@am.sony.com>
Subject: Re: [ANNOUNCE v2] ktest.pl: Easy and flexible testing script for
 Linux Kernel Developers (now with config bisect)
Message-ID: <20101118142623.GB13933@redhat.com>
References: <1289259910.12418.77.camel@gandalf.stny.rr.com>
 <1290089317.30543.114.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290089317.30543.114.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 09:08:37AM -0500, Steven Rostedt wrote:
> Question:
> 
> Has anyone tried this out? Does anyone feel that I should get this ready
> to be included in 2.6.38 tools directory?
> 
> Just want to know if I should go ahead and prepare it, or if it will
> just be a waste of my time.

I had done some testing only on initial internal version but did not
get a chance to do more testing later.

But I believe it is worth to put effort to keep this script going. I am
especially interested in part where I can just automate compilation and
testing of a patch on a remote machine.

Thanks
Vivek

> 
> Thanks,
> 
> -- Steve
> 
> 
> On Mon, 2010-11-08 at 18:45 -0500, Steven Rostedt wrote:
> > I previously posted the announcement about ktest (and shamelessly
> > promoted it at both Kernel Summit and Linux Plumbers), but I just
> > updated it with a new feature.
> > 
> >   TEST_TYPE = config_bisect
> > 
> > (See http://marc.info/?l=linux-kernel&m=128829496215347 for original
> > post)
> > 
> > With the new config_bisect, the config is tested in halves. To handle
> > strange dependencies, the following is done.
> > 
> > First the "bad-config" needs to be prepared for the current working git
> > tree. As with all other tests, a "min-config" may be specified and that
> > will be override any config settings in the "bad-config". Since this may
> > produce new settings to be set (or removed) some preparation needs to be
> > done. This is done automatically with ktest:
> > 
> > 1) overrides all configs with what is in the MIN_CONFIG or ADD_CONFIG
> > settings.
> > 
> > 2) Runs the result through a make oldconfig to see if what may have been
> > added or removed (it reports these).
> > 
> > 3) creates what is about to be tested and again runs the make oldconfig
> > to see if anything else might have been removed by dependencies.
> > 
> > All of the above changes are reported by the tool.
> > 
> > 
> > Finally, it gets into the bisect. It starts with a list of configs to
> > test. It cuts it in half, and then creates a .config file, and runs that
> > through oldconfig. If none of the configs in the list are enabled
> > (because they all depend on configs in the other half) then the second
> > half of the list is tried. If there's still no configs set, there must
> > be a circular dependency and the test fails here (but this should never
> > happen).
> > 
> > It compiles, and performs the type of test specified by the
> > CONFIG_BISECT_TYPE option (build, boot or test). If it passes, then all
> > the configs that were enabled in the .config are removed from the
> > configs to test and added to the good configs to always enable. This
> > allows for configs in the other half to be enabled if they depended on
> > these configs.
> > 
> > If the test fails, then we have a new subset of configs that is known to
> > cause the failure. Any config that was not set in the .config for this
> > run is removed from the test and will not be enabled again.
> > 
> > This iterates until we have one config left and that config will be
> > reported.
> > 
> > Because of dependencies and selects, the config reported may not be the
> > only config to cause the error. If you find that you can still produce
> > an error after disabling the config it reports, then simply disable it
> > and run the bisect again. Most likely it will turn up the problem. I may
> > automate this part in the future.
> > 
> > Anyway, you can download the latest ktest from:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/ktest.git
> > 
> > I need to write up a man page and perhaps more documentation. The
> > sample.conf that comes in that repo has loads of information on how to
> > do the tests.
> > 
> > 
> > Have fun!
> > 
> > -- Steve
> > 
> 

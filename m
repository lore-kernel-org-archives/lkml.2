Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab1I3PKt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 11:10:49 -0400
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:34833 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175Ab1I3PKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 11:10:48 -0400
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-Originating-IP: 217.70.178.145
X-Originating-IP: 50.43.15.19
Date: Fri, 30 Sep 2011 08:05:19 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: Please revert "debug: Make CONFIG_EXPERT select
 CONFIG_DEBUG_KERNEL to unhide debug options"
Message-ID: <20110930150519.GA7980@leaf>
References: <20110930134245.GB21474@localhost.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110930134245.GB21474@localhost.pp.htv.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 04:42:45PM +0300, Adrian Bunk wrote:
> I was just wondering why I was asked about all the debug options when I 
> tried 3.1-rc8, and that was due to commit f505c553 (debug: Make 
> CONFIG_EXPERT select CONFIG_DEBUG_KERNEL to unhide debug options),
> the full commit is below.
> 
> It is wrong, and the author does not seem to understand how Kconfig works.
> 
> The commit message is:
> 
>     Several debugging options currently default to y, such as
>     CONFIG_DEBUG_BUGVERBOSE and CONFIG_DEBUG_RODATA.  Embedded users
>     might want to turn those options off to save space; however,
>     turning them off requires turning on CONFIG_DEBUG_KERNEL to
>     unhide them.  Since CONFIG_DEBUG_KERNEL exists specifically to
>     unhide debugging options, and CONFIG_EXPERT exists specifically
>     to unhide options potentially needed by experts and/or embedded
>     users, make CONFIG_EXPERT automatically imply
>     CONFIG_DEBUG_KERNEL.
> 
> 
> Let me point at the obvious fact that both CONFIG_DEBUG_BUGVERBOSE and 
> CONFIG_DEBUG_RODATA do depend on DEBUG_KERNEL, and are contrary to the 
> claim of the author of this patch never enabled with 
> CONFIG_DEBUG_KERNEL=n. [1]

Not true:

~/src/linux-2.6$ rm .config
~/src/linux-2.6$ make allnoconfig
  HOSTCC  scripts/basic/fixdep
  HOSTCC  scripts/kconfig/conf.o
  HOSTCC  scripts/kconfig/zconf.tab.o
  HOSTLD  scripts/kconfig/conf
scripts/kconfig/conf --allnoconfig Kconfig
#
# configuration written to .config
#
~/src/linux-2.6$ grep BUGVERBOSE .config
CONFIG_DEBUG_BUGVERBOSE=y
~/src/linux-2.6$ grep DEBUG_KERNEL .config
# CONFIG_DEBUG_KERNEL is not set

DEBUG_BUGVERBOSE does not depend on DEBUG_KERNEL; it just only shows up
with DEBUG_KERNEL (and EXPERT) set.  The *description* has a conditional
on DEBUG_KERNEL and EXPERT:

config DEBUG_BUGVERBOSE
        bool "Verbose BUG() reporting (adds 70K)" if DEBUG_KERNEL && EXPERT

That doesn't mean the same thing as "depends on DEBUG_KERNEL".

Also see Ingo Molnar's mail with Message-Id
<20110605093445.GA19927@elte.hu>, which explicitly recommended this
approach.

- Josh Triplett

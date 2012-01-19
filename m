Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab2ASIMH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 03:12:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739Ab2ASIMC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 03:12:02 -0500
Date: Thu, 19 Jan 2012 09:09:55 +0100
From: Andrew Jones <drjones@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: rientjes@google.com, mingo@elte.hu, david.woodhouse@intel.com,
        linux-kernel@vger.kernel.org, gregkh@suse.de, davem@davemloft.net,
        axboe@kernel.dk, arnd@arndb.de, holt@sgi.com,
        linux-arch@vger.kernel.org, linux@arm.linux.org.uk,
        hskinnemoen@gmail.com, egtvedt@samfundet.no, msalter@redhat.com,
        a-jacquiot@ti.com, starvik@axis.com,
        jesper nilsson <jesper.nilsson@axis.com>, dhowells@redhat.com,
        takata@linux-m32r.org, geert@linux-m68k.org,
        yasutake koichi <yasutake.koichi@jp.panasonic.com>, jonas@southpole.se,
        kyle@mcmartin.ca, deller@gmx.de, jejb@parisc-linux.org,
        chris@zankel.net, greg@kroah.com, davej@redhat.com, airlied@linux.ie,
        jkosina@suse.cz, mchehab@infradead.org, johannes@sipsolutions.net,
        linville@tuxdriver.com
Subject: Re: [PATCH] kconfig: untangle EXPERT and EMBEDDED
Message-ID: <20120119080955.GA2274@turtle.usersys.redhat.com>
References: <1326295008-29795-1-git-send-email-drjones@redhat.com>
 <b6315f9b-0ead-4de4-a8f5-ed619f852c6c@zmail13.collab.prod.int.phx2.redhat.com>
 <20120118122830.037f1e29.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120118122830.037f1e29.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 12:28:30PM -0800, Andrew Morton wrote:
> And ditto EXPERT.  Is there really any benefit in hiding config options
> from developers so they won't burn their fingers?  Or is there some
> other reason for EXPERT?

The initial motivation for this patch actually comes from some backlash I
got when submitting a different patch. The other patch attempted to change
a silent config option, e.g.

config FOO
	def_bool y
	depends on BAR && BAZ

to one where it could be configurable, e.g.

config FOO
	bool "This is Foo"
	default y
	depends on BAR && BAZ
	help
	  Foo does FOObulously cool stuff

I needed it configurable because the default was y and I wanted to make it
n in my config. The backlash I got was that the configmenu was already too
complex, and thus this config option had been made silent to reduce that
complexity. My need to change the default was indeed for a very specific
purpose, and nobody else cared about it. Even though I was able to point
out another, more general, reason one might want to configure out that
option, it really didn't look like the patch was going anywhere. So I
looked around for another solution and found EXPERT. Changing the option
to

config FOO
	bool "This is Foo" if EXPERT
	default y
	depends on BAR && BAZ
	help
	  Foo does FOObulously cool stuff

seemed like a great way to solve the configmenu complexity issue, and get
my configurablity. The documentation for EXPERT

          This option allows certain base kernel options and settings
          to be disabled or tweaked. This is for specialized
          environments which can tolerate a "non-standard" kernel.
          Only use this if you really know what you are doing.

indicated to me that that's precisely what EXPERT was for. Unfortunately a
quick experiment showed that it messes with config options, as well as
expose them for disabling and tweaking.

That's the initial motivation for fixing EXPERT. Before posting this patch
though I came up with another motivation. If this patch was merged I was
planning to send an RFC asking if it would make sense to apply EXPERT to
most/all of the config options that have sentences like

    "If unsure select y, only disable if you know what you're doing"

Options like these also sound like expert options to me, and so there's no
reason to have to visit them while configuring a standard kernel. You'd
just select the default anyway.

> 
> Anyway, we already have a way to prevent fingers from getting burnt:
> defconfig.  Start out with that and carefully modify it.
> 

Yes, this is good, but it doesn't solve the silent option problem. For the
example above

config FOO
	def_bool y
	depends on BAR && BAZ

I can't just say FOO=n in my own personal config to override it.

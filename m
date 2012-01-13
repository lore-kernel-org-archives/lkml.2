Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127Ab2AMMYu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 07:24:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134Ab2AMMYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 07:24:47 -0500
Date: Fri, 13 Jan 2012 13:22:03 +0100
From: Andrew Jones <drjones@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, mingo@elte.hu, david.woodhouse@intel.com,
        gregkh@suse.de, davem@davemloft.net, axboe@kernel.dk, holt@sgi.com,
        linux-arch@vger.kernel.org, linux@arm.linux.org.uk,
        hskinnemoen@gmail.com, egtvedt@samfundet.no, msalter@redhat.com,
        a-jacquiot@ti.com, starvik@axis.com, jesper.nilsson@axis.com,
        dhowells@redhat.com, takata@linux-m32r.org, geert@linux-m68k.org,
        yasutake.koichi@jp.panasonic.com, jonas@southpole.se, kyle@mcmartin.ca,
        deller@gmx.de, jejb@parisc-linux.org, chris@zankel.net, greg@kroah.com,
        davej@redhat.com, airlied@linux.ie, jkosina@suse.cz,
        mchehab@infradead.org, johannes@sipsolutions.net,
        linville@tuxdriver.com
Subject: Re: [PATCH] kconfig: untangle EXPERT and EMBEDDED
Message-ID: <20120113122202.GB2452@turtle.usersys.redhat.com>
References: <1326295008-29795-1-git-send-email-drjones@redhat.com>
 <alpine.DEB.2.00.1201111353330.21755@chino.kir.corp.google.com>
 <201201120918.53026.arnd@arndb.de>
 <20120112101805.GA2375@turtle.usersys.redhat.com>
 <alpine.DEB.2.00.1201121259270.17287@chino.kir.corp.google.com>
 <20120113085125.GA2452@turtle.usersys.redhat.com>
 <alpine.DEB.2.00.1201130230320.15417@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1201130230320.15417@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 02:53:27AM -0800, David Rientjes wrote:
> What would be helpful is if CONFIG_EMBEDDED actually meant what it 
> implies, i.e. for config options that only make sense on embedded devices 
> (similar to CONFIG_SMALLMEM I mentioned earlier, but more focused).

Agreed, but it's not the problem that this patch is attempting to solve.
You and I are looking at this patch (and its predecessor 6a108a14fa35)
from two different sides. I want CONFIG_EXPERT to work, and you want
CONFIG_EMBEDDED to mean what it should. I'm saying that fixing EXPERT now,
by reverting EMBEDDED back a bit, and then eventually fixing that later,
is the better way to go. You're saying you don't want me to touch
EMBEDDED, and thus far you've ignored the problem I'm attempting to solve.

> why it currently selects EXPERT, but we'd like to be able to separate 
> those out so they can make more sane decisions and introduce things like 
> "depends on EXPERT || EMBEDDED".

This patch is actually attempting to make progress in the separation of
the semantics for EXPERT and the old, insane EMBEDDED, which had the very
loose semantics. That's why it's called "untangle EXPERT and EMBEDDED".

> Don't think of 6a108a14fa35 as renaming CONFIG_EMBEDDED to CONFIG_EXPERT, 
> think of it as adding CONFIG_EXPERT which is what it really does and frees 

I do think of 6a108a14fa35 as adding CONFIG_EXPERT, and I like
CONFIG_EXPERT, but I also think of it as adding CONFIG_EXPERT incorrectly.

> That's bogus, config EMBEDDED was used to select the new EXPERT so there 
> was no backwards compatibility issue.  I'd agree with you that your patch 
> would be backwards compatible and doesn't suddenly, and silently, lose 
> config options that were previously enabled when running make oldconfig if 
> everybody in the world used defconfigs.  That's not the case, which is why 
> this is a non-starter.

The fact that this patch breaks backward compatibility is unfortunate, but
the only way to fix the problem that it's attempting to fix, without that
breakage, is to introduce yet another config option (EXPERT2 or
REALLY_EXPERT?). If I'm not mistaken and config variable backward
compliance isn't required, then I'd say breaking it makes much more sense
then adding something like REALLY_EXPERT and all the mess that'll come
with it.

It's not clear to me, that it's clear to everyone else, what this patch is
really trying to fix. Below is a fun way to try and express it. It's done
in dialog form. Hopefully it'll be entertaining as well as get the point
across.

Developers Alice and Bob work on subcomponent XYZ and are chatting

Alice> hey Bob, I think we need a new symbol to compile out some
code that not all of our customers want
Bob> really? Ugh, The XYZ config menu already has tons of options,
and most have defaults that should really never be touched anyway.
I sure hate adding yet another...
Alice> hmm... Oh, I remember there's this nifty CONFIG_EXPERT that
some options use in order to hide from the standard configmenu.
The options are only available to experts that turn on EXPERT
Bob> oh, that sounds cool. We can clean up our whole menu by adding
that to the options nobody should be touching. Then for those
special customers we can turn CONFIG_EXPERT on and override the
default of that new option to off
Alice> OK, Kconfigs updated, new config with CONFIG_EXPERT=y and
CONFIG_XYZ_SPECIAL=n created, load, cock, fire, release the code
to QA!

...some time later...

QA person> HEY! Why is the kernel missing important features from
other subcomponents?
Alice+Bob> err.. We don't know. Last update we did was only to
XYZ's Kconfig files. Oh, and we turned on that nifty CONFIG_EXPERT,
but that shouldn't do anything...

...Alice and Bob take a closer look...

Alice> CRAP! CONFIG_EXPERT doesn't just expose config options, it
actually turns stuff off too!!
Bob> Ugh, CONFIG_EXPERT is junk


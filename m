Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab2APJXm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 04:23:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15179 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753694Ab2APJXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 04:23:38 -0500
Date: Mon, 16 Jan 2012 10:20:50 +0100
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
Message-ID: <20120116091832.GA2401@turtle.usersys.redhat.com>
References: <1326295008-29795-1-git-send-email-drjones@redhat.com>
 <alpine.DEB.2.00.1201111353330.21755@chino.kir.corp.google.com>
 <201201120918.53026.arnd@arndb.de>
 <20120112101805.GA2375@turtle.usersys.redhat.com>
 <alpine.DEB.2.00.1201121259270.17287@chino.kir.corp.google.com>
 <20120113085125.GA2452@turtle.usersys.redhat.com>
 <alpine.DEB.2.00.1201130230320.15417@chino.kir.corp.google.com>
 <20120113122202.GB2452@turtle.usersys.redhat.com>
 <alpine.DEB.2.00.1201131318340.24089@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1201131318340.24089@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 01:27:35PM -0800, David Rientjes wrote:
> CONFIG_EXPERT does work, there haven't been problems reported with it in 
> the year that it has been in the kernel, and CONFIG_EMBEDDED is available 
> to be extended to have its logical semantics.  Right now, CONFIG_EMBEDDED 
> is pretty useless other than setting CONFIG_EXPERT but that could easily 

Um? Isn't the whole point of me sending a patch because there's a problem?
Thus THIS is problem report. Who else besides a kernel developer would
even notice this problem? As you say, EMBEDDED does nothing more than
select EXPERT, which does exactly the same thing as EMBEDDED did.
Therefore to people using EMBEDDED there has been no change. But what new
users of EXPERT will there ever be as long EXPERT twists default config
options?

> You can't responsibly untangle EXPERT and EMBEDDED without making EMBEDDED 
> not select EXPERT and instead replace config options that should be 
> configurable only on embedded devices to do "depends on EXPERT || 
> EMBEDDED".  That's not what your patch does.

What? A dependency (or in this case a reverse dependency using select)
does not mean the semantics of the options are tangled. EXPERT should be
free of those old EMBEDDED semantics and do only one thing, expose expert
options. EMBEDDED can then select it or not, I don't care. As for your
example "depends on EXPERT || EMBEDDED", that doesn't matter to me either.
I don't care if EMBEDDED just selects EXPERT, or if somebody sprinkles
around something like that for particular options. If you actually did
know what my patch does, then you'd see what I care about is getting rid
of "default !EXPERT".

As I've said several times, cleaning up EMBEDDED's semantics, or doing
anything at all with EMBEDDED, is outside the scope of this patch. This
patch fixes EXPERT. It reverts EMBEDDED's side effects back onto itself.
Additional patches can tackle EMBEDDED later, but for starters let's just
make EXPERT something useful. And yes, until somebody does something with
EMBEDDED, it is now required that it selects EXPERT, but, hey, it already
does.

> Breaking backwards compatibility for users who aren't defconfigs is a 
> non-starter, as I've said.  Admitting that your patch does it is almost 
> like nacking your own patch.

Like I said (twice), afaik config options aren't in the ABI that we must
maintain. They're internal to the kernel. While it's nice to keep them the
same, in order to save people some effort, it's not required. If people
are compiling kernels, then they can (and should) select their options
each time they grab a new release. Oh, and guess what? It would be really
cool if the kconfig help accurately described what the option does that
they're debating over enabling/disabling, wouldn't it? Where does it say
for EXPERT that some defaults will be automatically changed? It says

          This option allows certain base kernel options and settings
          to be disabled or tweaked. This is for specialized
          environments which can tolerate a "non-standard" kernel.
          Only use this if you really know what you are doing.

See the word _allows_. It shouldn't actually disable anything, or if it
does (which it shouldn't), then it should state it as such, preferably
with a big WARNING in front of it.

I say break the compatibility and fix it now, rather than letting the mess
last any longer. The impact should be small since the patch is only a
year old, it's only used by a handful of people that are ok with the
defaults being flipped automatically, and I've updated the defconfigs,
which should help alert those that base their configs off of them that
they need to make a change. The alternative of adding a new EXPERT
(EXPERT2), which only exposes config options and doesn't have side
effects, just in order to preserve backward compatibility, would be
silly.

This is a trivial patch for an obvious problem. In all the emails that
we've exchanged you haven't told me anything I didn't know before posting.
I've now explained this patch in several ways (I thought for sure the
dialog idea would make it 100% obvious). If you still don't understand it,
then please try asking specific questions, rather than reiterating the
motivation for 6a108a14fa35. BTW, by your standpoint of config options
being required to be backward compatible, then what was the motivation for
6a108a14fa35? If you can never change EMBEDDED's semantics, in order to
maintain backward compatibility, then you can never stop selecting EXPERT,
and EXPERT can never lose its side effects. So 6a108a14fa35 achieved
nothing other than wasting a potentially useful config option name.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757824Ab2AMKxf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 05:53:35 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49533 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab2AMKxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 05:53:31 -0500
Date: Fri, 13 Jan 2012 02:53:27 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Jones <drjones@redhat.com>
cc: Arnd Bergmann <arnd@arndb.de>, akpm@linux-foundation.org,
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
In-Reply-To: <20120113085125.GA2452@turtle.usersys.redhat.com>
Message-ID: <alpine.DEB.2.00.1201130230320.15417@chino.kir.corp.google.com>
References: <1326295008-29795-1-git-send-email-drjones@redhat.com> <alpine.DEB.2.00.1201111353330.21755@chino.kir.corp.google.com> <201201120918.53026.arnd@arndb.de> <20120112101805.GA2375@turtle.usersys.redhat.com> <alpine.DEB.2.00.1201121259270.17287@chino.kir.corp.google.com>
 <20120113085125.GA2452@turtle.usersys.redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jan 2012, Andrew Jones wrote:

> We seem to be talking about two different time periods where the semantics
> changed, or didn't change. I'm stating that this patch reverts the
> semantics for EMBEDDED back to the way they were at 6a108a14fa35^, i.e.
> not inventing a new meaning, just reverting to the old one. Thus, relative
> to that time, there is no change.

That's the insanity that we're trying to avoid.  EMBEDDED prior to 
6a108a14fa35 wasn't sane in any way since it didn't represent anything 
even remotely related to embedded devices.  It was hijacked to be a config 
option that users would set so that they could disable (or, in some cases, 
enable) options that would be considered standard.  This isn't something 
that is restricted only to the embedded world and that's why a new config 
symbol, CONFIG_EXPERT, was introduced to take its place.

> You are stating that there is a
> semantics change relative to the way it is now, HEAD, which is true.
> The impact of that change isn't so much though. If you look at the patch
> you'll see EMBEDDED is only used around 30 times on the default value
> manipulations. EXPERT is still the only config option exposing symbol.
> 

What would be helpful is if CONFIG_EMBEDDED actually meant what it 
implies, i.e. for config options that only make sense on embedded devices 
(similar to CONFIG_SMALLMEM I mentioned earlier, but more focused).

> Considering part of the motivation for 6a108a14fa35 was to restore EMBEDDED's
> semantics to the way they were long ago, then I can see why this reversion
> (however small it is) isn't overly welcomed. Naturally, 6a108a14fa35
> succeeds at this goal of restoring EMBEDDED's original semantics, because
> it pushed the mess onto a new symbol name, thus freeing itself to be
> redefined.

We were tired of adding new config symbols under the illusion that 
CONFIG_EMBEDDED actually made any sense.  I wanted to make CONFIG_ZONE_DMA 
configurable on x86 like it was on other archs, and the only way to do 
that sanely would be to make it part of a non-standard kernel.  It was 
proposed to rename EMBEDDED to EXPERT at that time since users should only 
enable EXPERT, and be able to configure parts of the kernel (such as 
ZONE_DMA) that are considered standard.  You need prior knowledge before 
disabling such a config option, and that's why it's named EXPERT.  It has 
_nothing_ to do with the embedded world.  The embedded world will 
naturally want to disable options that are considered standard, and that's 
why it currently selects EXPERT, but we'd like to be able to separate 
those out so they can make more sane decisions and introduce things like 
"depends on EXPERT || EMBEDDED".

> However, 6a108a14fa35 also claims a second motivation as well,
> which is to offer the wider kernel a symbol that can be used to hide
> standard config options in menus. On this goal 6a108a14fa35 fails.
> CONFIG_EXPERT, as it stands, is useless to all users except the original
> users of CONFIG_EMBEDDED at time 6a108a14fa35^.
> 

Um, no, you can enable CONFIG_EXPERT without CONFIG_EMBEDDED which allows 
the latter to become a subset that actually makes sense semantically.  We 
want a CONFIG_EMBEDDED to open up configuring things like slab allocators 
for a small memory footprint but not everything that CONFIG_EXPERT offers.  
That's the direction that CONFIG_EMBEDDED is moving.

> Ideally EMBEDDED would have been tidied up more before its renaming (in
> order to avoid advertising a useless symbol in the first place).

Don't think of 6a108a14fa35 as renaming CONFIG_EMBEDDED to CONFIG_EXPERT, 
think of it as adding CONFIG_EXPERT which is what it really does and frees 
up CONFIG_EMBEDDED to return to its logical semantics by becoming a subset 
of CONFIG_EXPERT.

> However,
> in the absence of ideal patches, we always have reversions to patches and
> then new patches. This patch is that first (partial) reversion step, but
> the additional patches that will eventually reclaim EMBEDDED's long lost,
> ideal semantics are outside its scope.
> 

Then nack, but you're more than welcome to help speed up the usefulness of 
CONFIG_EMBEDDED by identifying config options that only make sense on 
embedded devices and then perhaps someday it might not need to select all 
of CONFIG_EXPERT and can be generally useful by adding the appropriate 
"depends on EXPERT || EMBEDDED".

> > You're ignoring backwards compatibility for users who have already enabled 
> > CONFIG_EXPERT and have not enabled CONFIG_EMBEDDED (EXPERT does not select 
> > EMBEDDED, EMBEDDED selects EXPERT).  So if you're losing options that are 
> > currently configurable with CONFIG_EXPERT unless those users now enable 
> > CONFIG_EMBEDDED again, it's a non-starter.
> 
> While, afaik, backward compatibility of kernel config symbols isn't
> guaranteed (I've seen non-backward compatible changes in the past), I
> still didn't ignore it. Part of the reason to go back to using EMBEDDED
> again was to address it (EMBEDDED was already used for this before). Also,
> while it naturally doesn't address configs outside the kernel source, the
> patch does update all defconfig files appropriately to add EMBEDDED
> wherever EXPERT was.
> 

That's bogus, config EMBEDDED was used to select the new EXPERT so there 
was no backwards compatibility issue.  I'd agree with you that your patch 
would be backwards compatible and doesn't suddenly, and silently, lose 
config options that were previously enabled when running make oldconfig if 
everybody in the world used defconfigs.  That's not the case, which is why 
this is a non-starter.

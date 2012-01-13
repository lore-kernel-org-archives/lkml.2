Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483Ab2AMIxx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 03:53:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755323Ab2AMIxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 03:53:50 -0500
Date: Fri, 13 Jan 2012 09:51:26 +0100
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
Message-ID: <20120113085125.GA2452@turtle.usersys.redhat.com>
References: <1326295008-29795-1-git-send-email-drjones@redhat.com>
 <alpine.DEB.2.00.1201111353330.21755@chino.kir.corp.google.com>
 <201201120918.53026.arnd@arndb.de>
 <20120112101805.GA2375@turtle.usersys.redhat.com>
 <alpine.DEB.2.00.1201121259270.17287@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1201121259270.17287@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 01:06:51PM -0800, David Rientjes wrote:
> On Thu, 12 Jan 2012, Andrew Jones wrote:
> 
> > No, I'm putting EMBEDDED back to work doing the same thing it did before,
> > i.e. the semantics for it are the same as they were before 6a108a14fa35.
> 
> Wrong, CONFIG_EMBEDDED actually had very loosely defined semantics prior 
> ot 6a108a14fa35 (the renaming of CONFIG_EMBEDDED to CONFIG_EXPERT) which 
> is why it was renamed in the first place.  Instead of being used solely 
> for embedded devices, as you would suspect given its name and the reason 
> it was introduced, it was hijacked to be used for any config option that 
> was atypical for normal admins to disable and thus considered to be 
> "expert" since it required a deeper level of understanding than enabling 
> and disabling options at first glance or what is considered to be 
> standard.  Those are two very different semantics.

We seem to be talking about two different time periods where the semantics
changed, or didn't change. I'm stating that this patch reverts the
semantics for EMBEDDED back to the way they were at 6a108a14fa35^, i.e.
not inventing a new meaning, just reverting to the old one. Thus, relative
to that time, there is no change. You are stating that there is a
semantics change relative to the way it is now, HEAD, which is true.
The impact of that change isn't so much though. If you look at the patch
you'll see EMBEDDED is only used around 30 times on the default value
manipulations. EXPERT is still the only config option exposing symbol.

Considering part of the motivation for 6a108a14fa35 was to restore EMBEDDED's
semantics to the way they were long ago, then I can see why this reversion
(however small it is) isn't overly welcomed. Naturally, 6a108a14fa35
succeeds at this goal of restoring EMBEDDED's original semantics, because
it pushed the mess onto a new symbol name, thus freeing itself to be
redefined. However, 6a108a14fa35 also claims a second motivation as well,
which is to offer the wider kernel a symbol that can be used to hide
standard config options in menus. On this goal 6a108a14fa35 fails.
CONFIG_EXPERT, as it stands, is useless to all users except the original
users of CONFIG_EMBEDDED at time 6a108a14fa35^.

Ideally EMBEDDED would have been tidied up more before its renaming (in
order to avoid advertising a useless symbol in the first place). However,
in the absence of ideal patches, we always have reversions to patches and
then new patches. This patch is that first (partial) reversion step, but
the additional patches that will eventually reclaim EMBEDDED's long lost,
ideal semantics are outside its scope.

> 
> > This is not a revert of that patch though. I'm keeping EXPERT, but
> > ensuring it doesn't do everything EMBEDDED used to do. I'm ensuring it
> > only does what it advertises it does, which is to give a useful configmenu
> > cleanup symbol to the whole kernel.
> > 
> 
> You're ignoring backwards compatibility for users who have already enabled 
> CONFIG_EXPERT and have not enabled CONFIG_EMBEDDED (EXPERT does not select 
> EMBEDDED, EMBEDDED selects EXPERT).  So if you're losing options that are 
> currently configurable with CONFIG_EXPERT unless those users now enable 
> CONFIG_EMBEDDED again, it's a non-starter.

While, afaik, backward compatibility of kernel config symbols isn't
guaranteed (I've seen non-backward compatible changes in the past), I
still didn't ignore it. Part of the reason to go back to using EMBEDDED
again was to address it (EMBEDDED was already used for this before). Also,
while it naturally doesn't address configs outside the kernel source, the
patch does update all defconfig files appropriately to add EMBEDDED
wherever EXPERT was.

Drew

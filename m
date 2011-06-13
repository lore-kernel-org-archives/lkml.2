Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab1FMTe5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 15:34:57 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46693 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645Ab1FMTe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 15:34:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=ffwll.ch; s=google;
        h=sender:date:from:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-type:content-disposition
         :in-reply-to:x-operating-system:user-agent;
        b=YETzKnXD+3nHUPKzUXF233TwbsjVkbBmwXuKIU1dnMJ6O6AUj3pLJxRwGXmePTRUNH
         imSW7PAPyjYBCaSDx24e2qBsv2TmKuxlOt5Tpw8hUkukGNrqpCFVFHK/TrLabgkdhW2W
         5fMF3K5ifuaQp2FJSEcG1twi+GHM4uULkPvuY=
Date: Mon, 13 Jun 2011 21:35:32 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Daniel Vetter <daniel@ffwll.ch>,
        Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
        Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, greg@kroah.com
Subject: Re: [PATCH 14/15] gma500: nuke the PSB debug stuff
Message-ID: <20110613193532.GB2761@phenom.ffwll.local>
Mail-Followup-To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org, greg@kroah.com
References: <20110608100411.9478.86672.stgit@localhost.localdomain>
 <20110608101515.9478.67943.stgit@localhost.localdomain>
 <BANLkTikYtLExBTcYAwicjEH=1bQp28WitQ@mail.gmail.com>
 <20110609091103.4b61f2a1@lxorguk.ukuu.org.uk>
 <1307615814.5963.2.camel@t60prh>
 <BANLkTikvteDhzirKUxDcnD8dykw_00ec=A@mail.gmail.com>
 <20110609130431.0c29218a@lxorguk.ukuu.org.uk>
 <BANLkTi=WhtbST=GxP9Q03L0bhppFuozjsw@mail.gmail.com>
 <20110613164403.4cb74675@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110613164403.4cb74675@lxorguk.ukuu.org.uk>
X-Operating-System: Linux phenom 3.0.0-rc2-00367-g69fbde8
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 04:44:03PM +0100, Alan Cox wrote:
> > Given that I've mucked around in drm_mm quite a bit I'd be very interested
> > in your opinion about what's weird in it (and presumably what could be
> > improved). Can you elaborate?
> 
> Mostly the API, which is also somewhat poorly documented. I've not dug
> into the internals beyond trying to figure out how to use it. Looking at
> the users the API is non-obvious, the interface involves a mix of calls
> and digging deep into struct internals.

Well, I've rewritten the api but that transition is not yet complete, i.e.
the new interface is there, but no driver is converted yet. The old api
has a two-step allocation (search_free + get_block) and frees allocated
ranges with put_block. The new api has just insert_node and remove_node,
struct drm_mm_node must be allocated by the caller (to get rid of the racy
preallocation scheme and allow embedding of drm_mm_node).

There's also the lru scanning helpers (only used by intel). Under specific
conditions (should be all documented in comments) this can be used as an
eviction roaster.

Generally only node->start should be used by drivers, otherwise
drm_mm_node should be opaque. At least that's the idea.

btw, old conversion patches for i915 to the new interface are at:

http://cgit.freedesktop.org/~danvet/drm/log/?h=embed-gtt-space

When creating the new interfaces I've tried to document them. Ideas to
improve that highly welcome.

> I'd have expected an API that had allocate/free type methods and exposed
> the needed information directly or very easily not one that has drivers
> doing. drm_sman seems to be attempt in that direction but its also rather
> odd with interfaces like

Should be fixed, see above ;-)

[snip]

> Possibly drm_sman and friends should just wrap whatever simple native
> allocator exists on the OS ?

Well, drm_mm has some graphics specific magic (range restricted scans and
the eviction helpers). But simpler stuff like sman is imo just "drm likes
to reinvent the wheel". Unfortunately I don't have the hw, so I haven't
dared to touch it (the snippet you've posted is a prime example why).

Yours, Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48

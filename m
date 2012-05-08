Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836Ab2EHHUJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 03:20:09 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:35269 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548Ab2EHHUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 03:20:06 -0400
Date: Tue, 8 May 2012 09:21:09 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>
Cc: =?iso-8859-1?Q?St=E9phane?= Marchesin <marcheu@chromium.org>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        olofj@chromium.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] mm: Work around Intel SNB GTT bug with some physical
 pages.
Message-ID: <20120508072109.GA4802@phenom.ffwll.local>
Mail-Followup-To: Dave Airlie <airlied@gmail.com>,
	=?iso-8859-1?Q?St=E9phane?= Marchesin <marcheu@chromium.org>,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	olofj@chromium.org, torvalds@linux-foundation.org
References: <1336432421-17972-1-git-send-email-marcheu@chromium.org>
 <CAPM=9txbqEsejvtQJ9XfRcuU-vwJUkASTW6cxEhbwf0tUTSTow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPM=9txbqEsejvtQJ9XfRcuU-vwJUkASTW6cxEhbwf0tUTSTow@mail.gmail.com>
X-Operating-System: Linux phenom 3.4.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2012 at 07:53:36AM +0100, Dave Airlie wrote:
> On Tue, May 8, 2012 at 12:13 AM, Stéphane Marchesin
> <marcheu@chromium.org> wrote:
> > While investing some Sandy Bridge rendering corruption, I found out
> > that all physical memory pages below 1MiB were returning garbage when
> > read through the GTT. This has been causing graphics corruption (when
> > it's used for textures, render targets and pixmaps) and GPU hangups
> > (when it's used for GPU batch buffers).
> >
> > I talked with some people at Intel and they confirmed my findings,
> > and said that a couple of other random pages were also affected.
> >
> > We could fix this problem by adding an e820 region preventing the
> > memory below 1 MiB to be used, but that prevents at least my machine
> > from booting. One could think that we should be able to fix it in
> > i915, but since the allocation is done by the backing shmem this is
> > not possible.
> >
> > In the end, I came up with the ugly workaround of just leaking the
> > offending pages in shmem.c. I do realize it's truly ugly, but I'm
> > looking for a fix to the existing code, and am wondering if people on
> > this list have a better idea, short of rewriting i915_gem.c to
> > allocate its own pages directly.
> 
> Ouch, can Intel get some details on why these pages are "special" and
> if they are special across chipsets, Ironlake? Ivybridge?
> 
> Like I can handle the < 1MB but the other selected pages look pretty
> random or misc, (2005, 2011, 2013? years?, 40004000, some shout out to
> the 4004?

I've discussed this with Stéphane, and that enumeration of 5 pages is
exhaustive. And both these 4 pages and the low 1mb block only cause
problems on snb (ivb and later is fixed). For the special pages the
official workaround is that the bios marks the two 2M blocks of memory at
512M and 1024M as reserved. And for the low 1M I guess Windows doesn't
hand out any of these to device drivers.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48

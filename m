Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423410Ab2KNURv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 15:17:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37609 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423370Ab2KNURs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 15:17:48 -0500
Date: Wed, 14 Nov 2012 12:17:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linus <torvalds@linux-foundation.org>,
        dri-devel@lists.freedesktop.org, Dave Airlie <airlied@gmail.com>
Subject: Re: linux-next: Tree for Nov 14 (gpu/drm/i915)
Message-Id: <20121114121747.46ffe05f.akpm@linux-foundation.org>
In-Reply-To: <50A3F3FD.4070707@infradead.org>
References: <20121114163042.64f0c0495663331b9c2d60d6@canb.auug.org.au>
	<50A3F3FD.4070707@infradead.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2012 11:41:49 -0800
Randy Dunlap <rdunlap@infradead.org> wrote:

> On 11/13/2012 09:30 PM, Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > News: next-20121115 (i.e. tomorrow) will be the last release until
> > next-20121126 (which should be just be after -rc7, I guess - assuming
> > that Linus does not release v3.7 before then), so if you want something
> > in linux-next for a reasonable amount of testing, it should probably be
> > committed tomorrow.
> > 
> > Changes since 20121113:
> > 
> 
> 
> 
> on i386:
> 
> ERROR: "__build_bug_on_failed" [drivers/gpu/drm/i915/i915.ko] undefined!
> 
> Reference to that symbol is found in
> i915_gem_execbuffer.o.  Reference to BUILD_BUG_ON() is found in
> i915_gem_execbuffer.c:
> 
> static struct eb_objects *
> eb_create(int size)
> {
> 	struct eb_objects *eb;
> 	int count = PAGE_SIZE / sizeof(struct hlist_head) / 2;
> 	BUILD_BUG_ON(!is_power_of_2(PAGE_SIZE / sizeof(struct hlist_head)));
> 

Where to start.

- eb_create() has no business assuming that the hlist_head has any
  particular size.  We could easily add some conditionally-compiled
  debug fields in there, and drm blows up.

- The assertion is obviously true at present, so I assume that gcc
  screwed up and failed to reduce all that to a compile-time constant.

- We have a BUILD_BUG_ON_NOT_POWER_OF_2().  Use it?

- This code is using PAGE_SIZE to scale a kernel data structure. 
  PAGE_SIZE can vary by a factor of 16, depending on Kconfig.  This
  can result in 64k PAGE_SIZE machines exhibiting different beahviour
  from that which the testers saw.

  Don't do it.  It's better to hard-wire 4096.


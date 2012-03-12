Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005Ab2CLX0o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 19:26:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47811 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757396Ab2CLX0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 19:26:43 -0400
Date: Mon, 12 Mar 2012 19:26:30 -0400
From: Dave Jones <davej@redhat.com>
To: Keith Packard <keithp@keithp.com>
Cc: Yang Bai <hamo.by@gmail.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>, kernel@tesarici.cz
Subject: Re: inode->i_wb_list corruption.
Message-ID: <20120312232630.GA20287@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Keith Packard <keithp@keithp.com>, Yang Bai <hamo.by@gmail.com>,
	Fengguang Wu <fengguang.wu@intel.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Fedora Kernel Team <kernel-team@fedoraproject.org>,
	kernel@tesarici.cz
References: <20120306185137.GA15881@redhat.com>
 <20120306210307.GC8781@quack.suse.cz>
 <20120307072608.GA24087@localhost>
 <20120307104240.GB18658@quack.suse.cz>
 <CAO_0yfNt2jgiTPZn5NkwBAjQZtk+377gG71d6QOuXQrDHjdkEg@mail.gmail.com>
 <20120309145713.GA21543@redhat.com>
 <20120309151951.GA30160@redhat.com>
 <CAO_0yfMYOOTvRg9=8_eYP09o0BpzSEk=8vqgNk_vV_u3-biAYA@mail.gmail.com>
 <20120309180015.GA3862@redhat.com>
 <868vj97d20.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <868vj97d20.fsf@sumi.keithp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2012 at 12:08:07PM -0800, Keith Packard wrote:
 > <#part sign=pgpmime>
 > On Fri, 9 Mar 2012 13:00:15 -0500, Dave Jones <davej@redhat.com> wrote:
 > 
 > > i915_drm_thaw is a deep nest of functions though, so this is going to be
 > > hard to track down where that write is coming from. Because the corruption
 > > seems to happen to pages that are already allocated, we probably can't
 > > even rely on DEBUG_PAGEALLOC, though it might be worth trying.
 > 
 > I'm worried that the write is coming through the GTT, which would make
 > sense as these look like pixel values. If this is on Ironlake (core
 > I3-I7 first gen), we know there are issues when VT-d is enabled, and
 > the work-around for that doesn't appear to be in place for the hibernate
 > resume case.

Thinking about how the GTT could contain stale pointers, I came up with this scenario:

Before we begin the thaw, the initramfs sets up a framebuffer.
This causes the GTT to be setup.

- Thaw begins, hardware state still points to the GTT setup by the modesetting code.
  At this point, any graphics operations are going to cause writes through
  those translations. Bad news if we just wrote a bunch of thawed data there.

  or..

- Thaw begins, and data is written over the GTT setup by the initramfs, but 
  the hardware registers still points at it, until thaw is complete, when we
  reprogram the GTT registers to their pre-hibernate values.

If we could somehow set modeset=0 automatically if we detect a hibernate
partition it would probably 'solve' it, but I suspect the real answer
would be to do GTT teardown before we do a thaw.

	Dave


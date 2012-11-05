Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab2KEUaR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 15:30:17 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52514 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889Ab2KEUaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 15:30:15 -0500
From: Lekensteyn <lekensteyn@gmail.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Norbert Preining <preining@logic.at>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: [bisected] drm i915 hangs on heavy io load
Date: Mon, 05 Nov 2012 21:29:53 +0100
Message-ID: <2841410.AEaCaTYTzS@al>
User-Agent: KMail/4.9.2 (Linux/3.6.0-rc2-git-87-g0327d6b+; KDE/4.9.2; x86_64; ; )
In-Reply-To: <CAPM=9txgXLHQPCP4egU57P0=pACmKZnAzwgj6fNxR5-4nwOF6A@mail.gmail.com>
References: <20121023053830.GA30776@gamma.logic.tuwien.ac.at> <20121104004431.GG6196@gamma.logic.tuwien.ac.at> <CAPM=9txgXLHQPCP4egU57P0=pACmKZnAzwgj6fNxR5-4nwOF6A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 November 2012 16:08:47 Dave Airlie wrote:
> On Sun, Nov 4, 2012 at 10:44 AM, Norbert Preining <preining@logic.at> wrote:

> > On Di, 30 Okt 2012, Dave Airlie wrote:
> >> I would suggest starting a bisect on drivers/gpu/drm/i915 from 3.6
> >> final to 3.7-rc1 or maybe -rc2.
> > 
> > Sorry for my ignorance ... I did on master branch
> > 
> >         $ git checkout v3.7-rc1
> >         ...
> >         $ git bisect start drivers/gpu/drm/i915
> >         $ git bisect bad
> >         $ git bisect good v3.6
> >         Bisecting: 121 revisions left to test after this (roughly 7 steps)
> >         [25c5b2665fe4cc5a93edd29b62e7c05c15dddd26] drm/i915: implement new
> >         set_mode code flow $
> > 
> > after that I am back somewhere around
> > 
> >         3.6.0-rc2
> > 
> > ???
> > 
> > Am I doing something wrong? I thought I am bisecting between 3.6 and
> > 3.7.-rc2? How can I go back to 3.6.0-rc2?
> 
> Yeah thats fine, bisecting works by going to where commits were
> originally committed, so drm-intel-next was 3.6.0-rc2 at some point
> was only merged into Linus later.

As I mentioned on https://bugs.freedesktop.org/show_bug.cgi?id=55984, I also 
hit this bug. The first time was on branch drm-intel-next-2012-09-20 on Daniel 
Vetters drm-intel git.

I guess it has something to do with low memory. To reproduce the bug on my 
laptop with 8GB RAM and a i5-460M, I did:

1. Boot (I use KDE)
3. Start glxspheres (from http://virtualgl.org/, but glxgears might work too, 
not tested)
2. Copy a 1.2 GiB Linux source tree to /dev/shm and /tmp (both tmpfs), 5 
times. This uses 6GiB of RAM. I used this bash script:
#!/bin/bash
for i in /tmp/hang-l1 /tmp/hang-l2 /tmp/hang-l3 \
/dev/shm/hang-l1 /dev/shm/hang-l2; do
        cp -ra ~/Linux-src/linux "$i" &
done; wait
3. When the copy is almost done, watch the machine become sluggish and 
eventually print the "[drm:i915_hangcheck_hung] *ERROR* Hangcheck timer 
elapsed... GPU hung" message to the kernel log. Until the machine is rebooted, 
all OpenGL applications will fail to load.

On kernels where it was working fine, there is no lag when the copy is almost 
finished.

504c7267a1e84b157cbd7e9c1b805e1bc0c2c846 is the first bad commit
commit 504c7267a1e84b157cbd7e9c1b805e1bc0c2c846
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Thu Aug 23 13:12:52 2012 +0100

    drm/i915: Use cpu relocations if the object is in the GTT but not mappable
    
    This prevents the case of unbinding the object in order to process the
    relocations through the GTT and then rebinding it only to then proceed
    to use cpu relocations as the object is now in the CPU write domain. By
    choosing to use cpu relocations up front, we can therefore avoid the
    rebind penalty.
    
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
    Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>

:040000 040000 090ed3d52b4f3210b988877f747b6ff86e123385 
1d48be89ded4777a543b693db833de64877059c4 M      drivers

Regards,
Peter

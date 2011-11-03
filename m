Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab1KCWJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 18:09:29 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56931 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab1KCWJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 18:09:26 -0400
Date: Thu, 3 Nov 2011 23:10:24 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Keith Packard <keithp@keithp.com>
Cc: Daniel Vetter <daniel@ffwll.ch>, Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>, stable@kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Morton, Andrew" <akpm@linux-foundation.org>
Subject: Re: [Intel-gfx] [PATCH 2/2] drm/i915: properly prefault for
 pread/pwrite
Message-ID: <20111103221024.GG2970@phenom.ffwll.local>
Mail-Followup-To: Keith Packard <keithp@keithp.com>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	intel-gfx <intel-gfx@lists.freedesktop.org>, stable@kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>,
	"Morton, Andrew" <akpm@linux-foundation.org>
References: <1317203844-2930-1-git-send-email-daniel.vetter@ffwll.ch>
 <1317203844-2930-2-git-send-email-daniel.vetter@ffwll.ch>
 <f80fcd$212d29@fmsmga001.fm.intel.com>
 <20111023101830.GE2953@phenom.ffwll.local>
 <yun7h3vbjgc.fsf@aiko.keithp.com>
 <20111023221157.GH2953@phenom.ffwll.local>
 <yunzkgcrk40.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yunzkgcrk40.fsf@aiko.keithp.com>
X-Operating-System: Linux phenom 3.1.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 03, 2011 at 02:06:55PM -0700, Keith Packard wrote:
> On Mon, 24 Oct 2011 00:11:57 +0200, Daniel Vetter <daniel@ffwll.ch> wrote:
> 
> > This patch only fixes things up so that we prefault the entire page range
> > and not just the first PAGE_SIZE bytes (i.e. at most 2 pages). So I don't
> > see the risk of extending the current behaviour to all pages. Userspace
> > can already see these zero writes, but only when doing something stupid.
> 
> When we posted a patch to instead fix fault_in_pages_writeable, Andrew
> complained that we'd have modified memory even on a short read, which
> wasn't considered polite. Could we read/write the same value and avoid
> that problem?

Hm, that might be a solution. My current plan was to ditch the prefault
for writing to userspace and beat my pwrite/pread patches into shape for
submission - the bug report only concerns -EFAULT due to handing in a gtt
mapping in pwrite, afaik.

otoh gem objects never change their size and we return -EINVAL if the read
would go past the end of it. And userspace should also never see short
reads due to signals, because the libdrm ioctl automatically restarts the
syscall - and that part is more or less abi. So in practice for our case,
I think it just doesn't matter because userspace really only sees these
zero writes when doing something buggy.

> Also, we should be fixing fault_in_pages_* going forward, rather than
> kludging in more code. And, we'd get to remove the version in ntfs,
> which should end in a patch that removes more code than it adds...

Hm, haven't noticed the version in nfs. The version in pagemap.h does what
all the other users of it want, namely prefault at most PAGE_SIZE bytes
(from at most two pages, in case the user pointer crosses a page boundary).
Which is why I've left it as is.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48

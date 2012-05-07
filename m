Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab2EGIG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 04:06:56 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:59596 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349Ab2EGIGw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 04:06:52 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20120507134513.bffe9dbda0fac21e472215b5@canb.auug.org.au>
References: <20120507134513.bffe9dbda0fac21e472215b5@canb.auug.org.au>
Date: Mon, 7 May 2012 10:06:52 +0200
Message-ID: <CAKMK7uFVURzdH-NKBaE7CHgbK8QfGtwcQ_12-9T_oVU4PnxK9g@mail.gmail.com>
Subject: Re: linux-next: manual merge of the drm tree with Linus' tree
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Dave Airlie <airlied@linux.ie>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 7, 2012 at 5:45 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Today's linux-next merge of the drm tree got a conflict in
> drivers/gpu/drm/i915/intel_display.c between commit 074b5e1a99fb
> ("drm/i915: Do not read non-existent DPLL registers on PCH hardware")
> from Linus' tree and I have no idea which commits from the drm tree.

The merge should be pretty simple, the problem is that git gets
completely confused.The offending commits in drm-next are
14415745b2..1fa611065 which simply moves a few functions from
intel_display.c to intel_pm.c. The offending commit in -fixes doesn't
touch these functions at all.

The problem seems to be that git diff gets completely confused:

$ git diff 14415745b2..1fa611065
is a nice mess in intel_display.c, and the diff leaks into totally
unrelated functions, whereas
$git diff --minimal  14415745b2..1fa611065
seems to be exactly what we want.

Unfortunately I haven't found any way to teach similar smarts to the
merge diff and merge conflict generation - with the minimal diff there
really shouldn't be any conflict with this patch

> I fixed it up (I think), but, again, the merge diff is way to log to
> post ...
>
> Again, Dave, can you cherry-pick or merge the commits that affect the drm
> tree from Linus' tree, please?  Surely those fixes are needed in the drm
> tree as well - or if they are not, then let me know and I will just use
> the drm tree's version of this file.

I'll sort this out with Dave. The problem though is that because git
is so confused, almost every intel_display.c patch in -fixes conflicts
with -next. And every time we change something in -next, the confused
diff moves around a bit, making also git rerere pretty useless. So
we'd need a backmarge of -fixes into -next an awful lot of times,
which is why I've held off doing the merge for as long as possible.

Does any of the git gurus have a good idea for how to get myself out
of this corner?

Another thing: Can you please add the new drm/i915 -next tree to
linux-next? With the new drm/i915 -next process we have about 2-3
weeks of lead time between the intel tree and Dave's tree for internal
QA and testing, so that we can sort out these issues earlier:

git://people.freedesktop.org/~danvet/drm-intel drm-intel-next-queued

[Note the -queued, -next is frozen every 2 weeks so that QA has a
known base for the manual testing cycle.]

Cheers, Daniel
-- 
Daniel Vetter
daniel.vetter@ffwll.ch - +41 (0) 79 365 57 48 - http://blog.ffwll.ch

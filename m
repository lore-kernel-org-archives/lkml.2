Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750932Ab1LGFBb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 00:01:31 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:64642 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab1LGFBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 00:01:30 -0500
X-Nat-Received: from [202.181.97.72]:60430 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1323234081.21100
Message-Id: <201112070501.pB751LoP064331@www262.sakura.ne.jp>
Subject: Re: [git pull] apparmor fix for __d_path() misuse
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: viro@ZenIV.linux.org.uk
Cc: john.johansen@canonical.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Wed, 07 Dec 2011 14:01:21 +0900
References: <4EDE94DC.8010106@canonical.com> <20111206224100.GM2203@ZenIV.linux.org.uk> <4EDEA152.90804@canonical.com> <CA+55aFwn=n5H_PuaRhnVPpMtfeig8nSi+Wj4Yzv6VBdjkUBEjw@mail.gmail.com> <20111207001643.GN2203@ZenIV.linux.org.uk> <20111207003922.GO2203@ZenIV.linux.org.uk> <CA+55aFyaz7K4V5xLmaQ9GK=5LA1mbRdVGCFspET=y6ode_i=jg@mail.gmail.com> <20111207011047.GQ2203@ZenIV.linux.org.uk> <20111207013720.GS2203@ZenIV.linux.org.uk> <201112070326.pB73QPZo042162@www262.sakura.ne.jp> <20111207034238.GX2203@ZenIV.linux.org.uk>
In-Reply-To: <20111207034238.GX2203@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 07122011 #5941518, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> > How commonly can conditions that make d_absolute_path() return -EINVAL happen?
> 
> Race with umount -l, basically.

d_absolute_path() will return -EINVAL if lazy unmount happens. I see.

Then, I prefer not denying the request with -EINVAL no matter how unreliable
the returned pathname is. I don't want to deny the request unless -ENOMEM
happens or rejected by the policy.

> In that case the pathname is completely
> unreliable - if I do umount -l /mnt, pathnames that would be under mnt
> may get truncated on *ANY* mountpoint.  Not "always cut on /mnt"; not "always
> cut on the last mountpoint"; it's "everything from root to arbitrary mountpoint
> on that path is not noticed".

Unfortunate specification for pathname based access control.
But since I assume that multiple LSM modules can run in parallel
( http://sourceforge.jp/projects/tomoyo/docs/lca2009-kumaneko.pdf),
I leave more stricter decisions to inode based access control.

So, can we keep behavior of tomoyo_get_absolute_path() unchanged?

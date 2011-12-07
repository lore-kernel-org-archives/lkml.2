Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441Ab1LGFol (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 00:44:41 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:58566 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab1LGFoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 00:44:39 -0500
X-Nat-Received: from [202.181.97.72]:54015 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1323236673.31383
Message-Id: <201112070544.pB75iX12072157@www262.sakura.ne.jp>
Subject: Re: [git pull] apparmor fix for __d_path() misuse
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: viro@ZenIV.linux.org.uk
Cc: john.johansen@canonical.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Wed, 07 Dec 2011 14:44:33 +0900
References: <4EDEA152.90804@canonical.com> <CA+55aFwn=n5H_PuaRhnVPpMtfeig8nSi+Wj4Yzv6VBdjkUBEjw@mail.gmail.com> <20111207001643.GN2203@ZenIV.linux.org.uk> <20111207003922.GO2203@ZenIV.linux.org.uk> <CA+55aFyaz7K4V5xLmaQ9GK=5LA1mbRdVGCFspET=y6ode_i=jg@mail.gmail.com> <20111207011047.GQ2203@ZenIV.linux.org.uk> <20111207013720.GS2203@ZenIV.linux.org.uk> <201112070326.pB73QPZo042162@www262.sakura.ne.jp> <20111207034238.GX2203@ZenIV.linux.org.uk> <201112070501.pB751LoP064331@www262.sakura.ne.jp> <20111207051908.GA2203@ZenIV.linux.org.uk>
In-Reply-To: <20111207051908.GA2203@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 07122011 #5941518, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> > So, can we keep behavior of tomoyo_get_absolute_path() unchanged?
> 
> Sure, you are always free to add
> 	if (pos == ERR_PTR(-EINVAL)) {
> 		pos = dentry_path(path->dentry, ...)
> 		/* do whatever you want to buffer to indicate that
> 		 * beginning had been lost
> 		 */
> 	}

Maybe I can call tomoyo_get_local_path() if tomoyo_get_absolute_path() failed
with -EINVAL.

> Or you might want to do __d_path() from (path->mnt,path->mnt->mnt_root) to
> path - that's the path from the last mountpoint to your object; i.e. it may
> be shorter if that vfsmount had been a binding into the guts of filesystem,
> but that is what __d_path() as you used it would stabilize to once the race
> window is over.

Excuse me, what "once the race window is over" means?
Does

  do {
    pos = d_absolute_path(path, buffer, buflen - 1);
  } while (pos == ERR_PTR(-EINVAL));

work (i.e. racing with "umount -l" is a temporary failure)?

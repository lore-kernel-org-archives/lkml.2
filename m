Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab1LGD0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 22:26:36 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:63567 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583Ab1LGD0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 22:26:35 -0500
X-Nat-Received: from [202.181.97.72]:55867 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1323228385.26889
Message-Id: <201112070326.pB73QPZo042162@www262.sakura.ne.jp>
Subject: Re: [git pull] apparmor fix for __d_path() misuse
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: viro@ZenIV.linux.org.uk
Cc: john.johansen@canonical.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Wed, 07 Dec 2011 12:26:25 +0900
References: <20111206205346.GK2203@ZenIV.linux.org.uk> <CA+55aFwbWUBs3Fy1hyP3CQ15rF2opvjxLR8gnSF5gERDGCGhOw@mail.gmail.com> <4EDE94DC.8010106@canonical.com> <20111206224100.GM2203@ZenIV.linux.org.uk> <4EDEA152.90804@canonical.com> <CA+55aFwn=n5H_PuaRhnVPpMtfeig8nSi+Wj4Yzv6VBdjkUBEjw@mail.gmail.com> <20111207001643.GN2203@ZenIV.linux.org.uk> <20111207003922.GO2203@ZenIV.linux.org.uk> <CA+55aFyaz7K4V5xLmaQ9GK=5LA1mbRdVGCFspET=y6ode_i=jg@mail.gmail.com> <20111207011047.GQ2203@ZenIV.linux.org.uk> <20111207013720.GS2203@ZenIV.linux.org.uk>
In-Reply-To: <20111207013720.GS2203@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 07122011 #5941518, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> diff --git a/security/tomoyo/realpath.c b/security/tomoyo/realpath.c
> index 738bbdf..36fa7c9 100644
> --- a/security/tomoyo/realpath.c
> +++ b/security/tomoyo/realpath.c
> @@ -101,9 +101,8 @@ static char *tomoyo_get_absolute_path(struct path *path, char * const buffer,
>  {
>         char *pos = ERR_PTR(-ENOMEM);
>         if (buflen >= 256) {
> -               struct path ns_root = { };
>                 /* go to whatever namespace root we are under */
> -               pos = __d_path(path, &ns_root, buffer, buflen - 1);
> +               pos = d_absolute_path(path, buffer, buflen - 1);
>                 if (!IS_ERR(pos) && *pos == '/' && pos[1]) {
>                         struct inode *inode = path->dentry->d_inode;
>                         if (inode && S_ISDIR(inode->i_mode)) {

Currently, TOMOYO assumes that -ENAMETOOLONG is the only error which __d_path()
might return (and retries with larger buffer size unless kmalloc() fails).
If d_absolute_path() starts returning -EINVAL, TOMOYO will deny requests even
if "partial (I mean the result would have been different if reachable)"
pathname is granted by the policy.

How commonly can conditions that make d_absolute_path() return -EINVAL happen?



Linus Torvalds wrote:
> I don't know of any big distro that uses Tomoyo, so...
Ubuntu, Debian, OpenSUSE, ArchLinux, Mandriva...
Hope you know one of these distro. ;-)

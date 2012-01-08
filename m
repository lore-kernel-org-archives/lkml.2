Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab2AHXFS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 18:05:18 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:50841 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602Ab2AHXEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 18:04:53 -0500
MIME-Version: 1.0
In-Reply-To: <20120105022318.GG23916@ZenIV.linux.org.uk>
References: <20120105022318.GG23916@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 8 Jan 2012 15:04:30 -0800
X-Google-Sender-Auth: lKaRfGgvXpnrpgnFDbJ_nzc4XEE
Message-ID: <CA+55aFw+7xvfP3NCr5p2Ma--UTb7zT+QQxtjCn3V2SU_g3LUdA@mail.gmail.com>
Subject: Re: [git pull] vfs pile 1
To: Al Viro <viro@zeniv.linux.org.uk>, Miklos Szeredi <mszeredi@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm.

Al, Miklos, I just triggered the new inc_link() warning three times in
very close succession by just doing a simple

              perf record -f -e cycles:pp make -j

(I don't think the "perf record" part was actually required or
relevant, although it may have been instrumental in triggering just
the right timing)

This was in a fully built tree, I'm just checking

The warning trace looks like this:

  [ 6933.446125] ------------[ cut here ]------------
  [ 6933.446131] WARNING: at fs/inode.c:349 inc_nlink+0x30/0x40()
  [ 6933.446133] Hardware name: System Product Name
  [ 6933.446135] Pid: 22955, comm: perf Not tainted
3.2.0-03190-g972b2c719990 #72
  [ 6933.446137] Call Trace:
  [ 6933.446143]  [<ffffffff8102ee15>] warn_slowpath_common+0x75/0xb0
  [ 6933.446145]  [<ffffffff8102ef15>] warn_slowpath_null+0x15/0x20
  [ 6933.446147]  [<ffffffff810f1450>] inc_nlink+0x30/0x40
  [ 6933.446151]  [<ffffffff8116f333>] ext4_symlink+0x113/0x2c0
  [ 6933.446154]  [<ffffffff810e7b01>] vfs_symlink+0xa1/0xf0
  [ 6933.446157]  [<ffffffff810e7c03>] sys_symlinkat+0xb3/0xd0
  [ 6933.446159]  [<ffffffff810e7c31>] sys_symlink+0x11/0x20
  [ 6933.446162]  [<ffffffff816916a2>] system_call_fastpath+0x16/0x1b
  [ 6933.446164] ---[ end trace 550d4b2eb6b8fbc9 ]---

and the three warnings all triggered within 2/100th of a second of
that one (the last one had a timestamp of 6933.465678), so they are
probably all related to the same thing happening.

Any ideas?

                     Linus

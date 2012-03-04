Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab2CDC1S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 21:27:18 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:60854 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118Ab2CDC1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 21:27:16 -0500
X-Nat-Received: from [202.181.97.72]:52269 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1330828022.19740
To: torvalds@linux-foundation.org, andi@firstfloor.org, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject: Re: Word-at-a-time dcache name accesses (was Re: .. anybody know ofany filesystems that depend on the exact VFS 'namehash' implementation?)
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <alpine.LFD.2.02.1203021544300.28247@i5.linux-foundation.org><CA+55aFyMn+gYh2uRPJSAS5n4UbQoY2iqe3peYjVosrP-73oQVA@mail.gmail.com>
In-Reply-To: <CA+55aFyMn+gYh2uRPJSAS5n4UbQoY2iqe3peYjVosrP-73oQVA@mail.gmail.com>
Message-Id: <201203041127.IDI56216.FHOQMOVLtOFSJF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sun, 4 Mar 2012 11:27:01 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 04032012 #7157519, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A passer-by's mumble.

We are discussing about systems with huge "struct dentry" instances where
selecting a hash list based on "struct qstr"->hash cannot effectively narrow
down candidates to compare, aren't we?

Then, I thought we can reconstruct candidates in a hash list.

For example, sort "struct dentry" based on return value of
strcmp(dentry1->d_name.name, dentry2->d_name.name).

For another example, embed another hash value (calculated using some algorithm
that is different from the one used for "struct qstr"->hash) into the leading 1
or 2 or 4 bytes of "struct dentry"->d_name.name (e.g.

  dentry1->d_name.name == { 0x12, 0x56, 0x34, 0x78, 'n', 'a', 'm', 'e', '1' }
  dentry2->d_name.name == { 0xab, 0xcd, 0xef, 0x01, 'n', 'a', 'm', 'e', '2' }

for 32 bits hash case, where 0x12563478 is hash value for name1 and 0xabcdef01
is hash value for name2) and compare the embedded hash (e.g.

  * (u32 *) dentry1->d_name.name == * (u32 *) dentry2->d_name.name

) before starting comparison of char array (e.g.

  memcmp(dentry1->d_name.name + 4, dentry2->d_name.name + 4, len)

).

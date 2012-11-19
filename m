Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab2KSI4e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 03:56:34 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:33193 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065Ab2KSI4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 03:56:32 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: The bug of iput() removal from flusher thread?
References: <8762541uyx.fsf@devron.myhome.or.jp>
Date: Mon, 19 Nov 2012 17:56:22 +0900
In-Reply-To: <8762541uyx.fsf@devron.myhome.or.jp> (OGAWA Hirofumi's message of
	"Sat, 17 Nov 2012 17:42:30 +0900")
Message-ID: <873906vumh.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:

> Hi,
>
> In 169ebd90131b2ffca74bb2dbe7eeacd39fb83714 commit, writeback doesn't
> __iget()/iput() anymore.
>
> This means nobody moves the inode to lru list. I.e.
>
> 	new_inode()
> 	dirty_inode()
> 	iput_final()
> 		/* keep inode without adding lru */
> 	flush indoes
>         /* clean inode is not on lru */
>
> I noticed this situation in my FS though, I think the same bug is on all
> FSes of linus tree too, after this commit.
>
> Am I missing the something?

This seems to be reproducible by the following,

#!/bin/sh

for i in $(seq -w 1000); do
	for j in $(seq -w 1000); do
        	for k in $(seq -w 1000); do
                	mkdir -p $i/$j
                        echo $i/$j/$k > $i/$j/$k
                        echo 2 > /proc/sys/vm/drop_caches
                done
        done
done

Some inodes never be reclaimed, and ls -l frees those inodes (stat(2)
does iget/iput).
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

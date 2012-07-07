Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585Ab2GGRAU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 13:00:20 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:42416 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab2GGRAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 13:00:18 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: "Steven J. Magnani" <steve@digidescorp.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] fat (exportfs): reconnect file handles to evicted inodes/dentries
References: <1341342576-15394-1-git-send-email-steve@digidescorp.com>
	<1341342576-15394-3-git-send-email-steve@digidescorp.com>
	<87pq8bokcp.fsf@devron.myhome.or.jp>
	<1341606824.2214.14.camel@iscandar.digidescorp.com>
	<871ukobntl.fsf@devron.myhome.or.jp>
	<1341623782.2021.9.camel@iscandar>
	<87wr2g9kh3.fsf@devron.myhome.or.jp>
	<1341679286.2435.12.camel@iscandar>
Date: Sun, 08 Jul 2012 02:00:13 +0900
In-Reply-To: <1341679286.2435.12.camel@iscandar> (Steven J. Magnani's message
	of "Sat, 07 Jul 2012 11:41:26 -0500")
Message-ID: <87zk7bo6aq.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Steven J. Magnani" <steve@digidescorp.com> writes:

>> You mean the unhashed inode is created by ->get_parent()? If so, the
>> root cause sounds like ->get_parent() itself. If not, I'm not
>> understanding the meaning of the temporary/unofficial inode here.
>
> Maybe "private" is a better word than "unofficial". Private inodes are
> created anywhere fat_new_inode (nee fat_build_unhashed_inode) is called
> directly, instead of through fat_build_inode. So yes, this is on the
> get_parent paths (via fat_lookup_dir), and also on the fh_to_dentry path
> when inode reconstruction is necessary.
>
> With private inodes, I don't see how anyone but the code that created
> them could find them to lock them. The reason they're private is that
> they're temporary aliases; at the time they're created, we don't have
> enough information to register them in a way that others could find
> them. A lookup, etc. operation will look for the inode of the "drivers"
> directory, not the ".." of the "usb" directory. We do need these private
> inodes in order to walk directory entries. I don't think they're a
> problem that needs solving; if we didn't use private inodes, we'd still
> need a way to walk directory entries in the context of these NFS
> operations, and there would still be potential races between that and
> other operations on the filesystem.

How do you prevent to modify or free the those inode/blocks from other
path?  Yeah, it is racy. And if races is not solved, that's simply wrong
and not solution.

Although I'm not thinking deeply about NFS support on FAT. Just a idea,
the one of possible solutions would be register it to hash, and find it
on all path. So, all path will use same inode and lock.

We need the key, possible key is - if it is only directory, FAT may be
able to use i_start as additional search key.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

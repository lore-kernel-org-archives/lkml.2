Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751054Ab2LUFKi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 00:10:38 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:48123 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab2LUFKa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 00:10:30 -0500
MIME-Version: 1.0
In-Reply-To: <87623ydnvq.fsf@devron.myhome.or.jp>
References: <1353504311-6020-1-git-send-email-linkinjeon@gmail.com>
	<878v9f5ugn.fsf@devron.myhome.or.jp>
	<CAKYAXd-ydXkwDq6vkECEKPUQiNgg2+GKbL+ah9sn+uqr8BT1kQ@mail.gmail.com>
	<87k3sy17vk.fsf@devron.myhome.or.jp>
	<CAKYAXd8=7BG8NsVyvUP5xW48Y9FJpD7M95_MiJVGcwYOfYsrLA@mail.gmail.com>
	<87txs0x45r.fsf@devron.myhome.or.jp>
	<CAKYAXd8OP_FXxJWHESW_bCY1hGQuZPMJYOkLkmQ4fOkDhGO8xw@mail.gmail.com>
	<CAKYAXd9NXVsBTMpTUWxN_10z1Ozt47f6Ghvsv9rbp_Y8tVMg2A@mail.gmail.com>
	<87623ydnvq.fsf@devron.myhome.or.jp>
Date: Fri, 21 Dec 2012 14:03:19 +0900
Message-ID: <CAKYAXd8GgrG+cMN_wQDFLiuXoBPbR7c6N9eZqGCrK-OH3HpuZA@mail.gmail.com>
Subject: Re: [PATCH v5 7/8] fat (exportfs): rebuild directory-inode if
 fat_dget() fails
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/12/20, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>>> Okay, We will check how we can consolidate the 2 paths to avoid any
>>> issue.
>> Hi OGAWA.
>>
>> On checking fat_search_long() logic, it is observed that it performs
>> name based lookup of the entries in a given directory.
>> In fat_get_parent(), we do not have such information to use the
>> existing API to reconstruct the  parent inode.
>> Could you give me some hint or guide to consolidate smoothly
>> fat_search_long and current traverse_logic ?
>
> Hm, start with copy of fat_search_long() and refactoring it. With it, we
> will be able to avoid the fixed bugs.
>
> After that, we might be able to merge those somehow. Well, I'm not
> pretty sure without doing it actually though.
Hi OGAWA.

When we checked to merge it with fat_search_long, we really did not
find any possibility of code reusing for fat_traverse_cluster.
It will not be proper ? In case of fat_search_long()-> it is
performing a name based lookup in a particular directory.
While for reconnection with parent from NFS ? we do not have the name
of the parent directory. We are relying on ‘i_pos’ ? on disk position
of directory entry.
So, on first request for lookup for “..” (i.e if we call
fat_search_long(child_dir->d_inode, MSDOS_DOTDOT,2,slot_info) it will
return the directory entry for “..” itself.  From this entry we can
read the “log start” which is the starting cluster of the parent
directory, but instead we need the “directory entry” where this is
stored.
So, from this level we need to go further one level up and read the
parent ->parent-> cluster. After reading that cluster, we need to do a
lookup of the “required ipos” in this directory block.
i.e., if the path is A/B/C ? and we call the get_parent() from ‘C’. We
need to read the directory block contents of ‘A’ and from those
‘directory entries' compare the log_start with the log_start value of
B, which was obtained by doing a lookup “..” in C.
So, Instead of it, we suggest we fix the “infinite-loop” condition in
fat_traverse_logic and retain the code.
of course, we will test it with corrupted FATfs.
Please share your thoughts on this.

Thanks.
>
> Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483Ab2LUITl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 03:19:41 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:55154 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab2LUITc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 03:19:32 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v5 7/8] fat (exportfs): rebuild directory-inode if fat_dget() fails
References: <1353504311-6020-1-git-send-email-linkinjeon@gmail.com>
	<878v9f5ugn.fsf@devron.myhome.or.jp>
	<CAKYAXd-ydXkwDq6vkECEKPUQiNgg2+GKbL+ah9sn+uqr8BT1kQ@mail.gmail.com>
	<87k3sy17vk.fsf@devron.myhome.or.jp>
	<CAKYAXd8=7BG8NsVyvUP5xW48Y9FJpD7M95_MiJVGcwYOfYsrLA@mail.gmail.com>
	<87txs0x45r.fsf@devron.myhome.or.jp>
	<CAKYAXd8OP_FXxJWHESW_bCY1hGQuZPMJYOkLkmQ4fOkDhGO8xw@mail.gmail.com>
	<CAKYAXd9NXVsBTMpTUWxN_10z1Ozt47f6Ghvsv9rbp_Y8tVMg2A@mail.gmail.com>
	<87623ydnvq.fsf@devron.myhome.or.jp>
	<CAKYAXd8GgrG+cMN_wQDFLiuXoBPbR7c6N9eZqGCrK-OH3HpuZA@mail.gmail.com>
	<CAKYAXd9OhKDh5r6O=ACyDez1B2S=DB0Eo2-cSNuM1vaURmFNoQ@mail.gmail.com>
Date: Fri, 21 Dec 2012 17:19:29 +0900
In-Reply-To: <CAKYAXd9OhKDh5r6O=ACyDez1B2S=DB0Eo2-cSNuM1vaURmFNoQ@mail.gmail.com>
	(Namjae Jeon's message of "Fri, 21 Dec 2012 14:08:22 +0900")
Message-ID: <877gobn7fy.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

>>> Hm, start with copy of fat_search_long() and refactoring it. With it, we
>>> will be able to avoid the fixed bugs.
>>>
>>> After that, we might be able to merge those somehow. Well, I'm not
>>> pretty sure without doing it actually though.
> Hi OGAWA.
>
> When we checked to merge it with fat_search_long, we really did not
> find any possibility of code reusing for fat_traverse_cluster.
> It will not be proper. In case of fat_search_long()-> it is performing
> a name based lookup in a particular directory.
> While for reconnection with parent from NFS, we do not have the name
> of the parent directory. We are relying on ‘i_pos’ on disk position of
> directory entry.
> So, on first request for lookup for “..” (i.e if we call
> fat_search_long(child_dir->d_inode, MSDOS_DOTDOT,2,slot_info) it will
> return the directory entry for “..” itself.  From this entry we can
> read the “log start” which is the starting cluster of the parent
> directory, but instead we need the “directory entry” where this is
> stored.
> So, from this level we need to go further one level up and read the
> parent ->parent-> cluster. After reading that cluster, we need to do a
> lookup of the “required ipos” in this directory block.
> i.e., if the path is A/B/C and we call the get_parent() from ‘C’. We
> need to read the directory block contents of ‘A’ and from those
> ‘directory entries' compare the log_start with the log_start value of
> B, which was obtained by doing a lookup “..” in C.
> So, Instead of it, we suggest we fix the “infinite-loop” condition in
> fat_traverse_logic and retain the code.
> of course, we will test it with corrupted FATfs.
> Please share your thoughts on this.

Yes, we can't use fat_search_long() as is, of course. However, we can
share the basic algorithm and code.

The both are doing,

1) traverse the blocks chained by ->i_start.
2) get the record (dirent) from blocks.
3) check the detail of record

The difference is only (3), right? I know, the code has many differences
though. The actual logic are almost same.

And see, e.g., fat_get_cluster() is checking several unexpected
state. We have to care about corrupting data. It is not only
"infinite-loop" case.  And why I'm saying it is better to share code.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

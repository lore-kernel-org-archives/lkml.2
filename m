Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab1D3Cri (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 22:47:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47756 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753134Ab1D3Crh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 22:47:37 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTimfOCwZQP=Hv+NEhFcxMpC51-RhTw@mail.gmail.com>
References: <web-515866242@zbackend1.aha.ru> <BANLkTimfOCwZQP=Hv+NEhFcxMpC51-RhTw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 29 Apr 2011 19:47:14 -0700
Message-ID: <BANLkTinv38NtVQHrayus6v89BocsK6+iQQ@mail.gmail.com>
Subject: Re: 2.6.39-rc5-git2 boot crashs
To: Joern Engel <joern@logfs.org>, Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, werner <w.landgraf@ru.ru>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 7:31 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> It looks like a NULL pointer dereference with offset 4, so at a guess,
> super->s_freeing_list.next is NULL, and it's the "next->prev = entry"
> instruction that faults when inserting into that list.
>
> How/why would s_freeing_list be NULL? I have no idea. But it looks
> like a failed mount, so presumably it was never initialized.

Hmm. super->s_freeing_list is initialized pretty late in
logfs_read_sb(), and any error path _before_ that point will result in
a "goto err1" in logfs_get_sb_device() which will do various iputs
etc. All without that list initialized. That would seem to be the
cause of this, possibly triggered by Al's changes to ->mount from
read_super.

Somebody who knows the code better than me (ie any reasonably
well-educated squirrel) should take another look, though.

Werner, if this is easily repeatable for you, could you test just
moving up the lines that initialize the superblock mutexes and the
s_freeing_list to the top of logfs_read_sb() rather than the end (ie
move the three lines that do

        mutex_init(&super->s_dirop_mutex);
        mutex_init(&super->s_object_alias_mutex);
        INIT_LIST_HEAD(&super->s_freeing_list);

to be before the call to mempool_create(). That way those things will
be initialized much earlier, which is definitely what we want.

Whether that's the only problem and actually fixes it, I won't even
begin to guess, though.

                    Linus

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab1ATJFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 04:05:30 -0500
Received: from mtoichi13.ns.itscom.net ([219.110.2.183]:47074 "EHLO
	mtoichi13.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990Ab1ATJFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 04:05:24 -0500
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: vfs-scale, general questions
To: Nick Piggin <npiggin@gmail.com>
Cc: Nick Piggin <npiggin@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
In-Reply-To: <AANLkTi=CqLm=33acFV42N8VbNK9=hwXV9iegKn-jjGJS@mail.gmail.com>
References: <20110113120626.GB30351@opensource.wolfsonmicro.com> <8138.1294924927@jrobl> <676f5c24375e1cc2aa14fe6630ef1324@mail.gmail.com> <8482.1294926315@jrobl> <AANLkTim=VY7+fo6d_nUXVxs+iZ_f79qWu_eYMUjvhVJO@mail.gmail.com> <909.1295419383@jrobl> <AANLkTi=CqLm=33acFV42N8VbNK9=hwXV9iegKn-jjGJS@mail.gmail.com>
Date: Thu, 20 Jan 2011 18:05:15 +0900
Message-ID: <13379.1295514315@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Some of mail destinations are removed since this is not nfs specific
anymore.)

Nick Piggin:
> > - getcwd(2) needs d_lock?
> > =A0It acquires rename_lock and then tests whether the pwd is removed by
> > =A0d_unhashed(). If a race condition between vfs_rename_dir() which may
> > =A0unhash/rehash the dentry happens, then getcwd() may return the wrong
> > =A0result due to unprotected d_unhashed() call, I am afraid. rename_lock
> > =A0doesn't help this case.
>
> We have the lock in write mode there, so it should exclude that
> particular race. But I need to take another look at this code I
> think, I'm not sure it's completely right, so I would appreciate reviews.

You might think about the race around d_move, but what I meant is the
race between d_unlinked and unhash/rehash.

- getcwd return -ENOENT when pwd is unhashed.
- vfs_rename_dir()
  + makes the existing target unhashed.
  + FS ->rename() is called, here let's assume an error happened. so the
    target dir is surely alive and reachable, nothing have been changed.
  + vfs_rename_dir() rehashes it again.

During this unhashed period, getcwd(2) may be issued.
And I am afraid it may return an error incorrectly.


About other issues, I will reply when I have time.


J. R. Okajima

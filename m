Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760058Ab0LNVJQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 16:09:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50238 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759993Ab0LNVJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 16:09:15 -0500
MIME-Version: 1.0
In-Reply-To: <20101214125143.0ab00c97.akpm@linux-foundation.org>
References: <1292150923-25586-1-git-send-email-stefani@seibold.net> <20101214125143.0ab00c97.akpm@linux-foundation.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 14 Dec 2010 13:08:54 -0800
Message-ID: <AANLkTinPkGHASWubtUY1aDbnxv8V3uGvV+b+e+TkSiVS@mail.gmail.com>
Subject: Re: [PATCH] cramfs: generate unique inode number for better inode
 cache usage
To: Andrew Morton <akpm@linux-foundation.org>
Cc: stefani@seibold.net, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 12:51 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> Did you look at using iunique() to generate cramfs inode numbers?

That breaks the cramfs "hardlinking" (which is just files that have
the same data pointer), and now a hardlinked file wouldn't have the
same inode number any more.

Of course, I'm not sure the hardlinking really matters. cramfs
hardlinks aren't really traditional hardlinks anyway - since the
permissions etc are in the directory entry, you can have the data
hardlinked without having the same permissions, so it's not a "real"
hardlink even if the inode number were to be the same.

But this patch seems to roughly approximate the old pseudo-hardlink
behavior. It used to be that all non-data files showed up with the
same inode number, now they have separate inode numbers.

That said, I hate how it moves that "setup_inode" helper function
inline and then does the "if it's a character device" kinds of tests
twice. Once for the inode number logic, and once for the inode
operations structure assignment.

So I think the approach is fine, but I think the implementation is pretty ugly.

                          Linus

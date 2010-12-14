Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026Ab0LNXoq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 18:44:46 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56017 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753672Ab0LNXop convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 18:44:45 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTi=HaS+wweLaAEcBuRFx+Dr1pKU=One1gOYF55CJ@mail.gmail.com>
References: <1292368360-32216-1-git-send-email-stefani@seibold.net> <AANLkTi=HaS+wweLaAEcBuRFx+Dr1pKU=One1gOYF55CJ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 14 Dec 2010 15:43:51 -0800
Message-ID: <AANLkTikvN9u3dB_TzNUKjz7g39i+t+h4vt7EVKDLVjLg@mail.gmail.com>
Subject: Re: [PATCH] cramfs: generate unique inode number for better inode
 cache usage
To: stefani@seibold.net
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 3:32 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Why do you repeat that
>
>    inode = iget_locked(sb, cramino(cramfs_inode, offset));
>    if (inode && (inode->i_state & I_NEW)) {
>
> so many times?
>
> Wouldn't it be nicer to just do it once at the top?

Oh, and I think it's probably nicer to then do the if-statements as a

   switch (cram_inode->mode & S_IFMT) {
   case S_IFREG:
   ..

but what I objected to in the previous patch was doing it multiple
times, and moving the nice separate helper function into the caller.

So I _think_ you should be able to just do something like this:

   ino = cramino(cramfs_inode, offset);
   switch (cram_inode->mode & S_IFMT) {
   case S_IFREG:
      fops = generic_ro_fops;
      aops = &cramfs_aops;
      break;
   case S_IFDIR:
      ...
   default:
       ino = CRAMINO_UNIQ(offset);
   }
   inode = iget_locked(sb, ino);
   if (inode && (inode->i_state & I_NEW)) {
      inode->i_ops = iops;
      inode->i_fops = fops;
      inode->i_data.a_ops = aops;
      setup_inode(inode, cramfs_inode, cramfs_inode->size);
    }

or whatever?

                   Linus

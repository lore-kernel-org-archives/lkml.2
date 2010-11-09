Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629Ab0KIQVz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 11:21:55 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42991 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab0KIQVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 11:21:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kA0Wdt/hww+bR4CPFyXsDr7r1JoRxh7wSLJazez8y+PQzKqtqUN2kkU2wWi6OKTqIx
         ytxWlZil5MRVKfmljUx+ZRxLhHsYuoSwg1f5UACeYSehDB1WG8Iny2m2Ivor9+78jflG
         QifnkDAViIasxMfAEv8d8VdZcjxWuedKXPfOQ=
Subject: Re: [patch 1/6] fs: icache RCU free inodes
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <AANLkTi=b3dEmoTgrJ2xMTUzgM-mUQNNx6J9jeLq2=mtf@mail.gmail.com>
References: <20101109124610.GB11477@amd>
	 <AANLkTi=b3dEmoTgrJ2xMTUzgM-mUQNNx6J9jeLq2=mtf@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Nov 2010 17:21:38 +0100
Message-ID: <1289319698.2774.16.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 09 novembre 2010 à 08:02 -0800, Linus Torvalds a écrit :
> On Tue, Nov 9, 2010 at 4:46 AM, Nick Piggin <npiggin@kernel.dk> wrote:
> > So here is the inode RCU code. It's obviously not worth doing until the
> > actual rcu-walk path walking is in, but I'd like to get opinions on it.
> > It would be nice to merge it in Al's tree at some point, though.
> 
> Remind me why it wasn't sufficient to just use SLAB_DESTROY_BY_RCU?
> 
> Especially if we still lock things for the actual (few) inode list
> operations, the added complexity of actually freeing _individual_
> inodes by RCU seems to be a bad thing.
> 
> The only thing we care about is the pathname walk - there are no other
> inode operations that are common enough to worry about. And the only
> thing _that_ needs is the ability to look at the inode under RCU, and
> SLAB_DESTROY_BY_RCU should be entirely sufficient for that.
> 
> But we had some discussion about this long ago, and I may have
> forgotten some of the context.
> 

David Chinner sent a patch using SLAB_DESTROY_BY_RCU

You can see problems using this fancy thing :

- Need to use slab ctor() to not overwrite some sensitive fields of
reused inodes.
  (spinlock, next pointer)

- Fancy algo to detect an inode moved from one chain to another. Lookups
should be able to detect and restart their loop.

- After a match, need to get a stable reference on inode (lock), then
recheck the keys to make sure the target inode is the right one.

http://www.gossamer-threads.com/lists/linux/kernel/1298710

A bit tricky, but doable IMHO, especially if covering only the main
lookup. The seldom used can still get a (spin)lock.




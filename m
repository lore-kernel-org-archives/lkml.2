Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933486Ab0KBEqf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 00:46:35 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40938 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933443Ab0KBEq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 00:46:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=vQovzVquvrE1LwiBjatV03HjH2GoF4ZHFBsJzw/apWVbGLQlnjtOaYG9l3cAzU4qSm
         +LgIEsYf7tcmIRJ3nm/vq9x1/CocFM4TE4/3rK+s+mxduMZkme2HcjnEvz7Le0k/9wfS
         B+KxJA8U9brAzUvL4g+IYp7K3aQFKgZI7HqVM=
Subject: Re: [PATCH 3/3] fs: rcu protect inode hash lookups
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Dave Chinner <david@fromorbit.com>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20101102000152.GO2715@dastard>
References: <1288589624-15251-1-git-send-email-david@fromorbit.com>
	 <1288589624-15251-4-git-send-email-david@fromorbit.com>
	 <1288604287.2660.94.camel@edumazet-laptop> <20101101134451.GN2715@dastard>
	 <1288625362.2660.108.camel@edumazet-laptop> <20101102000152.GO2715@dastard>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Nov 2010 05:46:15 +0100
Message-ID: <1288673175.2660.141.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 02 novembre 2010 à 11:01 +1100, Dave Chinner a écrit :

> So, to go to per-chain locks as per the proposed bit-lock-on-the-
> low-bit-of-the-head-pointer infrastructure, we'll have to cross that
> with the hlist_null code that plays low-bit pointer games for
> detecting the end of the chain.
> 

So what, just use another bit for the lock, this still let 30 bit for
the nulls value (62 bits on 64bit arches). Anyway, the bit lock is
rejected by RT guys, so why do you still care ?


> The chain is determined by hashing the inode number. Perhaps a
> simple enough test is to hash the last inode number on a cache miss
> and if that doesn't match the hash of the lookup key we redo the
> search. That seems to me like it will avoid needing to play games
> with termination markers - does that sound reasonable?
> 

Sure, if only the inode number is the key, it can be fetched in atomic
way so it should be good, even without taking a stable reference on last
item. It could be a problem if i_ino becomes a larger field...

Note : you'll have to remember the last item i_ino in a variable, not to
refetch it from a 'last item' pointer (this last item could also change
its chain...)

For TCP, hash key is a complex hash function of many fields needing to
take a reference before computing it, this was not an option.




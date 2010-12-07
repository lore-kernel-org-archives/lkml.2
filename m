Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab0LGPtt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 10:49:49 -0500
Received: from canuck.infradead.org ([134.117.69.58]:35098 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848Ab0LGPts convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 10:49:48 -0500
Subject: Re: [PATCH 00/46] rcu-walk and dcache scaling
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Nick Piggin <npiggin@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, Nick Piggin <npiggin@kernel.dk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTinAt9PEWMCP55o64E7wsfZ=depU+YXbG8DdGYdO@mail.gmail.com>
References: <cover.1290852958.git.npiggin@kernel.dk>
	 <20101207112555.GE16103@dastard>
	 <AANLkTinAt9PEWMCP55o64E7wsfZ=depU+YXbG8DdGYdO@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 07 Dec 2010 16:49:34 +0100
Message-ID: <1291736974.2032.665.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-08 at 02:24 +1100, Nick Piggin wrote:
> 
>  repeat:
>     spin_lock(&parent->d_lock);
>     spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
>     /* do stuff */
>     spin_unlock(&parent->d_lock);
>     spin_release(&dentry->d_lock.dep_map, 1, _RET_IP_);
>     parent = dentry;
>     spin_acquire(&this_parent->d_lock.dep_map, 0, 1, _RET_IP_);
>     goto repeat; 

shouldn't that be s/this_parent/parent/ ?

So what you're trying to do is:

  A -> B -> C -> ...

lock A
lock B, nested
unlock A
flip B from nested to top
lock C, nested
unlock B
flip C from nested to top
lock ...

Anyway, the way to write that is something like:

  lock_set_subclass(&detry->d_lock.dep_map, 0, _RET_IP_);

Which will reset the subclass of the held lock from DENTRY_D_LOCK_NESTED
to 0.

This is also used in double_unlock_balance(), we go into
double_lock_balance() with this_rq locked and want to lock busiest,
because of the lock ordering we might need to unlock this_rq and lock
busiest first, at which point this_rq is nested.

On unlock we thus need to map this_rq back to subclass 0 (which it had
before double_lock_balance(), because otherwise subsequent lock
operations will be done against the subclass and confuse things.



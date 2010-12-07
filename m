Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab0LGP7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 10:59:16 -0500
Received: from mail-ew0-f45.google.com ([209.85.215.45]:53511 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848Ab0LGP7O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 10:59:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iBs4+aUf8BxA7d5RGzTGe1MQOQwwo+/Tq0KP9t5doEdt55IXeYNHJoDFRu1LQgyYTX
         JGLR12yHPU8wye1Gy65rQ4otWeLXrDgAR/qwdV7nssW3hLDJvULSoQlAhZtE9SJlHjx0
         dHqSYKrDBV7eU/Ijfs57jfzrppN0dvYmS2zFc=
MIME-Version: 1.0
In-Reply-To: <1291736974.2032.665.camel@laptop>
References: <cover.1290852958.git.npiggin@kernel.dk>
	<20101207112555.GE16103@dastard>
	<AANLkTinAt9PEWMCP55o64E7wsfZ=depU+YXbG8DdGYdO@mail.gmail.com>
	<1291736974.2032.665.camel@laptop>
Date: Wed, 8 Dec 2010 02:59:12 +1100
Message-ID: <AANLkTim=aqwYsyR9fb=DTj2BNA5BmwsXRAPz-+OvUZPV@mail.gmail.com>
Subject: Re: [PATCH 00/46] rcu-walk and dcache scaling
From: Nick Piggin <npiggin@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Dave Chinner <david@fromorbit.com>, Nick Piggin <npiggin@kernel.dk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 8, 2010 at 2:49 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Wed, 2010-12-08 at 02:24 +1100, Nick Piggin wrote:
>>
>>  repeat:
>>     spin_lock(&parent->d_lock);
>>     spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
>>     /* do stuff */
>>     spin_unlock(&parent->d_lock);
>>     spin_release(&dentry->d_lock.dep_map, 1, _RET_IP_);
>>     parent = dentry;
>>     spin_acquire(&this_parent->d_lock.dep_map, 0, 1, _RET_IP_);
>>     goto repeat;
>
> shouldn't that be s/this_parent/parent/ ?

Yes, typo in my pseudo code.


> So what you're trying to do is:
>
>  A -> B -> C -> ...
>
> lock A
> lock B, nested
> unlock A
> flip B from nested to top
> lock C, nested
> unlock B
> flip C from nested to top
> lock ...
>
> Anyway, the way to write that is something like:
>
>  lock_set_subclass(&detry->d_lock.dep_map, 0, _RET_IP_);
>
> Which will reset the subclass of the held lock from DENTRY_D_LOCK_NESTED
> to 0.

OK, thanks. My version should not have caused any problems though,
right? Any idea what might have caused Dave's crash?


> This is also used in double_unlock_balance(), we go into
> double_lock_balance() with this_rq locked and want to lock busiest,
> because of the lock ordering we might need to unlock this_rq and lock
> busiest first, at which point this_rq is nested.
>
> On unlock we thus need to map this_rq back to subclass 0 (which it had
> before double_lock_balance(), because otherwise subsequent lock
> operations will be done against the subclass and confuse things.

Thanks,
Nick

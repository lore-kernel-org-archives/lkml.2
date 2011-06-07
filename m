Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318Ab1FGOK5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 10:10:57 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37570 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167Ab1FGOK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 10:10:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=C1ReXK8tAS+G4Yum/Sy9Bsz0aVA5M7gXhUx05351biYxe9BcP0M/XUs9SA6sAeBD27
         82saszRt5ZuPHofDVJHCOrUyp/IbNDqS7l5oW+X+wWUG2ReS+R37sdho8QwUTEP8N2CD
         061bvvfUV1ni+2wUZAE0govRKte99Ho/g9VQQ=
MIME-Version: 1.0
In-Reply-To: <1307454439.2322.260.camel@twins>
References: <BANLkTimZ8=YYZXZSzauy5ASsP0kwti8uxQ@mail.gmail.com>
	<1307454439.2322.260.camel@twins>
Date: Tue, 7 Jun 2011 22:10:55 +0800
Message-ID: <BANLkTikvFk7pbcw9PEtPGSK=6WCNLYXCuQ@mail.gmail.com>
Subject: Re: [PATCH] sched: correct testing need_resched in mutex_spin_on_owner()
From: Hillf Danton <dhillf@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 7, 2011 at 9:47 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2011-06-07 at 21:41 +0800, Hillf Danton wrote:
>> It is suppose to check the owner task that is not absolutly running on the
>> local CPU,
>
> Oh, why do you think so?
>
as the comment in __mutex_lock_common() says,

#ifdef CONFIG_MUTEX_SPIN_ON_OWNER
	/*
	 * Optimistic spinning.
	 *
	 * We try to spin for acquisition when we find that there are no
	 * pending waiters and the lock owner is currently running on a
	 ***************************
         * (different) CPU.
	 ***************************
         * .....
         */

>> and if NEED_RESCHED is happenly set on the current task of local
>> CPU, we get incorrect result.
>
> Only if your above assumption holds, which it doesn't. It explicitly
> checks to see if _this_ cpu needs a resched while spinning, if so it
> bails the spinning and calls schedule in the lock slow path.
>
> If the owner cpu reschedules, owner will leave the rq and
> owner_running() will return false, also breaking the loop.
>

need_resched is checked after true is returned by owner_running(),
in other words, owner is still on its CPU, so owner should be check
here. Even ower's CPU == this CPU, checking owner also gives
correct result.

thanks
           Hillf

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779Ab1FGOO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 10:14:56 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61275 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab1FGOOz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 10:14:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=L2vzHD0PDBVB1YocFkynvpsnpPsaLd1Z67PNOL3yY3aLqDY1d3Qizkbz/emtCOfqli
         No6+pDyfziIPkIWH2V3Igdfq64mf0Kcuc7nd0J6kzs5IXjBMle6BcvS9Ew87vPflYdBB
         1VbVGTLw7HB+g98fU7fzzaxTIBo4TH2MS+mSo=
MIME-Version: 1.0
In-Reply-To: <1307455140.2322.262.camel@twins>
References: <BANLkTimZ8=YYZXZSzauy5ASsP0kwti8uxQ@mail.gmail.com>
	<1307454439.2322.260.camel@twins>
	<1307455140.2322.262.camel@twins>
Date: Tue, 7 Jun 2011 22:14:53 +0800
Message-ID: <BANLkTimZzpUZe3vFe4aQdQBZBOS1a4=9rQ@mail.gmail.com>
Subject: Re: [PATCH] sched: correct testing need_resched in mutex_spin_on_owner()
From: Hillf Danton <dhillf@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 7, 2011 at 9:59 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2011-06-07 at 15:47 +0200, Peter Zijlstra wrote:
>> On Tue, 2011-06-07 at 21:41 +0800, Hillf Danton wrote:
>> > It is suppose to check the owner task that is not absolutly running on the
>> > local CPU,
>>
>> Oh, why do you think so?
>>
>> > and if NEED_RESCHED is happenly set on the current task of local
>> > CPU, we get incorrect result.
>>
>> Only if your above assumption holds, which it doesn't. It explicitly
>> checks to see if _this_ cpu needs a resched while spinning, if so it
>> bails the spinning and calls schedule in the lock slow path.
>>
>> If the owner cpu reschedules, owner will leave the rq and
>> owner_running() will return false, also breaking the loop.
>>
>> >
>> > Signed-off-by: Hillf Danton <dhillf@gmail.com>
>> > ---
>> >  kernel/sched.c |    2 +-
>> >  1 files changed, 1 insertions(+), 1 deletions(-)
>> >
>> > diff --git a/kernel/sched.c b/kernel/sched.c
>> > index fd18f39..3ea64fe 100644
>> > --- a/kernel/sched.c
>> > +++ b/kernel/sched.c
>> > @@ -4326,7 +4326,7 @@ int mutex_spin_on_owner(struct mutex *lock,
>> > struct task_struct *owner)
>> >             return 0;
>> >
>> >     while (owner_running(lock, owner)) {
>> > -           if (need_resched())
>> > +           if (test_tsk_need_resched(owner))
>> >                     return 0;
>> >
>
> Furthermore, that can crash the machine, as there's no guarantee owner
> is a sane pointer at this point.
>

Well, why is owner_running looped safely?

thanks
           Hillf

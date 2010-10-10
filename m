Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445Ab0JJXFU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 19:05:20 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:62020 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab0JJXFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 19:05:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=SE6OiR9qLD2KJupwccZt/HJA5cBx0YpCIHudOOmGVPZOiGt9naqbYzVwOmO/lRyvxv
         vlMWJpI5dBtYS0z6NW6SWTXiwDBdRbZxY2kX7JiiShhiI6sdXlxPXGTT/AKVIz3lMa6r
         fzGwZt/QMQ1HDRHbOrnDxROsw3cR/K1jC0vTg=
MIME-Version: 1.0
In-Reply-To: <1286639626.1891.0.camel@laptop>
References: <1286612169-27529-1-git-send-email-linus.walleij@stericsson.com>
	<1286639626.1891.0.camel@laptop>
Date: Mon, 11 Oct 2010 01:05:18 +0200
Message-ID: <AANLkTi=JfJknPNMiMXnK=kZj+ECJTE423AfjuiE67afu@mail.gmail.com>
Subject: Re: [PATCH] sched: SCHED_RESET_ON_FORK to recalculate load weights
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Lennart Poettering <lennart@poettering.net>, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/9 Peter Zijlstra <peterz@infradead.org>:

> On Sat, 2010-10-09 at 10:16 +0200, Linus Walleij wrote:
>>
>> So we always need to call set_load_weight(), not just if the
>> niceval was changed, because the scheduler gives
>> SCHED_RR/SCHED_FIFO processes very high weights.
>
> SCHED_RR/FIFO never uses that weight, we should remove all that cruft..

Hm I wonder if that is an ACK or "please throughly rewrite the
scheduler" request ;-)

Anyway I also saw you have started to get rid of RT weights it in
commit e51fd5e2, so in set_load_weight():

       if (task_has_rt_policy(p)) {
                p->se.load.weight = prio_to_weight[0] * 2;
                p->se.load.inv_weight = prio_to_wmult[0] >> 1;
                return;
        }

is now replaced by this:

        if (task_has_rt_policy(p)) {
                p->se.load.weight = 0;
                p->se.load.inv_weight = WMULT_CONST;
                return;
        }

I backported that commit onto 2.6.34 (bah, just patch -p1)
and tested. The problem persists, but mutates:

Whereas before this commit the problem was that processes came
back with enormous weights after forking of an RT process flagged
with SCHED_RESET_ON_FORK, the problem is now the reverse:
the process comes back with load weight zero making the forked
process totally numb (when it has enormous weights it would atlest
respond), so this patch is still needed to bring the weight back in
balance AFAICT.

Yours,
Linus Walleij

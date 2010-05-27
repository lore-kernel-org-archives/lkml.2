Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305Ab0E0KxA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 06:53:00 -0400
Received: from smtp.nokia.com ([192.100.122.230]:47285 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034Ab0E0Kw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 06:52:58 -0400
Subject: Re: [PATCHv4 17/17] writeback: lessen sync_supers wakeup count
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Nick Piggin <npiggin@suse.de>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org
In-Reply-To: <20100527072240.GM22536@laptop>
References: <1274795352-3551-1-git-send-email-dedekind1@gmail.com>
	 <1274795352-3551-18-git-send-email-dedekind1@gmail.com>
	 <20100527065041.GA31073@ZenIV.linux.org.uk> <20100527072240.GM22536@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 May 2010 13:51:09 +0300
Message-ID: <1274957469.13159.20.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 27 May 2010 10:52:38.0184 (UTC) FILETIME=[B8D63280:01CAFD8A]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick, thanks for serialization suggestion.

On Thu, 2010-05-27 at 17:22 +1000, Nick Piggin wrote:
> Yeah, we definitely don't want to add global cacheline writes in the
> common case. Also I don't know why you do the strange -1 value. I
> couldn't seem to find where you defined bdi_arm_supers_timer();

It is in mm/backing-dev.c:376 in today's Linus' tree. The -1 is used to
indicate that 'sync_supers()' is in progress and avoid arming timer in
that case. But yes, this is not really needed.

> But why doesn't this work?
> 
>   sb->s_dirty = 1;
>   smp_mb(); /* corresponding MB is in test_and_clear_bit */

AFAIU, test_and_clear_bit assumes 2 barriers - before the test and after
the clear. Then I do not really understand why this smp_mb is needed.

>   if (unlikely(!supers_timer_armed)) {
>     if (!test_and_set_bit(0, &supers_timer_armed))
>         bdi_arm_supers_timer();
>   }
>     
>   vs
> 
>   supers_timer_armed = 0;
> again:
>   sync_supers();
>   if (test_and_clear_bit(0, &supers_timer_armed))
>     goto again;

AFAIU, the following should be fine, no?:


    if (unlikely(!supers_timer_armed))
        if (!test_and_set_bit(0, &supers_timer_armed))
            bdi_arm_supers_timer();

vs

again:
    sync_supers();
    if (test_and_clear_bit(0, &supers_timer_armed))
        goto again;

I assume that it is harmless to run 'bdi_arm_supers_timer()'
concurrently;

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)


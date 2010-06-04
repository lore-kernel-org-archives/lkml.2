Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158Ab0FDK4T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 06:56:19 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49187 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289Ab0FDK4R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 06:56:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=MyxXKGdY6P+2vxJ0AkRtstdyFI9n4f7tBxw1sTkyoYBG9rF2IkiQnHOADYK1ZMCDJ+
         RVwDTmQffjY/N8N1XOKNvolYPVZwkLLO5A6TvH6OdlAiES/+raWWP0yFhgNQtmimbYGx
         9S0TgV2t6O9Ecv8+FlRJvYfls7UP9iNQMMudE=
MIME-Version: 1.0
In-Reply-To: <20100520204810.GA19188@think>
References: <20100520204810.GA19188@think>
Date: Fri, 4 Jun 2010 12:56:16 +0200
Message-ID: <AANLkTinifUTnjypY-h6Vv2qV9O7O4ZOFurxtrEr-3Rig@mail.gmail.com>
Subject: Re: [PATCH RFC] reduce runqueue lock contention
From: Stijn Devriendt <highguy@gmail.com>
To: Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       peterz@infradead.org, axboe@kernel.dk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 20, 2010 at 10:48 PM, Chris Mason <chris.mason@oracle.com> wrote:
> I think we probably want to add a way to wait just for a little while as
> a more lightweight operation (less balancing etc) but this patch doesn't
> do that.  It only tries to make the act of waking someone up less
> expensive by avoiding the runqueue lock when we're on a different CPU
> than the process we want to wake.
>
> I do this with a per-runqueue list and some cmpxchg tricks.  Basically
> all the other CPUs will toss a given process they want to wakeup onto
> the destination per-runqueue list.  Later on, when that runqueue is
> finding a new task to run, it processes the list in bulk.

I actually have the reverse lying around somewhere (even more broken, probably)
to allow nested wakeups from the scheduler.

The issue I want to tackle is waking up processes when others go to sleep.
This means try_to_wake_up() from inside the runqueue lock.

I used a simple per_cpu taskqueue where tasks are put on when waking
during schedule(). At the end of schedule() I empty the list and reschedule
as one of the newly woken tasks may be higher prio.

I'm wondering if both approaches can be merged by checking this list before
and after every schedule().

Stijn

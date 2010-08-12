Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758826Ab0HLBYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 21:24:12 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:57086 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932880Ab0HLBYG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 21:24:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Ya3/XMml8+JwNpsVctcYuSI6LuVlbiFZCZ2BIco5OFaiLYeLLmxD9OOzL5+2GZYAPH
         V2IeUnb3wGN+gg0qmXP/Jir40IFF+drK6l4G+r4MoWGsKGw0utsSFNKjCfLErPGbraCj
         7kIgLsrwnjdBs7jbpjNlG6IiRvBwXtUkPM5U8=
MIME-Version: 1.0
In-Reply-To: <1274733081-4623-7-git-send-email-walken@google.com>
References: <1274733081-4623-1-git-send-email-walken@google.com>
	<1274733081-4623-7-git-send-email-walken@google.com>
Date: Wed, 11 Aug 2010 18:24:04 -0700
X-Google-Sender-Auth: pDbWhQ34yBoK0kldAowrlUx2qmc
Message-ID: <AANLkTikFEy26V4epRGCJiDkQNQ5BH0fPP0C=4phUB=o3@mail.gmail.com>
Subject: Re: [PATCH 06/11] rwsem: wake queued readers when writer blocks on 
	active read lock
From: Tony Luck <tony.luck@intel.com>
To: Michel Lespinasse <walken@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Waychison <mikew@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 1:31 PM, Michel Lespinasse <walken@google.com> wrote:
> This change addresses the following situation:
>
> - Thread A acquires the rwsem for read
> - Thread B tries to acquire the rwsem for write, notices there is already
>  an active owner for the rwsem.
> - Thread C tries to acquire the rwsem for read, notices that thread B already
>  tried to acquire it.
> - Thread C grabs the spinlock and queues itself on the wait queue.
> - Thread B grabs the spinlock and queues itself behind C. At this point A is
>  the only remaining active owner on the rwsem.
>
> In this situation thread B could notice that it was the last active writer
> on the rwsem, and decide to wake C to let it proceed in parallel with A
> since they both only want the rwsem for read.
>
> Signed-off-by: Michel Lespinasse <walken@google.com>

Linus tree this morning[1] was behaving badly on ia64 ... processes would wander
off into some unkillable state ... and since this happened to processes starting
from rc*.d I couln't get the system up to a login prompt. System is a 32-way
(4 sockets * quad-core * hyperthread).

git bisect pins the blame on this change (commit 424acaaeb...).
Reverting it (and
it's successor a8618a0e - because I assumed that it depended on 424...) gives
me a kernel that works fine.

Not sure what is wrong with this change. Maybe ia64 needs some more memory
ordering bits than the changed code provides? I can dig into it a bit
harder tomorrow,
but I thought you'd like an early heads-up in case anyone else is seeing similar
problems.

-Tony

[1] N.B. I've been on vacation - so this morning's tree was the first
I'd tried since 2.6.35

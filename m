Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145Ab1EXR42 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 13:56:28 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61020 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab1EXR40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 13:56:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=S8mBJUP0U4fDJng1srPp2kbV5mGuzkd7R4r1sbXct5V+VORiX3u2y6FuDebSZ621WH
         BNNd159gS2/ZsokyEjwncD8MjmxvCh9u47bXrRZ9qBd1simtWYdDOHElqnVl+7wBPrI1
         nxpL+JvuC02lZJuxCVJFKA3jWyDJqsfPz23h0=
MIME-Version: 1.0
In-Reply-To: <20110524173326.GA7635@gere.osrc.amd.com>
References: <4ddad79317108eb33d@agluck-desktop.sc.intel.com>
	<20110524034023.GB25230@elte.hu>
	<987664A83D2D224EAE907B061CE93D5301D5D0595B@orsmsx505.amr.corp.intel.com>
	<20110524173326.GA7635@gere.osrc.amd.com>
Date: Tue, 24 May 2011 10:56:26 -0700
X-Google-Sender-Auth: aaDvlxMyf6utjaXom3c7JLNRTi0
Message-ID: <BANLkTinSOFAioAe2v5c6PRB9EKjJJNMg9w@mail.gmail.com>
Subject: Re: [RFC 0/9] mce recovery for Sandy Bridge server
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dragging PeterZ to this thread, since we are now talking about scheduler.

On Tue, May 24, 2011 at 10:33 AM, Borislav Petkov <bp@amd64.org> wrote:
> On Tue, May 24, 2011 at 09:57:46AM -0700, Luck, Tony wrote:
>> So can we talk about this part for a while before returning to the
>> "how to report this" discussion?
>>
>> So here's the situation - we are in the NMI handler when we find from
>> looking at the machine check bank registers that we have a recoverable
>> error. We know the physical address, and we know the task (which might
>> have been in user or kernel context). I can package that information
>> into a perf/event ... but then how can I mark the current task as
>> not-fit-for-execution?
>
> Maybe something like
>
> set_current_state(TASK_UNINTERRUPTIBLE);
>
> finish work in NMI context
>
> do remaining work in process context like sending appropriate signals
> etc; finally:
>
> set_task_state(tsk, TASK_RUNNING)

That looks pretty easy - are their any weird side effects that I should
be worried about?  My perf/event can't really include the "task" pointer
(that sounds way too internal) - but I can provide the process id, so
the "RAS daemon" that sees this event can look up the task to do that
final set_task_state(tsk, TASK_RUNNING).

Does this work in the threaded case? In the case where the task was in
kernel context (but in a CONFIG_PREEMT=y kernel at some point
where preemption is allowed)?

-Tony

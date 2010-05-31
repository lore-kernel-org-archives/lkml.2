Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789Ab0EaJnF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 05:43:05 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63589 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756682Ab0EaJnC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 05:43:02 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1005292026080.6300-100000@netrider.rowland.org>
References: <AANLkTik_4ezDAQoAQjkpEgwD9SLKeOjDzy2H7T2v6uCP@mail.gmail.com>
	<Pine.LNX.4.44L0.1005292026080.6300-100000@netrider.rowland.org>
Date: Mon, 31 May 2010 02:43:01 -0700
Message-ID: <AANLkTikxws5kmFhnBO1MLzE65ETka3Jy0R5ayAKTS1Lc@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Florian Mickler <florian@mickler.org>,
       Peter Zijlstra <peterz@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Brian Swetland <swetland@google.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/5/29 Alan Stern <stern@rowland.harvard.edu>:
> On Sat, 29 May 2010, Arve Hjønnevåg wrote:
>
>> > In place of in-kernel suspend blockers, there will be a new type of QoS
>> > constraint -- call it QOS_EVENTUALLY.  It's a very weak constraint,
>> > compatible with all cpuidle modes in which runnable threads are allowed
>> > to run (which is all of them), but not compatible with suspend.
>> >
>> This sound just like another API rename. It will work, but given that
>> suspend blockers was the name least objectionable last time around,
>> I'm not sure what this would solve.
>
> It's not just a rename.  By changing this into a QoS constraint, we
> make it more generally useful.  Instead of standing on its own, it
> becomes part of the PM-QOS framework.
>

We cannot use the existing pm-qos framework. It is not safe to call
from atomic context. Also, it does not have any state constraints, so
it iterates over every registered constraint each time one of them
changes. Nor does is currently provide any stats for debugging.

The original wakelock patchset supported a wakelock type so it could
be used to block more then suspend, but I had to remove this because
it "overlapped" with pm-qos. So, yes I do consider this just another
rename.

>> > There is no /sys/power/policy file.  In place of opportunistic suspend,
>> > we have "QoS-based suspend".  This is initiated by userspace writing
>> > "qos" to /sys/power/state, and it is very much like suspend-to-RAM.
>>
>> Why do you want to tie it to a specific state?
>
> I don't.  I suggested making it a veriant of suspend-to-RAM merely
> because that's what you were using.  But Nigel's suggestion of having
> "qos" variants of all the different suspend states makes sense.
>
>> > However a QoS-based suspend fails immediately if there are any active
>>
>> Fail or block? Your next paragraph said that it blocks for
>> QOS_EVENTUALLY, but if normal constraints fail, you are still stuck in
>> a retry loop.
>
> Normal (i.e., non QOS_EVENTUALLY) constraints aren't part of the
> Android use case, so it wasn't clear how they should be treated.  On
> further thought, it probably makes more sense to block for them too
> instead of failing immediately.
>
>> > normal QoS constraints incompatible with system suspend, in other
>> > words, any constraints requiring a throughput > 0 or an interrupt
>> > latency shorter than the time required for a suspend-to-RAM/resume
>> > cycle.
>> >
>> > If no such constraints are active, the QoS-based suspend blocks in an
>> > interruptible wait until the number of active QOS_EVENTUALLY
>>
>> How do you implement this?
>
> I'm not sure what you mean.  The same way you implement any
> interruptible wait.
>

I mean what should it wait on so that it gets interrupted by a
userspace ipc call. I guess you want to send a signal in addition to
the ipc. I still don't know why you want to do it this way though. It
seems much simpler to just return immedeately and allow the same
thread to cancel the request with another write.

>> >        for (;;) {
>> >                while (any IPC requests remain)
>> >                        handle them;
>> >                if (any processes need to prevent suspend)
>> >                        sleep;
>> >                else
>> >                        write "qos" to /sys/power/state;
>> >        }
>> >
>> > The idea is that receipt of a new IPC request will cause a signal to be
>> > sent, interrupting the sleep or the "qos" write.
>>
>> What happen if the signal is right before (or even right after)
>> calling write "qos". How does the signal handler stop the write?
>
> You're right, this is a serious problem.  The process would have to
> give the kernel a signal mask to be used during the wait, as in ppoll
> or pselect.  There ought to be a way to do this or something
> equivalent.
>
> Alan Stern
>
>



-- 
Arve Hjønnevåg

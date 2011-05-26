Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932735Ab1EZQG1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 12:06:27 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35417 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758036Ab1EZQGY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 12:06:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=qc3MxfOS7piZFfsRVC22G6wrk0ipNnNIJBqe2ZqCqRjevKB73t8vzMJ59tcIhubQCd
         jUPOidNLUfrN9OSIrl+FPw2N1tGp3STCjPb/+yMJ6Hp00Tlbec2DJr08sNzFEBP4o/gA
         /xwL2DdXIZeg8ljz3XDK/NYY5JTylkYVDvP/0=
MIME-Version: 1.0
In-Reply-To: <20110526133155.GH9520@thunk.org>
References: <BANLkTikGxbcMBD=3W_9_mpZBoVDc8HrX8A@mail.gmail.com>
 <201105231012.06928.oneukum@suse.de> <20110525000003.GJ32466@dastard>
 <201105250850.12179.oneukum@suse.de> <BANLkTincvGV735PKb60Kg0dLX6a1CZ-iNA@mail.gmail.com>
 <410B37BE-E380-40D0-82AA-48B56F389E16@mit.edu> <BANLkTimNjt4=9v33Z9Nr12xa6GmyJ-Ue5A@mail.gmail.com>
 <20110526133155.GH9520@thunk.org>
From: "D. Jansen" <d.g.jansen@googlemail.com>
Date: Thu, 26 May 2011 18:05:43 +0200
Message-ID: <BANLkTinTzNN2P45tgZAQ9FsL43CqyAJR3Q@mail.gmail.com>
Subject: Re: [rfc] Ignore Fsync Calls in Laptop_Mode
To: "Ted Ts'o" <tytso@mit.edu>, "D. Jansen" <d.g.jansen@googlemail.com>,
        Oliver Neukum <oneukum@suse.de>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        njs@pobox.com, bart@samwel.tk, jens.axboe@oracle.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Problem: any fsync call by any application spins up the hard disk any
time even in laptop_mode

On Thu, May 26, 2011 at 3:31 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Thu, May 26, 2011 at 01:16:45PM +0200, D. Jansen wrote:
>> exactly. so what now?

> This needs to be solved at the application level.  So what we need is
> a coordinating daemon which sends a message to all applications
> saying, "ok, here's an opportunity to flush data to the disk; if you
> have dirty files, or databases that has data that needs to be flushed,
> send it now", and then a little while later, it sends a message to all
> applications, "ok, we're going to let the disk spin down now, hold
> your horses and don't send any data to the disk".

I'm not sure this approach is straight forward.

Because though there is no possibility to destroy data that is on disk
due to non FIFO flushing of application writes queued in the kernel,
which seems to be the main kernel level problem, yet new problems come
up.

Now there is
1) special support needed on the application side.
2) need for new out-of-kernel buffers.
3) need for inter-application write alignment nightmares. This sort of
structure could cause very uncomfortable bugs that prevent writes from
happening at all in cases that were not foreseen at all.
4) need for resources wasted through yet another daemon.
5) If the _application_, but not the kernel crashes, the data is safe.
In my experience this is the much more likely case than that the mail
server on my netbook optimized for battery time receives an email in
laptop mode, sends the other server "200" and then before the next
commit window my battery slips out and it's all gone.
6) _If_ there would be a special daemon I think it would make sense
for that daemon to provide all the infrastructure, buffering and
manage the fsync calls itself. This shouldn't and wouldn't be
replicated by every single application.

I think the alternative of ensuring the application writes are
committed in order would make more sense:
e..g a _user space library_ disables fsync etc. in laptop_mode if the
user chooses to do so and kernel support for forced FIFO ordering or
writes.
This would fix 1) 2) 3) 4) 5) 6).

Cheers,

Dennis

ps.
So you've re-thought this "All that is necessary is a kernel patch to
allow laptop_mode to disable fsync() calls(...)"
(http://tytso.livejournal.com/2009/03/15/). That post had inspired my
patch.
pps.
I know that an email getting lost is everyone's nightmare. But these
things do happen, anyway. It's not the end of the world if one email
is lost. (There's still a copy in the sent box. People will probably
notice, eventually. I recently found out an email properly sent and
filed in my gmail sent box never arrived for several of the people
without any error reports. If people need to be 100% sure an email
arrived they should ask for a confirmation and/or use a different
medium.) This just makes it much more likely.

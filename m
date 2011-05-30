Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab1E3Bxx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 21:53:53 -0400
Received: from mail.lang.hm ([64.81.33.126]:40354 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389Ab1E3Bxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 21:53:52 -0400
Date: Sun, 29 May 2011 18:53:18 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "D. Jansen" <d.g.jansen@googlemail.com>
cc: Theodore Tso <tytso@mit.edu>, Oliver Neukum <oneukum@suse.de>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>, njs@pobox.com, bart@samwel.tk
Subject: Re: [rfc] Ignore Fsync Calls in Laptop_Mode
In-Reply-To: <BANLkTi=BgGagV+dN9-nFcSkNsGNKbRMLfQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1105291850260.5766@asgard.lang.hm>
References: <BANLkTikGxbcMBD=3W_9_mpZBoVDc8HrX8A@mail.gmail.com> <201105231012.06928.oneukum@suse.de> <20110525000003.GJ32466@dastard> <201105250850.12179.oneukum@suse.de> <BANLkTincvGV735PKb60Kg0dLX6a1CZ-iNA@mail.gmail.com> <410B37BE-E380-40D0-82AA-48B56F389E16@mit.edu>
 <BANLkTimNjt4=9v33Z9Nr12xa6GmyJ-Ue5A@mail.gmail.com> <20110526133155.GH9520@thunk.org> <BANLkTinTzNN2P45tgZAQ9FsL43CqyAJR3Q@mail.gmail.com> <20110526162138.GN9520@thunk.org> <BANLkTinPCcX9-gK7YnMngGUJKftRTmYXNw@mail.gmail.com> <AC254312-8FFF-4070-BF8B-D9B1E8FF1AE6@mit.edu>
 <BANLkTi=BgGagV+dN9-nFcSkNsGNKbRMLfQ@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="680960-2052966338-1306720399=:5766"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--680960-2052966338-1306720399=:5766
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Sun, 29 May 2011, D. Jansen wrote:

> On Fri, May 27, 2011 at 4:17 PM, Theodore Tso <tytso@mit.edu> wrote:
>> On May 27, 2011, at 3:12 AM, D. Jansen wrote:
>>> That reordering is exactly what I'm talking about. It wasn't my idea.
>>> But if I understood it correctly, it's possible that the kernel
>>> commits writes of an application, _to one and the same file_, in a
>>> non-FIFO order, if the application does not fsync. And this _afaiu_
>>> could result in the loss not only of new data, but complete corruption
>>> of previously existing data in laptop mode without fsync.
>>
>> No, you're not understanding the problem.   All layers of the storage
>> stack -- including the hard drive -- is allowed to reorder writes.  So
>> even if the kernel sends data to the disk in the exact same order that
>> the application wrote it, it could still get written in a different order,
>> because the hard drive itself can reorder writes.   This is necessary
>> for performance; if you didn't have this, the storage stack would be
>> dog slow, and would consume even more power.
>>
>> So at least level, the only thing you can count upon is that if you want
>> to make sure everything is flushed to stable store, you need to send
>> an fsync() command at the application to file system level, or a barrier
>> or flush command at the OS to hard drive level.
> (...)
>> Ordering doesn't matter, because nothing, including the hard drive,
>> guarantees ordering.  What does matter is that the fsync() commands
>> act like barriers; writes before the fsync() command are guaranteed
>> to be written to the disk, and survive a reboot, before any writes after
>> the fsync() are processed.  See?
>
> Ok, thanks a lot! I understand a lot better now!
> So we can't live without the fsyncs.
>
> So what if we would queue the fsyncs along with the writes - we would
> just fsync later instead of immediately, in between the writes as they
> came in. Then by design previous data could not be corrupted, right?
> We would do exactly the same thing, just later.
> It'd be kind of a disk write time distortion field.

the problem is that the spec for fsync says that your program stops until 
fsync finishes. If you don't do that then you will corrupt and loose data.

so if you delay fsync you will have your application (or desktop manager) 
freeze until the fsync completes.

if what you are wanting is the ability to say 'these things must be 
written before these other things to keep them from being corrupted, but I 
don't care when they get written (or if they get lost in a crash)' then 
what you want isn't fsync, it's a barrier.

David Lang
--680960-2052966338-1306720399=:5766--

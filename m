Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757727Ab1E3S3H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 14:29:07 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:43773 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab1E3S3F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 14:29:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=CUD6veC/NrtxJ6pkz9YwHcnokwuNzAM1mvivCpbIbGhDG7fORtKtnsTdKy7XNcgqMZ
         eLC07imw5hLu7ui+MiLZVjeiUhHApfkYJWlFIVckZNq54MauexZpRsGjrWrC+GG1D868
         mkyAjRXp3eh6IpUM19JXGO2SA+3y48fjl+Klo=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1105301058030.5766@asgard.lang.hm>
References: <BANLkTikGxbcMBD=3W_9_mpZBoVDc8HrX8A@mail.gmail.com>
 <201105231012.06928.oneukum@suse.de> <20110525000003.GJ32466@dastard>
 <201105250850.12179.oneukum@suse.de> <BANLkTincvGV735PKb60Kg0dLX6a1CZ-iNA@mail.gmail.com>
 <410B37BE-E380-40D0-82AA-48B56F389E16@mit.edu> <BANLkTimNjt4=9v33Z9Nr12xa6GmyJ-Ue5A@mail.gmail.com>
 <20110526133155.GH9520@thunk.org> <BANLkTinTzNN2P45tgZAQ9FsL43CqyAJR3Q@mail.gmail.com>
 <20110526162138.GN9520@thunk.org> <BANLkTinPCcX9-gK7YnMngGUJKftRTmYXNw@mail.gmail.com>
 <AC254312-8FFF-4070-BF8B-D9B1E8FF1AE6@mit.edu> <BANLkTi=BgGagV+dN9-nFcSkNsGNKbRMLfQ@mail.gmail.com>
 <alpine.DEB.2.02.1105291850260.5766@asgard.lang.hm> <BANLkTik69Gb2i1467bhnEU-pJ0WB10mqNQ@mail.gmail.com>
 <alpine.DEB.2.02.1105301058030.5766@asgard.lang.hm>
From: "D. Jansen" <d.g.jansen@googlemail.com>
Date: Mon, 30 May 2011 20:28:24 +0200
Message-ID: <BANLkTimtY0ggu28i-9VzWOO1=puZ0JvcAQ@mail.gmail.com>
Subject: Re: [rfc] Ignore Fsync Calls in Laptop_Mode
To: david@lang.hm
Cc: Theodore Tso <tytso@mit.edu>, Oliver Neukum <oneukum@suse.de>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>, njs@pobox.com, bart@samwel.tk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 8:02 PM,  <david@lang.hm> wrote:
> On Mon, 30 May 2011, D. Jansen wrote:
>> On Mon, May 30, 2011 at 3:53 AM,  <david@lang.hm> wrote:
>>> On Sun, 29 May 2011, D. Jansen wrote:
>>>> On Fri, May 27, 2011 at 4:17 PM, Theodore Tso <tytso@mit.edu> wrote:
>>>>> On May 27, 2011, at 3:12 AM, D. Jansen wrote:
>>>>>> That reordering is exactly what I'm talking about. It wasn't my idea.
>>>>>> But if I understood it correctly, it's possible that the kernel
>>>>>> commits writes of an application, _to one and the same file_, in a
>>>>>> non-FIFO order, if the application does not fsync. And this _afaiu_
>>>>>> could result in the loss not only of new data, but complete corruption
>>>>>> of previously existing data in laptop mode without fsync.
>>>>>
>>>>> No, you're not understanding the problem.   All layers of the storage
>>>>> stack -- including the hard drive -- is allowed to reorder writes.  So
>>>>> even if the kernel sends data to the disk in the exact same order that
>>>>> the application wrote it, it could still get written in a different
>>>>> order,
>>>>> because the hard drive itself can reorder writes.   This is necessary
>>>>> for performance; if you didn't have this, the storage stack would be
>>>>> dog slow, and would consume even more power.
>>>>>
>>>>> So at least level, the only thing you can count upon is that if you
>>>>> want
>>>>> to make sure everything is flushed to stable store, you need to send
>>>>> an fsync() command at the application to file system level, or a
>>>>> barrier
>>>>> or flush command at the OS to hard drive level.
>>>>
>>>> (...)
>>>>>
>>>>> Ordering doesn't matter, because nothing, including the hard drive,
>>>>> guarantees ordering.  What does matter is that the fsync() commands
>>>>> act like barriers; writes before the fsync() command are guaranteed
>>>>> to be written to the disk, and survive a reboot, before any writes
>>>>> after
>>>>> the fsync() are processed.  See?
>>>>
>>>> Ok, thanks a lot! I understand a lot better now!
>>>> So we can't live without the fsyncs.
>>>>
>>>> So what if we would queue the fsyncs along with the writes - we would
>>>> just fsync later instead of immediately, in between the writes as they
>>>> came in. Then by design previous data could not be corrupted, right?
>>>> We would do exactly the same thing, just later.
>>>> It'd be kind of a disk write time distortion field.
>>>
>>> the problem is that the spec for fsync says that your program stops until
>>> fsync finishes. If you don't do that then you will corrupt and loose
>>> data.
>>>
>>> so if you delay fsync you will have your application (or desktop manager)
>>> freeze until the fsync completes.
>>
>> So that would not be an option. Freezing until the end of the write
>> window is not what we want.
>> Neither is ignoring the fsync because that could corrupt data, esp. in
>> databases like sqlite.
>>>
>>> if what you are wanting is the ability to say 'these things must be
>>> written
>>> before these other things to keep them from being corrupted, but I don't
>>> care when they get written (or if they get lost in a crash)' then what
>>> you
>>> want isn't fsync, it's a barrier.
>>
>> That sounds great!
>> So an fsync call in laptop mode could be interpreted as a barrier
>> and we would be reasonably save from corrupting old existing data?
>
> no, you cannot just change a fsync to a barrier, in some cases the data
> absolutly needs to be saved, not just ordered (remember the example of a
> mail server telling the other system that the data can be deleted after a
> fsync returns)

I'm not really sure I why shouldn't have that choice as a user. Just
because someone else could be running a mailserver on his system and
configure it in a way that it doesn't behave as it should?
If he really wants to do that there's really nothing we can do to stop
him. I'm sure there are other ways existing kernel options can be used
to make software behave different than it should. Are we going to
remove them all now?

The big problem is that so far only fsync existed and lots of software
seemingly abuses it as an expensive write barrier. And it would really
be lovely to have the choice to stop that on an opt-in basis in laptop
mode.

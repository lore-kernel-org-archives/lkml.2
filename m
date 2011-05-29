Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab1E2Kqd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 06:46:33 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:35032 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab1E2Kqb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 06:46:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=RD/cgzeiAfmCf6FvP7j30Srp4iGjoBxiaRLzdWDiR6RgE7C7rvHtyvpBifOoX+2OEs
         AxsyIO98dytm+u1UZUwjUfbP2c7XdpL5x2cbpaKSF0d7wNBHKl30t9MFcOkjmOrqQOJr
         oevgcYC7k9x+xAxcjKeoWA3UYeHVCXQmw6bH0=
MIME-Version: 1.0
In-Reply-To: <AC254312-8FFF-4070-BF8B-D9B1E8FF1AE6@mit.edu>
References: <BANLkTikGxbcMBD=3W_9_mpZBoVDc8HrX8A@mail.gmail.com>
 <201105231012.06928.oneukum@suse.de> <20110525000003.GJ32466@dastard>
 <201105250850.12179.oneukum@suse.de> <BANLkTincvGV735PKb60Kg0dLX6a1CZ-iNA@mail.gmail.com>
 <410B37BE-E380-40D0-82AA-48B56F389E16@mit.edu> <BANLkTimNjt4=9v33Z9Nr12xa6GmyJ-Ue5A@mail.gmail.com>
 <20110526133155.GH9520@thunk.org> <BANLkTinTzNN2P45tgZAQ9FsL43CqyAJR3Q@mail.gmail.com>
 <20110526162138.GN9520@thunk.org> <BANLkTinPCcX9-gK7YnMngGUJKftRTmYXNw@mail.gmail.com>
 <AC254312-8FFF-4070-BF8B-D9B1E8FF1AE6@mit.edu>
From: "D. Jansen" <d.g.jansen@googlemail.com>
Date: Sun, 29 May 2011 12:45:51 +0200
Message-ID: <BANLkTi=BgGagV+dN9-nFcSkNsGNKbRMLfQ@mail.gmail.com>
Subject: Re: [rfc] Ignore Fsync Calls in Laptop_Mode
To: Theodore Tso <tytso@mit.edu>
Cc: Oliver Neukum <oneukum@suse.de>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        njs@pobox.com, bart@samwel.tk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 4:17 PM, Theodore Tso <tytso@mit.edu> wrote:
> On May 27, 2011, at 3:12 AM, D. Jansen wrote:
>> That reordering is exactly what I'm talking about. It wasn't my idea.
>> But if I understood it correctly, it's possible that the kernel
>> commits writes of an application, _to one and the same file_, in a
>> non-FIFO order, if the application does not fsync. And this _afaiu_
>> could result in the loss not only of new data, but complete corruption
>> of previously existing data in laptop mode without fsync.
>
> No, you're not understanding the problem.   All layers of the storage
> stack -- including the hard drive -- is allowed to reorder writes.  So
> even if the kernel sends data to the disk in the exact same order that
> the application wrote it, it could still get written in a different order,
> because the hard drive itself can reorder writes.   This is necessary
> for performance; if you didn't have this, the storage stack would be
> dog slow, and would consume even more power.
>
> So at least level, the only thing you can count upon is that if you want
> to make sure everything is flushed to stable store, you need to send
> an fsync() command at the application to file system level, or a barrier
> or flush command at the OS to hard drive level.
(...)
> Ordering doesn't matter, because nothing, including the hard drive,
> guarantees ordering.  What does matter is that the fsync() commands
> act like barriers; writes before the fsync() command are guaranteed
> to be written to the disk, and survive a reboot, before any writes after
> the fsync() are processed.  See?

Ok, thanks a lot! I understand a lot better now!
So we can't live without the fsyncs.

So what if we would queue the fsyncs along with the writes - we would
just fsync later instead of immediately, in between the writes as they
came in. Then by design previous data could not be corrupted, right?
We would do exactly the same thing, just later.
It'd be kind of a disk write time distortion field.

Thanks again for your feedback!

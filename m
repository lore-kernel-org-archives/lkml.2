Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751401Ab1E0ORz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 10:17:55 -0400
Received: from DMZ-MAILSEC-SCANNER-7.MIT.EDU ([18.7.68.36]:51531 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750839Ab1E0ORy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 10:17:54 -0400
X-AuditID: 12074424-b7bc6ae000005a77-7c-4ddfb29128c1
Subject: Re: [rfc] Ignore Fsync Calls in Laptop_Mode
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <BANLkTinPCcX9-gK7YnMngGUJKftRTmYXNw@mail.gmail.com>
Date: Fri, 27 May 2011 10:17:45 -0400
Cc: Oliver Neukum <oneukum@suse.de>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        njs@pobox.com, bart@samwel.tk
Content-Transfer-Encoding: 8BIT
Message-Id: <AC254312-8FFF-4070-BF8B-D9B1E8FF1AE6@mit.edu>
References: <BANLkTikGxbcMBD=3W_9_mpZBoVDc8HrX8A@mail.gmail.com> <201105231012.06928.oneukum@suse.de> <20110525000003.GJ32466@dastard> <201105250850.12179.oneukum@suse.de> <BANLkTincvGV735PKb60Kg0dLX6a1CZ-iNA@mail.gmail.com> <410B37BE-E380-40D0-82AA-48B56F389E16@mit.edu> <BANLkTimNjt4=9v33Z9Nr12xa6GmyJ-Ue5A@mail.gmail.com> <20110526133155.GH9520@thunk.org> <BANLkTinTzNN2P45tgZAQ9FsL43CqyAJR3Q@mail.gmail.com> <20110526162138.GN9520@thunk.org> <BANLkTinPCcX9-gK7YnMngGUJKftRTmYXNw@mail.gmail.com>
To: "D. Jansen" <d.g.jansen@googlemail.com>
X-Mailer: Apple Mail (2.1084)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCKsWRmVeSWpSXmKPExsUixCmqrTtx031fg7ePVCzmrF/DZrHi5Ho2
	i2u3J7FZbDl2j9Hi8q45bBaHu+6zWCy+OJvVgd3j1CIJj6cTJrN7nJjxm8Xj4iVlj82XlrJ7
	bD5d7fF5k1wAexSXTUpqTmZZapG+XQJXxs71e5gKtqtVrH8o2cC4Uq6LkZNDQsBE4u2X72wQ
	tpjEhXvrwWwhgX2MEhtfMXUxcgHZGxgl9h78xA7hnGaSuLN2FTNIlTBQ98TtE8BsXgFDiaWb
	2tlBbGYBLYkb/14ygdhsAkoSdz7tZ+li5ODgFHCUOLsxBcRkEVCVWPHaGmQks8BGRokH336y
	QrRqSyxb+BpqpJXEnuW7mSH2fmKWeNK0FWy+CFDR0UkXmEAGSQjISjQty5jAKDgLyRWzkFwx
	C8nYBYzMqxhlU3KrdHMTM3OKU5N1i5MT8/JSi3TN9XIzS/RSU0o3MYIig91FZQdj8yGlQ4wC
	HIxKPLzeafd8hVgTy4orcw8xSnIwKYnyPt1431eILyk/pTIjsTgjvqg0J7X4EKMEB7OSCG9K
	N1CONyWxsiq1KB8mJc3BoiTOO09S3VdIID2xJDU7NbUgtQgmK8PBoSTB+xJkqGBRanpqRVpm
	TglCmomDE2Q4D9DwJyA1vMUFibnFmekQ+VOMilLivJ9BEgIgiYzSPLheWOJ6xSgO9IowxN08
	wKQH1/0KaDAT0GCd33dBBpckIqSkGhgVIm09gx5aBe1iO+e7WvMKc7pW5p6DF+WZw3IZ/+rc
	9St/rRCrYZBv6HThqIpTSI9mgfnbGwU9zYKfVGZefOXycunhBTlzdxQmfvgS+tPlTEm3M3PG
	wvX+AaEfIhWroxvO9jC9UV24dk/4x7dPGb+FcsvtMdzfx7YnZnOGhf2fO8HxccdE65RYijMS
	DbWYi4oTAVGSYsU3AwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 27, 2011, at 3:12 AM, D. Jansen wrote:

> 
> That reordering is exactly what I'm talking about. It wasn't my idea.
> But if I understood it correctly, it's possible that the kernel
> commits writes of an application, _to one and the same file_, in a
> non-FIFO order, if the application does not fsync. And this _afaiu_
> could result in the loss not only of new data, but complete corruption
> of previously existing data in laptop mode without fsync.

No, you're not understanding the problem.   All layers of the storage
stack -- including the hard drive -- is allowed to reorder writes.  So
even if the kernel sends data to the disk in the exact same order that
the application wrote it, it could still get written in a different order, 
because the hard drive itself can reorder writes.   This is necessary
for performance; if you didn't have this, the storage stack would be 
dog slow, and would consume even more power.   

So at least level, the only thing you can count upon is that if you want
to make sure everything is flushed to stable store, you need to send
an fsync() command at the application to file system level, or a barrier
or flush command at the OS to hard drive level.  

So what databases do is the first write the changes they intend to
make to an intent log.   Then they send an fsync() command; then 
they write a commit block to the intent log; then they send another
fsync() command; and only then now that the transaction has been
committed to the commit log, do they start updating the table files.
(This is a highly simplified model, but it's good enough for this 
discussion.)

Ordering doesn't matter, because nothing, including the hard drive,
guarantees ordering.  What does matter is that the fsync() commands
act like barriers; writes before the fsync() command are guaranteed
to be written to the disk, and survive a reboot, before any writes after
the fsync() are processed.  See?

This is why getting fsync() right is so critical; things are defined to work
this way, and programs like mysql and sqllite depend on things working
this way.  You are proposing to break this.

> (Though we're not talking about writing hundreds of
> MBs in laptop mode in my average use case scenario of office
> applications and maybe a browser running.)

Firefox, in order to make their "awesome bar" work, is responsible for
300+ MB's worth of writes per click; so for every three clicks, you've
written a gigabyte.  Any other questions?

> 
> No, what I meant is that if there is a bug at any step of the
> coordination between the applications and the daemon: in the daemon,
> the software, their communication connection, etc., writes may not
> occur and we may lose data without need.

But the application will know that, and at the end of the day, if
the coordination is wrong, the application can always ignore the 
daemon, write the data and call fsync().  So if there is any failure, 
it fails safe; worst case you just waste more battery.

> Your scenario sounds like this:
> daemon announced when to flush data
> until then application buffers data in it's user space.
> 
> This means if you save a file and the application crashes, e.g. segfaults
> and is killed, the data is still in its queue and thus lost.

If the application crashes, it will always lose data.  If the application thinks
its flaky, it can always ignore protocol and force a disk write; as I said,
that will just burn battery, which is preferable to losing data.

> 
> Exactly. Great example! Again, I very much agree.("Even") I don't want
> to end up with
> corrupt data. But I accept old data. Is there really no way to get there without
> rewriting each and every application's fsync code?

If the application is using a binary database file format, then no, if you subvert
fsync(), you can risk losing the entire database.   But even if you use 100's
of flat files, if you care about the relationship between the flat files as having
critical meaning, then you can end up corrupting data even if you use lots 
of flat files.

If you are willing to rewrite the *entire* database to a completely new file each
time you want to write out some data, and only delete the old database
once the new database has been written out, then you're fine.   If the file is too
big you can delay the time period between a complete writeout of the 
database.  But then if you drop your laptop and the battery slips out, you'll
lose more data.  Life is full of tradeoffs.

If the only editor you use is vi, and the only web browser you use is  lynx, then
life is much simpler.  If you want more complexity, AND you want more safety,
then you'll have to pay for that in terms of more battery usage.

-- Ted




> 
> Thanks for your insights!


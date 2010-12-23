Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795Ab0LWWKJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 17:10:09 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51019 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab0LWWKE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 17:10:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=kQgGNtYA8lz0LHLOmm+qd9/Nox/53Ki5r/pOsWGhQ6X1Z5B2ZRH7M5zx8h4wLP0Rv5
         guP8S/xKYiCKU5bwOE4sQuOF6D5v0FcczJXeTHgG7D0fVuOPpE98nJ1oYbeR2sR5pNkC
         +eUcP0CwCnlhBHUzSnGDAEpoG5tkOmczY0CKM=
MIME-Version: 1.0
In-Reply-To: <4D139EAE.9090307@jcz.nl>
References: <20101220141553.GA6088@bitwizard.nl> <20101220190630.66084e1d@neptune.home>
 <AANLkTi=VAJbVSzX_DH9_==a3RonLJmawYu3MzF-uqGXC@mail.gmail.com>
 <20101222104306.GB30941@bitwizard.nl> <x49aajxsrh3.fsf@segfault.boston.devel.redhat.com>
 <20101222224416.GE30941@bitwizard.nl> <x494oa48scp.fsf@segfault.boston.devel.redhat.com>
 <20101223170109.GA31591@bitwizard.nl> <x49bp4c7555.fsf@segfault.boston.devel.redhat.com>
 <AANLkTikbhzopmyfbJuHUQdEBJLLP9e65n0cNBuUjhDdd@mail.gmail.com> <4D139EAE.9090307@jcz.nl>
From: Greg Freemyer <greg.freemyer@gmail.com>
Date: Thu, 23 Dec 2010 17:09:43 -0500
Message-ID: <AANLkTimXCb00Hj1iPG5XKdfSmvQCwtw1Oo7Qr14ZR=Ge@mail.gmail.com>
Subject: Re: Slow disks.
To: Jaap Crezee <jaap@jcz.nl>
Cc: Jeff Moyer <jmoyer@redhat.com>, Rogier Wolff <R.E.Wolff@bitwizard.nl>,
        =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 23, 2010 at 2:10 PM, Jaap Crezee <jaap@jcz.nl> wrote:
> On 12/23/10 19:51, Greg Freemyer wrote:
>> On Thu, Dec 23, 2010 at 12:47 PM, Jeff Moyer<jmoyer@redhat.com>  wrote:
>> I suspect a mailserver on a raid 5 with large chunksize could be a lot
>> worse than 2x slower.  But most of the blame is just raid 5.
>
> Hmmm, well if this really is so.. I use raid 5 to not "spoil" the storage
> space of one disk. I am using some other servers with raid 5 md's which
> seems to be running just fine; even under higher load than the machine we
> are talking about.
>
> Looking at the vmstat block io the typical load (both write and read) seems
> to be less than 20 blocks per second. Will this drop the performance of the
> array (measured by dd if=/dev/md<x> of=/dev/null bs=1M) below 3MB/secs?
>

You clearly have problems more significant than your raid choice, but
hopefully you will find the below informative anyway.

====

The above is a meaningless performance tuning test for a email server,
but assuming it was a useful test for you:

With bs=1MB you should have optimum performance with a 3-disk raid5
and 512KB chunks.

The reason is that a full raid stripe for that is 1MB  (512K data +
512K data + 512K parity = 1024K data)

So the raid software should see that as a full stripe update and not
have to read in any of the old data.

Thus at the kernel level it is just:

write data1 chunk
write data2 chunk
write parity chunk

All those should happen in parallel, so a raid 5 setup for 1MB writes
is actually just about optimal!

Anything smaller than a 1 stripe write is where the issues occur,
because then you have the read-modify-write cycles.

(And yes, the linux mdraid layer recognizes full stripe writes and
thus skips the read-modify portion of the process.)

>> ie.
>> write 4K from userspace
>>
>> Kernel
>> Read old primary data, wait for data to actually arrive
>> Read old parity data, wait again
>> modify both for new data
>> write primary data to drive queue
>> write parity data to drive queue
>
> What if I (theoratically) change the chunksize to 4kb? (I can try that in
> the new server...).

4KB random writes is really just too small for an efficient raid 5
setup.  Since that's your real workload, I'd get away from raid 5.

If you really want to optimize a 3-disk raid-5 for random 4K writes,
you need to drop down to 2K chunks which gives you a 4K stripe.  I've
never seen chunks that small used, so I have no idea how it would
work.

===> fyi: If reliability is one of the things pushing you away from raid-1

A 2 disk raid-1 is more reliable than a 3-disk raid-5.

The math is, assume each of your drives has a one in 1000 chance of
dieing on a specific day.

So a raid-1 has a 1 in a million chance of a dual failure on that same
specific day.

And a raid-5 would have 3 in a million chances of a dual failure on
that same specific day.  ie. drive 1 and 2 can fail that day, or 1 and
3, or 2 and 3.

So a 2 drive raid-1 is 3 times as reliable as a 3-drive raid-5.

If raid-1 still makes you uncomfortable, then go with a 3-disk mirror
(raid 1 or raid 10 depending on what you need.)

You can get 2TB sata drives now for about $100 on sale, so you could
do a 2 TB 3-disk raid-1 for $300.  Not a bad price at all in my
opinion.

fyi: I don't know if "enterprise" drives cost more or not.  But it is
important you use those in a raid setup.  The reason being normal
desktop drives have retry logic built into the drive that can take
from 30 to 120 seconds.  Enterprise drives have fast fail logic that
allows a media error to rapidly be reported back to the kernel so that
it can read that data from the alternate drives available in a raid.

> Jaap

Greg


-- 
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
CNN/TruTV Aired Forensic Imaging Demo -
   http://insession.blogs.cnn.com/2010/03/23/how-computer-evidence-gets-retrieved/

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com

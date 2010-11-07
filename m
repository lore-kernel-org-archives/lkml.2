Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774Ab0KGGGp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 01:06:45 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52965 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab0KGGGo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 01:06:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=i8YHqN6vMD7j/BGTzGlENR9n/ix+M+aYAqE+XJf3DFfMxX+DRulJDZr6ee0dmFbXfH
         /hIus+3BNHwS1RWUMbEiWlsC9yAREAED5bY7RDsFiRJXBB9OM5sPpBFfnab43MNQ9VLy
         vLUUZ2AUySencKrNllHi8JIhzZvVieZ/UbsBg=
MIME-Version: 1.0
In-Reply-To: <20101106151237.GM13830@dastard>
References: <20101105014334.GF13830@dastard> <E1PELiI-0001Pj-8g@approx.mit.edu>
 <AANLkTimON_GL6vRF9=_U6oRFQ30EYssx3wv5xdNsU9JM@mail.gmail.com> <20101106151237.GM13830@dastard>
From: dave b <db.pub.mail@gmail.com>
Date: Sun, 7 Nov 2010 17:06:22 +1100
Message-ID: <AANLkTikbcTwZ5ttafqQTQgJ4sxbcpOrDhAQgDURgoimL@mail.gmail.com>
Subject: Re: 2.6.36 io bring the system to its knees
To: Dave Chinner <david@fromorbit.com>
Cc: Sanjoy Mahajan <sanjoy@olin.edu>, Jesper Juhl <jj@chaosbits.net>,
        Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
        Pekka Enberg <penberg@kernel.org>,
        Aidar Kultayev <the.aidar@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Nick Piggin <npiggin@suse.de>, Arjan van de Ven <arjan@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, "Ted Ts'o" <tytso@mit.edu>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        Shaohua Li <shaohua.li@intel.com>, Steven Barrett <damentz@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 November 2010 02:12, Dave Chinner <david@fromorbit.com> wrote:
> On Sun, Nov 07, 2010 at 01:10:24AM +1100, dave b wrote:
>> I now personally have thought that this problem is the kernel not
>> keeping track of reads vs writers properly  or not providing enough
>> time to reading processes as writing ones which look like they are
>> blocking the system....
>
> Could be anything from that description....
>
>> If you want to do a simple test do an unlimited dd  (or two dd's of a
>> limited size, say 10gb) and a find /
>> Tell me how it goes :)
>
> The find runs at IO latency speed while the dd processes run at disk
> bandwidth:
>
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> vda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
> vdb               0.00     0.00   58.00 1251.00     0.45   556.54   871.45    26.69   20.39   0.72  94.32
> sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
>
> That looks pretty normal to me for XFS and the noop IO scheduler,
> and there are no signs of latency or interactive problems in
> the system at all. Kill the dd's and:
>
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> vda               0.00     0.00    0.00    0.00     0.00     0.00 0.00     0.00    0.00   0.00   0.00
> vdb               0.00     0.00  214.80    0.40     1.68     0.00 15.99     0.33    1.54   1.54  33.12
> sda               0.00     0.00    0.00    0.00     0.00     0.00 0.00     0.00    0.00   0.00   0.00
>
> And the find runs 3-4x faster, but ~200 iops is about the limit
> I'd expect from 7200rpm SATA drives given a single thread issuing IO
> (i.e. 5ms average seek time).
>
>> ( the system will stall)
>
> No, the system doesn't stall at all. It runs just fine. Sure,
> anything that requires IO on the loaded filesystem is _slower_, but
> if you're writing huge files to it that's pretty much expected. The
> root drive (on a different spindle) is still perfectly responsive on
> a cold cache:
>
> $ sudo time find / -xdev > /dev/null
> 0.10user 1.87system 0:03.39elapsed 58%CPU (0avgtext+0avgdata 7008maxresident)k
> 0inputs+0outputs (1major+844minor)pagefaults 0swap
>
> So what you describe is not a systemic problem, but a problem that
> your system configuration triggers. That's why we need to know
> _exactly_ how your storage subsystem is configured....
>
>> http://article.gmane.org/gmane.linux.kernel.device-mapper.dm-crypt/4561
>> iirc can reproduce this on plain ext3.
>
> You're pointing to a "fsync-tester" program that exercises a
> well-known problem with ext3 (sync-the-world-on-fsync). Other
> filesystems do not have that design flaw so don't suffer from
> interactivity problems uner these workloads.  As it is, your above
> dd workload example is not related to this fsync problem, either.
>
> This is what I'm trying to point out - you need to describe in
> significant detail your setup and what your applications are doing
> so we can identify if you are seeing a known problem or not. If you
> are seeing problems as a result of the above ext3 fsync problem,
> then the simple answer is "don't use ext3".

Thank you for your reply.
Well I am not sure :)
Is the answer "don't use ext3" ?
If it is what should I really be using instead?

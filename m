Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539Ab2GSNdu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 09:33:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852Ab2GSNdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 09:33:47 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, "Alasdair G. Kergon" <agk@redhat.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        dm-devel@redhat.com, lwoodman@redhat.com,
        Andrea Arcangeli <aarcange@redhat.com>, kosaki.motohiro@jp.fujitsu.com
Subject: Re: Crash when IO is being submitted and block size is changed
References: <Pine.LNX.4.64.1206272226050.22857@file.rdu.redhat.com>
	<20120628111541.GB17515@quack.suse.cz>
	<Pine.LNX.4.64.1207152051490.4240@file.rdu.redhat.com>
	<x49ipdmyz4q.fsf@segfault.boston.devel.redhat.com>
	<Pine.LNX.4.64.1207181512530.10923@file.rdu.redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 19 Jul 2012 09:33:11 -0400
In-Reply-To: <Pine.LNX.4.64.1207181512530.10923@file.rdu.redhat.com> (Mikulas
	Patocka's message of "Wed, 18 Jul 2012 22:27:13 -0400 (EDT)")
Message-ID: <x49k3xzq3jc.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikulas Patocka <mpatocka@redhat.com> writes:

> On Tue, 17 Jul 2012, Jeff Moyer wrote:
>

>> > This is the patch that fixes this crash: it takes a rw-semaphore around 
>> > all direct-IO path.
>> >
>> > (note that if someone is concerned about performance, the rw-semaphore 
>> > could be made per-cpu --- take it for read on the current CPU and take it 
>> > for write on all CPUs).
>> 
>> Here we go again.  :-)  I believe we had at one point tried taking a rw
>> semaphore around GUP inside of the direct I/O code path to fix the fork
>> vs. GUP race (that still exists today).  When testing that, the overhead
>> of the semaphore was *way* too high to be considered an acceptable
>> solution.  I've CC'd Larry Woodman, Andrea, and Kosaki Motohiro who all
>> worked on that particular bug.  Hopefully they can give better
>> quantification of the slowdown than my poor memory.
>> 
>> Cheers,
>> Jeff
>
> Both down_read and up_read together take 82 ticks on Core2, 69 ticks on 
> AMD K10, 62 ticks on UltraSparc2 if the target is in L1 cache. So, if 
> percpu rw_semaphores were used, it would slow down only by this amount.

Sorry, I'm not familiar with per-cpu rw semaphores.  Where are they
implemented?

> I hope that Linux developers are not so obsessed with performance that
> they want a fast crashing kernel rather than a slow reliable kernel.
> Note that anything that changes a device block size (for example
> mounting a filesystem with non-default block size) may trigger a crash
> if lvm or udev reads the device simultaneously; the crash really
> happened in business environment).

I wasn't suggesting that we leave the problem unfixed (though I can see
how you might have gotten that idea, sorry for not being more clear).  I
was merely suggesting that we should try to fix the problem in a way
that does not kill performance.

Cheers,
Jeff

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434Ab0GNTAn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 15:00:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757419Ab0GNTAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 15:00:41 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] deadline-iosched: don't allow aliased requests to starve others
References: <x494og2cfjd.fsf@segfault.boston.devel.redhat.com>
	<x49vd8iatee.fsf@segfault.boston.devel.redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 14 Jul 2010 15:00:37 -0400
In-Reply-To: <x49vd8iatee.fsf@segfault.boston.devel.redhat.com> (Jeff Moyer's
	message of "Wed, 14 Jul 2010 13:02:33 -0400")
Message-ID: <x49lj9dc2i2.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Moyer <jmoyer@redhat.com> writes:

> Jeff Moyer <jmoyer@redhat.com> writes:
>
>> Hi,
>>
>> In running a test case that tries to trip up the kernel's AIO
>> implementation, we ran into a situation where no other I/O to the device
>> under test would be completed.  The test program spawned (in this case)
>> 100 threads, each of which performed the following in a loop:
>>
>> open file O_DIRECT
>> queue 1MB of read I/O from file using 16 iocbs
>> close file
>> repeat
>>
>> The program does NOT wait for the I/O to complete.  The file length is
>> only 4MB, meaning that you have 25 threads performing I/O on each of the
>> 4 1MB regions.
>>
>> Both deadline and cfq check for aliased requests in the sorted list of
>> I/Os, and when an alias is found, the request in the rb tree is moved to
>> the dispatch list.  So, what happens is that, with this workload, only
>> requests from this program are moved to the dispatch list, starving out
>> all other I/O.
>>
>> The attached patch fixes this problem by issuing all expired requests in
>> the aliased request handling code.  The reason I opted to issue all
>> expired requsts is because if we only service a single one, I still see
>> really awful interactivity;  an ls would take over 5 minutes to
>> complete.  With the attached patch, the ls took about 7 seconds to
>> complete.
>
> It occured to me that this doesn't solve the problem of starving WRITE
> I/O.  So, this patch fixes that as well, tested with a dd if=/dev/zero
> of=outfile bs=1M count=1 oflag=sync while.

Gah.  Forgot:

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

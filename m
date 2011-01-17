Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab1AQTIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 14:08:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15574 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055Ab1AQTIQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 14:08:16 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Nick Piggin <npiggin@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] fs: aio fix rcu lookup
References: <AANLkTimMwZnm3UKvmrPscBeZF77vh1sW0ERO1tuv1oNW@mail.gmail.com>
	<x494o9bbkqo.fsf@segfault.boston.devel.redhat.com>
	<AANLkTimuCgn4aHzUJRmQfsXjG_UF-3W8fAWb0Y-sSPsM@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 17 Jan 2011 14:07:41 -0500
In-Reply-To: <AANLkTimuCgn4aHzUJRmQfsXjG_UF-3W8fAWb0Y-sSPsM@mail.gmail.com>
	(Nick Piggin's message of "Sat, 15 Jan 2011 02:00:25 +1100")
Message-ID: <x49tyh7mjr6.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <npiggin@gmail.com> writes:

> On Sat, Jan 15, 2011 at 1:52 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
>> Nick Piggin <npiggin@gmail.com> writes:
>>
>>> Hi,
>>>
>>> While hunting down a bug in NFS's AIO, I believe I found this
>>> buggy code...
>>>
>>> fs: aio fix rcu ioctx lookup
>>>
>>> aio-dio-invalidate-failure GPFs in aio_put_req from io_submit.
>>>
>>> lookup_ioctx doesn't implement the rcu lookup pattern properly.
>>> rcu_read_lock does not prevent refcount going to zero, so we
>>> might take a refcount on a zero count ioctx.
>>
>> So, does this patch fix the problem?  You didn't actually say....
>
> No, it seemd to be an NFS AIO problem, although it was a
> slightly older kernel so I'll re test after -rc1 if I haven't heard
> back about it.

OK.

> Do you agree with the theoretical problem? I didn't try to
> write a racer to break it yet. Inserting a delay before the
> get_ioctx might do the trick.

I'm not convinced, no.  The last reference to the kioctx is always the
process, released in the exit_aio path, or via sys_io_destroy.  In both
cases, we cancel all aios, then wait for them all to complete before
dropping the final reference to the context.

So, while I agree that what you wrote is better, I remain unconvinced of
it solving a real-world problem.  Feel free to push it in as a cleanup,
though.

Cheers,
Jeff

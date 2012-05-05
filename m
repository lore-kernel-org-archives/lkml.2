Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077Ab2EEL2g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 07:28:36 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64186 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636Ab2EEL2f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 07:28:35 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <CAHGf_=oOx1qPFEboQeuaeMKtveM2==BSDG=xdfRHz+gFx1GAfw@mail.gmail.com>
References: <CAHGf_=qdE3yNw=htuRssfav2pECO1Q0+gWMRTuNROd_3tVrd6Q@mail.gmail.com>
 <CAHGf_=ojhwPUWJR0r+jVgjNd5h_sRrppzJntSpHzxyv+OuBueg@mail.gmail.com>
 <x49ehr4lyw1.fsf@segfault.boston.devel.redhat.com> <CAHGf_=rzcfo3OnwT-YsW2iZLchHs3eBKncobvbhTm7B5PE=L-w@mail.gmail.com>
 <x491un3nc7a.fsf@segfault.boston.devel.redhat.com> <CAPa8GCCgLUt1EDAy7-O-mo0qir6Bf5Pi3Va1EsQ3ZW5UU=+37g@mail.gmail.com>
 <20120502081705.GB16976@quack.suse.cz> <CAPa8GCCnvvaj0Do7sdrdfsvbcAf0zBe3ssXn45gMfDKCcvJWxA@mail.gmail.com>
 <20120502091837.GC16976@quack.suse.cz> <CAHGf_=qfuRZzb91ELEcArNaNHsfO4BBMPO8a-QRBzFNaT2ev_w@mail.gmail.com>
 <20120502192325.GA18339@quack.suse.cz> <CAHGf_=oOx1qPFEboQeuaeMKtveM2==BSDG=xdfRHz+gFx1GAfw@mail.gmail.com>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Sat, 5 May 2012 23:28:13 +1200
Message-ID: <CAKgNAkjybL_hmVfONUHtCbBe_VxQHNHOrmWQErGWDUqHiczkFg@mail.gmail.com>
Subject: Re: [PATCH] Describe race of direct read and fork for unaligned buffers
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Nick Piggin <npiggin@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Jeff Moyer <jmoyer@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-man@vger.kernel.org,
        linux-mm@kvack.org, mgorman@suse.de,
        Andrea Arcangeli <aarcange@redhat.com>, Woodman <lwoodman@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 3, 2012 at 7:25 AM, KOSAKI Motohiro
<kosaki.motohiro@gmail.com> wrote:
> On Wed, May 2, 2012 at 3:23 PM, Jan Kara <jack@suse.cz> wrote:
>> On Wed 02-05-12 15:14:33, KOSAKI Motohiro wrote:
>>> Hello,
>>>
>>> >> I see what you mean.
>>> >>
>>> >> I'm not sure, though. For most apps it's bad practice I think. If you get into
>>> >> realm of sophisticated, performance critical IO/storage managers, it would
>>> >> not surprise me if such concurrent buffer modifications could be allowed.
>>> >> We allow exactly such a thing in our pagecache layer. Although probably
>>> >> those would be using shared mmaps for their buffer cache.
>>> >>
>>> >> I think it is safest to make a default policy of asking for IOs against private
>>> >> cow-able mappings to be quiesced before fork, so there are no surprises
>>> >> or reliance on COW details in the mm. Do you think?
>>> >    Yes, I agree that (and MADV_DONTFORK) is probably the best thing to have
>>> > in documentation. Otherwise it's a bit too hairy...
>>>
>>> I neglected this issue for years because Linus asked who need this and
>>> I couldn't
>>> find real world usecase.
>>>
>>> Ah, no, not exactly correct. Fujitsu proprietary database had such
>>> usecase. But they quickly fixed it. Then I couldn't find alternative usecase.
>>  One of our customers hit this bug recently which is why I started to look
>> at this. But they also modified their application not to hit the problem.
>>
>>> I'm not sure why you say "hairy". Do you mean you have any use case of this?
>>  I meant that if we should describe conditions like "if you have page
>> aligned buffer and you don't write to it while the IO is running, the
>> problem also won't occur", then it's already too detailed and might
>> easily change in future kernels...

So, am I correct to assume that right text to add to the page is as below?

Nick, can you clarify what you mean by "quiesced"?

[[
O_DIRECT IOs should never be run concurrently with fork(2) system call,
when the memory buffer is anonymous memory, or comes from mmap(2)
with MAP_PRIVATE.

Any such IOs, whether submitted with asynchronous IO interface or from
another thread in the process, should be quiesced before fork(2) is called.
Failure to do so can result in data corruption and undefined behavior in
parent and child processes.

This restriction does not apply when the memory buffer for the O_DIRECT
IOs comes from mmap(2) with MAP_SHARED or from shmat(2).
Nor does this restriction apply when the memory buffer has been advised
as MADV_DONTFORK with madvise(2), ensuring that it will not be available
to the child after fork(2).
]]

Thanks,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/

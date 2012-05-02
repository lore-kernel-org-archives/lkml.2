Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758522Ab2EBDKH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 23:10:07 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63489 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757629Ab2EBDKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 23:10:05 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1205011952040.1293@eggly.anvils>
References: <1335778207-6511-1-git-send-email-jack@suse.cz>
	<CAHGf_=qqiast+6XzGnq+LRdFXoWG9h2MkofmjS1h5OeNPRyWfw@mail.gmail.com>
	<CAKgNAkjAOGM+mZLkXGiDFYsnMCpJsxx=Nd5pZfx-_f4B1jvh+A@mail.gmail.com>
	<CAPa8GCC7tHm_8Ks_=tM4x544+SEtkVk6TMAF3KPsVqzNOi-naA@mail.gmail.com>
	<alpine.LSU.2.00.1205011952040.1293@eggly.anvils>
Date: Wed, 2 May 2012 13:10:04 +1000
Message-ID: <CAPa8GCB7UGe0xr_pagbAJQAXn1t03m_8sraYxpkdbY1F3o7GRw@mail.gmail.com>
Subject: Re: [PATCH] Describe race of direct read and fork for unaligned buffers
From: Nick Piggin <npiggin@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: mtk.manpages@gmail.com, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        linux-man@vger.kernel.org, linux-mm@kvack.org, mgorman@suse.de,
        Jeff Moyer <jmoyer@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 May 2012 13:04, Hugh Dickins <hughd@google.com> wrote:
> On Wed, 2 May 2012, Nick Piggin wrote:
>> On 2 May 2012 03:56, Michael Kerrisk (man-pages) <mtk.manpages@gmail.com> wrote:
>> >
>> > In the light of all of the comments, can someone revise the man-pages
>> > patch that Jan sent?
>>
>> This does not quite describe the entire situation, but something understandable
>> to developers:
>>
>> O_DIRECT IOs should never be run concurrently with fork(2) system call,
>> when the memory buffer is anonymous memory, or comes from mmap(2)
>> with MAP_PRIVATE.
>>
>> Any such IOs, whether submitted with asynchronous IO interface or from
>> another thread in the process, should be quiesced before fork(2) is called.
>> Failure to do so can result in data corruption and undefined behavior in
>> parent and child processes.
>>
>> This restriction does not apply when the memory buffer for the O_DIRECT
>> IOs comes from mmap(2) with MAP_SHARED or from shmat(2).
>
> Nor does this restriction apply when the memory buffer has been advised
> as MADV_DONTFORK with madvise(2), ensuring that it will not be available
> to the child after fork(2).

Yes of course, I forgot that was exported too.

>
>>
>>
>>
>> Is that on the right track? I feel it might be necessary to describe this
>> allowance for MAP_SHARED, because some databases may be doing
>> such things, and anyway it gives apps a potential way to make this work
>> if concurrent fork + DIO is very important.
>
> Looks good, but we do need a reference to MADV_DONTFORK, perhaps as above.

Yep, thanks Hugh.

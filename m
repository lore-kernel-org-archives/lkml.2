Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445Ab2EBAe6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 20:34:58 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61182 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756679Ab2EBAem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 20:34:42 -0400
MIME-Version: 1.0
In-Reply-To: <CAKgNAkjAOGM+mZLkXGiDFYsnMCpJsxx=Nd5pZfx-_f4B1jvh+A@mail.gmail.com>
References: <1335778207-6511-1-git-send-email-jack@suse.cz>
	<CAHGf_=qqiast+6XzGnq+LRdFXoWG9h2MkofmjS1h5OeNPRyWfw@mail.gmail.com>
	<CAKgNAkjAOGM+mZLkXGiDFYsnMCpJsxx=Nd5pZfx-_f4B1jvh+A@mail.gmail.com>
Date: Wed, 2 May 2012 10:34:42 +1000
Message-ID: <CAPa8GCC7tHm_8Ks_=tM4x544+SEtkVk6TMAF3KPsVqzNOi-naA@mail.gmail.com>
Subject: Re: [PATCH] Describe race of direct read and fork for unaligned buffers
From: Nick Piggin <npiggin@gmail.com>
To: mtk.manpages@gmail.com
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>, Jan Kara <jack@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>, linux-man@vger.kernel.org,
        linux-mm@kvack.org, mgorman@suse.de, Jeff Moyer <jmoyer@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 May 2012 03:56, Michael Kerrisk (man-pages) <mtk.manpages@gmail.com> wrote:
> On Wed, May 2, 2012 at 4:15 AM, KOSAKI Motohiro
> <kosaki.motohiro@gmail.com> wrote:
>>> +suffices. However, if the user buffer is not page aligned and direct read
>>
>> One more thing. direct write also makes data corruption. Think
>> following scenario,
>
> In the light of all of the comments, can someone revise the man-pages
> patch that Jan sent?

This does not quite describe the entire situation, but something understandable
to developers:

O_DIRECT IOs should never be run concurrently with fork(2) system call,
when the memory buffer is anonymous memory, or comes from mmap(2)
with MAP_PRIVATE.

Any such IOs, whether submitted with asynchronous IO interface or from
another thread in the process, should be quiesced before fork(2) is called.
Failure to do so can result in data corruption and undefined behavior in
parent and child processes.

This restriction does not apply when the memory buffer for the O_DIRECT
IOs comes from mmap(2) with MAP_SHARED or from shmat(2).



Is that on the right track? I feel it might be necessary to describe this
allowance for MAP_SHARED, because some databases may be doing
such things, and anyway it gives apps a potential way to make this work
if concurrent fork + DIO is very important.

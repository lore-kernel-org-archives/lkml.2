Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536Ab2EAPe0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 11:34:26 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46868 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab2EAPeZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 11:34:25 -0400
MIME-Version: 1.0
In-Reply-To: <x49ehr4lyw1.fsf@segfault.boston.devel.redhat.com>
References: <1335778207-6511-1-git-send-email-jack@suse.cz>
 <CAHGf_=qdE3yNw=htuRssfav2pECO1Q0+gWMRTuNROd_3tVrd6Q@mail.gmail.com>
 <CAHGf_=ojhwPUWJR0r+jVgjNd5h_sRrppzJntSpHzxyv+OuBueg@mail.gmail.com> <x49ehr4lyw1.fsf@segfault.boston.devel.redhat.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Tue, 1 May 2012 11:34:04 -0400
Message-ID: <CAHGf_=rzcfo3OnwT-YsW2iZLchHs3eBKncobvbhTm7B5PE=L-w@mail.gmail.com>
Subject: Re: [PATCH] Describe race of direct read and fork for unaligned buffers
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Michael Kerrisk <mtk.manpages@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-man@vger.kernel.org,
        linux-mm@kvack.org, mgorman@suse.de, npiggin@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 1, 2012 at 11:11 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> KOSAKI Motohiro <kosaki.motohiro@gmail.com> writes:
>
>>> Hello,
>>>
>>> Thank you revisit this. But as far as my remember is correct, this issue is NOT
>>> unaligned access issue. It's just get_user_pages(_fast) vs fork race issue. i.e.
>>> DIRECT_IO w/ multi thread process should not use fork().
>>
>> The problem is, fork (and its COW logic) assume new access makes cow break,
>> But page table protection can't detect a DMA write. Therefore DIO may override
>> shared page data.
>
> Hm, I've only seen this with misaligned or multiple sub-page-sized reads
> in the same page.  AFAIR, aligned, page-sized I/O does not get split.
> But, I could be wrong...

If my remember is correct, the reproducer of past thread is misleading.

dma_thread.c in
http://lkml.indiana.edu/hypermail/linux/kernel/0903.1/01498.html has
align parameter. But it doesn't only change align. Because of, every
worker thread read 4K (pagesize), then
 - when offset is page aligned
    -> every page is accessed from only one worker
 - when offset is not page aligned
    -> every page is accessed from two workers

But I don't remember why two threads are important things. hmm.. I'm
looking into the code a while.
Please don't 100% trust me.

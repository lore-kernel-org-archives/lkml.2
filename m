Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371Ab2EBJJ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 05:09:56 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49402 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756098Ab2EBJJy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 05:09:54 -0400
MIME-Version: 1.0
In-Reply-To: <20120502081705.GB16976@quack.suse.cz>
References: <1335778207-6511-1-git-send-email-jack@suse.cz>
	<CAHGf_=qdE3yNw=htuRssfav2pECO1Q0+gWMRTuNROd_3tVrd6Q@mail.gmail.com>
	<CAHGf_=ojhwPUWJR0r+jVgjNd5h_sRrppzJntSpHzxyv+OuBueg@mail.gmail.com>
	<x49ehr4lyw1.fsf@segfault.boston.devel.redhat.com>
	<CAHGf_=rzcfo3OnwT-YsW2iZLchHs3eBKncobvbhTm7B5PE=L-w@mail.gmail.com>
	<x491un3nc7a.fsf@segfault.boston.devel.redhat.com>
	<CAPa8GCCgLUt1EDAy7-O-mo0qir6Bf5Pi3Va1EsQ3ZW5UU=+37g@mail.gmail.com>
	<20120502081705.GB16976@quack.suse.cz>
Date: Wed, 2 May 2012 19:09:54 +1000
Message-ID: <CAPa8GCCnvvaj0Do7sdrdfsvbcAf0zBe3ssXn45gMfDKCcvJWxA@mail.gmail.com>
Subject: Re: [PATCH] Describe race of direct read and fork for unaligned buffers
From: Nick Piggin <npiggin@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Jeff Moyer <jmoyer@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-man@vger.kernel.org,
        linux-mm@kvack.org, mgorman@suse.de,
        Andrea Arcangeli <aarcange@redhat.com>, Woodman <lwoodman@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 May 2012 18:17, Jan Kara <jack@suse.cz> wrote:
> On Wed 02-05-12 01:50:46, Nick Piggin wrote:

>> KOSAKI-san is correct, I think.
>>
>> The race is something like this:
>>
>> DIO-read
>>     page = get_user_pages()
>>                                                         fork()
>>                                                             COW(page)
>>                                                          touch(page)
>>     DMA(page)
>>     page_cache_release(page);
>>
>> So whether parent or child touches the page, determines who gets the
>> actual DMA target, and who gets the copy.
>  OK, this is roughly what I understood from original threads as well. So
> if our buffer is page aligned and its size is page aligned, you would hit
> the corruption only if you do modify the buffer while IO to / from that buffer
> is in progress. And that would seem like a really bad programming practice
> anyway. So I still believe that having everything page size aligned will
> effectively remove the problem although I agree it does not aim at the core
> of it.

I see what you mean.

I'm not sure, though. For most apps it's bad practice I think. If you get into
realm of sophisticated, performance critical IO/storage managers, it would
not surprise me if such concurrent buffer modifications could be allowed.
We allow exactly such a thing in our pagecache layer. Although probably
those would be using shared mmaps for their buffer cache.

I think it is safest to make a default policy of asking for IOs against private
cow-able mappings to be quiesced before fork, so there are no surprises
or reliance on COW details in the mm. Do you think?

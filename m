Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540Ab2ECKFS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 06:05:18 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57705 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622Ab2ECKFQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 06:05:16 -0400
MIME-Version: 1.0
In-Reply-To: <5b62749cb9227016ed5965fa57b96c0dccce37a8.1335894230.git.dledford@redhat.com>
References: <1335894655-11398-1-git-send-email-dledford@redhat.com>
	<5b62749cb9227016ed5965fa57b96c0dccce37a8.1335894230.git.dledford@redhat.com>
Date: Thu, 3 May 2012 20:05:15 +1000
Message-ID: <CAPa8GCCBQfR-nUOmwz6oSdCao63tHUH1jfGs2XcgCe_+g3grCQ@mail.gmail.com>
Subject: Re: [Patch 1/4] ipc/mqueue: improve performance of send/recv
From: Nick Piggin <npiggin@gmail.com>
To: Doug Ledford <dledford@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        sfr@canb.auug.org.au
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 May 2012 03:50, Doug Ledford <dledford@redhat.com> wrote:

> Avg time to send/recv (in nanoseconds per message)
>  when queue empty            305/288                    349/318
>  when queue full (65528 messages)
>    constant priority      526589/823                    362/314
>    increasing priority    403105/916                    495/445
>    decreasing priority     73420/594                    482/409
>    random priority        280147/920                    546/436
>
> Time to fill/drain queue (65528 messages, in seconds)
>  constant priority         17.37/.12                    .13/.12
>  increasing priority        4.14/.14                    .21/.18
>  decreasing priority       12.93/.13                    .21/.18
>  random priority            8.88/.16                    .22/.17
>
> So, I think the results speak for themselves.  It's possible this
> implementation could be improved by cacheing at least one priority
> level in the node tree (that would bring the queue empty performance
> more in line with the old implementation), but this works and is *so*
> much better than what we had, especially for the common case of a
> single priority in use, that further refinements can be in follow on
> patches.

Nice work! Yeah I think if you cache a last unused entry, that
should mostly solve the empty queue regression.

I would imagine most users won't have huge queues, so the
empty case should be important too.

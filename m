Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab1IWAdk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 20:33:40 -0400
Received: from smtp-out.google.com ([74.125.121.67]:19041 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604Ab1IWAdi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 20:33:38 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=kNUAhahpagKXZQwC3znFHTcrlLfDhMbFc2BjIDZMTbVHhXpJbuoNVwK7LUSz0mcWr
	epHIBIiXOwhTMhZ2S6upQ==
MIME-Version: 1.0
In-Reply-To: <x4962kkh6ls.fsf@segfault.boston.devel.redhat.com>
References: <x4962kkh6ls.fsf@segfault.boston.devel.redhat.com>
Date: Thu, 22 Sep 2011 17:33:29 -0700
Message-ID: <CAAK6Zt2nkBX5ak=p-hAj4=UHiGd6WXRgeFYntAeWV++iaaGN4w@mail.gmail.com>
Subject: Re: [patch, v3] aio: allocate kiocbs in batches
From: Daniel Ehrenberg <dehrenberg@google.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 9:41 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Hi,
>
> In testing aio on a fast storage device, I found that the context lock
> takes up a fair amount of cpu time in the I/O submission path.  The
> reason is that we take it for every I/O submitted (see __aio_get_req).
> Since we know how many I/Os are passed to io_submit, we can preallocate
> the kiocbs in batches, reducing the number of times we take and release
> the lock.  In my testing, I was able to reduce the amount of time spent
> in _raw_spin_lock_irq by .56% (average of 3 runs).  The command I used
> to test this was:
>   aio-stress -O -o 2 -o 3 -r 8 -d 128 -b 32 -i 32 -s 16384 <dev>
>
> I also tested the patch with various numbers of events passed to
> io_submit, and I ran the xfstests aio group of tests to ensure I didn't
> break anything.
>

This patch looks great! It produces a significant speedup on a
benchmark I care about.

I have been looking into improving the efficiency of io_submit, and I
believe there is still more work that can be done.

Dan

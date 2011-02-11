Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454Ab1BKAga (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 19:36:30 -0500
Received: from smtp-out.google.com ([216.239.44.51]:9789 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822Ab1BKAg2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 19:36:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=l2xAdJBjbeB1ZJGYjt55jnbaxkq6Zs6mAY56uUGPUp3twfi5FQsJFCw8r+pgqC201a
         bZdA2wn/EvPPX7od4BPA==
MIME-Version: 1.0
In-Reply-To: <AANLkTi=J8x3cEhQ_tJJ0=YM6+y_ZNLtK_34PweQfNJL8@mail.gmail.com>
References: <20110210013211.21573.69260.stgit@neat.mtv.corp.google.com>
	<20110210020946.GA27040@redhat.com>
	<AANLkTi=dZDK6VosLX8JH4gJyRQ0KXGKMA5vhJ-7D93s7@mail.gmail.com>
	<20110210035738.GC27040@redhat.com>
	<AANLkTi=J8x3cEhQ_tJJ0=YM6+y_ZNLtK_34PweQfNJL8@mail.gmail.com>
Date: Thu, 10 Feb 2011 16:36:25 -0800
Message-ID: <AANLkTimdOO2qvafZ9f6csjqhh1e5w1iOEybN+1-3G3ep@mail.gmail.com>
Subject: Re: [PATCH] Avoid preferential treatment of groups that aren't backlogged
From: Chad Talbott <ctalbott@google.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: jaxboe@fusionio.com, guijianfeng@cn.fujitsu.com, mrubin@google.com,
        teravest@google.com, jmoyer@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 10:57 AM, Chad Talbott <ctalbott@google.com> wrote:
> On Wed, Feb 9, 2011 at 7:57 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> If you ran different random readers in different groups of differnet
>> weight with group_isolation=1, then there is a case of having service
>> differentiation. In that case we will idle for 8ms on each group before
>> we expire the group. So in these test cases are low weight groups not
>> submitting IO with-in 8ms? Putting a random reader in separate group
>> with think time > 8, I think is going to hurt a lot because for every
>> single IO dispatched group is going to weight for 8ms before it is
>> expired.
>
> You're right about the behavior of group_idle.  We have more
> experience with earlier kernels (before group_idle).  With this patch
> we are able to achieve isolation without group_idle even with these
> large ratios.  (Without group_idle the random reader workloads will
> get marked seeky, and idling is disabled.  Without group_idle, we have
> to remember the vdisktime to get isolation.)
>
>> Can you run blktrace and verify what's happenig?
>
> I can run a blktrace, and I think it will show what you expect.

So, I ran the following two tests and took a blktrace.

950 rdrand, 50 rdrand.delay10
weight 950 random reader with low think time vs weight 50 random
reader with 10ms think time

950 rdrand, 50 rdrand.delay50 # 50ms think time
weight 950 random reader with low think time vs weight 50 random
reader with 50ms think time

I find that we are still idling for these random readers, even the one
with 50ms think time.  group_idle is 0 according to blktrace.

With this patch, both of these cases have correct isolation.  Without
this patch, the small weight reader is able to get more than its
share.

I think that idling for a random reader with a 50ms think time is
likely a bug, but a separate issue.

Chad

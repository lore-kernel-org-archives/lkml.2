Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab1FGDt3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 23:49:29 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42200 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658Ab1FGDt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 23:49:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Ra2S5RVAlJZFa9YV7bVu7ZEr7qFWHH7cecHebXBGO5xKOjlAL/wHQ4Ozsj5jiFmG+N
         KiZRs3s5L7wStzs7/zb8SMKeLZEHQBibIuSihrMpgoMzWHjBMcggw+V2i1RJA55iN895
         YGh/tLSCzj2YRAiyJ9FJpZAK6AGLxWSSierK4=
Subject: Re: Change in functionality of futex() system call.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        David Oliver <david@rgmadvisors.com>, linux-kernel@vger.kernel.org,
        Shawn Bohrer <sbohrer@rgmadvisors.com>,
        Zachary Vonler <zvonler@rgmadvisors.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4DED976C.90009@linux.intel.com>
References: <BANLkTinA9h=84gjYhus3EsNFL8tOUBe1jQ@mail.gmail.com>
	 <1307373819.3098.40.camel@edumazet-laptop>
	 <1307376672.2322.167.camel@twins>  <1307376989.2322.171.camel@twins>
	 <1307377349.3098.65.camel@edumazet-laptop>
	 <1307377782.2322.183.camel@twins>
	 <1307378564.3098.67.camel@edumazet-laptop>
	 <4DED1421.5000300@linux.intel.com>
	 <1307383898.3098.90.camel@edumazet-laptop> <4DED976C.90009@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Jun 2011 05:49:22 +0200
Message-ID: <1307418562.2642.51.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 06 juin 2011 à 20:13 -0700, Darren Hart a écrit :
> 
> On 06/06/2011 11:11 AM, Eric Dumazet wrote:
> > Le lundi 06 juin 2011 à 10:53 -0700, Darren Hart a écrit :
> >>
> > 
> >> If I understand the problem correctly, RO private mapping really doesn't
> >> make any sense and we should probably explicitly not support it, while
> >> special casing the RO shared mapping in support of David's scenario.
> >>
> > 
> > We supported them in 2.6.18 kernels, apparently. This might sounds
> > stupid but who knows ?
> 
> 
> I guess this is actually the key point we need to agree on to provide a
> solution. This particular case "worked" in 2.6.18 kernels, but that
> doesn't necessarily mean it was supported, or even intentional.
> 
> It sounds to me that we agree that we should support RO shared mappings.
> The question remains about whether we should introduce deliberate
> support of RO private mappings, and if so, if the forced COW approach is
> appropriate or not.
> 
> Does anyone with a longer history working with futexes than I have an
> opinion on this? Is support for RO private mappings part of our futex
> API, or was it an unintentional side effect of the futex simply being a
> userspace address.
> 

I personnally dont care as I dont use ro mappings for my futexes land,
but I can feel the pain of people discovering yet another
incompatibility in their user apps after a kernel upgrade, spending so
much time to find the root of the problem (hey, not everybody is a
kernel hacker)

If we think about it, futex_wait() should not touch memory, only read
it. Some smart layer could be upset by this (valgrind ?)

Its like saying write(int fd, const void *buffer, size_t count) could
try to do a COW on buffer, because it makes kernel programmer life more
comfortable, this makes litle sense to me IMHO.

Part of the problem comes from futex() syscall being a multiplexor.
What a mess.

If we had a clean API at the beginning, then we would have :

int sys_futex_wait(const void *futex, int val, const struct timespec *t);

And really, doing COW in futex_wait() would clearly be wrong.




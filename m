Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092Ab1HaQDO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 12:03:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932075Ab1HaQDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 12:03:09 -0400
Message-ID: <4E5E5B10.6000503@redhat.com>
Date: Wed, 31 Aug 2011 19:02:24 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Daniel Ehrenberg <dehrenberg@google.com>, Jens Axboe <axboe@kernel.dk>,
        Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org
Subject: Re: Approaches to making io_submit not block
References: <CAAK6Zt2icmsBxjdqFvDXfnxZHXuKN3hDSTdDmh7Vhj1iJ_5LXQ@mail.gmail.com> <CAAK6Zt0Sh1GdEOb-tNf2FGXJs=e1Jbcqew13R_GdTqrv6vW97w@mail.gmail.com> <x49k49uk2ox.fsf@segfault.boston.devel.redhat.com> <4E5D5817.6040704@kernel.dk> <CAAK6Zt2C1646qwDiZ7sWheSWrnx2yrDtCE=+VTx7QNyh2bEz_g@mail.gmail.com> <4E5D64E8.7000102@kernel.dk> <20110830154157.d802d097.akpm@linux-foundation.org> <CAAK6Zt20MNqgydQTgN3O46p+OZxR9Ta9=MfqRrw=w+y77-75Yw@mail.gmail.com> <20110830155438.bc31ab99.akpm@linux-foundation.org> <20110831154558.GA12259@redhat.com>
In-Reply-To: <20110831154558.GA12259@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2011 06:45 PM, Gleb Natapov wrote:
> KVM also have similar needs. KVM has x86 emulator in kernel which is,
> in fact, a state machines that sometimes need an input from userspace
> to proceed.  Currently, when userspace input is needed, KVM goes back
> to userspace to retrieve the input and than retries the emulation. Some
> instructions may require several such iterations. This is somewhat similar
> to aio except that in KVM case emulation waits for userspace instead of
> disk/network HW. The resulting code is complex and error prone. It would
> be nice to not have to unwind the stack from the middle of the emulator
> just to be able to exit to userspace to retrieve the value. One idea that
> came up was to execute emulator on separate kernel stack (withing same
> task). When emulator needs a value from userspace it sleeps while main
> stack goes to userspace to get the value. When the value is available
> main stack wakes up emulator stack and emulation continues from the
> place it was stopped. Cooperative multithreading inside the kernel
> if you want. Bellow is the patch I prototyped to implement that on
> x86_64. I made KVM x86 emulator to use it too. I think AIO can use the
> same technique. io_submit will execute IO on alternative stack. If it
> blocks main thread will continue to run. When IO is completed IO stack
> will resume (alternative stack has priority over main stack).
>

Note that kvm has a significant interest in linux-aio as well - we see a 
significant performance win when we can use it.  From my point of view 
extending linux-aio to be truly asynchronous in all cases is the bigger 
win here, the emulator issue is a nice code cleanup but we could live 
without it.

-- 
error compiling committee.c: too many arguments to function


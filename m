Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382Ab2ARToG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 14:44:06 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:48682 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756406Ab2ARToE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 14:44:04 -0500
MIME-Version: 1.0
In-Reply-To: <CAOAMb1B7oENhPzgUkFjzuJ0==dnHRJkmHFSq-7QtSGeV6JeBvA@mail.gmail.com>
References: <CAOAMb1AUHV6mHwkUbX4+0wfOJpnMuVj_vr9jvb=h-Q4+6HKFzg@mail.gmail.com>
 <CAH+eYFB8xBPLJdN+jfqpESsqjkxdeRQD7oyfU8qHewzfmbqHow@mail.gmail.com>
 <20120115125853.GA9234@localhost> <20120115153838.GA4279@debian>
 <20120116025331.GA16516@localhost> <CAOAMb1Av0w8ip+YyMm82_U3n3zt8DDrofOmvKR+_5ikDMcbYmQ@mail.gmail.com>
 <20120116055044.GA14857@localhost> <20120116055354.GA15265@localhost> <CAOAMb1B7oENhPzgUkFjzuJ0==dnHRJkmHFSq-7QtSGeV6JeBvA@mail.gmail.com>
From: Rabin Vincent <rabin@rab.in>
Date: Thu, 19 Jan 2012 01:13:21 +0530
X-Google-Sender-Auth: LS645zzWY2ZIPv7MWsHomv5EmF4
Message-ID: <CAH+eYFBkm+D_N2tF8F_Pdk8qbVeTFcNefeJ6ROcDW3vLgsCGcw@mail.gmail.com>
Subject: Re: [PATCH] mm/backing-dev.c: fix crash when USB/SCSI device is detached
To: Chanho Min <chanho0207@gmail.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 12:04, Chanho Min <chanho0207@gmail.com> wrote:
>> But wait.. Rabin's patch actually fixes the NULL deference in
>> the call
>>
>>        trace_writeback_wake_forker_thread(bdi);
>>
>> The wakeup of the forker thread should be harmless.
>>
> The forker thread shoud not be woken up after the bdi is unregistered.
> Is this also Rabin's intention?
> Also, I'm not sure the wakeup of the forker thread is harmless as bellows.
> ..
> case FORK_THREAD:
> ..
>  task = kthread_create(bdi_writeback_thread, &bdi->wb,
>                      "flush-%s", dev_name(bdi->dev));

By the time the bdi->dev is made NULL, the bdi has been removed from the
bdi_list (in bdi_wb_shutdown()), so even if the forker thread is woken
up after that it will not find the bdi and won't get to this part of the
code.

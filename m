Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327Ab2FPOjQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 10:39:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33090 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab2FPOjP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 10:39:15 -0400
MIME-Version: 1.0
In-Reply-To: <1339852911-29481-1-git-send-email-yuanhan.liu@linux.intel.com>
References: <1339852911-29481-1-git-send-email-yuanhan.liu@linux.intel.com>
From: Kay Sievers <kay@vrfy.org>
Date: Sat, 16 Jun 2012 16:38:54 +0200
Message-ID: <CAPXgP11QdNqMzKEuAqfA8SYLLVTeDVHp1L29L71rVHO32t+B7Q@mail.gmail.com>
Subject: Re: [PATCH] printk: use mutex lock to stop syslog_seq from going wild
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, wfg@linux.intel.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2012 at 3:21 PM, Yuanhan Liu
<yuanhan.liu@linux.intel.com> wrote:
> Although syslog_seq and log_next_seq stuff are protected by logbuf_lock
> spin log, it's not enough. Say we have two processes A and B, and let
> syslog_seq = N, while log_next_seq = N + 1, and the two processes both
> come to syslog_print at almost the same time. And No matter which
> process get the spin lock first, it will increase syslog_seq by one,
> then release spin lock; thus later, another process increase syslog_seq
> by one again. In this case, syslog_seq is bigger than syslog_next_seq.
> And latter, it would make:
>   wait_event_interruptiable(log_wait, syslog != log_next_seq)
> don't wait any more even there is no new write comes. Thus it introduce
> a infinite loop reading.
>
> I can easily see this kind of issue by the following steps:
>  # cat /proc/kmsg # at meantime, I don't kill rsyslog
>                   # So they are the two processes.
>  # xinit          # I added drm.debug=6 in the kernel parameter line,
>                   # so that it will produce lots of message and let that
>                   # issue happen
>
> It's 100% reproducable on my side. And my disk will be filled up by
> /var/log/messages in a quite short time.
>
> So, introduce a mutex_lock to stop syslog_seq from going wild just like
> what devkmsg_read() does. It does fix this issue as expected.
>
> v2: use mutex_lock_interruptiable() instead (comments from Kay)
>
> Cc: Kay Sievers <kay@vrfy.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>

Acked-By: Kay Sievers <kay@vrfy.org>

Thanks again for finding and fixing it.

Kay

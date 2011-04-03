Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736Ab1DCVJY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 17:09:24 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62754 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab1DCVJW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 17:09:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=ginkel.com; s=google;
        h=mime-version:x-originating-ip:in-reply-to:references:from:date
         :message-id:subject:to:cc:content-type:content-transfer-encoding;
        b=VLU2LE84u2lIznnKF31uDgMAJpiCxUgydMeR2M1+UDeU1KSM9hthXismgyY+4gH1HI
         Eupy+pGMcBMKN5yQ+7/OfQ9w8BVz3UgOwZfzAy3aDEiNVaUwzNCqA5Tgn3mAkDL5NIQJ
         6P7eP0YTtSVY3eFMEKCMGpveZ4UuLs4tAfugI=
MIME-Version: 1.0
X-Originating-IP: [91.17.155.41]
In-Reply-To: <AANLkTimeRFN_5ZFwjtY6+yo0V=VAoX8T_Ju+ceDJnfHv@mail.gmail.com>
References: <AANLkTim5ctAoaB4+BS7Z-+ARUgTEBO22bkYMUvFtGmoN@mail.gmail.com>
 <1301811515.7592.2.camel@marge.simson.net> <AANLkTimeRFN_5ZFwjtY6+yo0V=VAoX8T_Ju+ceDJnfHv@mail.gmail.com>
From: Thilo-Alexander Ginkel <thilo@ginkel.com>
Date: Sun, 3 Apr 2011 23:08:51 +0200
Message-ID: <AANLkTi=Yusq1TicVCPN9CY2UCZ6jmcp+bw_CunG7uSFh@mail.gmail.com>
Subject: Re: Soft lockup during suspend since ~2.6.36
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 3, 2011 at 19:32, Thilo-Alexander Ginkel <thilo@ginkel.com> wrote:
> A good night of sleep and some Googling later I am under the
> impression that this issue was already supposedly fixed by the
> following commit a long time ago:
>  http://git.kernel.org/?p=linux/kernel/git/jikos/hid.git;a=commitdiff;h=9c9e54a8df0be48aa359744f412377cc55c3b7d2
>  http://permalink.gmane.org/gmane.linux.kernel/1024386
>
> This makes some sense as versions closer to 2.6.36 only lock up
> sporadically whereas the original bug locks up reliably. I'll try to
> get a backtrace for the sporadic bug, but may only be able to do so
> using a tainted kernel as my text console does not survive
> suspend/resume without proprietary drivers (and the serial console
> also breaks during the relevant suspend phase). I hope, this is
> acceptable.

All right. I have actually been able to obtain a backtrace for a
2.6.36 kernel, which only shows this problem sporadically (so this
probably has a different root cause).

It all starts with the suspend sequence hanging while shutting down
non-boot CPUs (the CPU# varies from case to case):
  https://secure.tgbyte.de/dropbox/ueph3Ohm-1.jpg

Then, after some time, the following backtrace is written:
  https://secure.tgbyte.de/dropbox/ueph3Ohm-2.jpg

Transcript:
| RIP: _raw_spin_unlock_irqrestore
| Call Stack:
|   _set_cpus_allowed_ptr
|   worker_maybe_bind_and_lock
|   rescuer_thread
|   rescuer_thread
|   kernel_thread_helper
|   kthread
|   kernel_thread_helper
|   kthread

After some more time, the following backtrace is printed:
  https://secure.tgbyte.de/dropbox/ueph3Ohm-3.jpg

Transcript:
| RIP: worker_maybe_bind_and_lock
| Call Stack:
|   rescuer_thread
|   rescuer_thread
|   kernel_thread_helper
|   kthread
|   kernel_thread_helper
|   kthread

>From then on these two backtraces are printed in an alternating fashion.

Unfortunately, the top of the output is missing as it does not fit on
screen (does someone know an even smaller console font?), but I assume
it's the deadlock detection.

Thanks,
Thilo

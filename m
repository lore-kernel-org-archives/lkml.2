Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab1DDN5j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 09:57:39 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55574 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab1DDN5i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 09:57:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=ginkel.com; s=google;
        h=mime-version:x-originating-ip:in-reply-to:references:from:date
         :message-id:subject:to:content-type:content-transfer-encoding;
        b=kFzo16DH/r1KjE7DyF+9Zs+p9eOz4b1fxZ/+D59Q6r7Mn/UuZ1N3ungcgDRGny+lun
         cRWbVjgt+OEq3dRXEwDM1b2UYUQWY2j6NfM4RPuN7q/s1bM4KDLGs43tqRzvRPs1S4mn
         h3rsRfdPtUVpFNumucui0NOMYdr/00hALm5/E=
MIME-Version: 1.0
X-Originating-IP: [91.17.219.124]
In-Reply-To: <201104040502.52526.arnd@arndb.de>
References: <AANLkTim5ctAoaB4+BS7Z-+ARUgTEBO22bkYMUvFtGmoN@mail.gmail.com>
 <AANLkTimeRFN_5ZFwjtY6+yo0V=VAoX8T_Ju+ceDJnfHv@mail.gmail.com>
 <AANLkTi=Yusq1TicVCPN9CY2UCZ6jmcp+bw_CunG7uSFh@mail.gmail.com> <201104040502.52526.arnd@arndb.de>
From: Thilo-Alexander Ginkel <thilo@ginkel.com>
Date: Mon, 4 Apr 2011 15:57:07 +0200
Message-ID: <BANLkTi=n4jLsjOYCd0L3hYb30sgPmdv_WA@mail.gmail.com>
Subject: Re: Soft lockup during suspend since ~2.6.36
To: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 4, 2011 at 05:02, Arnd Bergmann <arnd@arndb.de> wrote:
> On Sunday 03 April 2011, Thilo-Alexander Ginkel wrote:
>> Transcript:
>> | RIP: _raw_spin_unlock_irqrestore
>> | Call Stack:
>> |   _set_cpus_allowed_ptr
>> |   worker_maybe_bind_and_lock
>> |   rescuer_thread
>> |   rescuer_thread
>> |   kernel_thread_helper
>> |   kthread
>> |   kernel_thread_helper
>> |   kthread
>>
>> After some more time, the following backtrace is printed:
>>   https://secure.tgbyte.de/dropbox/ueph3Ohm-3.jpg
>>
>> Transcript:
>> | RIP: worker_maybe_bind_and_lock
>> | Call Stack:
>> |   rescuer_thread
>> |   rescuer_thread
>> |   kernel_thread_helper
>> |   kthread
>> |   kernel_thread_helper
>> |   kthread
>>
>> From then on these two backtraces are printed in an alternating fashion.
>>
>> Unfortunately, the top of the output is missing as it does not fit on
>> screen (does someone know an even smaller console font?), but I assume
>> it's the deadlock detection.
>
> The interesting thing is that the backtrace is from unlock, not from lock,
> so it can't really be a deadlock. However, the _raw_spin_unlock_irqrestore
> function calls debug_spin_unlock(), which does a few sanity check. Maybe
> one of those got triggered.
>
> The easiest way to get the full output is usually to attach a serial
> NULL modem cable and redirect the console to that, so you can get the
> output on another machine. Another idea would be to modify the
> show_registers function in arch/x86/kernel/dumpstack_64.c so that
> it prints less data.

Unfortunately, the output via a serial console becomes garbled after
"Entering mem sleep", so I went for patching dumpstack_64.c and a
couple of other source files to reduce the verbosity. I hope not to
have stripped any essential information. The result is available in
these pictures:
  https://secure.tgbyte.de/dropbox/IeZalo4t-1.jpg
  https://secure.tgbyte.de/dropbox/IeZalo4t-2.jpg

For both traces, the printed error message reads: "BUG: soft lockup -
CPU#3 stuck for 67s! [kblockd:28]"

(After a bit of Googling I understand that a soft lockup is probably
different from a deadlock - please correct me if that assumption is
wrong)

> Yet another idea would be to set /sys/kernel/printk_delay so that the
> oops gets printed slower.

Hm, that file does not exist on my machine. Does it need a special
compile-time config  option to be enabled?

Regards,
Thilo

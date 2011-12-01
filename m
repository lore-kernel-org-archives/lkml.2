Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab1LACVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 21:21:51 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33924 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab1LACVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 21:21:50 -0500
MIME-Version: 1.0
In-Reply-To: <20111129114603.GB7299@redhat.com>
References: <4ED43A5C.9000102@gmail.com>
	<20111129114603.GB7299@redhat.com>
Date: Wed, 30 Nov 2011 20:21:49 -0600
Message-ID: <CADLC3L2QpEtPiBg+yvaxir1LpU6j5YMpDG4g0+ezs06g745zcg@mail.gmail.com>
Subject: Re: [rt2x00-users] Poor performance and lockup with rt2800usb and
 Asus USB-N13 adapter
From: Robert Hancock <hancockrwd@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 5:46 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Mon, Nov 28, 2011 at 07:50:20PM -0600, Robert Hancock wrote:
>> I recently got an Asus USB-N13 USB Wireless-N adapter which
>> apparently uses a Ralink RT3072 chip. I'm using it with an Asus
>> RT-N16 access point running TomatoUSB. When running Windows the
>> performance is reasonable (about 80 Mbps in both directions).
>> However under Fedora 16 (currently kernel 3.1.2) the performance is
>> abysmal (10 Mbps or less with lots of packet loss). I'll post some
>> debug information below.
> rt2800usb needs fixing. I'm able to reproduce these performance
> problems locally. They are quite hard to debug, and need some
> experiments. But I hope I will provide patches soon or leter.

Do you have any leads on what is going wrong? I'm not sure if the
issue is with the higher MCS rates not working as well as they should,
or with the rate control trying to use them even though they're not
working well.

>
>> While debugging this I also noticed that doing an rmmod on rt2800usb
>> with the adapter plugged in locks up the machine and then spews out
>> soft lockup stack traces on the console. I was only able to capture
>> it off the screen with a camera, but it basically is:
>>
>> rt2x00usb_work_rxdone
>> process_one_work
>> worker_thread
>> kthread
>> kernel_thread_helper
> Another thing to investigate. Can yo try to reproduce that with
> CONFIG_DEBUG_OBJECTS=y
> CONFIG_DEBUG_OBJECTS_FREE=y
> CONFIG_DEBUG_OBJECTS_TIMERS=y
> CONFIG_DEBUG_OBJECTS_WORK=y
> CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
> CONFIG_DEBUG_SPINLOCK=y
> CONFIG_DEBUG_MUTEXES=y
> CONFIG_DEBUG_LOCK_ALLOC=y
> CONFIG_PROVE_LOCKING=y
> CONFIG_LOCKDEP=y
> and see if these options print some aditional message when rmmod.

I tried with the Fedora kernel-debug kernel and didn't see much
additional output. The stack trace might have a bit more detail:

rt2x00queue_index_inc
rt2x00lib_dmadone
rt2x00usb_kick_rx_entry
rt2x00usb_clear_entry
rt2x00lib_rxdone
rt2x00usb_work_rxdone
process_one_work
worker_thread
kthread
kernel_thread_helper

Seems like something that happens on rmmod with the device connected
causes these rxdone/txdone functions to go into a tight loop somehow.

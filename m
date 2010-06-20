Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033Ab0FTGUk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 02:20:40 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:54010 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab0FTGUi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 02:20:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:reply-to:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:content-type
         :content-transfer-encoding;
        b=gLK8oqIVePv8UU4+mNBRk5Quy3rUaUv5u5RBtvEVeQg07B+r6bync3dF4SIZS0xOrB
         TEYQ3vurugtVfkjeuutDYH9KdK0ciyStY+rQcbxYvy3zJbQiGM7XSoI2NriOkyXbG+9i
         7xjOQxyAcZWdX29t5ijLd5wxQ0Ph5MJYoua4o=
MIME-Version: 1.0
Reply-To: linux@schou.dk
In-Reply-To: <1276972298.22889.16.camel@obelisk.thedillows.org>
References: <AANLkTimO5PXmJiIPDw82MTA53mLSl-OC0e1SOEh7v8pH@mail.gmail.com> 
	<1276972298.22889.16.camel@obelisk.thedillows.org>
From: Hans Schou <linux@schou.dk>
Date: Sun, 20 Jun 2010 08:20:17 +0200
X-Google-Sender-Auth: Uky-qTgIW-1YUBCNDnxtbsHXchU
Message-ID: <AANLkTimwZFNLBNJWODyzKXwx9CbIorg3OCA53XZchkeN@mail.gmail.com>
Subject: Re: PROBLEM: SIS7019 stops recording after 42 min
To: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/19 David Dillow <dave@thedillows.org>:
> Not trimming for the benefit of alsa-devel, cc'd. Please trim replies.

ok

> On Sat, 2010-06-19 at 16:13 +0200, Hans Schou wrote:
>> Hi
>>
>> I have a problem with recording sound when using the sound chip
>> SIS7019 with both kernel 2.6.26 and 2.6.34. After recording about 42
>> minutes it kind a stops recording, more precisely it is taking a pause
>> of exactly 10 seconds between each reading.
>>
>> As recorder I have tried several programs and all of them fails after
>> 42 minutes. Some programs uses Alsa and some uses the old deprecated
>> method. In this example I have logged sox rec.
>>
>> Recording method in a script:
>>   strace -tt -o strace.log rec -c 1 -r 44100 -2 sox.wav &
>>   sleep 3000
>>   kill $?
>
> I think the answer is no, but to be sure -- are you talking directly to
> the hardware device, or are you going through pulseaudio?

Eh? No to what? Alsa? I am not really sure. In strace I can see 'rec'
uses ioclt which could implies that it is talking directly to
hardware.

> While rec is running, can you capture the configuration using
> head -1000 /proc/asound/card0/pcm0c/sub0/*

Below was captured while running:
   arecord -c 1 -r 44100 -f S16 arec01.wav

==> /proc/asound/card0/pcm0c/sub0/hw_params <==
access: RW_INTERLEAVED
format: S16_LE
subformat: STD
channels: 1
rate: 44100 (44100/1)
period_size: 5513
buffer_size: 22050

==> /proc/asound/card0/pcm0c/sub0/info <==
card: 0
device: 0
subdevice: 0
stream: CAPTURE
id: SiS7019
name: SiS7019
subname: subdevice #0
class: 0
subclass: 0
subdevices_count: 1
subdevices_avail: 0

==> /proc/asound/card0/pcm0c/sub0/prealloc <==
64

==> /proc/asound/card0/pcm0c/sub0/prealloc_max <==
128

==> /proc/asound/card0/pcm0c/sub0/status <==
state: RUNNING
owner_pid   : 3112
trigger_time: 1277013037.939382815
tstamp      : 1277013038.809174469
delay       : 10640
avail       : 10640
avail_max   : 10920
-----
hw_ptr      : 38368
appl_ptr    : 27728

==> /proc/asound/card0/pcm0c/sub0/sw_params <==
tstamp_mode: NONE
period_step: 1
avail_min: 5513
start_threshold: 1
stop_threshold: 22050
silence_threshold: 0
silence_size: 0
boundary: 1944986400

I got a strange error message from arecord while recording at rate 44100:
overrun!!! (at least 0.188 ms long)
overrun!!! (at least 0.190 ms long)
overrun!!! (at least 0.191 ms long)

Could this be a clue?

The error does occur with rate 8000 8bit (the default).

> Can you try using arecord? You can use options to tell it how to
> configure the PCM. Especially interesting will be to configure 2 periods
> per buffer vs whatever rec uses. 2 periods per buffer uses the hardware
> interrupts to clock out periods, where as 3+ uses a more complex
> mechanism. You can also use -M to use mmap vs not.

Options like this?
strace -tt -o arec.log arecord -c 1 -r 44100 -f S16 -M arec.wav


best regards/hans

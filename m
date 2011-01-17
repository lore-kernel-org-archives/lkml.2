Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab1AQPQF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 10:16:05 -0500
Received: from smtp.nokia.com ([147.243.1.47]:16555 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143Ab1AQPQC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 10:16:02 -0500
From: <samu.p.onkalo@nokia.com>
To: <peterz@infradead.org>
CC: <mingo@elte.hu>, <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>
Subject: RE: Bug in scheduler when using rt_mutex
Thread-Topic: Bug in scheduler when using rt_mutex
Thread-Index: AQHLtlQXay3GyjQpRU+COSTWPdFmbpPVMQKAgAASv0A=
Date: Mon, 17 Jan 2011 15:15:38 +0000
Message-ID: <90C2C3D80A94B8448891D39FF568E8760760B892@008-AM1MPN1-012.mgdnok.nokia.com>
References: <1295275365.12840.13.camel@kolo>
 <1295276401.30950.125.camel@laptop>
In-Reply-To: <1295276401.30950.125.camel@laptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginalArrivalTime: 17 Jan 2011 15:15:42.0239 (UTC) FILETIME=[67F11AF0:01CBB659]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p0HFGLXe017129



>-----Original Message-----
>From: ext Peter Zijlstra [mailto:peterz@infradead.org]
>Sent: 17 January, 2011 17:00
>To: Onkalo Samu.P (Nokia-MS/Tampere)
>Cc: mingo@elte.hu; linux-kernel@vger.kernel.org; tglx
>Subject: Re: Bug in scheduler when using rt_mutex
>
>On Mon, 2011-01-17 at 16:42 +0200, Onkalo Samu wrote:
>> Hi
>>
>> I believe that there are some problems in the scheduling when
>> the following happens:
>> - Normal priority process locks rt_mutex and sleeps while keeping it
>> locked.
>
>There's your fail, don't do that!

So that is forbidden:

rt_mutex_lock();
wait_for_completion(); <--- shared HW finishes its job
rt_mutex_unlock();



>
>> - RT priority process blocks on the rt_mutex while normal priority
>> process is sleeping
>>
>> This sequence can occur with I2C access when both normal priority
>> thread and irq-thread access the same I2C bus. I2C core
>> contains rt_mutex and I2C drivers can sleep with wait_for_completion.
>
>Why does I2C core use rt_mutex, that's utterly broken.

To get low priority task finish ongoing I2C access in time under
heavy load cases I think.

>
>> Based on my debugging following sequence occurs (single CPU
>> system):
>>
>> 1) There is some user process running at the background (like
>> cat /dev/zero..)
>> 2) User process reads sysfs entry which causes I2C acccess
>> 3) User process locks rt_mutex in the I2C-core
>> 4) User process sleeps while it keeps rt_mutex locked
>> (wait_for_completion in I2C transfer function)
>
>That's where things go wrong, there's absolutely nothing you can do to
>fix the system once you block while holding a mutex.

Of course other processes are waiting until the (rt_)mutex is unlocked.
Problem is that after the rt_mutex_unlock is done, the task which  just released
the lock, may be in some non-running state for minutes.

 -Samu

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

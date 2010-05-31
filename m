Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab0EaPr6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 11:47:58 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64414 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756611Ab0EaPr5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 11:47:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=x+qZj6Aj9hkCD3m138wY1YLLMM4Br05ipKQpkZ6FrO3FcQ1RD084Xc4+djvQ7AWtO+
         NXw5hDMsi06Btz0ubPrp9I763jAO/G9MHpZDtjya1wEwSusyE2mKM+/dVPSEAhafRdVq
         0eSqJmGA7ZxKOmCPWX1usK97l5Co741SYtgNk=
MIME-Version: 1.0
In-Reply-To: <AANLkTiluoCSqPR92khE2tacmGt8hcbODBaoDRSEi54CO@mail.gmail.com>
References: <AANLkTiluoCSqPR92khE2tacmGt8hcbODBaoDRSEi54CO@mail.gmail.com>
Date: Mon, 31 May 2010 23:47:56 +0800
Message-ID: <AANLkTikyd0-qZ84E7dGO4RZdVwm1oeGQ5anzrXQqlc5P@mail.gmail.com>
Subject: Fwd: A weird multi-thread performance problem
From: zhigang gong <zhigang.gong@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I experienced a very strange performance problem. I wrote a user space
application which has three threads:
Thread A, Thread B, Thread C.  The initial state is that C is waiting
on a semaphore S0, B is waiting on another
semaphore S1.

Now A prepare a buffer, and do some processing on the buffer, and it
will wakeup C, then A will wait on semaphore S2.
C will copy the buffer and do some processing on the buffer, and then
it will wakeup B then itself will wait on S0 again.

B will copy the buffer and do the same as what A have done before to
pass the buffer to A through C.

It's a A-->C-->B-->C--->A sequence, and it will repeat for many times.
I measure the ping-pong latency at A
thread.

My test environment is
a 2core, each core has 4 hardware threads，a intel machine. The linux
kernel version is 2.6.31.

Now the result is that when I bind all threads on 1 hardware thread,
the latency is about 17us.
taskset 10 ./latency_test.

But when I just execute ./latency_test   it got about 40us.

I use vmstat to monitor the performance, and I found that:

For the first case, the interrupt count is much lesser than the second
case, while the context switch count is very close
to each other. The intterupt count for the first case is about 30K ,
for the second case is about 79K.
The ratio of 79K/30K is approximatly equal to 40us/17us.

My question is why these two cases have such a different interrupt
count ? And is there any tool other than vmstat to measure
what is the intterupt source, it's  IPC intterupt or a system call or
something else?

Is there anybody can give me a clue on this? I will very appreciate
for your help.

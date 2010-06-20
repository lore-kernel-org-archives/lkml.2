Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab0FTGwf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 02:52:35 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51103 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab0FTGwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 02:52:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:from:date:x-google-sender-auth:message-id
         :subject:to:content-type;
        b=u1YE/k+A5t/DyJSv99Mo+/VEH2nOw3lKB5y2L53GR0mGTkTjl90dJBlvR7n4i1jNDY
         gq+0x+PqMAIANX8lEy4Ld0IfIM9jJu5c3P3hPWeiMlj4xMxdUcOqQx8YxEy4Z5egmhDI
         fK4iMpJaPeWKjtzrny2LwVmsbnNhNj0PVbI6Q=
MIME-Version: 1.0
From: Suresh Rajashekara <suresh.raj+linuxomap@gmail.com>
Date: Sat, 19 Jun 2010 23:52:10 -0700
X-Google-Sender-Auth: bSDkTBWE5IDUp1tjxW8uyNl7F40
Message-ID: <AANLkTikPOcNZk5ISX2WDHSmsPDw_a5_3Ic3owAbO4o0y@mail.gmail.com>
Subject: wait_for_completion_interruptible does not wait !!
To: linux-omap@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have an application which calls the ioctl of the codec driver to
know the status of the headset.

The ioctl waits on a completion variable (using
wait_for_completion_interruptible).

The variable is completed in the interrupt handler, which happens on
headset insertion/removal. Once the variable is completed, the ioctl
returns (with appropriate value in the argument) and the application
decides what to do with the event.

Once done handling the event, the application then calls the ioctl
once again (bascially it polls the audio driver) to know the status of
the headset. The call is blocked until the headset status changes.

I am running the system on linux-2.6.29 on a OMAP1 based board. All
this works well when the OMAP is awake.

The problem starts when we suspend the OMAP. The moment we suspend,
the wait_for_completion_interruptible is interrupted and the ioctl
returns. Application ends up thinking that the headset was either
removed/inserted. Our system does an aggressive sleep (wakes up every
500 ms and sleeps again) and hence the application gets the event of
headset every 500 ms.

I tried wait_for_completion instead, but now the kernel refuses to suspend.

I have tried wait queues and mutexs with no success.

Could anyone please point me how I can resolve this issue? Is there
any construct which can block inside the kernel during suspend/resume?
Can there be a blocking call active while we suspend?

Ideally I would resort to a method in which I would signal the process
when there is a headset event, but I am not free to change the
application. Its a legacy application and I have to make the kernel
work for it.

Thanks in advance,
Suresh


PS: It might be unrelated, but I am mentioning it here because I
learnt this while debugging the issue. If I use an application
scheduled as SCHED_FIFO to suspend the kernel (using a driver ioctl
which in turn calls enter_state), the operation fails (kernel aborts
the process of suspending after 20 seconds saying some applications
failed to freeze). Just changing the application scheduling policy to
SCHED_OTHER resolves the issue. I was unable to find an explaination
for this. However, my current test applications are scheduled as
SCHED_OTHER.

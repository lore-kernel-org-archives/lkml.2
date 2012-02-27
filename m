Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab2B0WvM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 17:51:12 -0500
Received: from mail1.windriver.com ([147.11.146.13]:57923 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224Ab2B0WvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 17:51:10 -0500
Message-ID: <4F4C08D3.8000105@windriver.com>
Date: Mon, 27 Feb 2012 16:50:59 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Andrei Warkentin <awarkentin@vmware.com>
CC: <kgdb-bugreport@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
        Andrei Warkentin <andreiw@vmware.com>
Subject: Re: [PATCH] KDB: Fix usability issues relating to the 'enter' key.
References: <190287371.1567191.1330304658088.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
In-Reply-To: <190287371.1567191.1330304658088.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2012 07:04 PM, Andrei Warkentin wrote:
> Hi,
> 
> ----- Original Message -----
>> From: "Jason Wessel" <jason.wessel@windriver.com>
>> To: "Andrei Warkentin" <andreiw@vmware.com>
>> Cc: kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org
>> Sent: Sunday, February 26, 2012 8:58:37 AM
>> Subject: Re: [PATCH] KDB: Fix usability issues relating to the 'enter' key.
> 
>>
>> Andrei, if you agree with the attached patch, I'll put it in the
>> merge queue.  If you find problems we can go another iteration. :-)
>>
> 
> Nak. As I've mentioned in my original email, I went down this route as well, only
> to ask the question of why the special ENTER code was there, since all it did
> was introduce problems elsewhere (like repeat ENTER handling, KP ENTER key...).
> This is exactly why my solution was to get rid of the special ENTER code altogether.
> 
> The code in kgdboc already will do input device reset on kdb exit, so there is no need
> to explicitely empty out the keyboard FIFO on every ENTER.
> 

Did you try the patch I sent?  It might not address the key repeat
problem, but this is some thing I had not yet duplicated.  Outside of
the warning message (which was killed off in the patch), was there
garbage characters or some notable behavior?  Was it something you
could see in qemu or only in ESX?

Having authored the keyboard/input handler with some suggestions from
Dmitry, I was fairly certain it had no way to prevent the leak of the
up keystroke unless you have the KDB specific capture where it waits
to act on the "key up" event for an enter keystroke.  The cleanup
handler only cleans up state events where keys were down at the time
the debug core became active.  It will not prevent the leak of key
strokes or state changes while the kernel was stopped.  The goofy
enter handler was supposed to take care of that.

I conclusively proved there is event leakage from using the original
patch you provided. Here is the test case, which you should be able to
execute with qemu or kvm (since you also mentioned that was what you
were previously using).

1) boot the qemu
2) Use kgdboc=kbd
3) break into the debugger to the kdb prompt
4) type "g" but to not press return
5) Connect to the qemu back end debug connection with gdb and set a
   breakpoint at line 402 of atkbd.c which should be the call to:
   	input_event(dev, EV_MSC, MSC_RAW, code);
6) continue the gdb connection
7) In the qemu monitor enter the command:
    sendkey ret 4000

After 4 seconds when the key is released you will catch the leaked
event in the atkbd.c, and if you had X running it propagates all the
way up the input chain.

Jason.

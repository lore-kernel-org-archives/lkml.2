Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab2B0XS1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 18:18:27 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:49352 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754452Ab2B0XS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 18:18:26 -0500
Date: Mon, 27 Feb 2012 15:18:25 -0800 (PST)
From: Andrei Warkentin <awarkentin@vmware.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Andrei Warkentin <andreiw@vmware.com>
Message-ID: <608420295.1620292.1330384705791.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
In-Reply-To: <4F4C08D3.8000105@windriver.com>
Subject: Re: [PATCH] KDB: Fix usability issues relating to the 'enter' key.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.60.13]
X-Mailer: Zimbra 7.1.3_GA_3374 (ZimbraWebClient - FF3.0 (Linux)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

----- Original Message -----
> From: "Jason Wessel" <jason.wessel@windriver.com>
> To: "Andrei Warkentin" <awarkentin@vmware.com>
> Cc: kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org, "Andrei Warkentin" <andreiw@vmware.com>
> Sent: Monday, February 27, 2012 5:50:59 PM
> Subject: Re: [PATCH] KDB: Fix usability issues relating to the 'enter' key.
> 
> Did you try the patch I sent?  It might not address the key repeat
> problem, but this is some thing I had not yet duplicated.  Outside of
> the warning message (which was killed off in the patch), was there
> garbage characters or some notable behavior?  Was it something you
> could see in qemu or only in ESX?

Let me elaborate. The cpu_relax() you added solves the hanging.

> 
> Having authored the keyboard/input handler with some suggestions from
> Dmitry, I was fairly certain it had no way to prevent the leak of the
> up keystroke unless you have the KDB specific capture where it waits
> to act on the "key up" event for an enter keystroke.  The cleanup
> handler only cleans up state events where keys were down at the time
> the debug core became active.  It will not prevent the leak of key
> strokes or state changes while the kernel was stopped.  The goofy
> enter handler was supposed to take care of that.
> 
> I conclusively proved there is event leakage from using the original
> patch you provided. Here is the test case, which you should be able
> to
> execute with qemu or kvm (since you also mentioned that was what you
> were previously using).
> 
> 1) boot the qemu
> 2) Use kgdboc=kbd
> 3) break into the debugger to the kdb prompt
> 4) type "g" but to not press return
> 5) Connect to the qemu back end debug connection with gdb and set a
>    breakpoint at line 402 of atkbd.c which should be the call to:
>    	input_event(dev, EV_MSC, MSC_RAW, code);
> 6) continue the gdb connection
> 7) In the qemu monitor enter the command:
>     sendkey ret 4000
> 
> After 4 seconds when the key is released you will catch the leaked
> event in the atkbd.c, and if you had X running it propagates all the
> way up the input chain.

I know I should have read deeper into the input code. I assumed it performed a reset
on the input device. Assumptions are bad. Sorry.

So here is the thing. With the patch you sent, you would still leak the break
keypress for the keypad enter. This is because the break code for KP ENTER is 0xe0 0x9c,
and the inb(KBD_DATA_REG) done in the goofy handler will read just the 0xe0 part, leaving
0x9c behind, which will be leaked out.

So here is my question - do you want me to fix the existing goofy handler to properly
handle KP ENTER and ENTER repeats? Or do you think it's appropriate to empty out the
FIFO during KDB exit as part of post_exp kgdb_io op? Or reset the input device?

Thanks for investigating this.

A


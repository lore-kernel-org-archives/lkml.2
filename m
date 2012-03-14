Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030405Ab2CNCVf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 22:21:35 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34803 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759917Ab2CNCVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 22:21:32 -0400
MIME-Version: 1.0
In-Reply-To: <CAPXgP13D9haan4SdxhxzzKUaw=FV1JgP0weKmezK8tJBip4QXA@mail.gmail.com>
References: <201203032122.36745.chunkeey@googlemail.com> <201203132042.07794.rjw@sisk.pl>
 <CAPXgP11fWf-0Jkk=d6G+d=sQa-hoX3jUM+K6K4rGYhh0dv1u_w@mail.gmail.com>
 <201203140110.40671.rjw@sisk.pl> <CAPXgP118s+DuLaATKOq7w=F82GB=8PkwUJDichffXA-Er6Zqvw@mail.gmail.com>
 <CA+55aFxq=GWof-ExXjeC2nwUBcGi46SKwcvc2iccfymbbyXbfA@mail.gmail.com>
 <CAPXgP11ZKT-ZNBLdPQWotFayz9m7pKcNHDBPWxcp_2-ja+SAcQ@mail.gmail.com>
 <CA+55aFyG6utURVkVbAXF_T+BcA94af=c+oDBAwWZOyNwgiQ+5g@mail.gmail.com> <CAPXgP13D9haan4SdxhxzzKUaw=FV1JgP0weKmezK8tJBip4QXA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 13 Mar 2012 19:21:11 -0700
X-Google-Sender-Auth: bA1RE72ZC5KEUPgIGG1dTH-AryU
Message-ID: <CA+55aFx_sJS_KfhG4qBOT1V_Mv8x5dpXjMebjrXXXGx5yWqVpg@mail.gmail.com>
Subject: Re: [PATCH] firmware loader: don't cancel _nowait requests when
 helper is not yet available
To: Kay Sievers <kay@vrfy.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <gregkh@linuxfoundation.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 6:55 PM, Kay Sievers <kay@vrfy.org> wrote:
>
> I do NOT talk about exec, I talk about a REQUEST which can be QUEUED
> just fine, but which the kernel refuses to QUEUE, even when it will
> not harm anything. That check and warning is wrong.

No. request_firmware() is synchronous. People call it, and then use
the loaded firmware immediately after success.

And no, it's not at all clear that you can just say "we'll just wait".
The device that wants the firmware may be something that can be
brought up asynchronously (so "wait until everything is ok" can work),
BUT IT IS NOT AT ALL GUARANTEED.

Seriously, you don't know what you are talking about. We *used* to
just wait, and have a thirty-second timeout etc instead of failing
aggressively. It often worked.

And then quite often it DID NOT WORK, and it caused 30-second delays
at resume time (maybe it was 60s, I forget). Because it turns out that
people were waiting for that device to get through its resume until
the resume was completed. And the system wasn't up. Deadlock.

So a 30-second "let's try delaying this" has been done. It didn't
work. Stop arguing for it, when you clearly don't know what the
problems were. The 30-second delay is when the user just says "resume
didn't work" and has long since pressed the power button.

So fail fast, fail hard. DO NOT REQUEST FIRMWARE WHILE THE SYSTEM IS SUSPENDED.

It really is that simple. Your "let's just queue it up" is crap. Stop
arguing for it, we used to do it, it "worked" much of the time, and
when it didn't work it killed the system.

Which is why it now fails with a big warning. EXACTLY SO THAT DRIVER
WRITERS WOULD KNOW NOT TO DO THAT BROKEN THING.

I'm shouting at you, because you are arguing from ignorance. Stop
doing it. "Works most of the time" just isn't good enough. It needs to
*always* work, and the way to do that is to just do firmware load when
the system is up and running, not when it is suspended.

If a driver is ok with being delayed for a firmware load, it should
just do its resume *without* doing the firmware load at all, and
schedule one serparately for later. But no, we can not just say "let's
delay request_firmware()", because we used to do that and it was shown
to not work.

Comprende?

              Linus

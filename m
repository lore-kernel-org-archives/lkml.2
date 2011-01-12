Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932728Ab1ALBem (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 20:34:42 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37568 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756397Ab1ALBej convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 20:34:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LRXn20gQ4k2zJwRvbFqDPd16GOqBpFnO/ZlWXdt3itLBWSrMrms9IS+fahKtTdarod
         P4KUNxDPKE9wdWVBgivt+kP1Q2quAMN1VR6qHhCAW1nqVY6lXo8qRAg8TtZ9Wxr6Y3b+
         qCc+9ApxbC8hMjdf2RZLwSzPmm6zIRMTep60A=
MIME-Version: 1.0
In-Reply-To: <20110111143244.GC30607@htj.dyndns.org>
References: <201101070014.p070Egpo023959@imap1.linux-foundation.org>
	<4D2ADD43.2020702@gmail.com>
	<AANLkTin7h=R0cfzpeuvpTAGRFCsFocJezpW7Riz5Za4z@mail.gmail.com>
	<AANLkTimeUN9m-roDmsfaMaiD4wZw1wETYsf+dONjpmyj@mail.gmail.com>
	<20110111143244.GC30607@htj.dyndns.org>
Date: Wed, 12 Jan 2011 09:34:38 +0800
Message-ID: <AANLkTinX5R7-CzrLW=b4PwC3v3QucQkgz7Vs6tnYG7Hr@mail.gmail.com>
Subject: Re: WARNING: at kernel/workqueue.c [was: mmotm 2011-01-06-15-41 uploaded]
From: Hillf Danton <dhillf@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Tony Luck <tony.luck@gmail.com>, Minchan Kim <minchan.kim@gmail.com>,
        Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 10:32 PM, Tejun Heo <tj@kernel.org> wrote:
> On Mon, Jan 10, 2011 at 03:36:09PM -0800, Tony Luck wrote:
>> > Here it is, too.
>> > mmotm-01-06
>>
>> Also in today's linux-next (tag: next-20110110) on ia64:
>>
>>
>> ------------[ cut here ]------------
>> WARNING: at kernel/workqueue.c:1202 worker_enter_idle+0x3f0/0x4a0()
>> Hardware name: server rx2620
>> Modules linked in:
>>
>> Call Trace:
>>  [<a000000100014cb0>] show_stack+0x50/0xa0
>>                                 sp=e0000040600d7c30 bsp=e0000040600d0dd0
>>  [<a000000100bcaa20>] dump_stack+0x30/0x50
>>                                 sp=e0000040600d7e00 bsp=e0000040600d0db8
>>  [<a000000100082260>] warn_slowpath_common+0xc0/0x100
>>                                 sp=e0000040600d7e00 bsp=e0000040600d0d78
>>  [<a0000001000822e0>] warn_slowpath_null+0x40/0x60
>>                                 sp=e0000040600d7e00 bsp=e0000040600d0d50
>>  [<a0000001000b0830>] worker_enter_idle+0x3f0/0x4a0
>>                                 sp=e0000040600d7e00 bsp=e0000040600d0d28
>>  [<a0000001000b2c80>] worker_thread+0x8c0/0x980
>>                                 sp=e0000040600d7e00 bsp=e0000040600d0c28
>>  [<a0000001000c08c0>] kthread+0x120/0x160
>>                                 sp=e0000040600d7e00 bsp=e0000040600d0be8
>>  [<a000000100012ef0>] kernel_thread_helper+0x30/0x60
>>                                 sp=e0000040600d7e30 bsp=e0000040600d0bc0
>>  [<a00000010000a0c0>] start_kernel_thread+0x20/0x40
>>                                 sp=e0000040600d7e30 bsp=e0000040600d0bc0
>> ---[ end trace 7e2fb881ec0622f8 ]---
>
> Ah, of course, it's commit 21ec12364bb78b72ad36b94269c64b3ee31b038f
> (workqueue: remove noop condition check in worker_clr_flags()).  The
> condition it removes is not a noop.  Reverting it.
>

Hey all

It looks that WORKER_NOT_RUNNING could be defined finer :/

thanks
Hillf
---

--- a/kernel/workqueue.c	2011-01-05 08:50:20.000000000 +0800
+++ b/kernel/workqueue.c	2011-01-12 09:40:56.000000000 +0800
@@ -62,8 +62,9 @@ enum {
 	WORKER_CPU_INTENSIVE	= 1 << 6,	/* cpu intensive */
 	WORKER_UNBOUND		= 1 << 7,	/* worker is unbound */

-	WORKER_NOT_RUNNING	= WORKER_PREP | WORKER_ROGUE | WORKER_REBIND |
-				  WORKER_CPU_INTENSIVE | WORKER_UNBOUND,
+	WORKER_NOT_RUNNING	= (WORKER_PREP | WORKER_ROGUE |
+				   WORKER_REBIND | WORKER_CPU_INTENSIVE |
+				   WORKER_UNBOUND),

 	/* gcwq->trustee_state */
 	TRUSTEE_START		= 0,		/* start */

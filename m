Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab1ATLaf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 06:30:35 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:55916 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755056Ab1ATLae convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 06:30:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=USIzYQHIVJlpY1WIJ5PvTVWOAik5M4pUJDfjDjHxnAsEvqF8NbXBKDUQxzMNFKhJtC
         r3NQX41TMkZYFPCaLRmfRficfec8RFRk9LUAr+ok1gzsWgayFGW/uwJgOwkHMm4MXxoi
         mar1z8TN+RECTkUPbyWNGgQBI/mjQrUYJ3obY=
MIME-Version: 1.0
In-Reply-To: <20110120112606.GF6036@htj.dyndns.org>
References: <AANLkTimajU0x1v6y3rH2+jr-bZ=tNLs1S_agXdGGAa3S@mail.gmail.com>
	<20110119120200.GA1057@elte.hu>
	<20110120110635.GB6036@htj.dyndns.org>
	<20110120111149.GD6036@htj.dyndns.org>
	<1295522631.28776.155.camel@laptop>
	<20110120112606.GF6036@htj.dyndns.org>
Date: Thu, 20 Jan 2011 13:30:33 +0200
X-Google-Sender-Auth: 2g6iGF3SoY0enFIZCuJfg45IXr0
Message-ID: <AANLkTikiYjV+brMK0Aneazq7O6Pz5HVFgAiPqvJBkhkO@mail.gmail.com>
Subject: Re: [PATCH 1/2] lockdep: move early boot local IRQ enable/disable
 status to init/main.c
From: Pekka Enberg <penberg@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Jan 20, 2011 at 12:23:51PM +0100, Peter Zijlstra wrote:
>> On Thu, 2011-01-20 at 12:11 +0100, Tejun Heo wrote:
>> > Hello, guys.
>> >
>> > These two patches remove both warnings.  The first warning was
>> > completely spurious.  The second lockdep one was triggered by
>> > on_each_cpu() enabling local IRQ too early.
>> >
>> > I don't think percpu allocator itself malfunctioned.  There was no
>> > allocation failure.  It whines when percpu allocation fails but didn't
>> > in the log.  Other than calling vfree() early triggering the above
>> > condition, it worked okay.
>> >
>> > So, it's either the early enabling of local IRQ by on_each_cpu()
>> > breaking something in the IRQ subsystem or something different.  Ingo,
>> > can you please see whether these two patches cure the panic too?
>>
>> Why not use something like: system_state != SYSTEM_RUNNING ?

On Thu, Jan 20, 2011 at 1:26 PM, Tejun Heo <tj@kernel.org> wrote:
> Cuz, it's finer grained than that.  We can add a SYSTEM_* flag but I
> wasn't sure whether that would be just creating more noise.  If we try
> to consolidate these things, we probably should consider
> oops_in_progress too.  It probably is a good idea but let's first fix
> the problem at hand.

Yup, SYSTEM_RUNNING happens much later in the boot sequence so we
don't want to use it here. We had a long discussion about system_state
when we introduced gfp_allowed_mask and IIRC people wanted to avoid
more system_state flags and preferred more explicit ones like
early_boot_irqs_disabled.

We can do more cleanups later but for the problem at hand:

Acked-by: Pekka Enberg <penberg@kernel.org>

for both patches.

                   Pekka

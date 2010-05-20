Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281Ab0ETVhS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 17:37:18 -0400
Received: from smtp-out.google.com ([216.239.44.51]:34702 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119Ab0ETVhQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 17:37:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=Edc+/0C11NVMwH8uFDfYsO5h+fai6hH06i9fSm/dXcblpspHRDeL5FneTJL+ZeKLj
	TGgBeKhUuZXMJrrQKk0kA==
MIME-Version: 1.0
In-Reply-To: <30356.1274269677@redhat.com>
References: <1274135154-24082-1-git-send-email-walken@google.com>
	 <1274135154-24082-2-git-send-email-walken@google.com>
	 <30356.1274269677@redhat.com>
Date: Thu, 20 May 2010 14:37:11 -0700
Message-ID: <AANLkTim_hX5HevyN0HhLmJ6Y_Lg8eff16tBbXsqmKpgD@mail.gmail.com>
Subject: Re: [PATCH 01/10] x86 rwsem: minor cleanups
From: Michel Lespinasse <walken@google.com>
To: David Howells <dhowells@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 4:47 AM, David Howells <dhowells@redhat.com> wrote:
> Given that you describe this first, this would suggest that the subject of the
> patch should be this.  I'm not sure I'd count this as a minor cleanup.  I think
> I'd split it into its own patch.

OK, split it in two.

> Mostly okay, except where you said "expects old value in %edx" - that's only
> true on i386, not x86_64.  On the latter it would be %rdi.  However, I can live
> with that: it's true enough.

It's actually still %edx in x86_64 - we're calling into
arch/x86/lib/rwsem_64.S which has its own unusual conventions.

>> -     rwsem_count_t tmp;
>> +     rwsem_count_t tmp = -RWSEM_ACTIVE_WRITE_BIAS;
>> ...
>>                    : "+m" (sem->count), "=d" (tmp)
>> -                  : "a" (sem), "1" (-RWSEM_ACTIVE_WRITE_BIAS)
>> +                  : "a" (sem), "1" (tmp)
>
> If you're going to put the initialisation of EDX/RDI on tmp (which isn't really
> necessary), rather than directly on the asm statement, you could change the
> '"=d" (tmp)' output constraint to be '"+d" (tmp)' and drop the '"1" (tmp)'
> constraint entirely.

I agree it'd be nicer, but I wondered if all gcc versions would handle
the constraints change fine and then I chickened out. Instead I moved
the initialization on the constraints list as was already done in
__up_write(). All I was really shooting for here is consistency
accross __down_write_nested, __up_read and __up_write functions.

> However, apart from that, feel free to add my Acked-by to this patch or its
> split resultant patches.

Thanks. I'll send a V4 series soon integrating your feedback & mark
the two splitted patches resulting from this one as Acked-by.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.

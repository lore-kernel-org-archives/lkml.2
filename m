Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757730Ab0FIMxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 08:53:16 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46534 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874Ab0FIMxP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 08:53:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=GE5Y+ORrtF8A/GLaLu+IjFTBu5Gw13Jq4QVZI6clsYjNZym+NKsHoN2mrEefkEUttl
         m0622dTQXQusiW0wWWFHQ6Ea0VGwWHtt3gBSa9Cot0fx4m5+uVrspQOthnUrtL7srj09
         aPqOuUYaSCgxkOs9T+lG+dT0H9X10XRQPLlTg=
MIME-Version: 1.0
In-Reply-To: <1276086133.1645.575.camel@laptop>
References: <1274193049-25997-1-git-send-email-ebmunson@us.ibm.com>
	<tip-3af9e859281bda7eb7c20b51879cf43aa788ac2e@git.kernel.org>
	<AANLkTimsd32TL44V-aXvEoa3SE63X6qaOmMny9Q8uNRi@mail.gmail.com>
	<1276086133.1645.575.camel@laptop>
Date: Wed, 9 Jun 2010 15:53:13 +0300
X-Google-Sender-Auth: DTtmGdJZbE_oTmJHdBjTkqNB2_U
Message-ID: <AANLkTimcvVyLRBQbCmePLrrNyC01KBHIpZ873hXQcYf4@mail.gmail.com>
Subject: Re: [tip:perf/core] perf: Add non-exec mmap() tracking
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, hpa@zytor.com, anton@samba.org, acme@redhat.com,
       paulus@samba.org, linux-kernel@vger.kernel.org, efault@gmx.de,
       fweisbec@gmail.com, ebmunson@us.ibm.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 9, 2010 at 3:22 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-06-09 at 13:44 +0300, Pekka Enberg wrote:
>> > @@ -3830,6 +3834,14 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
>> >                if (!vma->vm_mm) {
>> >                        name = strncpy(tmp, "[vdso]", sizeof(tmp));
>> >                        goto got_name;
>> > +               } else if (vma->vm_start <= vma->vm_mm->start_brk &&
>> > +                               vma->vm_end >= vma->vm_mm->brk) {
>> > +                       name = strncpy(tmp, "[heap]", sizeof(tmp));
>> > +                       goto got_name;
>> > +               } else if (vma->vm_start <= vma->vm_mm->start_stack &&
>> > +                               vma->vm_end >= vma->vm_mm->start_stack) {
>> > +                       name = strncpy(tmp, "[stack]", sizeof(tmp));
>> > +                       goto got_name;
>> >                }
>> >
>> >                name = strncpy(tmp, "//anon", sizeof(tmp));
>>
>> Doesn't this change here break the JIT generated code region detection
>> in map__new() of tools/perf/util/map.c? We generate a new
>> "/tmp/perf-<pid>.map" filename for anonymous memory regions and check
>> for that in dso__load() of tools/perf/util/symbol.c.
>
> Not unless you stick your executable code in the heap or on the stack.

Right, I misread the patch. Thanks for the clarification, Peter!

> If you use something like mmap(NULL, size, PROT_READ|PROT_WRITE|
> PROT_EXEC, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0); to allocate your memory
> everything should be fine.

Sure, that's what I do.

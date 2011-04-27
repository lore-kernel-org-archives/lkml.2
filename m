Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759869Ab1D0TDO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 15:03:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34837 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260Ab1D0TDN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 15:03:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=iF3dmgnYxduuFXeWOn0I2cxgjrrcNw6CvRPyzL/Ik+NX0xCpnV7BYI/+6dc8XlM2Ys
         7l1cjKda+UkHNgt0rQrYhwu0tt2wiF0CJ+LqURIWvVhryC+UQsmxJXUmZ89twvQPP1vT
         4S70bSaA5J/8ZohW/sE7mQmmbAQUWf7vfRadg=
MIME-Version: 1.0
In-Reply-To: <20110427154805.GB23494@elte.hu>
References: <BANLkTikNWgzKefWxp6UUqQ-XdBvgG+QSNQ@mail.gmail.com>
	<20110422092322.GA1948@elte.hu>
	<BANLkTi=G7-v3ysxK2wY_3f8TecbD6ZjKog@mail.gmail.com>
	<20110422105211.GB1948@elte.hu>
	<20110422165007.GA18401@vps.sharma-home.net>
	<20110422203022.GA20573@elte.hu>
	<20110423201409.GA20072@elte.hu>
	<20110424061645.GA12013@radium.snc4.facebook.com>
	<20110427111141.GB28993@elte.hu>
	<BANLkTimz-KevvqmxxUPp73GEaAC5PTGWWw@mail.gmail.com>
	<20110427154805.GB23494@elte.hu>
Date: Wed, 27 Apr 2011 12:03:12 -0700
X-Google-Sender-Auth: gXggd1bdqVKf5_-FkkGaNbBr9D0
Message-ID: <BANLkTiko3bTCYP9oiX8KuQHQO0j2KtZ-mA@mail.gmail.com>
Subject: Re: [PATCH] perf events: Add stalled cycles generic event - PERF_COUNT_HW_STALLED_CYCLES
From: Arun Sharma <arun@sharma-home.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arun Sharma <asharma@fb.com>, Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, eranian@gmail.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 8:48 AM, Ingo Molnar <mingo@elte.hu> wrote:

>
>> The other issue I had to deal with was UOPS_RETIRED > UOPS_EXECUTED
>> condition. I believe this is caused by what AMD calls sideband stack
>> optimizer and Intel calls dedicated stack manager (i.e. UOPS executed outside
>> the main pipeline). A recursive fibonacci(30) is a good test case for
>> reproducing this.
>
> So the PORT015+234 sum is not precise? The definition seems to be rather firm:
>
>  Counts number of Uops executed that where issued on port 2, 3, or 4.
>  Counts number of Uops executed that where issued on port 0, 1, or 5.
>

There is some work done outside of the main out of order engine for
power optimization reasons:

Described as dedicated stack engine here:
http://www.intel.com/technology/itj/2003/volume07issue02/art03_pentiumm/vol7iss2_art03.pdf

However, I can't seem to be able to reproduce this behavior using a
micro benchmark right now:

# cat foo.s
.text
        .global main
main:
1:
        push %rax
        push %rbx
        push %rcx
        push %rdx
        pop  %rax
        pop  %rbx
        pop  %rcx
        pop  %rdx
        jmp  1b

 Performance counter stats for './foo':

     7,755,881,073 UOPS_ISSUED:ANY:t=1       (scaled from 79.98%)
    10,569,957,988 UOPS_RETIRED:ANY:t=1      (scaled from 79.96%)
     9,155,400,383 UOPS_EXECUTED:PORT234_CORE  (scaled from 80.02%)
     2,594,206,312 UOPS_EXECUTED:PORT015:t=1  (scaled from 80.02%)

Perhaps I was thinking of UOPS_ISSUED < UOPS_RETIRED.

In general, UOPS_RETIRED (or instruction retirement in general) is the
"source of truth" in an otherwise crazy world and might be more
interesting as a generalized event that works on multiple
architectures.

 -Arun

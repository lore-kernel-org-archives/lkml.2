Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933251Ab0JZNtf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 09:49:35 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57224 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933177Ab0JZNte convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 09:49:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tM3vZj+js4jE7QBfdx6jLwWMCcwdNluQER0riR23jCas1vHoxAQ1T5xMw1st4d75NV
         njIASvqEyqSKyzvJf50CKBqbFdxoLMG6yN2+lzvkfnLYVwJLBFEfAf9xXLVPza1oYdbb
         m7Y9cijt1Yj0W6vR/EFHJqXD8ZrLm2WIIMgks=
MIME-Version: 1.0
In-Reply-To: <4CC6D8FD.10802@kernel.org>
References: <4CC69B22.2050708@kernel.org>
	<20101025224111.7798.38960.stgit@warthog.procyon.org.uk>
	<12101.1288088542@redhat.com>
	<4CC6C62F.1000804@kernel.org>
	<4CC6C941.2080003@kernel.org>
	<4CC6CD4D.3010501@kernel.org>
	<20101026132548.GA14666@elte.hu>
	<4CC6D8FD.10802@kernel.org>
Date: Tue, 26 Oct 2010 09:49:31 -0400
Message-ID: <AANLkTinUMzMZEredesCH-qr-WBVPmNT+HGOq8T5ikd_G@mail.gmail.com>
Subject: Re: [PATCH] x86, percpu: revert commit fe8e0c25
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, torvalds@osdl.org,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        David Howells <dhowells@redhat.com>, akpm@linux-foundation.org,
        linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>,
        Mark Salter <msalter@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 26, 2010 at 9:34 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On 10/26/2010 03:25 PM, Ingo Molnar wrote:
>>
>> * Tejun Heo <tj@kernel.org> wrote:
>>
>>> Commit fe8e0c25 (x86, 32-bit: Align percpu area and irq stacks to THREAD_SIZE)
>>> aligned PERCPU section to THREAD_SIZE which can be larger than PAGE_SIZE,
>>> introduced DEFINE_PER_CPU_MULTIPAGE_ALIGNED() and used it to make irq stacks
>>> aligned to THREAD_SIZE on x86_32.
>>>
>>> This won't work.  The PERCPU output section is used as the template to prepare the
>>> percpu area and the actual percpu area is _alwasy_ aligned to PAGE_SIZE whether
>>> the source area is aligned to larger size or not.
>>
>> The problem is, this will reintroduce a nasty boot crash which commit fe8e0c25
>> fixed. Do you say that fe8e0c25 didnt have the alignment effect?
>
> AFAICS, not in a way which is correct.  The patch probably made the
> following two differences.
>
> * The stack in the template area is THREAD_SIZE aligned.  If something
>  was dereferencing it before percpu init, this could have helped.
>  IIRC, x86 early init code does use the template area.
>
> * The percpu address would be THREAD_SIZE aligned while the translated
>  kernel address for each cpu wouldn't be.  For masking stack pointer
>  to find out task struct, I don't think aligning the percpu address
>  would have been helpful.
>
> It's simply broken and needs to be reverted.  If the patch somehow
> fixed boot crash, yeah, we probably want to put a fix for it first
> tho.
>
> Thanks.

Probably the best fix is to go back to allocating the stacks with
get_free_pages(), and only keep the pointers in percpu memory.

--
Brian Gerst

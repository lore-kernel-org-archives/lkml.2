Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022Ab1FPNcp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 09:32:45 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52157 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757861Ab1FPNcm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 09:32:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sVuri22PhrZomB9Ly4ZMMegeVM4u2ntZ4EEUAgKipvi96yyJgXl1L6cMiICa3JcDEH
         TBqCsIyoMch9xLQxYalmBgKrtVkCvPjleKujMRxbWpPZv08lIjF3Z/4ploUc0XklB1ri
         +3VQGhR5aGOHc2AynmUgIKKTYp6DyTwMobueY=
MIME-Version: 1.0
In-Reply-To: <1308230239.9218.137.camel@gandalf.stny.rr.com>
References: <BANLkTimG_oBX1bDTEVfZ81_uqXOahqR1ww@mail.gmail.com>
	<1308230239.9218.137.camel@gandalf.stny.rr.com>
Date: Thu, 16 Jun 2011 14:32:41 +0100
Message-ID: <BANLkTinO85w4G9nFjio4HtOcrS0u-Ezz1Q@mail.gmail.com>
Subject: Re: [PATCH] ring_buffer: Ensure that buffer page data is aligned.
From: Will Newton <will.newton@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, fweisbec@gmail.com,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 2:17 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Thu, 2011-06-16 at 14:03 +0100, Will Newton wrote:
>> Explicitly align the start of the buffer page data array to the
>> required arch alignment. This is required for architectures that
>> require 8 byte alignment but do not have a 8 byte local_t.
>
> What arch does that? A 32bit arch that forces 8 byte alignment?

Yes, it's likely for all 64bit arches will be aligned correctly.

>>
>> Signed-off-by: Will Newton <will.newton@imgtec.com>
>> ---
>>  kernel/trace/ring_buffer.c |    4 +++-
>>  1 files changed, 3 insertions(+), 1 deletions(-)
>>
>> I don't believe that any currently in-tree architecture is affected by
>> this, but it can be an issue on 32bit architectures that require an
>> 8 byte aligment but only have a 32bit local_t. I think it's potentially
>> cleaner to make the alignment explicit anyway.
>>
>> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
>> index 0ef7b4b..36d5699 100644
>> --- a/kernel/trace/ring_buffer.c
>> +++ b/kernel/trace/ring_buffer.c
>> @@ -215,6 +215,8 @@ EXPORT_SYMBOL_GPL(tracing_is_on);
>>  # define RB_ARCH_ALIGNMENT           8U
>>  #endif
>>
>> +#define RB_ALIGN_DATA                __aligned(RB_ARCH_ALIGNMENT)
>> +
>
> Note, the code above this is:
>
> #define RB_EVNT_HDR_SIZE (offsetof(struct ring_buffer_event, array))
> #define RB_ALIGNMENT            4U
> #define RB_MAX_SMALL_DATA       (RB_ALIGNMENT * RINGBUF_TYPE_DATA_TYPE_LEN_MAX)
> #define RB_EVNT_MIN_SIZE        8U      /* two 32bit words */
>
> #if !defined(CONFIG_64BIT) || defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
> # define RB_FORCE_8BYTE_ALIGNMENT       0
> # define RB_ARCH_ALIGNMENT              RB_ALIGNMENT
> #else
> # define RB_FORCE_8BYTE_ALIGNMENT       1
> # define RB_ARCH_ALIGNMENT              8U
> #endif
>
>
> Which means that when CONFIG_64BIT is not set, RB_ARCH_ALIGNMENT is 4.
> This means that this patch is really a nop and doesn't do anything for
> your arch.

I have modified that conditional in my local tree so the patch is not
a nop there. Obviously it doesn't make any sense to merge that change
yet. I thought this part of the patch was a reasonable cleanup to make
the code a bit more self documenting though.

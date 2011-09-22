Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab1IVVUG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 17:20:06 -0400
Received: from smtp-out.google.com ([74.125.121.67]:45783 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928Ab1IVVUB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 17:20:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=nfKDn4zz1Vjp3zX6GdzYU0J68c2n02Bh+wgKO4OuAZEh27rrbNx6booU4kTrOYb4M
	n84NP28cQ5a3YjFpAQV0A==
MIME-Version: 1.0
In-Reply-To: <1316725632.29447.21.camel@Joe-Laptop>
References: <1316725029-22737-1-git-send-email-ccross@android.com>
	<1316725029-22737-4-git-send-email-ccross@android.com>
	<1316725632.29447.21.camel@Joe-Laptop>
Date: Thu, 22 Sep 2011 14:19:58 -0700
X-Google-Sender-Auth: Jb0SiaoHzPpkxfPWLi4-sl_X6dw
Message-ID: <CAMbhsRSNYUF+wMrhu+LMWpSuDrE6o3p_t7Ai5ZOqGDXHs6cTzg@mail.gmail.com>
Subject: Re: [PATCH 3/3] seq_file: convert seq buffer to vmalloc
From: Colin Cross <ccross@android.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 2:07 PM, Joe Perches <joe@perches.com> wrote:
> On Thu, 2011-09-22 at 13:57 -0700, Colin Cross wrote:
>> seq_files are often used for debugging.  When things are going wrong
>> due to failed physically contiguous allocations, the exponentially
>> growing physically contiguous allocations in seq_read can make things
>> worse.  There is no need for physically contiguous memory, so switch
>> to virtually contiguous memory instead.
>
> vmalloc's are relatively expensive.
> Perhaps use kmalloc when appropriate instead?
Talking about allocation efficiency in the context of seq_files is
silly - for a KMALLOC_MAX_SIZE buffer (8MB), you are already going to
allocate 11 times, with increasingly large buffers, and are likely to
fail long before you ever get to KMALLOC_MAX_SIZE.

> []
>> -     /* don't ask for more than the kmalloc() max size */
>> -     if (size > KMALLOC_MAX_SIZE)
>> -             size = KMALLOC_MAX_SIZE;
>> -
>> -     buf = kmalloc(size, GFP_KERNEL);
>> +     buf = vmalloc(size);
>>       if (!buf)
>>               return -ENOMEM;
>
>        if (size > KMALLOC_MAX_SIZE)
>                buf = vmalloc(size, GFP_KERNEL)
>        else
>                buf = kmalloc(size, GFP_KERNEL);
KMALLOC_MAX_SIZE is far too big for this.  KMALLOC_MAX_SIZE is the
maximum allocation that is theoretically possible, but will fail if
you don't have any completely empty pageblocks.  If I were to put a
size here, it would probably be order 3, but even that can easily fail
on a system that has under memory pressure.

>> +     vfree(m->buf);
>
>        if (m->size > KMALLOC_MAX_SIZE)
>                vfree(m->buf);
>        else
>                kfree(m->buf);
>
>>       m->buf = buf;
>>       m->size = size;
>>
>> @@ -106,7 +103,7 @@ static int traverse(struct seq_file *m, loff_t offset)
>>               return 0;
>>       }
>>       if (!m->buf) {
>> -             m->buf = kmalloc(m->size = PAGE_SIZE, GFP_KERNEL);
>> +             m->buf = vmalloc(m->size = PAGE_SIZE);
>
> embedding the set of m->size like this is ugly.
I agree, but it was there in the original file.  I could clean it up,
but that should be in a separate patch.

> [do the same as above kmalloc/vmalloc based on size]
>
> etc.
>
>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304Ab1IVX0g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 19:26:36 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37688 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931Ab1IVX0e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 19:26:34 -0400
MIME-Version: 1.0
In-Reply-To: <CAMbhsRSNYUF+wMrhu+LMWpSuDrE6o3p_t7Ai5ZOqGDXHs6cTzg@mail.gmail.com>
References: <1316725029-22737-1-git-send-email-ccross@android.com>
	<1316725029-22737-4-git-send-email-ccross@android.com>
	<1316725632.29447.21.camel@Joe-Laptop>
	<CAMbhsRSNYUF+wMrhu+LMWpSuDrE6o3p_t7Ai5ZOqGDXHs6cTzg@mail.gmail.com>
Date: Fri, 23 Sep 2011 08:26:33 +0900
Message-ID: <CAKYAXd8jdjqB9BO++6JNJ7GArNiOt9-DMQHz+XOFsHEkk1iPZw@mail.gmail.com>
Subject: Re: [PATCH 3/3] seq_file: convert seq buffer to vmalloc
From: NamJae Jeon <linkinjeon@gmail.com>
To: Colin Cross <ccross@android.com>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/23 Colin Cross <ccross@android.com>:
> On Thu, Sep 22, 2011 at 2:07 PM, Joe Perches <joe@perches.com> wrote:
>> On Thu, 2011-09-22 at 13:57 -0700, Colin Cross wrote:
>>> seq_files are often used for debugging.  When things are going wrong
>>> due to failed physically contiguous allocations, the exponentially
>>> growing physically contiguous allocations in seq_read can make things
>>> worse.  There is no need for physically contiguous memory, so switch
>>> to virtually contiguous memory instead.
>>
>> vmalloc's are relatively expensive.
>> Perhaps use kmalloc when appropriate instead?
> Talking about allocation efficiency in the context of seq_files is
> silly - for a KMALLOC_MAX_SIZE buffer (8MB), you are already going to
> allocate 11 times, with increasingly large buffers, and are likely to
> fail long before you ever get to KMALLOC_MAX_SIZE.
>
>> []
>>> -     /* don't ask for more than the kmalloc() max size */
>>> -     if (size > KMALLOC_MAX_SIZE)
>>> -             size = KMALLOC_MAX_SIZE;
>>> -
>>> -     buf = kmalloc(size, GFP_KERNEL);
>>> +     buf = vmalloc(size);
>>>       if (!buf)
>>>               return -ENOMEM;
>>
>>        if (size > KMALLOC_MAX_SIZE)
>>                buf = vmalloc(size, GFP_KERNEL)
>>        else
>>                buf = kmalloc(size, GFP_KERNEL);
> KMALLOC_MAX_SIZE is far too big for this.  KMALLOC_MAX_SIZE is the
> maximum allocation that is theoretically possible, but will fail if
> you don't have any completely empty pageblocks.  If I were to put a
> size here, it would probably be order 3, but even that can easily fail
> on a system that has under memory pressure.
-> I agree. I think that vmalloc is better than kmalloc. because you
can face page allocation fail by high order page.
>
>>> +     vfree(m->buf);
>>
>>        if (m->size > KMALLOC_MAX_SIZE)
>>                vfree(m->buf);
>>        else
>>                kfree(m->buf);
>>
>>>       m->buf = buf;
>>>       m->size = size;
>>>
>>> @@ -106,7 +103,7 @@ static int traverse(struct seq_file *m, loff_t offset)
>>>               return 0;
>>>       }
>>>       if (!m->buf) {
>>> -             m->buf = kmalloc(m->size = PAGE_SIZE, GFP_KERNEL);
>>> +             m->buf = vmalloc(m->size = PAGE_SIZE);
>>
>> embedding the set of m->size like this is ugly.
> I agree, but it was there in the original file.  I could clean it up,
> but that should be in a separate patch.
>
>> [do the same as above kmalloc/vmalloc based on size]
>>
>> etc.
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

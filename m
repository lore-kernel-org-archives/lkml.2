Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413Ab2EJQI7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 12:08:59 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34017 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab2EJQI6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 12:08:58 -0400
MIME-Version: 1.0
In-Reply-To: <20120508155726.d02d6600.akpm@linux-foundation.org>
References: <1336229772-3488-1-git-send-email-levinsasha928@gmail.com> <20120508155726.d02d6600.akpm@linux-foundation.org>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Thu, 10 May 2012 18:08:36 +0200
Message-ID: <CA+1xoqfTTrMMybaFTE-GUpMd9SRq9Kdgp5JBem--tqRKAocLBg@mail.gmail.com>
Subject: Re: [PATCH] kmsg: limit message size
To: Andrew Morton <akpm@linux-foundation.org>
Cc: arnd@arndb.de, gregkh@linuxfoundation.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 9, 2012 at 12:57 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Sat,  5 May 2012 16:56:12 +0200
> Sasha Levin <levinsasha928@gmail.com> wrote:
>
>> There are no size checks in kmsg_write(), and we try allocating enough
>> memory to store everything userspace gave us, which may be too much for
>> kmalloc to allocate.
>>
>> Furthermore, we can have an integer overflow if len==INT_MAX, in that case
>> we'll corrupt kernel memory.
>>
>> This was tested with several userspace programs that write to kmsg, and haven't
>> found a case where the program attempts to write more than PAGE_SIZE.
>>
>> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
>> ---
>>  drivers/char/mem.c |    3 +++
>>  1 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/char/mem.c b/drivers/char/mem.c
>> index d6e9d08..c90964b 100644
>> --- a/drivers/char/mem.c
>> +++ b/drivers/char/mem.c
>> @@ -815,6 +815,9 @@ static ssize_t kmsg_writev(struct kiocb *iocb, const struct iovec *iv,
>>       ssize_t ret = -EFAULT;
>>       size_t len = iov_length(iv, count);
>>
>> +     if (len > PAGE_SIZE)
>> +             return -E2BIG;
>> +
>>       line = kmalloc(len + 1, GFP_KERNEL);
>>       if (line == NULL)
>>               return -ENOMEM;
>
> Well, this is a write(), and write() is permitted to return
> less-than-asked-for.  So what we could do here is to write the first N
> bytes and then return N to userspace.  Well-behaved userspace will
> notice this and then do some more writing from offset N.
>
> Could I ask that you try this and test it a bit, see whether there is
> any well-behaved userspace out there?  Things like cat and echo
> _should_ dtrt.

Yup, cat and echo do dtrt. I'll resend a patch which limits the write
instead of canceling it altogether.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab1ACVqr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 16:46:47 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49888 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754960Ab1ACVqp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 16:46:45 -0500
MIME-Version: 1.0
In-Reply-To: <20110103131911.c1c2adf6.akpm@linux-foundation.org>
References: <1293182186-23462-1-git-send-email-namhyung@gmail.com> <20110103131911.c1c2adf6.akpm@linux-foundation.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 3 Jan 2011 13:46:19 -0800
Message-ID: <AANLkTinL8Zi2=XjRrb1g7Wg=tqGk3Tmk3C7-CzZY_QjJ@mail.gmail.com>
Subject: Re: [PATCH] compat: fix use of an uninitialized variable in compat_sys_io_setup()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Namhyung Kim <namhyung@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 3, 2011 at 1:19 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri, 24 Dec 2010 18:16:26 +0900
> Namhyung Kim <namhyung@gmail.com> wrote:
>
>> The upper bytes of ctx64 might contain garbages because it was
>> set by get_user() which copied only lower 4 bytes as its second
>> argument points to. Since sys_io_setup() requires its argumet
>> is properly initialized to 0 we should set it explicitly.
>>
>> On x86, this was not a problem since its implementation of
>> get_user() does a C assignment so that it can fill upper bytes
>> with 0's. But other archs that use __get_user_asm() or something
>> might have a problem.
>>
>> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
>> Cc: Jeff Moyer <jmoyer@redhat.com>
>> ---
>>  fs/compat.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/compat.c b/fs/compat.c
>> index 4376e07febbb..b074e9f79148 100644
>> --- a/fs/compat.c
>> +++ b/fs/compat.c
>> @@ -526,7 +526,7 @@ asmlinkage long
>>  compat_sys_io_setup(unsigned nr_reqs, u32 __user *ctx32p)
>>  {
>>       long ret;
>> -     aio_context_t ctx64;
>> +     aio_context_t ctx64 = 0;
>>
>>       mm_segment_t oldfs = get_fs();
>>       if (unlikely(get_user(ctx64, ctx32p)))
>
> Well.  What _should_ a get_user(some_u64, some_u32*) do to `some_u64'?

We do "get_user(int,char *)" etc all the time. It's expected to work,
and do the proper zero- (or sign-) extension.

The x86 code does:

  #define get_user(x, ptr)
           ...
           (x) = (__typeof__(*(ptr)))__val_gu;

and that's the _only_ correct thing to do. That assignment, with the
proper type expansion, is absolutely vital. And there's no way you can
do that with any asm constructs, exactly because of the whole
sign/zero extension requirement.

If somebody only sets the low 32 bits of the result, that's simply a
bug. That's a seriously buggered uaccess.h.

So NAK on the patch, and please point to what architecture has this problem.

                            Linus

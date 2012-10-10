Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382Ab2JJWbN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 18:31:13 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:37964 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756906Ab2JJWbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 18:31:08 -0400
MIME-Version: 1.0
In-Reply-To: <20121010134646.4e9bba55.akpm@linux-foundation.org>
References: <20121009225401.GA10219@www.outflux.net>
	<20121010134646.4e9bba55.akpm@linux-foundation.org>
Date: Wed, 10 Oct 2012 15:31:07 -0700
X-Google-Sender-Auth: N6pM4f7Qyl-_zUIijj_Unz8M9go
Message-ID: <CAGXu5jJCQ3RxoFJ5FrGo=FJLSApK2PKX0PAt=E8y=PECNn4XWg@mail.gmail.com>
Subject: Re: [PATCH v2] fix stack memory content leak via UNAME26
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        PaX Team <pageexec@freemail.hu>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 1:46 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 9 Oct 2012 15:54:01 -0700
> Kees Cook <keescook@chromium.org> wrote:
>
>> Calling uname() with the UNAME26 personality set allows a leak of kernel
>> stack contents. This fixes it by initializing the stack buffer to zero,
>> defensively calculating the length of copy_to_user() call, and making
>> the len argument unsigned.
>>
>> ...
>>
>> --- a/kernel/sys.c
>> +++ b/kernel/sys.c
>> @@ -1265,13 +1265,13 @@ DECLARE_RWSEM(uts_sem);
>>   * Work around broken programs that cannot handle "Linux 3.0".
>>   * Instead we map 3.x to 2.6.40+x, so e.g. 3.0 would be 2.6.40
>>   */
>> -static int override_release(char __user *release, int len)
>> +static int override_release(char __user *release, size_t len)
>>  {
>>       int ret = 0;
>> -     char buf[65];
>>
>>       if (current->personality & UNAME26) {
>> -             char *rest = UTS_RELEASE;
>> +             const char *rest = UTS_RELEASE;
>> +             char buf[65] = { 0 };
>>               int ndots = 0;
>>               unsigned v;
>>
>> @@ -1283,7 +1283,9 @@ static int override_release(char __user *release, int len)
>>                       rest++;
>>               }
>>               v = ((LINUX_VERSION_CODE >> 8) & 0xff) + 40;
>> -             snprintf(buf, len, "2.6.%u%s", v, rest);
>> +             snprintf(buf, sizeof(buf), "2.6.%u%s", v, rest);
>> +             if (sizeof(buf) < len)
>> +                     len = sizeof(buf);
>>               ret = copy_to_user(release, buf, len);
>>       }
>>       return ret;
>
> This looks unecessarily complicated.  Is there a reason to be copying
> all 65 bytes out to userspace?
>
> If not, then couldn't we just do
>
>         len = scnprintf(...);
>         ret = copy_to_user(..., len + 1);
>
> ?

As it is, nothing calls override_release with crazy "len" values, but,
to make the code less fragile, there should be checking for
sizeof(buf) vs len. In the patch I sent, bounding the sprintf was
sizeof(buf), and the copy_to_user was bounded by effectively
min(sizeof(buf), len). If you wanted to use scnprintf, you'd have to
reorganize the checks and explicitly handle len == 0:

if (!len)
    return -EFAULT;
if (sizeof(buf) < len)
    len = sizeof(buf)
len = scnprintf(buf, len, "2.6.%u%s", v, rest);
ret = copy_to_user(release, buf, len + 1);

> (This code is application #11,493 for the sprintf_user() which we don't have)

Indeed.

-Kees

-- 
Kees Cook
Chrome OS Security

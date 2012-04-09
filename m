Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957Ab2DIT0G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 15:26:06 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45404 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757885Ab2DIT0B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 15:26:01 -0400
MIME-Version: 1.0
In-Reply-To: <20120406141415.93f46bc6.akpm@linux-foundation.org>
References: <1333051320-30872-1-git-send-email-wad@chromium.org>
	<1333051320-30872-10-git-send-email-wad@chromium.org>
	<20120406141415.93f46bc6.akpm@linux-foundation.org>
Date: Mon, 9 Apr 2012 14:26:01 -0500
Message-ID: <CABqD9hZVZQXA5cyufwWirWVUYZwSkjRxHR2CBKW5V62qD-DGtA@mail.gmail.com>
Subject: Re: [PATCH v17 09/15] seccomp: remove duplicated failure logging
From: Will Drewry <wad@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
        kernel-hardening@lists.openwall.com, netdev@vger.kernel.org,
        x86@kernel.org, arnd@arndb.de, davem@davemloft.net, hpa@zytor.com,
        mingo@redhat.com, oleg@redhat.com, peterz@infradead.org,
        rdunlap@xenotime.net, mcgrathr@chromium.org, tglx@linutronix.de,
        luto@mit.edu, serge.hallyn@canonical.com, djm@mindrot.org,
        scarybeasts@gmail.com, indan@nul.nu, pmoore@redhat.com, corbet@lwn.net,
        eric.dumazet@gmail.com, markus@chromium.org, coreyb@linux.vnet.ibm.com,
        jmorris@namei.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 6, 2012 at 4:14 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 29 Mar 2012 15:01:54 -0500
> Will Drewry <wad@chromium.org> wrote:
>
>> From: Kees Cook <keescook@chromium.org>
>>
>> This consolidates the seccomp filter error logging path and adds more
>> details to the audit log.
>>
>> ...
>>
>> --- a/include/linux/audit.h
>> +++ b/include/linux/audit.h
>>
>> ...
>>
>>  #define audit_inode(n,d) do { (void)(d); } while (0)
>>  #define audit_inode_child(i,p) do { ; } while (0)
>>  #define audit_core_dumps(i) do { ; } while (0)
>> -#define audit_seccomp(i) do { ; } while (0)
>> +#define audit_seccomp(i,s,c) do { ; } while (0)
>
> Sigh.  Someone please convert all these to C.  That way we get
> typechecking and don't need dopey party tricks like that "(void)(d)" to
> squish compilation warnings.
>
>> ...
>> --- a/kernel/auditsc.c
>> +++ b/kernel/auditsc.c
>> @@ -67,6 +67,7 @@
>>  #include <linux/syscalls.h>
>>  #include <linux/capability.h>
>>  #include <linux/fs_struct.h>
>> +#include <linux/compat.h>
>>
>>  #include "audit.h"
>>
>> @@ -2710,13 +2711,18 @@ void audit_core_dumps(long signr)
>>       audit_log_end(ab);
>>  }
>>
>> -void __audit_seccomp(unsigned long syscall)
>> +void __audit_seccomp(unsigned long syscall, long signr, int code)
>>  {
>>       struct audit_buffer *ab;
>>
>>       ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_ANOM_ABEND);
>> -     audit_log_abend(ab, "seccomp", SIGKILL);
>> +     audit_log_abend(ab, "seccomp", signr);
>>       audit_log_format(ab, " syscall=%ld", syscall);
>> +#ifdef CONFIG_COMPAT
>> +     audit_log_format(ab, " compat=%d", is_compat_task());
>> +#endif
>
> We don't need the ifdef for compilation reasons now.
>
> The question is: should we emit the compat= record on
> non-compat-capable architectures?  Doing so would be safer - making it
> conditional invites people to write x86-only usersapce.

I'd certainly prefer it always being there for exactly that reason.

Kees, Eric, any preferences?  Unless I hear one, I'll just drop the
ifdefs in the next revision.

thanks!

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653Ab2BSRpR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 12:45:17 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:45818 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754449Ab2BSRpN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 12:45:13 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of keescook@google.com designates 10.182.169.4 as permitted sender) smtp.mail=keescook@google.com; dkim=pass header.i=keescook@google.com
MIME-Version: 1.0
In-Reply-To: <20120219124916.GB25900@elte.hu>
References: <20120218193857.GA30985@www.outflux.net>
	<20120219124916.GB25900@elte.hu>
Date: Sun, 19 Feb 2012 09:45:12 -0800
X-Google-Sender-Auth: O17xWxy3g6BK8ZU9WoUActLOQeI
Message-ID: <CAGXu5jL-NZP9At16q-b6biszMAWQQ4HLzW3cHDQUf0m7PGwGbQ@mail.gmail.com>
Subject: Re: [PATCH] fs: hardlink creation restrictions
From: Kees Cook <keescook@chromium.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 19, 2012 at 4:49 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Kees Cook <keescook@chromium.org> wrote:
>
>> This is the other half of link restrictions, now that symlink
>> restriction has landed in -mm.
>
> Nice features!

Thanks!

>> @@ -300,9 +302,29 @@ config PROTECTED_STICKY_SYMLINKS_ENABLED
>>         via /proc/sys/kernel/protected_sticky_symlinks.
>>
>>  config PROTECTED_STICKY_SYMLINKS_ENABLED_SYSCTL
>> -     depends on PROTECTED_STICKY_SYMLINKS
>> +     depends on PROTECTED_LINKS
>>       int
>>       default "1" if PROTECTED_STICKY_SYMLINKS_ENABLED
>>       default "0"
>>
>> +config PROTECTED_NONACCESS_HARDLINKS_ENABLED
>> +     depends on PROTECTED_LINKS
>> +     bool "Disallow hardlink creation to non-accessible files"
>> +     default y
>> +     help
>> +       Solve ToCToU hardlink race vulnerabilities by permitting hardlinks
>> +       to be created only when to a regular file that is owned by the user,
>> +       or is readable and writable by the user. Also blocks users from
>> +       "pinning" vulnerable setuid/setgid programs from being upgraded by
>> +       the administrator.
>> +
>> +       When PROC_SYSCTL is enabled, this setting can also be controlled
>> +       via /proc/sys/kernel/protected_nonaccess_hardlinks.
>
> I'd add a:
>
>        See Documentation/sysctl/fs.txt for details.
>
> line as well.

Good call.

>> +config PROTECTED_NONACCESS_HARDLINKS_ENABLED_SYSCTL
>> +     depends on PROTECTED_LINKS
>> +     int
>> +     default "1" if PROTECTED_NONACCESS_HARDLINKS_ENABLED
>> +     default "0"
>
> Naming nit: how about dropping the _NONACCESS/_nonaccess names
> complete and turn it into protected_hardlinks? The longer
> variant is not any better descriptive, and needlessly longer.
>
> The PROTECTED_SYMLINKS/PROTECTED_HARDLINKS naming is thus also
> nicely symmetric.

Yeah, this really does look much better. I had opted for extreme
verbosity, but I would agree: it's not really called for here.

>> +#ifdef CONFIG_AUDIT
>> +     if (error) {
>> +             struct audit_buffer *ab;
>> +
>> +             ab = audit_log_start(current->audit_context,
>> +                                  GFP_KERNEL, AUDIT_AVC);
>> +             audit_log_format(ab, "op=linkat action=denied");
>> +             audit_log_format(ab, " pid=%d comm=", current->pid);
>> +             audit_log_untrustedstring(ab, current->comm);
>> +             audit_log_d_path(ab, " path=", old_path);
>> +             audit_log_format(ab, " dev=");
>> +             audit_log_untrustedstring(ab, inode->i_sb->s_id);
>> +             audit_log_format(ab, " ino=%lu", inode->i_ino);
>> +             audit_log_end(ab);
>> +     }
>> +#endif
>
> Small detail: don't these audit methods map to nothing on
> !CONFIG_AUDIT, allowing the #ifdef to be dropped? (if not then
> it should really be so.)

Ah-ha; a more careful look at audit.h agrees. :) I'll adjust this as well.

> Acked-by: Ingo Molnar <mingo@elte.hu>

Thanks for the review,

-Kees

-- 
Kees Cook
ChromeOS Security

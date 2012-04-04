Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089Ab2DDVna (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 17:43:30 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37663 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab2DDVn3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 17:43:29 -0400
MIME-Version: 1.0
In-Reply-To: <20120404212750.GA29394@mail.hallyn.com>
References: <20120404023033.GB18730@mail.hallyn.com>
	<20120404184019.GA32681@www.outflux.net>
	<20120404212750.GA29394@mail.hallyn.com>
Date: Wed, 4 Apr 2012 14:43:28 -0700
X-Google-Sender-Auth: fh-mEb3ok4TQfRc3XbMZjiwxMNI
Message-ID: <CAGXu5j+xMkEwVYb0zb-4ZCa77pfg=hnUa-eVsE2pY1r133twiQ@mail.gmail.com>
Subject: Re: [PATCH] sysctl: fix write access to dmesg_restrict/kptr_restrict
From: Kees Cook <keescook@chromium.org>
To: Phillip Lougher <plougher@redhat.com>
Cc: linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Richard Weinberger <richard@nod.at>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>, Eugene Teo <eteo@redhat.com>,
        Eric Paris <eparis@redhat.com>, James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[forward, with my botch of plougher's email address corrected]

On Wed, Apr 4, 2012 at 2:27 PM, Serge E. Hallyn <serge@hallyn.com> wrote:
> Quoting Kees Cook (keescook@chromium.org):
>> Commit bfdc0b4 adds code to restrict access to dmesg_restrict,
>> however, it incorrectly alters kptr_restrict rather than
>> dmesg_restrict.
>>
>> The original patch from Richard Weinberger
>> (https://lkml.org/lkml/2011/3/14/362) alters dmesg_restrict as
>> expected, and so the patch seems to have been misapplied.
>>
>> This adds the CAP_SYS_ADMIN check to both dmesg_restrict and
>> kptr_restrict, since both are sensitive.
>>
>> Reported-by: Phillip Lougher <plougher@redhat.com>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>
> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
>
>> Cc: stable@vger.kernel.org
>> ---
>>  kernel/sysctl.c |    8 ++++----
>>  1 files changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
>> index 52b3a06..4ab1187 100644
>> --- a/kernel/sysctl.c
>> +++ b/kernel/sysctl.c
>> @@ -170,7 +170,7 @@ static int proc_taint(struct ctl_table *table, int write,
>>  #endif
>>
>>  #ifdef CONFIG_PRINTK
>> -static int proc_dmesg_restrict(struct ctl_table *table, int write,
>> +static int proc_dointvec_minmax_sysadmin(struct ctl_table *table, int write,
>>                               void __user *buffer, size_t *lenp, loff_t *ppos);
>>  #endif
>>
>> @@ -703,7 +703,7 @@ static struct ctl_table kern_table[] = {
>>               .data           = &dmesg_restrict,
>>               .maxlen         = sizeof(int),
>>               .mode           = 0644,
>> -             .proc_handler   = proc_dointvec_minmax,
>> +             .proc_handler   = proc_dointvec_minmax_sysadmin,
>>               .extra1         = &zero,
>>               .extra2         = &one,
>>       },
>> @@ -712,7 +712,7 @@ static struct ctl_table kern_table[] = {
>>               .data           = &kptr_restrict,
>>               .maxlen         = sizeof(int),
>>               .mode           = 0644,
>> -             .proc_handler   = proc_dmesg_restrict,
>> +             .proc_handler   = proc_dointvec_minmax_sysadmin,
>>               .extra1         = &zero,
>>               .extra2         = &two,
>>       },
>> @@ -1943,7 +1943,7 @@ static int proc_taint(struct ctl_table *table, int write,
>>  }
>>
>>  #ifdef CONFIG_PRINTK
>> -static int proc_dmesg_restrict(struct ctl_table *table, int write,
>> +static int proc_dointvec_minmax_sysadmin(struct ctl_table *table, int write,
>>                               void __user *buffer, size_t *lenp, loff_t *ppos)
>>  {
>>       if (write && !capable(CAP_SYS_ADMIN))
>> --
>> 1.7.0.4
>>
>> --
>> Kees Cook
>> Chrome OS Security



-- 
Kees Cook
ChromeOS Security

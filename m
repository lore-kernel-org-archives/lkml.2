Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922Ab2KSW1B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 17:27:01 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:35482 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034Ab2KSW1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 17:27:00 -0500
MIME-Version: 1.0
In-Reply-To: <20121119141458.883e6535.akpm@linux-foundation.org>
References: <20121119220051.GA16851@www.outflux.net>
	<20121119141458.883e6535.akpm@linux-foundation.org>
Date: Mon, 19 Nov 2012 14:26:59 -0800
X-Google-Sender-Auth: -rj98kY30ZAgWTisf78bx8wuDBE
Message-ID: <CAGXu5jK5Y2dEoYJwq5+KdQT5a9+VdkrDbwbYBHsSHLgeBf1gUg@mail.gmail.com>
Subject: Re: [PATCH] audit: catch possible NULL audit buffers
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Eric Paris <eparis@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 2:14 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon, 19 Nov 2012 14:00:51 -0800
> Kees Cook <keescook@chromium.org> wrote:
>
>> It's possible for audit_log_start() to return NULL. Handle it in the
>> various callers.
>>
>> ...
>>
>> --- a/kernel/audit.c
>> +++ b/kernel/audit.c
>> @@ -272,6 +272,8 @@ static int audit_log_config_change(char *function_name, int new, int old,
>>       int rc = 0;
>>
>>       ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_CONFIG_CHANGE);
>> +     if (unlikely(!ab))
>> +             return rc;
>
> Returning success here looks suspicious.  audit_do_config_change() will
> fail to take its wtf-just-happened action (which
> audit_log_config_change() duplicates, btw).

It seemed like the only meaningful rc was from when
security_secid_to_secctx failed, which changes the audit report and
has external side-effects that seem specific to that condition. It
seemed that audit_log_start() failing was less of a problem than
security_secid_to_secctx failing, which seems supposed be all the
other code in the kernel that gives up if audit_log_start() fails.

> Meanwhile audit_receive_msg() is off living in a happy land where
> nothing ever goes wrong.

Right, this reinforced my perceptions that a audit_log_start() failure
wasn't meaningful to propagate to callers of
audit_log_config_change().

>
>>       audit_log_format(ab, "%s=%d old=%d auid=%u ses=%u", function_name, new,
>>                        old, from_kuid(&init_user_ns, loginuid), sessionid);
>>       if (sid) {
>> @@ -619,6 +621,8 @@ static int audit_log_common_recv_msg(struct audit_buffer **ab, u16 msg_type,
>>       }
>>
>>       *ab = audit_log_start(NULL, GFP_KERNEL, msg_type);
>> +     if (unlikely(!*ab))
>> +             return rc;
>
> Also looks fishy.

Without any callers checking the return value, it seemed useless to
propagate here too.

-Kees

-- 
Kees Cook
Chrome OS Security

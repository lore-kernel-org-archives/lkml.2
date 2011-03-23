Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932647Ab1CWOIJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 10:08:09 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58186 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164Ab1CWOII convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 10:08:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mYfZif3FBHT7CM4rX7SYbKX7PuGl9rA3fZF1QE+PMkAEZGb4212jU/C2j8bphFQYDZ
         vJ717qLufys1R72SHQHw2wWFC/6iUcLzNVE78i/uWzDZoc0E4SXtSuxPA30mOFz4o75S
         iUIM2mI6WF6vyRCoBgvPBwEwPDoo6454qjA6M=
MIME-Version: 1.0
In-Reply-To: <1300885734.1479.6.camel@leonhard>
References: <1299584662-24421-4-git-send-email-namhyung@gmail.com>
	<tip-2f8058ae197236f9d5641850ce27f67d8f3e0b39@git.kernel.org>
	<20110310230222.GB1837@nowhere>
	<1300885734.1479.6.camel@leonhard>
Date: Wed, 23 Mar 2011 15:08:06 +0100
Message-ID: <AANLkTikMaimbA=ia-Gr91JbdwFqeAcyTuQ9VzHhATent@mail.gmail.com>
Subject: Re: [tip:x86/cleanups] x86, dumpstack: Use frame pointer during stack trace
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/3/23 Namhyung Kim <namhyung@gmail.com>:
> 2011-03-11 (금), 00:02 +0100, Frederic Weisbecker:
>> On Thu, Mar 10, 2011 at 10:26:07PM +0000, tip-bot for Namhyung Kim wrote:
>> > Commit-ID:  2f8058ae197236f9d5641850ce27f67d8f3e0b39
>> > Gitweb:     http://git.kernel.org/tip/2f8058ae197236f9d5641850ce27f67d8f3e0b39
>> > Author:     Namhyung Kim <namhyung@gmail.com>
>> > AuthorDate: Tue, 8 Mar 2011 20:44:22 +0900
>> > Committer:  Thomas Gleixner <tglx@linutronix.de>
>> > CommitDate: Thu, 10 Mar 2011 23:20:30 +0100
>> >
>> > x86, dumpstack: Use frame pointer during stack trace
>> >
>> > If CONFIG_FRAME_POINTER is set then use the frame pointer for the
>> > stack backtrace rather than scanning whole stack blindly.
>>
>> We don't do it blindly, we actually check the reliability with the
>> frame pointer.
>>
>> I'm not sure this patch is a good idea. stack dumps need to stay very
>> robust and not exclusively rely on the frame pointer to be correct.
>> At least walking blindly the stack provides a best effort dump as a last
>> resort.
>>
>
> Sounds reasonable. How about adding a boot param to control it then?

Hmm, but I'm not sure what it would be useful for. Even if one is sure that his
crash will have the needed reliable addresses already, having
unreliable ones too in
the report are not a problem. Are they?

Besides, how can we read a stack dump report posted by someone and be sure
he did not miss an important part because he had this kernel parameter enabled
and his frame pointer broken, or our frame based stack dump walking broken as
it has been many times, like your fixed in your patchset.

One win I could find though is that it can help a stack dump to fit in
the screen....

>
> diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
> index 809d027de28f..0d7efd90c588 100644
> --- a/arch/x86/kernel/dumpstack.c
> +++ b/arch/x86/kernel/dumpstack.c
> @@ -177,6 +177,16 @@ static const struct stacktrace_ops print_trace_ops
> #endif
>  };
>
> +static int __init nofptrace_setup(char *s)
> +{
> +       struct stacktrace_ops *ops;
> +
> +       ops = (struct stacktrace_ops *) &print_trace_ops;
> +       ops->walk_stack = walk_context_stack;
> +       return 0;
> +}
> +early_param("nofptrace", nofptrace_setup);
> +
>  void
>  show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
>                unsigned long *stack, unsigned long bp, char *log_lvl)
>
>
>
> --
> Regards,
> Namhyung Kim
>
>
>

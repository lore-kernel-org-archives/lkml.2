Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932740Ab2B2OHf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 09:07:35 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43591 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932675Ab2B2OHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 09:07:34 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dmitry.antipov@linaro.org designates 10.204.154.211 as permitted sender) smtp.mail=dmitry.antipov@linaro.org
Message-ID: <4F4E3173.60804@linaro.org>
Date: Wed, 29 Feb 2012 18:08:51 +0400
From: Dmitry Antipov <dmitry.antipov@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Rusty Russell <rusty.russell@linaro.org>, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Subject: Re: [RFC PATCH] module: debugging check for runaway kthreads
References: <1330419863-3508-1-git-send-email-dmitry.antipov@linaro.org> <20120228124318.6ed21b02.akpm@linux-foundation.org>
In-Reply-To: <20120228124318.6ed21b02.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/29/2012 12:43 AM, Andrew Morton wrote:

> Please make the stub function a proper C function, not a macro.  It
> provides type checking, can prevent compile warnings and is generally
> easier on the eyes.

OK

> I think this should be under the kernel hacking menu, dependent on
> CONFIG_DEBUG_KERNEL, in lib/Kconfig.debug.

I tried to group all module options together. Nevertheless,
I have no objections for separately grouping debugging options.

>>   struct kthread {
>>   	int should_stop;
>> +#ifdef CONFIG_MODULE_KTHREAD_CHECK
>> +	void *fn;
>> +#endif
>
> A little comment describing what this field is for would be nice.

OK

>> +unsigned long get_kthread_func(struct task_struct *tsk)
>> +{
>> +	struct kthread *kt;
>> +	unsigned long addr;
>> +
>> +	get_task_struct(tsk);
>> +	BUG_ON(!(tsk->flags&  PF_KTHREAD));
>> +	kt = to_kthread(tsk);
>> +	barrier();
>> +	addr = tsk->vfork_done ? (unsigned long)kt->fn : 0UL;
>> +	put_task_struct(tsk);
>> +	return addr;
>> +}
>
> gack, I hadn't noticed the kthread ab^wre^wuse of vfork_done before.
> Kooky.  Undocumented, too.

Hm... vfork_done of the just created kthread is NULL. When the new
kthread calls kthread(), it assigns it's private 'struct kthread' to
it's own tsk->vfork_done (IIUC, this is just a hack to avoid ugly
stuff like excessive pointer in task_struct or pointer type conversion).
So, to_kthread(tsk) is valid only if tsk->vfork_done is non-NULL,
otherwise it's just a bogus pointer. IMHO this hack should be documented
in kthread().

>> +#ifdef CONFIG_KALLSYMS
>> +static const char *get_ksymbol(struct module *mod, unsigned long addr,
>> +			       unsigned long *size, unsigned long *offset);
>> +#else
>> +#define get_ksymbol(mod, addr, size, offset) NULL
>> +#endif
>
> Can this code block be moved to after the get_ksymbol() definition so
> the forward declaration is unneeded?

OK

> Did we really need to use the internal get_ksymbol(), rather than an
> official kallsyms interface function?

I don't see a kallsyms interface function which is able to look through
just one module. Since the module name (and struct module pointer) is
known, it looks redundant to lookup through the whole kallsyms tables.

> The CONFIG_KALLSYMS=n stub should be written in C.  Make it return
> "<unknown>" and the ?: in check_kthreads() can be done away with.

OK

>> +#else
>> +
>> +#define check_kthreads(mod) do { } while (0)
>
> In C, please.

OK

Dmitry


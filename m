Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933122Ab1IMXmv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 19:42:51 -0400
Received: from mail-vw0-f42.google.com ([209.85.212.42]:41462 "EHLO
	mail-vw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933105Ab1IMXmt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 19:42:49 -0400
X-Greylist: delayed 310 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Sep 2011 19:42:49 EDT
MIME-Version: 1.0
In-Reply-To: <CAJ0pr1-ba0iY808igXJuEiWAX5zwhTUD6r+8MAMeBTHYFTenCg@mail.gmail.com>
References: <1313758358-27536-1-git-send-email-per.forlin@stericsson.com>
	<1313758358-27536-2-git-send-email-per.forlin@stericsson.com>
	<1313758358-27536-3-git-send-email-per.forlin@stericsson.com>
	<CAC5umyjWx7ZvT+F_XhOZt_utr=mS-0p5tDpJ1ioWNiDAJLNXwQ@mail.gmail.com>
	<CAJ0pr18dn3CtBsXk9MG3Zn9zSwAiNoxB3b-62aMO3+8H+kUX3A@mail.gmail.com>
	<CAJ0pr1-ba0iY808igXJuEiWAX5zwhTUD6r+8MAMeBTHYFTenCg@mail.gmail.com>
Date: Wed, 14 Sep 2011 08:37:37 +0900
Message-ID: <CAC5umygBmE-dayTrUhU_=dn7+YZ=nd8-s7SJw5xLxnKN1pBMAQ@mail.gmail.com>
Subject: Re: [PATCH v9 2/3] mmc: core: add random fault injection
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Per Forlin <per.forlin@linaro.org>
Cc: Per Forlin <per.forlin@stericsson.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        Linus Walleij <linus.walleij@linaro.org>, Chris Ball <cjb@laptop.org>,
        linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/14 Per Forlin <per.forlin@linaro.org>:
> Hi Akinobu,
>
> On 13 September 2011 16:19, Per Forlin <per.forlin@linaro.org> wrote:
>> On 13 September 2011 15:12, Akinobu Mita <akinobu.mita@gmail.com> wrote:
>>> 2011/8/19 Per Forlin <per.forlin@stericsson.com>:
>>>
>>>> +#ifdef KERNEL
>>>> +/*
>>>> + * Internal function. Pass the boot param fail_mmc_request to
>>>> + * the setup fault injection attributes routine.
>>>> + */
>>>> +static int __init setup_fail_mmc_request(char *str)
>>>> +{
>>>> +       return setup_fault_attr(&fail_mmc_request, str);
>>>> +}
>>>> +__setup("fail_mmc_request=", setup_fail_mmc_request);
>>>> +#endif /* KERNEL */
>>>
>>> You attempt to enable __setup() only when mmc_core is built into
>>> the kernel.  Does it really work? I cannot find any drivers using
>>> "KERNEL" macro.
>>>
>> Your right it doesn't work. I think I change from ifndef MODULE to
>> ifdef KERNEL at one point.
>> It should be "ifndef MODULE"

It's simple and I like this solution.

module_param is more complicated than this. Also the parameter is only
usefull when when mmc_core is built into the kernel (it's useless when
mmc_core is built as a module).

>>> You can use module_param_cb() instead of __setup() without #ifdef KERNEL.
>>> When mmc_core is built into the kernel, you can specify the parameter
>>> with "mmc_core.fail_mmc_request=..."
>>>
> I am considering using module_param() with perm = 0 (not visible in
> sysfs). The purpose of the param is to set fault attributes during
> kerne boot time or module load time. After the kernel boot all can be
> set under debug fs, therefore no need to make the module param
> visible.
>
> What do you think about this? I have not tested it yet.
> ----------------------------------------------------------

...

> ----------------------------------------------------------
> It's only necessary to call setup_fault_attr() once for all hosts.
> Here it's called one time for each host. I think it's ok since the
> routine is small and used for debugging purposes.
> I could use a static bool to indicate whether setup_fault_attr() has
> already been issued.
> + if (fail_mmc_request && !setup_fault_attr_done)

module_param_cb() doesn't work as you expected?  (Although I suggested
to use #ifdef MODULE instead of #ifdef KERNEL, I'm just asking out of
curiosity)

static int fail_mmc_request_param_set(const char *val,
                                const struct kernel_param *kp)
{
        setup_fault_attr(&fail_mmc_request, val);
        return 0;
}

static const struct kernel_param_ops fail_mmc_request_param_ops = {
        .set = fail_mmc_request_param_set
};

module_param_cb(fail_mmc_request, &fail_mmc_request_param_ops,
                &fail_mmc_request, 0);

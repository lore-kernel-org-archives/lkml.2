Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374Ab1GYVUh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 17:20:37 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:52812 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab1GYVUe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 17:20:34 -0400
MIME-Version: 1.0
In-Reply-To: <CAJ0pr1_rL8rsEbDR-PL6fs9EzyGfUMbmeUjTGk=WspvrAkdy+g@mail.gmail.com>
References: <1311199321-4618-1-git-send-email-per.forlin@linaro.org>
	<1311199321-4618-3-git-send-email-per.forlin@linaro.org>
	<CAC5umyg44tQxrFEYRL-tjzBMA2+KNXjB+nQveH3KcB_LPmYVHw@mail.gmail.com>
	<CAJ0pr1_rL8rsEbDR-PL6fs9EzyGfUMbmeUjTGk=WspvrAkdy+g@mail.gmail.com>
Date: Mon, 25 Jul 2011 23:20:33 +0200
Message-ID: <CAJ0pr19oTmt5PQw45wbRO8qEzVi3J1OgL=w9Ma7XxX-=1A=A=A@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] mmc: core: add random fault injection
From: Per Forlin <per.forlin@linaro.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linaro-dev@lists.linaro.org, Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-doc@vger.kernel.org,
        Venkatraman S <svenkatr@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Sourav Poddar <sourav.poddar@ti.com>,
        Chris Ball <cjb@laptop.org>,
        J Freyensee <james_p_freyensee@linux.intel.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Akinobu,

On 25 July 2011 21:19, Per Forlin <per.forlin@linaro.org> wrote:
> On 25 July 2011 17:58, Akinobu Mita <akinobu.mita@gmail.com> wrote:
>> 2011/7/21 Per Forlin <per.forlin@linaro.org>:
>>> This adds support to inject data errors after a completed host transfer.
>>> The mmc core will return error even though the host transfer is successful.
>>> This simple fault injection proved to be very useful to test the
>>> non-blocking error handling in the mmc_blk_issue_rw_rq().
>>> Random faults can also test how the host driver handles pre_req()
>>> and post_req() in case of errors.
>>
>> Looks good to me.
>>
> Thanks,
>
>>> @@ -82,6 +87,66 @@ static void mmc_flush_scheduled_work(void)
>>>        flush_workqueue(workqueue);
>>>  }
>>>
>>> +#ifdef CONFIG_FAIL_MMC_REQUEST
>>> +
>>> +static DECLARE_FAULT_ATTR(fail_mmc_request);
>>
>> I think the fail_attr should be defined for each mmc_host like make_it_fail
>> in struct mmc_host and debugfs entries should also be created in a
>> subdirectory of mmc host debugfs.
>>
> I looked at blk-core.c and used the same code here. Current code
> creates the entry under the debugfs root. This means one fail_attr for
> all hosts.
> I agree, it's more clean to move the fail_attr to the
> host-debugfs-entry which require the fail_attr to be stored same way
> as make_it_fail.
>
>> And I know that init_fault_attr_dentries() can only create a
>> subdirectory in debugfs root directory.  But I have a patch which
>> support for creating it in arbitrary directory.  Could you take a look
>> at this? (Note that this patch is based on mmotm and not yet tested)
>>
I looked at your patch and it raised two questions.
I can't use FAULT_ATTR_INITIALIZER since mmc_host is allocated on the
heap. It looks like setup_fault_attr(attr, str) will fail if str is
NULL. How can I initialise the fault_attrs if not stack allocated?
About the boot param initialisation of fault attr. There can only be
one fault_mmc_request boot param for the entire kernel but there is
one fault_attr per host, and there may be many hosts. It would be
convenient if setup_fault_attrs would take (attr, boot_param_name),
look up boot_param_name and use that otherwise set default values.

Regards,
Per

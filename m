Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483Ab2HQFpc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 01:45:32 -0400
Received: from mga05.intel.com ([192.55.52.89]:13625 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754270Ab2HQFpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 01:45:12 -0400
MIME-Version: 1.0
In-Reply-To: <CALLzPKa_4BaaZPjzDcy_QG9t1Gsauk6myU-WzaBab8A-w+9LJA@mail.gmail.com>
References: <cover.1345055638.git.dmitry.kasatkin@intel.com>
	<68a6f647ca1d4429d6b781b6cfeed9c93a346c14.1345055639.git.dmitry.kasatkin@intel.com>
	<20120815201635.GB10088@amd1>
	<CALLzPKa_4BaaZPjzDcy_QG9t1Gsauk6myU-WzaBab8A-w+9LJA@mail.gmail.com>
Date: Fri, 17 Aug 2012 08:45:10 +0300
Message-ID: <CALLzPKaN+18oTDy83F5mLPSOOiR2HGqF49rVXfXCD-tNknXdZQ@mail.gmail.com>
Subject: Re: [RFC v2 4/7] modsig: add integrity_module_check hook
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Serge Hallyn <serge.hallyn@canonical.com>
Cc: zohar@linux.vnet.ibm.com, jmorris@namei.org, rusty@rustcorp.com.au,
        dhowells@redhat.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 12:13 AM, Kasatkin, Dmitry
<dmitry.kasatkin@intel.com> wrote:
> On Wed, Aug 15, 2012 at 11:16 PM, Serge Hallyn
> <serge.hallyn@canonical.com> wrote:
>> Quoting Dmitry Kasatkin (dmitry.kasatkin@intel.com):
>>> IMA measures/appraises modules when modprobe or insmod opens and read them.
>>> Unfortunately, there are no guarantees between what is read by userspace and
>>> what is passed to the kernel via load_module system call. This patch adds a
>>> hook called integrity_module_check() to verify the integrity of the module
>>> being loaded.
>>>
>>> Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
>>> ---
>>>  include/linux/integrity.h |   10 ++++++++++
>>>  kernel/module.c           |    9 +++++++++
>>>  2 files changed, 19 insertions(+)
>>>
>>> diff --git a/include/linux/integrity.h b/include/linux/integrity.h
>>> index 66c5fe9..a80ec06 100644
>>> --- a/include/linux/integrity.h
>>> +++ b/include/linux/integrity.h
>>> @@ -37,4 +37,14 @@ static inline void integrity_inode_free(struct inode *inode)
>>>       return;
>>>  }
>>>  #endif /* CONFIG_INTEGRITY_H */
>>> +
>>> +#ifdef CONFIG_INTEGRITY_MODULES
>>> +int integrity_module_check(const void *hdr, const unsigned long len);
>>
>> sadly not bisect-safe, since integrity_module_check() is defined in
>> the next patch.
>>
>
> Ok.. Hooks come after implementation...
> Will swap.
>

Hi Serge.

Actually Kconfig option is defined in following implementation patch,
so CONFIG_INTEGRITY_MODULES is not defined and it will compile inline
empty function.

Why is it not bisect-safe?

- Dmitry

> Thanks.
>
>>> +#else
>>> +static inline int integrity_module_check(const void *buf, unsigned long len)
>>> +{
>>> +     return 0;
>>> +}
>>> +#endif
>>> +
>>>  #endif /* _LINUX_INTEGRITY_H */
>>> diff --git a/kernel/module.c b/kernel/module.c
>>> index 4edbd9c..791da47 100644
>>> --- a/kernel/module.c
>>> +++ b/kernel/module.c
>>> @@ -58,6 +58,7 @@
>>>  #include <linux/jump_label.h>
>>>  #include <linux/pfn.h>
>>>  #include <linux/bsearch.h>
>>> +#include <linux/integrity.h>
>>>
>>>  #define CREATE_TRACE_POINTS
>>>  #include <trace/events/module.h>
>>> @@ -2437,6 +2438,14 @@ static int copy_and_check(struct load_info *info,
>>>
>>>       info->hdr = hdr;
>>>       info->len = len;
>>> +
>>> +     err = integrity_module_check(hdr, len);
>>> +     if (err < 0)
>>> +             goto free_hdr;
>>> +
>>> +     /* cut signature tail */
>>> +     info->len = err;
>>> +
>>>       return 0;
>>>
>>>  free_hdr:
>>> --
>>> 1.7.9.5
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

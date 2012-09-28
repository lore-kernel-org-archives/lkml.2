Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab2I1Bko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 21:40:44 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63465 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085Ab2I1Bkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 21:40:43 -0400
MIME-Version: 1.0
In-Reply-To: <5064EE3F.3080606@jp.fujitsu.com>
References: <1348724705-23779-1-git-send-email-wency@cn.fujitsu.com>
 <1348724705-23779-2-git-send-email-wency@cn.fujitsu.com> <CAEkdkmVW5wwG4_cy0yHFNVmk2bzAqzo2adRsMn1yHOW9Ex98_g@mail.gmail.com>
 <5064EE3F.3080606@jp.fujitsu.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Thu, 27 Sep 2012 21:35:01 -0400
X-Google-Sender-Auth: 8KfN5nv7GPWRiuvCks3uyYppT8M
Message-ID: <CAHGf_=pDn852sRadnXQMWx3rOTxGLy7876pxk1Ww4oJtkBAZbQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] memory-hotplug: add memory_block_release
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Ni zhan Chen <nizhan.chen@gmail.com>, wency@cn.fujitsu.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, rientjes@google.com,
        liuj97@gmail.com, len.brown@intel.com, benh@kernel.crashing.org,
        paulus@samba.org, minchan.kim@gmail.com, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 8:24 PM, Yasuaki Ishimatsu
<isimatu.yasuaki@jp.fujitsu.com> wrote:
> Hi Chen,
>
>
> 2012/09/27 19:20, Ni zhan Chen wrote:
>>
>> Hi Congyang,
>>
>> 2012/9/27 <wency@cn.fujitsu.com>
>>
>>> From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>>>
>>> When calling remove_memory_block(), the function shows following message
>>> at
>>> device_release().
>>>
>>> Device 'memory528' does not have a release() function, it is broken and
>>> must
>>> be fixed.
>>>
>>
>> What's the difference between the patch and original implemetation?
>
>
> The implementation is for removing a memory_block. So the purpose is
> same as original one. But original code is bad manner. kobject_cleanup()
> is called by remove_memory_block() at last. But release function for
> releasing memory_block is not registered. As a result, the kernel message
> is shown. IMHO, memory_block should be release by the releae function.

but your patch introduced use after free bug, if i understand correctly.
See unregister_memory() function. After your patch, kobject_put() call
release_memory_block() and kfree(). and then device_unregister() will
touch freed memory.

static void
unregister_memory(struct memory_block *memory)
{
	BUG_ON(memory->dev.bus != &memory_subsys);

	/* drop the ref. we got in remove_memory_block() */
	kobject_put(&memory->dev.kobj);
	device_unregister(&memory->dev);
}

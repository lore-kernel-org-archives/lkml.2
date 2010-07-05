Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758442Ab0GENfh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 09:35:37 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63653 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758391Ab0GENfe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 09:35:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=f47tlcUseIdaPUi7IIs7TVltJetkplC+fya4QXW8cTLXE4L2Hjci4zXcV4slvbi9Hp
         cSF0zUYMToen4emz8/t00t2LrEx3I2bTTQS4ilpEeSHYnsEJlOntCKCGnNt1EPCe+aJE
         V2EzDM0l3nwLVGJRGLMOxM+ZbxokT7TgX2O/s=
MIME-Version: 1.0
In-Reply-To: <20100705131835.GN10072@secunet.com>
References: <AANLkTimVTMsVkSBHWLve8t76-YkoSYposgv9wHir_wPa@mail.gmail.com>
	<20100702125628.GK10072@secunet.com>
	<AANLkTimH9IKkqqLADjUbycKD8bh4oX8oCxSDTCGxv4r1@mail.gmail.com>
	<20100705131835.GN10072@secunet.com>
Date: Mon, 5 Jul 2010 17:35:32 +0400
X-Google-Sender-Auth: QroZL21dUBFz9rTkJk1yIj44uxs
Message-ID: <AANLkTimvyUiQqAO_uBxTMTLRWdujDWKSo7WBuI7cPLKc@mail.gmail.com>
Subject: Re: [PATCH] Fixed division by zero bug in kernel/padata.c
From: Dan Kruchinin <dkruchinin@acm.org>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.hengli.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 5, 2010 at 5:18 PM, Steffen Klassert
<steffen.klassert@secunet.com> wrote:
> On Fri, Jul 02, 2010 at 05:24:13PM +0400, Dan Kruchinin wrote:
>> No problem. Here is fixed patch:
>> --
>>  When boot CPU(typically CPU #0) is excluded from padata cpumask and
>>  user enters halt command from console, kernel faults on division by zero;
>>  This occurs because during the halt kernel shuts down each non-boot CPU one
>>  by one. After it shuts down the last CPU that is set in the padata cpumask,
>>  the only working CPU in the system is a boot CPU(#0) and it's the only CPU that
>>  is set in the cpu_active_mask. Hence when padata_cpu_callback calls
>>  __padata_remove_cpu(and hence padata_alloc_pd) it appears that padata
>> cpumask and
>>  cpu_active mask aren't intersect. Hence the following code in
>> padata_alloc_pd causes
>>  a DZ error exception:
>>   cpumask_and(pd->cpumask, cpumask, cpu_active_mask); // pd->cpumask
>> will be empty
>>   ...
>>   num_cpus = cpumask_weight(pd->cpumask); // num_cpus = 0
>>   pd->max_seq_nr = (MAX_SEQ_NR / num_cpus) * num_cpus - 1; // DZ!
>>
>
> I'm still thinking about how to handle an empty cpumask here.
> While your patch would be ok to handle the shutdown case you
> noticed, the problem is a bit more complex as soon as we are
> able to change the cpumasks from userspace with your patches.
>
> Essentially, we can end up with an empty cpumask here because
> of two reasons:
>
> 1. A user removed the last cpu that belongs to the padata
> cpumask and the active cpumask.
>
> 2. The last cpu that belongs to the padata cpumask and the
> active cpumask goes offline.
>
> In the first case it would be ok to tell the user that this is
> an invalid operation by returning an error. In the second case
> we can't just return an error to the cpu hotplug callback function,
> because it returns NOTIFY_BAD on error. This means, that it depends
> on the padata user configuration whether a cpu can go offline or not.
> This is certainly not what we want to have.
>
> Both cases should be handled in the same way. So we could just
> stop the instance if the cpumasks do not intersect, and enable
> it as soon as they do intersect again. The padata instance would
> refuse to do anything as long as the cpumasks do not intersect,
> but it is still in a consistent state. Let me add the infrastructure
> to handle this, then you can use it with your patches.

Ok, get it.

>
> Thanks,
>
> Steffen
>



-- 
W.B.R.
Dan Kruchinin

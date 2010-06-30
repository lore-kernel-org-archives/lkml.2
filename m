Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311Ab0F3V0n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 17:26:43 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49647 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757274Ab0F3V0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 17:26:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Jc7wGBXiQbxr6EWEShqFmHxpJNy8HY6NZdjHDULQals1X5ggLGzzPEfNO9l1USed0v
         5gOrjbcA6XJW1Ar2NLTjI89Evbsgf1xspbjuSyjcILweNba9z8i0/oJbhLLA3n9xNBwv
         +649YDs6E/WF9nXbzwrAei6Evfc8x7SUFb1+c=
MIME-Version: 1.0
In-Reply-To: <201006301227.08709.dtor@vmware.com>
References: <AANLkTimmIG6GF-hKBk7JsZpvZNEAj1Tlt4GrPXexN0_0@mail.gmail.com>
	<201006301227.08709.dtor@vmware.com>
Date: Wed, 30 Jun 2010 17:26:40 -0400
Message-ID: <AANLkTil6KfEHhQFwhPHRtb-dZHpDyttY09Kor_FQVFPK@mail.gmail.com>
Subject: Re: [PATCH] VMware balloon: force compiling as a module
From: Chetan Loke <chetanloke@gmail.com>
To: Dmitry Torokhov <dtor@vmware.com>
Cc: "pv-drivers@vmware.com" <pv-drivers@vmware.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dmitry,

On Wed, Jun 30, 2010 at 3:27 PM, Dmitry Torokhov <dtor@vmware.com> wrote:
> Hi Chetan,
>
> On Wednesday, June 30, 2010 11:42:53 am Chetan Loke wrote:
>> Q1)Does vmtools handle pvscsi correctly?
>>
>
> Yes, as long as it compiled as a module or installer will not overwrite
> distribution-supplied version unless user explicitly requests installer
> to clobber it.
>
perfect.

> So far distributions have not tried building their kernels with pvscsi
> or vmxnet3 built-in, but did so with our ballon driver, which prompted
> this particular change.
>
We are building iso's which will then be used to build/create an ESX
appliance. So we would need the pvscsi driver from the start. vNICs
will be populated post-install. At which point vmxnet[2/3] will
kick-in via vmtools.

>> Q2)In case if a VM wants to be a good citizen, is there a way for a
>> guest to know about the balloon-event?
>
> I am not sure I follow. Ballooning supposed to be as transparent as
> possible...
>
This is too product specific. I will send you an email separately.


>> Q3)What if an app mlock's its memory resources and driver's have
>> pinned down their pages then how does inflation work?
>
> We will inflate as much as we can. Obviously if there are no more
> memory balloon may not grow to its full target size.
>
> Balloon driver communicates to the hypervisor the total amount of
> memory in the guest, we may want to adjust that number by subtracting
> memory allocated by the kernel, mlocked memory and so on, but it is
> not done currently.
Ok.

I'm stuck with one question -

A) Ballooning will trigger guest's native memory management policy.
   A.1) So this could mean guest might swap it's pages on it's vdisk, correct?

Consider this setup -
B) VM1..VMn have backing store(data and OS partitions) on LUNs(SAN).
Further, data LUNs are mounted as RDMs. I chose RDMs just to keep it
simple.
C) Say there's memory pressure. How? Well, few VM's are blasting I/O
to the LUNs. Plus, a backup triggered. Plus, whatever else happened.
   C.1) VM's now seem to need more and more memory.
   C.2) hypervisors block-layer/other-layers also need more memory.
   C.3) Hypervisor's memory-management algorithm kicks-in.
        ......
        C.3.x) Ballooning triggers - now some VM's (excluding the ones
from C.1) are giving up memory and if A.1) above is true then the
guest's pages will be swapped out on the LUNs via
                  hypervisor's SCSI-LLDD. But look at C.2) above. Is
this a soft-deadlock?

Oh, it's a linux-guest and if C.1) timesout then the guest will send
aborts and eventually a LUN reset ;).

In this particular case, if my suspicion is valid and if all the
signatures match(swap is out on the SAN, block-congestion etc) then
the balloon driver could just bail out.

> Thanks.
> --
> Dmitry

Thanks
Chetan Loke

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab2IINqJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 09:46:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470Ab2IINqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 09:46:08 -0400
Message-ID: <504C9D99.8020507@redhat.com>
Date: Sun, 09 Sep 2012 16:46:01 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v6 12/12] KVM: indicate readonly access fault
References: <5032F8FD.2020306@linux.vnet.ibm.com> <5032FA78.9040405@linux.vnet.ibm.com> <5034CB60.30107@redhat.com> <5034D4E3.2080801@linux.vnet.ibm.com> <5048AE96.3050909@redhat.com> <5049C4D7.50101@linux.vnet.ibm.com>
In-Reply-To: <5049C4D7.50101@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2012 12:56 PM, Xiao Guangrong wrote:
> On 09/06/2012 10:09 PM, Avi Kivity wrote:
>> On 08/22/2012 03:47 PM, Xiao Guangrong wrote:
>>> On 08/22/2012 08:06 PM, Avi Kivity wrote:
>>>> On 08/21/2012 06:03 AM, Xiao Guangrong wrote:
>>>>> Introduce write_readonly_mem in mmio-exit-info to indicate this exit is
>>>>> caused by write access on readonly memslot
>>>>
>>>> Please document this in chapter 5 of apic.txt.
>>>>
>>>
>>> Okay, please review this one.
>>>
>>> Subject: [PATCH v6 12/12] KVM: indicate readonly access fault
>>>
>>> Introduce write_readonly_mem in mmio-exit-info to indicate this exit is
>>> caused by write access on readonly memslot
>>>
>> 
>> I'm not sure whether this indication can be trusted by userspace.  By
>> the time userspace gets to process this, the slot may no longer exist,
>> or it may be writable.
> 
> The case of deleting memslot is ok, because userspace just skips this fault
> if no readonly mem or no fault handler can be found.
> 
> Switching memslot from readonly to writable sounds strange, i agree with you
> that this flag is untrusty under this case.

It's not so strange, see the PAM registers in the 440fx chipset.

The strategy for shadowing the BIOS is to set PAM for (read: pci, write:
RAM) (=a readonly slot in kvm), memcpy the BIOS onto itself, then switch
the PAM to (read: RAM, write: RAM) (=rw slot in kvm) or (read: RAM,
write: PCI) (=different readonly slot in kvm).

Of course that usually happens with just one cpu running so there would
be no confusion.  But in general the indication is racy.

-- 
error compiling committee.c: too many arguments to function

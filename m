Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab2JVLJs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 07:09:48 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:38621 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732Ab2JVLJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 07:09:46 -0400
Message-ID: <50852972.305@linux.vnet.ibm.com>
Date: Mon, 22 Oct 2012 19:09:38 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: fix vcpu->mmio_fragments overflow
References: <5081033C.4060503@linux.vnet.ibm.com> <20121022091615.GG29310@redhat.com>
In-Reply-To: <20121022091615.GG29310@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12102211-5140-0000-0000-0000023C4C94
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2012 05:16 PM, Gleb Natapov wrote:
> On Fri, Oct 19, 2012 at 03:37:32PM +0800, Xiao Guangrong wrote:
>> After commit b3356bf0dbb349 (KVM: emulator: optimize "rep ins" handling),
>> the pieces of io data can be collected and write them to the guest memory
>> or MMIO together.
>>
>> Unfortunately, kvm splits the mmio access into 8 bytes and store them to
>> vcpu->mmio_fragments. If the guest uses "rep ins" to move large data, it
>> will cause vcpu->mmio_fragments overflow
>>
>> The bug can be exposed by isapc (-M isapc):
>>
>> [23154.818733] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
>> [ ......]
>> [23154.858083] Call Trace:
>> [23154.859874]  [<ffffffffa04f0e17>] kvm_get_cr8+0x1d/0x28 [kvm]
>> [23154.861677]  [<ffffffffa04fa6d4>] kvm_arch_vcpu_ioctl_run+0xcda/0xe45 [kvm]
>> [23154.863604]  [<ffffffffa04f5a1a>] ? kvm_arch_vcpu_load+0x17b/0x180 [kvm]
>>
>>
>> Actually, we can use one mmio_fragment to store a large mmio access for the
>> mmio access is always continuous then split it when we pass the mmio-exit-info
>> to userspace. After that, we only need two entries to store mmio info for
>> the cross-mmio pages access
>>
> I wonder can we put the data into coalesced mmio buffer instead of

If we put all mmio data into coalesced buffer, we should:
- ensure the userspace program uses KVM_REGISTER_COALESCED_MMIO to register
  all mmio regions.

- even if the MMIO region is not used by emulated-device, it also need to be
  registered.

It will breaks old version userspace program.

> exiting for each 8 bytes? Is it worth the complexity?

Simpler way is always better but i failed, so i appreciate your guys comments.



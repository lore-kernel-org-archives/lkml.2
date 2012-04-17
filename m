Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105Ab2DQNEv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 09:04:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15532 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755905Ab2DQNEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 09:04:50 -0400
Message-ID: <4F8D6A61.9030209@redhat.com>
Date: Tue, 17 Apr 2012 16:04:33 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Wen Congyang <wency@cn.fujitsu.com>
CC: zhangyanfei <zhangyanfei@cn.fujitsu.com>, mtosatti@redhat.com,
        ebiederm@xmission.com, luto@mit.edu, joerg.roedel@amd.com,
        dzickus@redhat.com, paul.gortmaker@windriver.com, gregkh@suse.de,
        ludwig.nussel@suse.de, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH 0/4] Export offsets of VMCS fields as note information
 for kdump
References: <4F84E0DF.8040206@cn.fujitsu.com> <4F8D1F46.3090901@redhat.com> <4F8D4B4C.8070705@cn.fujitsu.com> <4F8D4D1C.4010400@redhat.com> <4F8D530C.3050908@cn.fujitsu.com>
In-Reply-To: <4F8D530C.3050908@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2012 02:25 PM, Wen Congyang wrote:
> > 
> >>
> >> For scenario 2, we also want the guest's registers values to be dumped into
> >> qemu process's core file when qemu process crashes. This is the task of TODO-list 2.
> > 
> > Why?  If qemu crashed it is because of an internal qemu fault.  If any
> > guest registers were involved, they would have been decoded by qemu
> > previously and would be present in the stack trace (for example mmio
> > address/data).
>
> Hmm, IIRC, if qemu meets some critical error, it will call abort() or assert().
> The guest registers are stored in the kernel, and qemu does not call
> cpu_synchronize_state() to get guest register. So I donot understand
> why the registers woubld be present int the stack trace...

There are two cases.  One case is where the problem was not caused
directly by guest action, for example a segmentation fault in the block
layer or the VNC server.  In this case the guest registers are immaterial.

The other case is where the problem was directly caused by guest action,
for example an mmio write to a device register triggered an error. In
this case kvm emulates the mmio instruction and returns KVM_EXIT_MMIO;
it can be seen in the kvm_run page.  The address/data pair is propagated
by the qemu memory core all the way to the device callback.  So the
instruction and register contents are unneeded for debugging the crash.

Is there a scenario where the guest registers help towards debugging a
qemu crash?

-- 
error compiling committee.c: too many arguments to function


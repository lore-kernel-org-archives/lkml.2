Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484Ab2DKLPk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 07:15:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28785 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932308Ab2DKLPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 07:15:37 -0400
Message-ID: <4F8567CB.9000005@redhat.com>
Date: Wed, 11 Apr 2012 14:15:23 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: zhangyanfei <zhangyanfei@cn.fujitsu.com>
CC: mtosatti@redhat.com, ebiederm@xmission.com, luto@mit.edu,
        joerg.roedel@amd.com, dzickus@redhat.com, paul.gortmaker@windriver.com,
        gregkh@suse.de, ludwig.nussel@suse.de, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH 0/4] Export offsets of VMCS fields as note information
 for kdump
References: <4F84E0DF.8040206@cn.fujitsu.com> <4F85472A.4080009@redhat.com> <4F855903.3070703@cn.fujitsu.com>
In-Reply-To: <4F855903.3070703@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2012 01:12 PM, zhangyanfei wrote:
> > 
> >> TODO:
> >>   1. In kexec-tools, get VMCSINFO via sysfs and dump it as note information
> >>      into vmcore.
> >>   2. Dump VMCS region of each guest vcpu and VMCSINFO into qemu-process
> >>      core file. To do this, we will modify kernel core dumper, gdb gcore
> >>      and crash gcore.
> > 
> > 
> > Seems excessive.  Why do you want vmcs information in qemu cores?  A
> > qemu crash is very rarely related to kvm, let alone the vmcs.  I
> > understand that you may want it in a kernel core dump, though I've never
> > needed to myself.  Can you outline a case where this data was needed?
> > 
>
> If a qemu process comes to a fatal error that causes itself to be core dumped
> by kernel, the running guest based on the qemu process will be included in that
> qemu core file. But with no vmcsinfo information in qemu core file, we could not
> get the guest's states(registers' values), then we could not make a complete
> guest vmcore.

We can't anyway.  Many registers (GPRs except RSP, fpu) are not stored
in the VMCS, but in kvm data structures.

So for this case we'd want a kvm callback to execute (that would make it
work cross vendor, too).

>
> >>   3. Dump guest image from the qemu-process core file into a vmcore.
> > 
> > For this perhaps a different approach is better - modify the core dumper
> > to call kvm to extract the relevant vmcs information into an elf note. 
> > This way there is no need to reconstruct the guest data from the
> > offsets.  It's also more reliable, since vmread can access cached fields
> > that direct memory access cannot.
> > 
>
> Does this approach is a replacement for TODO 2 ? That is to say, when generating
> a qemu core by kernel core dumper, we could call kvm to extract the relevant vmcs
> information into an elf note instead of VMCSINFO and the whole vmcs regions.

Yes.  I'm not convinced it's important though.

-- 
error compiling committee.c: too many arguments to function


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab2IXL41 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 07:56:27 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:55598 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289Ab2IXL4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 07:56:25 -0400
Message-ID: <50604988.2030506@linux.vnet.ibm.com>
Date: Mon, 24 Sep 2012 17:22:40 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
        Rik van Riel <riel@redhat.com>, Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH RFC 0/2] kvm: Improving undercommit,overcommit scenarios
 in PLE handler
References: <20120921115942.27611.67488.sendpatchset@codeblue> <1348486479.11847.46.camel@twins>
In-Reply-To: <1348486479.11847.46.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12092411-3568-0000-0000-0000028167A7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2012 05:04 PM, Peter Zijlstra wrote:
> On Fri, 2012-09-21 at 17:29 +0530, Raghavendra K T wrote:
>> In some special scenarios like #vcpu<= #pcpu, PLE handler may
>> prove very costly, because there is no need to iterate over vcpus
>> and do unsuccessful yield_to burning CPU.
>
> What's the costly thing? The vm-exit, the yield (which should be a nop
> if its the only task there) or something else entirely?
>
Both vmexit and yield_to() actually,

because unsuccessful yield_to() overall is costly in PLE handler.

This is because when we have large guests, say 32/16 vcpus, and one
vcpu is holding lock, rest of the vcpus waiting for the lock, when they
do PL-exit, each of the vcpu try to iterate over rest of vcpu list in
the VM and try to do directed yield (unsuccessful). (O(n^2) tries).

this results is fairly high amount of cpu burning and double run queue
lock contention.

(if they were spinning probably lock progress would have been faster).
As Avi/Chegu Vinod had felt it is better to avoid vmexit itself, which
seems little complex to achieve currently.






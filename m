Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932614Ab2BBS1b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 13:27:31 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49346 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295Ab2BBS13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 13:27:29 -0500
Message-ID: <4F2AD58A.3090307@gmail.com>
Date: Fri, 03 Feb 2012 02:27:22 +0800
From: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Stefan Hajnoczi <stefanha@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] KVM: x86: add tracepoints to trace mmio begin
 and complete
References: <4F2AC707.7020801@gmail.com> <4F2AC790.1090805@gmail.com> <4F2AC9A0.7090904@redhat.com> <4F2ACE04.9040602@gmail.com> <4F2ACE46.4000307@redhat.com>
In-Reply-To: <4F2ACE46.4000307@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2012 01:56 AM, Avi Kivity wrote:

> On 02/02/2012 07:55 PM, Xiao Guangrong wrote:
>> On 02/03/2012 01:36 AM, Avi Kivity wrote:
>>
>>> On 02/02/2012 07:27 PM, Xiao Guangrong wrote:
>>>> From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>>>>
>>>> 'perf kvm-events' will use kvm_exit and kvm_mmio(read...) to calculate
>>>> mmio read emulated time for the old kernel, in order to trace mmio read
>>>> event more exactly, we add kvm_mmio_begin to trace the time when mmio read
>>>> begins
>>>>
>>>> Also, add kvm_mmio_done to trace the time when mmio/pio is completed
>>>
>>> Previously, we discussed using the kvm_entry to do this.  This reduces
>>> the number of tracepoints, and is backwards compatible.  What was the
>>> conclusion?
>>>
>>
>>
>> Since using kvm_entry can cause lots of unnecessary calculated, these new two
>> tracepoints can let the result be exacter.
> 
> Do you have numbers on the ratio between kvm_entry traces and
> kvm_mmio_begin/end traces?
> 


1: Using kvm_mmio_begin/end:

# ./perf kvm-events report --event mmio
  Warning: Error: expected type 5 but read 4
  Warning: Error: expected type 5 but read 0
  Warning: unknown op '}'


Analyze events for all VCPUs:

         MMIO Access    Samples  Samples%     Time%         Avg time

        0xfee00380:W      54926    58.45%    57.32%      3.90us ( +-   0.29% )
        0xfee00300:W      12906    13.73%    28.70%      8.32us ( +-   0.50% )
        0xfee00300:R      12906    13.73%     7.68%      2.23us ( +-   1.27% )
        0xfee00310:W      12906    13.73%     6.07%      1.76us ( +-   1.05% )
        0xfee00190:R        323     0.34%     0.23%      2.65us ( +-   2.85% )

Total Samples:93967, Total events handled time:374012.26us.

2: kvm_mmio_begin/end is not used:

# ./perf kvm-events report --event mmio
  Warning: Error: expected type 5 but read 4
  Warning: Error: expected type 5 but read 0
  Warning: unknown op '}'


Analyze events for all VCPUs:

         MMIO Access    Samples  Samples%     Time%         Avg time

        0xfee00380:W      54926    58.45%    42.90%      3.90us ( +-   0.29% )
        0xfee00300:W      12906    13.73%    21.48%      8.32us ( +-   0.50% )
        0xfee00300:R      12906    13.73%    30.26%     11.72us ( +-   1.40% )
        0xfee00310:W      12906    13.73%     4.54%      1.76us ( +-   1.05% )
        0xfee00190:R        323     0.34%     0.82%     12.63us ( +-   2.85% )

Total Samples:93967, Total events handled time:499755.82us.

In this sample, the time of MMIO Read has big different,
in the case 1(new tracepoints), the time is calculated by kvm_mmio_begin -> kvm_mmio(read...)
in the case 2(existing tracepoints), the time is calculated by kvm_exit -> kvm_mmio(read...)

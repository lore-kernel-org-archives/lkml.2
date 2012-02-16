Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751279Ab2BPFFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 00:05:16 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47383 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667Ab2BPFFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 00:05:14 -0500
Message-ID: <4F3C8E84.80905@gmail.com>
Date: Wed, 15 Feb 2012 22:05:08 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.1) Gecko/20120208 Thunderbird/10.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/3] KVM: perf: kvm events analysis tool
References: <j8pru203h6n22hdd9bryyyfr.1329110982240@email.android.com> <4F38E091.5070504@linux.vnet.ibm.com> <4F3931D6.2090305@gmail.com> <4F3C8D3F.9010105@linux.vnet.ibm.com>
In-Reply-To: <4F3C8D3F.9010105@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/15/12 9:59 PM, Xiao Guangrong wrote:
>
>
> Okay, i will post the next version after collecting your new comments!
>
> Thanks for your time, David! :)
>

I had more comments, but got sidetracked and forgot to come back to 
this. I still haven't looked at the code yet, but some comments from 
testing:

1. The error message:
   Warning: Error: expected type 5 but read 4
   Warning: Error: expected type 5 but read 0
   Warning: unknown op '}'

is fixed by this patch which has not yet made its way into perf:
https://lkml.org/lkml/2011/9/4/41

The most recent request:
https://lkml.org/lkml/2012/2/8/479

Arnaldo: the patch still applies cleanly (but with an offset of -2 lines).


2. negatve testing:

perf kvm-events record -e kvm:* -p 2603 -- sleep 10

   Warning: Error: expected type 4 but read 7
   Warning: Error: expected type 5 but read 0
   Warning: failed to read event print fmt for kvm_apic
   Warning: Error: expected type 4 but read 7
   Warning: Error: expected type 5 but read 0
   Warning: failed to read event print fmt for kvm_inj_exception
   Fatal: bad op token {

If other kvm events are specified in the record line they appear to be 
silently ignored in the report in which case why allow the -e option to 
record?


3. What is happening for multiple VMs?

a. perf kvm-events report
data is collected for all VMs. What is displayed in the report? An
average for all VMs?

b. perf kvm-events report --vcpu 1
Does this given an average of all vcpu 1's?

Perhaps a -p option for the report to pull out events related to a 
single VM. Really this could be a generic option (to perf-report and 
perf-script as well) to only show/analyze events for the specified pid. 
ie., data is recorded for all VMs (or system wide for the regular 
perf-record) and you want to only consider events for a specific pid. 
e.g., in process_sample_event() skip event if event->ip.pid != 
report_pid (works for perf code because PERF_SAMPLE_TID attribute is 
always set).

David

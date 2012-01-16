Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014Ab2APKMB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 05:12:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927Ab2APKL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 05:11:59 -0500
Message-ID: <4F13F7EB.3060108@redhat.com>
Date: Mon, 16 Jan 2012 12:11:55 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [RFC][PATCH] KVM: perf: a smart tool to analyse kvm events
References: <4F13EE3D.2070602@linux.vnet.ibm.com>
In-Reply-To: <4F13EE3D.2070602@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2012 11:30 AM, Xiao Guangrong wrote:
> This tool is very like xenoprof(if i remember correctly), and traces kvm events
> smartly. currently, it supports vmexit/mmio/ioport events.
>
> Usage:
> - to trace kvm events:
> # ./perf kvm-events record
>
> - show the result
> # ./perf kvm-events report
>
> Some output are as follow:
> # ./perf kvm-events report
>   Warning: Error: expected type 5 but read 4
>   Warning: Error: expected type 5 but read 0
>   Warning: unknown op '}'
>
>
> Analyze events for all VCPUs:
>
>              VM-EXIT    Samples      Samples%         Time%        Avg time
>
>          APIC_ACCESS     438107        44.89%         6.20%        17.91us
>   EXTERNAL_INTERRUPT     219226        22.46%         8.01%        46.20us
>       IO_INSTRUCTION     122651        12.57%         1.88%        19.44us
>        EPT_VIOLATION      83110         8.52%         1.36%        20.75us
>    PENDING_INTERRUPT      37055         3.80%         0.16%         5.38us
>                CPUID      32718         3.35%         0.08%         3.15us
>        EXCEPTION_NMI      23601         2.42%         0.17%         8.87us
>                  HLT      15424         1.58%        82.12%      6735.06us
>            CR_ACCESS       4089         0.42%         0.02%         6.08us
>
> Total Samples:975981, Total events handled time:126502464.88us.

Nice!  If we can have a live version as well, this can replace kvm_stat.

The average numbers are really high.  Like a factor of 3x-4x off.  Would
be good to print the standard deviation and see why.  Maybe it's due to
the tracing overhead.

> The default event to be analysed is vmexit, we can use --event to specify it,
> for example, if we want to trace mmio event:
> # ./perf kvm-events report --event mmio
>   Warning: Error: expected type 5 but read 4
>   Warning: Error: expected type 5 but read 0
>   Warning: unknown op '}'
>
>
> Analyze events for all VCPUs:
>
>          MMIO Access    Samples      Samples%         Time%        Avg time
>
>         0xfee00380:W     196589        64.95%        70.01%         3.83us
>         0xfee00310:W      35356        11.68%         6.48%         1.97us
>         0xfee00300:W      35356        11.68%        16.37%         4.97us
>         0xfee00300:R      35356        11.68%         7.14%         2.17us

These are more reasonable (though still high - 5us for an ICR write?)

>
> Total Samples:302657, Total events handled time:1074746.01us.
>
> We can use --vcpu to specify which vcpu is traced:
> root@localhost perf]# ./perf kvm-events report --event mmio --vcpu 1
>   Warning: Error: expected type 5 but read 4
>   Warning: Error: expected type 5 but read 0
>   Warning: unknown op '}'
>
>
> Analyze events for VCPU 1:
>
>          MMIO Access    Samples      Samples%         Time%        Avg time
>
>         0xfee00380:W      58041        71.20%        74.90%         3.70us
>         0xfee00310:W       7826         9.60%         5.28%         1.93us
>         0xfee00300:W       7826         9.60%        13.82%         5.06us
>         0xfee00300:R       7826         9.60%         6.01%         2.20us
>
> Total Samples:81519, Total events handled time:286577.81us.
>
> And, '--key' is used to sort the result, the possible value sample (default,
> the result is sorted by samples number), time(the result is sorted by time%):
> # ./perf kvm-events report --key time
>   Warning: Error: expected type 5 but read 4
>   Warning: Error: expected type 5 but read 0
>   Warning: unknown op '}'
>
>
> Analyze events for all VCPUs:
>
>              VM-EXIT    Samples      Samples%         Time%        Avg time
>
>                  HLT      15424         1.58%        82.12%      6735.06us
>   EXTERNAL_INTERRUPT     219226        22.46%         8.01%        46.20us
>          APIC_ACCESS     438107        44.89%         6.20%        17.91us
>       IO_INSTRUCTION     122651        12.57%         1.88%        19.44us
>        EPT_VIOLATION      83110         8.52%         1.36%        20.75us
>        EXCEPTION_NMI      23601         2.42%         0.17%         8.87us
>    PENDING_INTERRUPT      37055         3.80%         0.16%         5.38us
>                CPUID      32718         3.35%         0.08%         3.15us
>            CR_ACCESS       4089         0.42%         0.02%         6.08us
>
> Total Samples:975981, Total events handled time:126502464.88us.
>
> I hope guys will like it and any comments are welcome! :)

I think it's great!  A live version would be a nice addition too.

Please copy the perf userspace maintainers to get more detailed review
in the next version.

-- 
error compiling committee.c: too many arguments to function


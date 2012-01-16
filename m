Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152Ab2APWxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 17:53:30 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59936 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab2APWx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 17:53:29 -0500
Message-ID: <4F14AA60.1040904@gmail.com>
Date: Mon, 16 Jan 2012 15:53:20 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [RFC][PATCH] KVM: perf: a smart tool to analyse kvm events
References: <4F13EE3D.2070602@linux.vnet.ibm.com>
In-Reply-To: <4F13EE3D.2070602@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/16/2012 02:30 AM, Xiao Guangrong wrote:
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

Integrating the trace-cmd plugins into perf will remedy the above errors:
https://lkml.org/lkml/2011/8/16/352

Unfortunately, that effort is stalled at the moment.

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

Have you thought about dumping a time history -- something similar to
what perf-script can do with dumping events but adding in kvm-specific
analysis like what you are doing in these examples?

David


> 
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
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

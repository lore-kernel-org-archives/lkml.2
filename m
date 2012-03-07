Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab2CGKEM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 05:04:12 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62815 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751920Ab2CGKEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 05:04:10 -0500
X-IronPort-AV: E=Sophos;i="4.73,545,1325433600"; 
   d="scan'208";a="4480952"
Message-ID: <4F5732FB.5040208@cn.fujitsu.com>
Date: Wed, 07 Mar 2012 18:05:47 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH v2] deal with guest paniced event
References: <4F56BEF2.4020405@cn.fujitsu.com> <4F56C0E1.1090703@cn.fujitsu.com> <4F57302B.1040505@siemens.com>
In-Reply-To: <4F57302B.1040505@siemens.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-07 18:02:08,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-07 18:02:14,
	Serialize complete at 2012-03-07 18:02:14
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 03/07/2012 05:53 PM, Jan Kiszka Wrote:
> On 2012-03-07 02:58, Wen Congyang wrote:
>> When the host knows the guest is paniced, it will set
>> exit_reason to KVM_EXIT_GUEST_PANICED. So if qemu receive
>> this exit_reason, we can send a event to tell management
>> application that the guest is paniced and set the guest
>> status to RUN_STATE_PANICED.
>>
>> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
>> ---
>>  kvm-all.c                 |    4 ++++
>>  linux-headers/linux/kvm.h |    1 +
>>  monitor.c                 |    3 +++
>>  monitor.h                 |    1 +
>>  qapi-schema.json          |    2 +-
>>  qmp.c                     |    3 ++-
>>  vl.c                      |    1 +
>>  7 files changed, 13 insertions(+), 2 deletions(-)
>>
>> diff --git a/kvm-all.c b/kvm-all.c
>> index c4babda..d356948 100644
>> --- a/kvm-all.c
>> +++ b/kvm-all.c
>> @@ -1190,6 +1190,10 @@ int kvm_cpu_exec(CPUState *env)
>>                      (uint64_t)run->hw.hardware_exit_reason);
>>              ret = -1;
>>              break;
>> +        case KVM_EXIT_GUEST_PANICED:
>> +            monitor_protocol_event(QEVENT_GUEST_PANICED, NULL);
>> +            vm_stop(RUN_STATE_PANICED);
>> +            break;
> 
> This cannot work. You missed to set ret to -1 to break out of loop.

I fotgot to do it. But it works fine while I test this patch. I
think ret has set to 0 before I guest is panicked.

> 
>>          case KVM_EXIT_INTERNAL_ERROR:
>>              ret = kvm_handle_internal_error(env, run);
>>              break;
>> diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
>> index f6b5343..ddc9716 100644
>> --- a/linux-headers/linux/kvm.h
>> +++ b/linux-headers/linux/kvm.h
>> @@ -163,6 +163,7 @@ struct kvm_pit_config {
>>  #define KVM_EXIT_OSI              18
>>  #define KVM_EXIT_PAPR_HCALL	  19
>>  #define KVM_EXIT_S390_UCONTROL	  20
>> +#define KVM_EXIT_GUEST_PANICED	  21
> 
> Linux header must be sync'ed in a separate patch, referencing the
> upstream (typically kvm.git) commit hash that was used as base. Make
> sure to use the update-linux-headers.sh script for this.
> 
> So the ordering is: Get the kernel changes accepted, then push the
> (final) user space patches. That said, a patch like this can still be
> posted in advance for informational purposes, but not for application.

OK.

Thanks
Wen Congyang

> 
> Jan
> 


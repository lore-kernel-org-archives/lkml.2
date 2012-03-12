Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab2CLByX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 21:54:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65469 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754516Ab2CLByA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 21:54:00 -0400
X-IronPort-AV: E=Sophos;i="4.73,568,1325433600"; 
   d="scan'208";a="4505654"
Message-ID: <4F5D5566.8030807@cn.fujitsu.com>
Date: Mon, 12 Mar 2012 09:46:14 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Daniel P. Berrange" <berrange@redhat.com>
CC: Avi Kivity <avi@redhat.com>, kvm list <kvm@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: Re: [RESEND][PATCH 2/2 v3] deal with guest panicked event
References: <4F58664D.1070800@cn.fujitsu.com> <4F5868C4.2090509@cn.fujitsu.com> <4F5886C4.7040100@cn.fujitsu.com> <4F5897F8.6090503@redhat.com> <20120308113607.GC25529@redhat.com> <4F589D8D.4030105@redhat.com> <20120308115656.GD25529@redhat.com>
In-Reply-To: <20120308115656.GD25529@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-12 09:42:25,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-12 09:44:03,
	Serialize complete at 2012-03-12 09:44:03
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 03/08/2012 07:56 PM, Daniel P. Berrange Wrote:
> On Thu, Mar 08, 2012 at 01:52:45PM +0200, Avi Kivity wrote:
>> On 03/08/2012 01:36 PM, Daniel P. Berrange wrote:
>>> On Thu, Mar 08, 2012 at 01:28:56PM +0200, Avi Kivity wrote:
>>>> On 03/08/2012 12:15 PM, Wen Congyang wrote:
>>>>> When the host knows the guest is panicked, it will set
>>>>> exit_reason to KVM_EXIT_GUEST_PANICKED. So if qemu receive
>>>>> this exit_reason, we can send a event to tell management
>>>>> application that the guest is panicked and set the guest
>>>>> status to RUN_STATE_PANICKED.
>>>>>
>>>>> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
>>>>> ---
>>>>>  kvm-all.c        |    5 +++++
>>>>>  monitor.c        |    3 +++
>>>>>  monitor.h        |    1 +
>>>>>  qapi-schema.json |    2 +-
>>>>>  qmp.c            |    3 ++-
>>>>>  vl.c             |    1 +
>>>>>  6 files changed, 13 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/kvm-all.c b/kvm-all.c
>>>>> index 77eadf6..b3c9a83 100644
>>>>> --- a/kvm-all.c
>>>>> +++ b/kvm-all.c
>>>>> @@ -1290,6 +1290,11 @@ int kvm_cpu_exec(CPUState *env)
>>>>>                      (uint64_t)run->hw.hardware_exit_reason);
>>>>>              ret = -1;
>>>>>              break;
>>>>> +        case KVM_EXIT_GUEST_PANICKED:
>>>>> +            monitor_protocol_event(QEVENT_GUEST_PANICKED, NULL);
>>>>> +            vm_stop(RUN_STATE_PANICKED);
>>>>> +            ret = -1;
>>>>> +            break;
>>>>>
>>>>
>>>> If the management application is not aware of this event, then it will
>>>> never resume the guest, so it will appear hung.
>>>
>>> Even if the mgmt app doesn't know about the QEVENT_GUEST_PANICKED, it should
>>> still see a QEVENT_STOP event emitted by vm_stop() surely ? So it will
>>> know the guest CPUs have been stopped, even if it isn't aware of the
>>> reason why, which seems fine to me.
>>
>> No.  The guest is stopped, and there's no reason to suppose that the
>> management app will restart it.  Behaviour has changed.
>>
>> Suppose the guest has reboot_on_panic set; now the behaviour change is
>> even more visible - service will stop completely instead of being
>> interrupted for a bit while the guest reboots.
> 
> Hmm, so this calls for a new command line argument to control behaviour,
> similar to what we do for disk werror, eg something like
> 
>   --onpanic "report|pause|stop|..."
> 
> where
> 
>  report - emit QEVENT_GUEST_PANICKED only

If the guest is panicked when libvirt is stopped, and we only emit a event,
we cannot know the guest is panicked when libvirt starts.

So I add a new RunState to solve this problem. If the guest is stopped when
it is panicked, it will change the behaviour. So I think the new RunState
should be a running state.

Thanks
Wen Congyang

>  pause  - emit QEVENT_GUEST_PANICKED and pause VM
>  stop   - emit QEVENT_GUEST_PANICKED and quit VM
>  stop   - emit QEVENT_GUEST_PANICKED and quit VM
> 
> This would map fairly well into libvirt, where we already have config
> parameters for controlling what todo with a guest when it panics.
> 
> Regards,
> Daniel


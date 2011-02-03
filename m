Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932402Ab1BCSkF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 13:40:05 -0500
Received: from usindmx01.hds.com ([207.126.252.12]:62435 "EHLO
	usindmx01.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932312Ab1BCSkD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 13:40:03 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Vivek Goyal <vgoyal@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jarod Wilson <jwilson@redhat.com>
Date: Thu, 3 Feb 2011 13:38:13 -0500
Subject: RE: Query about kdump_msg hook into crash_kexec()
Thread-Topic: Query about kdump_msg hook into crash_kexec()
Thread-Index: AcvDRu9OsQmVAqdMQCiSKOyxoi6K9QAiJCOg
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C147F4346@USINDEVS01.corp.hds.com>
References: <20110131225939.GH11974@redhat.com>
 <20110203094715.939C.A69D9226@jp.fujitsu.com>
 <20110203020528.GA21603@redhat.com>
In-Reply-To: <20110203020528.GA21603@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>PS: FWIW, Hitach folks have usage idea for their enterprise purpose, but 
>    unfortunately I don't know its detail. I hope anyone tell us it.

I explain the usage of kmsg_dump(KMSG_DUMP_KEXEC) in enterprise area.

[Background]
In our support service experience, we always need to detect root cause 
of OS panic.
So, customers in enterprise area never forgive us if kdump fails and 
we can't detect the root cause of panic due to lack of materials for 
investigation.

>- Why do you need a notification from inside crash_kexec(). IOW, what
>  is the usage of KMSG_DUMP_KEXEC.


The usage of kdump(KMSG_DUMP_KEXEC) in enterprise area is getting 
useful information for investigating kernel crash in case kdump
kernel doesn't boot.

Kdump kernel may not start booting because there is a sha256 checksum
verified over the kdump kernel before it starts booting.
This means kdump kernel may fail even if there is no bug in kdump and
we can't get any information for detecting root cause of kernel crash.

As I mentioned in [Background], We must avoid lack of materials for 
investigation.
So, kdump(KMSG_DUMP_KEXEC) is very important feature in enterprise
area.

>- One can anyway call kmsg_dump() outside crash_kexec() before it so
>  that kmsg_dump notification will go out before kdump gets the control.
>  What I am arguing here is that it is not necessarily a very good idea
>  because external modules can try to do any amount of unsafe actions
>  once we export the hook.
>

kmsg_dump() is a feature for specific servers capable NVRAM or flash memory.
So, it should be provided as a option.

By providing notification, linux kernel is able to support
this feature in following different kinds of servers flexibly.

- equipped with some NVRAMs or flash memories
- equipped with a NVRAM or flash memory

Also, linux kernel is able to support servers which don't have NVRAM/flash memory

Seiji

>-----Original Message-----
>From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Vivek Goyal
>Sent: Wednesday, February 02, 2011 9:05 PM
>To: KOSAKI Motohiro
>Cc: Eric W. Biederman; linux kernel mailing list; Jarod Wilson
>Subject: Re: Query about kdump_msg hook into crash_kexec()
>
>On Thu, Feb 03, 2011 at 09:55:41AM +0900, KOSAKI Motohiro wrote:
>> Hi
>>
>> > Hi,
>> >
>> > I noticed following commit which hooks into crash_kexec() for calling
>> > kmsg_dump().
>> >
>> > I think it is not a very good idea to pass control to modules after
>> > crash_kexec() has been called. Because modules can try to take locks
>> > or try to do some other operations which we really should not be doing
>> > now and fail kdump also. The whole design of kdump is built on the
>> > fact that in crashing kernel we do minimal thing and try to make
>> > transition to second kernel robust. Now with this hook, kmsg dumper
>> > breaks that assumption.
>>
>> I guess you talked about some foolish can shoot their own foot. if so,
>> Yes. Any kernel module can make kernel panic or more disaster result.
>
>Yes, the difference is that once a fool shoots his foot, kernel tries
>to take a meaningful action to figure out what went wrong. Like displayig
>an oops backtrace or like dumping a core (if kdump is configured) so
>that one can figure out who was the fool and what did who do.
>
>Now think give the control to two fools. First fool shoots his foot
>and then kernel transfers the control to another fool which completely
>screws up the situation and one can not save the core.
>
>>
>>
>> > Anyway, if an image is loaded and we have setup to capture dump also
>> > why do we need to save kmsg with the help of an helper. I am assuming
>> > this is more of a debugging aid if we have no other way to capture the
>> > kernel log buffer. So if somebody has setup kdump to capture the
>> > vmcore, why to call another handler which tries to save part of the
>> > vmcore (kmsg) separately.
>>
>> No.
>>
>> kmsg_dump() is desingned for embedded.
>
>Great. And I like the idea of trying to save some useful information
>to non volatile RAM or flash or something like that.
>
>> kexec for non dumping purpose. (Have you seen your embedded devices
>> show "Now storing dump image.." message?)
>
>No I have not seen. Can you explain a bit more that apart from kernel
>dump, what are the other purposes of kdump.
>
>>
>> Anyway, you can feel free to avoid to use ksmg_dump().
>
>Yes, that is one more way but this information is not even exported to
>user space to figure out if there are any registerd users of kmsg_dump.
>
>Seconly there are two more important things.
>
>- Why do you need a notification from inside crash_kexec(). IOW, what
>  is the usage of KMSG_DUMP_KEXEC.
>
>- One can anyway call kmsg_dump() outside crash_kexec() before it so
>  that kmsg_dump notification will go out before kdump gets the control.
>  What I am arguing here is that it is not necessarily a very good idea
>  because external modules can try to do any amount of unsafe actions
>  once we export the hook.
>
>  Doing this is still fine if kdump is not configured as anyway syste would
>  have rebooted. But if kdump is configured, then we are just reducing
>  the reliability of the operation by passing the control in the hands
>  of unaudited code and trusting it when kernel data structures are
>  corrupt.
>
>  So to me, sending out kmsg_dump notifications are perfectly fine when
>  kdump is not configured. But if it is configured, then it probably is
>  not a good idea. Anyway, if you have configured the system to capture
>  the full dump, why do you also need kmsg_dump. And if you are happy
>  with kmsg_dump() then you don't need kdump. So these both seem to be
>  mutually exclusive anyway.
>
>Thanks
>Vivek
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/

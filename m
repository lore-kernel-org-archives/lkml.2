Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827Ab2CVIA0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 04:00:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:6246 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752032Ab2CVIAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 04:00:24 -0400
X-IronPort-AV: E=Sophos;i="4.73,629,1325433600"; 
   d="scan'208";a="4598085"
Message-ID: <4F6AD783.1000706@cn.fujitsu.com>
Date: Thu, 22 Mar 2012 15:40:51 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Anthony Liguori <anthony@codemonkey.ws>, minyard@acm.org,
        kvm list <kvm@vger.kernel.org>, Jan Kiszka <jan.kiszka@siemens.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>, Avi Kivity <avi@redhat.com>,
        Corey Minyard <tcminyard@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [Qemu-devel] [PATCH 0/2 v3] kvm: notify host when guest panicked
References: <4F58664D.1070800@cn.fujitsu.com> <4F66E14F.3040809@cn.fujitsu.com>	<4F6854F4.3060703@cn.fujitsu.com>	<20120320154517.GG27928@redhat.com>	<4F692723.8050904@cn.fujitsu.com>	<20120321091127.GO22368@redhat.com> <4F69FF48.3010200@acm.org>	<4F6A00EC.3060706@redhat.com> <4F6A29C6.2070708@redhat.com> <20120322072855.GX22368@redhat.com>
In-Reply-To: <20120322072855.GX22368@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-22 15:36:34,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-22 15:36:53,
	Serialize complete at 2012-03-22 15:36:53
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 03/22/2012 03:28 PM, Gleb Natapov Wrote:
> On Wed, Mar 21, 2012 at 02:19:34PM -0500, Anthony Liguori wrote:
>> On 03/21/2012 11:25 AM, Avi Kivity wrote:
>>> On 03/21/2012 06:18 PM, Corey Minyard wrote:
>>>>
>>>>> Look at drivers/char/ipmi/ipmi_msghandler.c. It has code to send panic
>>>>> event over IMPI. The code is pretty complex. Of course if we a going to
>>>>> implement something more complex than simple hypercall for panic
>>>>> notification we better do something more interesting with it than just
>>>>> saying "panic happened", like sending stack traces on all cpus for
>>>>> instance.
>>>>
>>>> I doubt that's the best example, unfortunately.  The IPMI event log
>>>> has limited space and it has to be send a little piece at a time since
>>>> each log entry is 14 bytes.  It just prints the panic string, nothing
>>>> else.  Not that it isn't useful, it has saved my butt before.
>>>>
>>>> You have lots of interesting options with paravirtualization.  You
>>>> could, for instance, create a console driver that delivered all
>>>> console output efficiently through a hypercall.  That would be really
>>>> easy.  Or, as you mention, a custom way to deliver panic information.
>>>> Collecting information like stack traces would be harder to
>>>> accomplish, as I don't think there is currently a way to get it except
>>>> by sending it to printk.
>>>
>>> That already exists; virtio-console (or serial console emulation) can do
>>> the job.
>>
>> I think the use case here is pretty straight forward: if the guest
>> finds itself in bad place, it wants to indicate that to the host.
>>
>> We shouldn't rely on any device drivers or complex code.  It should
>> be as close to a single instruction as possible that can run even if
>> interrupts are disabled.
>>
>> An out instruction fits this very well.  I think a simple protocol like:
>>
>> inl PORT -> returns a magic number indicating the presence of qemucalls
>> inl PORT+1 -> returns a bitmap of supported features
>>
> Sigh, one more PV isa device.
> 
>> outl PORT+1 -> data reg1
>> outl PORT+2 -> data reg2
>> outl PORT+N -> data regN
>>
>> outl PORT -> qemucall of index value with arguments 1..N
> And you think you can trust panicked SMP guest to not call this on
> multiple cpus simultaneously?

We can register panic notifier in the guest kernel, and do it in the panic
notifier callback.

Thanks
Wen Congyang

> 
>>
>> Regards,
>>
>> Anthony Liguori
>>
>>>
>>> In fact the feature can be implemented 100% host side by searching for a
>>> panic string signature in the console logs.
>>>
> 
> --
> 			Gleb.
> 
> 


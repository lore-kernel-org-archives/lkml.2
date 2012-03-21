Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760064Ab2CUTTj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 15:19:39 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54685 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755717Ab2CUTTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 15:19:37 -0400
Message-ID: <4F6A29C6.2070708@redhat.com>
Date: Wed, 21 Mar 2012 14:19:34 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: minyard@acm.org, Gleb Natapov <gleb@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, Corey Minyard <tcminyard@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [Qemu-devel] [PATCH 0/2 v3] kvm: notify host when guest panicked
References: <4F58664D.1070800@cn.fujitsu.com> <4F66E14F.3040809@cn.fujitsu.com> <4F6854F4.3060703@cn.fujitsu.com> <20120320154517.GG27928@redhat.com> <4F692723.8050904@cn.fujitsu.com> <20120321091127.GO22368@redhat.com> <4F69FF48.3010200@acm.org> <4F6A00EC.3060706@redhat.com>
In-Reply-To: <4F6A00EC.3060706@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2012 11:25 AM, Avi Kivity wrote:
> On 03/21/2012 06:18 PM, Corey Minyard wrote:
>>
>>> Look at drivers/char/ipmi/ipmi_msghandler.c. It has code to send panic
>>> event over IMPI. The code is pretty complex. Of course if we a going to
>>> implement something more complex than simple hypercall for panic
>>> notification we better do something more interesting with it than just
>>> saying "panic happened", like sending stack traces on all cpus for
>>> instance.
>>
>> I doubt that's the best example, unfortunately.  The IPMI event log
>> has limited space and it has to be send a little piece at a time since
>> each log entry is 14 bytes.  It just prints the panic string, nothing
>> else.  Not that it isn't useful, it has saved my butt before.
>>
>> You have lots of interesting options with paravirtualization.  You
>> could, for instance, create a console driver that delivered all
>> console output efficiently through a hypercall.  That would be really
>> easy.  Or, as you mention, a custom way to deliver panic information.
>> Collecting information like stack traces would be harder to
>> accomplish, as I don't think there is currently a way to get it except
>> by sending it to printk.
>
> That already exists; virtio-console (or serial console emulation) can do
> the job.

I think the use case here is pretty straight forward: if the guest finds itself 
in bad place, it wants to indicate that to the host.

We shouldn't rely on any device drivers or complex code.  It should be as close 
to a single instruction as possible that can run even if interrupts are disabled.

An out instruction fits this very well.  I think a simple protocol like:

inl PORT -> returns a magic number indicating the presence of qemucalls
inl PORT+1 -> returns a bitmap of supported features

outl PORT+1 -> data reg1
outl PORT+2 -> data reg2
outl PORT+N -> data regN

outl PORT -> qemucall of index value with arguments 1..N

Regards,

Anthony Liguori

>
> In fact the feature can be implemented 100% host side by searching for a
> panic string signature in the console logs.
>


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab2JEPrf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 11:47:35 -0400
Received: from relay3.sgi.com ([192.48.152.1]:53305 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750750Ab2JEPrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 11:47:32 -0400
Message-ID: <506F0113.9020605@sgi.com>
Date: Fri, 5 Oct 2012 10:47:31 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Joe Perches <joe@perches.com>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] revert "PCI: log vendor/device ID always"
References: <1349187780-25692-1-git-send-email-nzimmer@sgi.com> <CAErSpo7ZQEm9==nsGiH2c_ZG8LPP8MAA8M9xSPyWPtCW2EHUUQ@mail.gmail.com> <506DB30F.2000704@sgi.com> <1349368662.2008.20.camel@joe-AO722> <506EE6D5.4010603@sgi.com> <1349446478.2008.66.camel@joe-AO722> <506EF48B.5070801@sgi.com> <CAErSpo6=9vdoR=Z83jyDrHAc_4XAL+rHw55=UeXf8C+N=xUHrw@mail.gmail.com>
In-Reply-To: <CAErSpo6=9vdoR=Z83jyDrHAc_4XAL+rHw55=UeXf8C+N=xUHrw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.162.233.146]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2012 10:16 AM, Bjorn Helgaas wrote:
> On Fri, Oct 5, 2012 at 8:54 AM, Nathan Zimmer <nzimmer@sgi.com> wrote:
>> On 10/05/2012 09:14 AM, Joe Perches wrote:
>>> On Fri, 2012-10-05 at 08:55 -0500, Nathan Zimmer wrote:
>>>> On 10/04/2012 11:37 AM, Joe Perches wrote:
>>>>> On Thu, 2012-10-04 at 11:02 -0500, Nathan Zimmer wrote:
>>>>>> At many of our customer sites the log level is set to KERN_DEBUG. It
>>>>>> helps avoid reboots due to operator impatience.  Machines this large
>>>>>> take significantly longer then typical to boot and seeing the extra
>>>>>> messages reassures them that the kernel isn't hung.
>>>>> That argues for adding some KERN_INFO "still booting" messages
>>>>> not logging unnecessary KERN_DEBUG messages.
>>>>>
>>>> Actually I would think that argues for reducing boot times on these
>>>> large systems.
>>> Right.
>>>
>>> That's an independent argument, but sure, go ahead
>>> and do that too.
>>>
>>
>> Here is output for my workstation a simple 4x box
>>
>> -bash-4.1$ dmesg | grep "type [0-9][0-9] class" | wc
>>       12     108     804
>> -bash-4.1$ dmesg | wc
>>      744    6359   49474
>>
>>
>> Here is some output from one of the biggest boxes.
>>
>> -bash-4.1$ dmesg | wc
>>    26503  235414 1811651
>> -bash-4.1$ dmesg | grep "type [0-9][0-9] class" | wc
>>    12085 108765  821780
> Many vendors don't expose host bridges that lead to the CPU-related
> PCI devices because they don't want the OS to muck with them.  We
> currently blindly probe for these in domain 0, so we find them anyway
> (I think we should change this behavior).
>
> I'd guess that having all these CPU-related devices around also really
> clutters up "lspci" output, and of course, consumes memory for all the
> pci_dev structs in the kernel.  It takes some time to enumerate them
> all, so avoiding that would speed up boot somewhat.

Yea now that you mention it lspci is quite cluttered.

>
> So I wonder if it might be more useful to figure out how to avoid
> enumerating those devices in the first place?  The first step would be
> to stop exposing PNP0A03/PNP0A08 host bridges that lead to them.  As I
> mentioned, we currently will probably find them anyway via blind
> probing.  You might be able to avoid that if you could place them in a
> PCI domain other than 0.
>
> Bjorn

This seems like a better way to go.  I'll start digging down this route.

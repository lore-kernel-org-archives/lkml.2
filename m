Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab2EAGix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 02:38:53 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:56931 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750925Ab2EAGiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 02:38:51 -0400
X-Authenticated: #23875046
X-Provags-ID: V01U2FsdGVkX1+G8rFMocSGBvUQiXA3Oqdykp79AabjKyTGfkqrsC
	/CkF+PdxFp6WCz
Message-ID: <4F9F84F6.7000509@fisher-privat.net>
Date: Tue, 01 May 2012 08:38:46 +0200
From: "Oleksij Rempel (fishor)" <bug-track@fisher-privat.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>, linux-pci@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrey Rahmatullin <wrar@wrar.name>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] ACPI / PCI: Make _SxD/_SxW check follow ACPI 4.0a spec
References: <Pine.LNX.4.44L0.1204301348180.1558-100000@iolanthe.rowland.org> <4F9F0473.9090408@fisher-privat.net> <201204302343.35215.rjw@sisk.pl>
In-Reply-To: <201204302343.35215.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.04.2012 23:43, Rafael J. Wysocki wrote:
> On Monday, April 30, 2012, Oleksij Rempel wrote:
>> On 30.04.2012 19:53, Alan Stern wrote:
>>> On Mon, 30 Apr 2012, Bjorn Helgaas wrote:
>>>
>>>> On Sun, Apr 29, 2012 at 2:44 PM, Rafael J. Wysocki<rjw@sisk.pl>  wrote:
>>>>> From: Oleksij Rempel<bug-track@fisher-privat.net>
>>>>>
>>>>> This patch makes _SxD/_SxW check follow the ACPI 4.0a specification
>>>>> more closely and fixes suspend bug found on ASUS Zenbook UX31E.
>>>>>
>>>>> Some OEM use _SxD fileds do blacklist brocken Dx states.
>>>>> If _SxD/_SxW return values are check before suspend as appropriate,
>>>>> some nasty suspend/resume issues may be avoided.
>>>>>
>>>>> References: https://bugzilla.kernel.org/show_bug.cgi?id=42728
>>>>> Signed-off-by: Oleksij Rempel<bug-track@fisher-privat.net>
>>>>> Signed-off-by: Rafael J. Wysocki<rjw@sisk.pl>
>>>>> ---
>>>>>
>>>>> Bjorn, Len,
>>>>>
>>>>> This is -stable material and therefore v3.4 as well, IMO. �Please let me
>>>>> know if one of you can take it or whether you want me to handle it all the
>>>>> way to Linus.
>>>>
>>>> I'm OK with this from a PCI perspective.  Most of the change is in
>>>> ACPI, so I propose that either you or Len take care of it.
>>>>
>>>> The second paragraph of the changelog has several typos
>>>> (fileds/fields, do/to, brocken/broken, etc).
>>>
>>> It also turns out that the normal wakeup mechanism doesn't work for the
>>> devices in question.  Can this be detected by ACPI?  We don't want to
>>> tell userspace that wakeup works when in fact it doesn't.
>>
>> hm... how about using pci config and acpi together. PCI config provides
>> map of Dx states and wakeup support of them. If pci says wakeup works
>> only on D0 and D3 and acpi say - we can use only D2 in S3, then there is
>> no wakeup.
>
> Not really.  ACPI trumps PCI here, so if ACPI says we can use D2 in S3,
> then we can.
>
> ACPI device states are not the same as PCI device states.  They usually map
> to each other directly, but they don't have to.

I mean not just the mapping.
I mean PCI:PME_SUP field.  If it PME(D0+,D1-,D2-,D3hot+,D3cold+), and 
acpi trying to avoid D3 states for this device. then is is same like 
PME(D0+,D1-,D2-)? Or not?

According to spec.:
7.2 Device Power Management Objects (page 287)
_S3D - Highest D-state supported by the device in the S3 state
_S3W - Lowest D-state supported by the device in the S3 state which can 
wake the system.
by definition if _S3W is specified then we can assume, the device can 
wake? But _SxW is not defined.

Are there any other method to forbid the system use broken state, after 
device was actually produced? Usual BIOS flash utility will probably no 
rewrite the PCIs EEPROM. Only hope is ACPI, what is correct method to do 
define it by ACPI?

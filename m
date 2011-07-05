Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab1GEH0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 03:26:20 -0400
Received: from adelie.canonical.com ([91.189.90.139]:39387 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635Ab1GEH0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 03:26:19 -0400
Message-ID: <4E12BC90.2030702@canonical.com>
Date: Tue, 05 Jul 2011 15:26:08 +0800
From: Ike Panhc <ike.pan@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Thunderbird/3.1.10
MIME-Version: 1.0
To: =?UTF-8?B?S2VuZy1Zw7wgTGlu?= <kengyu@canonical.com>
CC: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, vanhoof@canonical.com,
        kent.lin@canonical.com, sylee@canonical.com
Subject: Re: [PATCH 2/2] ideapad-laptop: Handle the App-controlled RF event
References: <1309268154-6872-1-git-send-email-kengyu@canonical.com> <1309268154-6872-2-git-send-email-kengyu@canonical.com> <4E0B2F06.3060706@canonical.com> <BANLkTimXyoC74XhZSG7jOngYdrx7yZ7nDg@mail.gmail.com>
In-Reply-To: <BANLkTimXyoC74XhZSG7jOngYdrx7yZ7nDg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2011 06:34 PM, Keng-Yü Lin wrote:
> On Wed, Jun 29, 2011 at 2:56 PM, Ike Panhc <ike.pan@canonical.com> wrote:
>> On 06/28/2011 09:35 PM, Keng-Yu Lin wrote:
>>> Notification with VPC2 bit 5 set is generated when the wireless
>>> hotkey is pressed. BIOS fires this to notify a Windows
>>> application to handle the RF switch.
>>>
>>> On Linux, there is no such application. This patch implements
>>> a toggle for all RF devices through accessing the EC I/O ports.
>>>
>>> Without the explicit EC commands, the wifi LED is always on.
>>>
>>> Signed-off-by: Keng-Yu Lin <kengyu@canonical.com>
>>> ---
>>>  drivers/platform/x86/ideapad-laptop.c |    6 +++++-
>>>  1 files changed, 5 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
>>> index 820f013..5e1e971 100644
>>> --- a/drivers/platform/x86/ideapad-laptop.c
>>> +++ b/drivers/platform/x86/ideapad-laptop.c
>>> @@ -461,7 +461,11 @@ static void ideapad_acpi_notify(struct acpi_device *adevice, u32 event)
>>>               if (test_bit(vpc_bit, &vpc1)) {
>>>                       if (vpc_bit == 9)
>>>                               ideapad_sync_rfk_state(adevice);
>>> -                     else if (vpc_bit == 4)
>>> +                     else if (vpc_bit == 13) {
>>> +                             read_ec_data(handle, 0x23, &vpc2);
>>> +                             write_ec_cmd(handle, 0x24, !vpc2);
>>> +                             ideapad_sync_rfk_state(adevice);
>>> +                     } else if (vpc_bit == 4)
>>>                               read_ec_data(handle, 0x12, &vpc2);
>>>                       else if (vpc_bit == 1) {
>>>                       } else
>>
>> I think its better to implement the changes in ideapad_sync_rfk_state() because we have
>> read switch status there. It is not necessary to read the same data twice in an event.
>>
>>
> 
> Current ideapad_sync_rfk_state() code does not really toggle the
> hardware swtich (I mean to write_ec_cmd with 0x24 command). It just
> assumes that the BIOS or EC is responsible for the wifi switch-on/-off
> and reports the state via rfkill_set_hw_state().
> 
> In my case, without explicit sending the 0x24 command to turn off the
> radio device, the wifi LED is always on.
> 
> Though it might not be true or applicable on ideapads,  in my last
> experience on Dell laptops that to switch off the RF radio in the
> driver while the hardware claims to control it can cause some mess-up.
> 
> So to be safe I prefer not to move the toggle code in ideapad_sync_rfk_state().
> 
>   Thanks,
> -kengyu
> 

Look twice and I do not think this patch is acceptable.

vpc_bit 13 is soft block key event (Fn+F5) and read_ec_data from 0x23 is
hardware switch status. This patch will mask the key report of inputdev
and to force update switch status in EC (0x24) is not a reasonable solution.

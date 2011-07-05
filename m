Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318Ab1GELmp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 07:42:45 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65244 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932242Ab1GELmn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 07:42:43 -0400
MIME-Version: 1.0
In-Reply-To: <4E12BC90.2030702@canonical.com>
References: <1309268154-6872-1-git-send-email-kengyu@canonical.com>
 <1309268154-6872-2-git-send-email-kengyu@canonical.com> <4E0B2F06.3060706@canonical.com>
 <BANLkTimXyoC74XhZSG7jOngYdrx7yZ7nDg@mail.gmail.com> <4E12BC90.2030702@canonical.com>
From: =?UTF-8?B?S2VuZy1Zw7wgTGlu?= <kengyu@canonical.com>
Date: Tue, 5 Jul 2011 19:42:02 +0800
X-Google-Sender-Auth: 6_rKpzfsiVVQ-9F2X3Bkf0CSnQQ
Message-ID: <CADXHx7bsEBwhMKaPp-KRHYA4YuSECYf0oN6LdY3nYPhop3Ri2w@mail.gmail.com>
Subject: Re: [PATCH 2/2] ideapad-laptop: Handle the App-controlled RF event
To: Ike Panhc <ike.pan@canonical.com>
Cc: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, vanhoof@canonical.com,
        kent.lin@canonical.com, sylee@canonical.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 5, 2011 at 3:26 PM, Ike Panhc <ike.pan@canonical.com> wrote:
> On 06/30/2011 06:34 PM, Keng-Yü Lin wrote:
>> On Wed, Jun 29, 2011 at 2:56 PM, Ike Panhc <ike.pan@canonical.com> wrote:
>>> On 06/28/2011 09:35 PM, Keng-Yu Lin wrote:
>>>> Notification with VPC2 bit 5 set is generated when the wireless
>>>> hotkey is pressed. BIOS fires this to notify a Windows
>>>> application to handle the RF switch.
>>>>
>>>> On Linux, there is no such application. This patch implements
>>>> a toggle for all RF devices through accessing the EC I/O ports.
>>>>
>>>> Without the explicit EC commands, the wifi LED is always on.
>>>>
>>>> Signed-off-by: Keng-Yu Lin <kengyu@canonical.com>
>>>> ---
>>>>  drivers/platform/x86/ideapad-laptop.c |    6 +++++-
>>>>  1 files changed, 5 insertions(+), 1 deletions(-)
>>>>
>>>> diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
>>>> index 820f013..5e1e971 100644
>>>> --- a/drivers/platform/x86/ideapad-laptop.c
>>>> +++ b/drivers/platform/x86/ideapad-laptop.c
>>>> @@ -461,7 +461,11 @@ static void ideapad_acpi_notify(struct acpi_device *adevice, u32 event)
>>>>               if (test_bit(vpc_bit, &vpc1)) {
>>>>                       if (vpc_bit == 9)
>>>>                               ideapad_sync_rfk_state(adevice);
>>>> -                     else if (vpc_bit == 4)
>>>> +                     else if (vpc_bit == 13) {
>>>> +                             read_ec_data(handle, 0x23, &vpc2);
>>>> +                             write_ec_cmd(handle, 0x24, !vpc2);
>>>> +                             ideapad_sync_rfk_state(adevice);
>>>> +                     } else if (vpc_bit == 4)
>>>>                               read_ec_data(handle, 0x12, &vpc2);
>>>>                       else if (vpc_bit == 1) {
>>>>                       } else
>>>
>>> I think its better to implement the changes in ideapad_sync_rfk_state() because we have
>>> read switch status there. It is not necessary to read the same data twice in an event.
>>>
>>>
>>
>> Current ideapad_sync_rfk_state() code does not really toggle the
>> hardware swtich (I mean to write_ec_cmd with 0x24 command). It just
>> assumes that the BIOS or EC is responsible for the wifi switch-on/-off
>> and reports the state via rfkill_set_hw_state().
>>
>> In my case, without explicit sending the 0x24 command to turn off the
>> radio device, the wifi LED is always on.
>>
>> Though it might not be true or applicable on ideapads,  in my last
>> experience on Dell laptops that to switch off the RF radio in the
>> driver while the hardware claims to control it can cause some mess-up.
>>
>> So to be safe I prefer not to move the toggle code in ideapad_sync_rfk_state().
>>
>>   Thanks,
>> -kengyu
>>
>
> Look twice and I do not think this patch is acceptable.
>
> vpc_bit 13 is soft block key event (Fn+F5) and read_ec_data from 0x23 is
> hardware switch status. This patch will mask the key report of inputdev
> and to force update switch status in EC (0x24) is not a reasonable solution.
>

In fact quite a few things involved in this:

since we get notified with VPC bit 13 set when Fn+F5 is pressed, I
think that it is ok to be treated as a hardware rfkill
blocking/unblocking.

However it is true that the bit/event is supposed be to be handled by
an application in Windows, it is a soft-killswitch by the definition.
Yet currently there is no such correspondent userspace app/daemon as I
know. This inspired the original intention of the patch, to handle the
app-controlled rfkill in the driver. I think that this is probably
common in other platform-x86 drivers.

I'd rather agree with you that it is a better idea to report a keycode.

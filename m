Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591Ab2CLK2c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 06:28:32 -0400
Received: from stats.peacock.arvixe.com ([174.122.104.67]:55623 "EHLO
	peacock.arvixe.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751853Ab2CLK2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 06:28:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=firszt.eu;
	h=Message-ID:In-Reply-To:References:Date:Subject:From:To:Cc:Reply-To:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:Importance;
	b=TmH05IVxf2TEycwBqUfxKEwXwt/+laL5MSGC7BYGeAmcJTTJXyUH0zwlxOHOdcSlSLjapVK+/6VBzIucGmHidegOycCvJQBwEn8CfMlvpYU7X1AfS2pD5wgGFZFrJIaj;
Message-ID: <5949dcded77a16e0b804c4b5231a3c49.squirrel@webmail.firszt.eu>
In-Reply-To: <CAGzDe_Y=vcKrdqSpwudSwWJKPU4hnSboDA3j81gOY7BZnBax2w@mail.gmail.com>
References: <1331324862-15989-1-git-send-email-przemo@firszt.eu>
    <CAGzDe_Y=vcKrdqSpwudSwWJKPU4hnSboDA3j81gOY7BZnBax2w@mail.gmail.com>
Date: Mon, 12 Mar 2012 10:28:13 -0000
Subject: Re: [PATCH] HID: wacom: Add reporting of wheel for Intuos4 WL
From: "Przemo Firszt" <przemo@firszt.eu>
To: "Chris Bagwell" <chris@cnpbagwell.com>
Cc: "Przemo Firszt" <przemo@firszt.eu>, killertofu@gmail.com,
        pinglinux@gmail.com, jkosina@suse.cz,
        linuxwacom-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Reply-To: przemo@firszt.eu
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-2
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - peacock.arvixe.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - firszt.eu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dnia 9 Marca 2012, 10:40 pm, Pt, Chris Bagwell napisa³(a):
> On Fri, Mar 9, 2012 at 2:27 PM, Przemo Firszt <przemo@firszt.eu> wrote:
>> This patch adds reporting of ABS_WHEEL event. Raported walues are 0..71
>> and are related to absolute location of the finger on the wheel.
>>
>> Signed-off-by: Przemo Firszt <przemo@firszt.eu>
>> Reviewed-by: Jason Gerecke <killertofu@gmail.com>
>> ---
>>  drivers/hid/hid-wacom.c |   25 +++++++++++++++++++++++++
>>  1 files changed, 25 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/hid/hid-wacom.c b/drivers/hid/hid-wacom.c
>> index 5c25036..dab7588 100644
>> --- a/drivers/hid/hid-wacom.c
>> +++ b/drivers/hid/hid-wacom.c
>> @@ -36,6 +36,7 @@
>>  struct wacom_data {
>>        __u16 tool;
>>        __u16 butstate;
>> +       __u8 whlstate;
>>        __u8 features;
>>        __u32 id;
>>        __u32 serial;
>> @@ -322,6 +323,23 @@ static void wacom_i4_parse_button_report(struct
>> wacom_data *wdata,
>>                        struct input_dev *input, unsigned char *data)
>>  {
>>        __u16 new_butstate;
>> +       __u8 new_whlstate;
>> +       __u8 sync = 0;
>> +
>> +       new_whlstate = data[1];
>> +       if (new_whlstate != wdata->whlstate) {
>> +               wdata->whlstate = new_whlstate;
>> +               if (new_whlstate & 0x80) {
>> +                       input_report_key(input, BTN_TOUCH, 1);
>> +                       input_report_abs(input, ABS_WHEEL, (new_whlstate
>> & 0x7f));
>> +                       input_report_key(input, BTN_TOOL_FINGER, 1);
>> +               } else {
>> +                       input_report_key(input, BTN_TOUCH, 0);
>> +                       input_report_abs(input, ABS_WHEEL, 0);
>> +                       input_report_key(input, BTN_TOOL_FINGER, 0);
>> +               }
>> +               sync = 1;
>> +       }
>>
>>        new_butstate = (data[3] << 1) | (data[2] & 0x01);
>>        if (new_butstate != wdata->butstate) {
>> @@ -336,6 +354,10 @@ static void wacom_i4_parse_button_report(struct
>> wacom_data *wdata,
>>                input_report_key(input, BTN_7, new_butstate & 0x080);
>>                input_report_key(input, BTN_8, new_butstate & 0x100);
>>                input_report_key(input, BTN_TOOL_FINGER, 1);
>> +               sync = 1;
>> +       }
>> +
>> +       if (sync) {
>>                input_report_abs(input, ABS_MISC, PAD_DEVICE_ID);
>>                input_event(input, EV_MSC, MSC_SERIAL, 0xffffffff);
>>                input_sync(input);
>> @@ -512,6 +534,9 @@ static int wacom_input_mapped(struct hid_device
>> *hdev, struct hid_input *hi,
>>                input_set_abs_params(input, ABS_DISTANCE, 0, 32, 0, 0);
>>                break;
>>        case USB_DEVICE_ID_WACOM_INTUOS4_BLUETOOTH:
>> +               __set_bit(ABS_WHEEL, input->absbit);
>> +               input_set_abs_params(input, ABS_WHEEL, 0, 71, 0, 0);
>> +               input_set_capability(input, EV_MSC, MSC_SERIAL);
>
> Is this input_set_capability MSC_SERIAL line to fix the next line
> thats above case statement?
>
>          __set_bit(MSC_SERIAL, input->mscbit);
>
> Should the original line be deleted/replaced?
Chris,
Thanks - good catch!
I no longer have the graphire tablet to test is it's safe to set "evbit" 
to "EV_MSC". That's the difference between "__set_bit(MSC_SERIAL,
input->mscbit);" and "input_set_capability(input, EV_MSC, MSC_SERIAL);" if
I read the code correctly. I'm OK to move "input_set_capability(input,
EV_MSC, MSC_SERIAL);" before the case statement, if someone can test that
it doesn't brak pad buttons on graphire tablet.

-- 
Regards,
Przemo Firszt


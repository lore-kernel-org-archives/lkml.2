Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632Ab2BVK07 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 05:26:59 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35500 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab2BVK05 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 05:26:57 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of djkurtz@google.com designates 10.42.158.5 as permitted sender) smtp.mail=djkurtz@google.com; dkim=pass header.i=djkurtz@google.com
MIME-Version: 1.0
In-Reply-To: <20120222083858.GA26570@polaris.bitmath.org>
References: <1329896503-28394-1-git-send-email-cywang@chromium.org> <20120222083858.GA26570@polaris.bitmath.org>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Wed, 22 Feb 2012 18:26:37 +0800
X-Google-Sender-Auth: 0HxfpJPOirKnrzECYcINMeAYykU
Message-ID: <CAGS+omCU9f=DyC442+4HOF=sGhZYXne+E2ephFiOmuj-XKciMA@mail.gmail.com>
Subject: Re: [PATCH] CHROMIUM: Input: synaptics - filter out the events with
 low z values
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Chung-yih Wang <cywang@chromium.org>,
        Alessandro Rubini <rubini@cvml.unipv.it>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 4:38 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi Chung-yih Wang,
>
>> The single touch path imposes a minimum z value (with hysterisis) before
>> registering BTN_TOUCH. Apply the same (hard coded) threshold when
>> deciding how many fingers to report in the semi-mt path.
>>
>> This patch improves performance of the Google Cr-48 chromebook's
>> extremely sensitive Synaptics profile sensor touchpad by filtering out
>> touch events for hovering fingers.
>>
>> Note: We continue to use the same hard coded threshold value used in the
>> single touch case as it appears this works just as well on these
>> multitouch profile sensor pads as on whatever pads it was originally
>> discovered.
>>
>> Signed-off-by: Chung-Yih Wang <cywang@chromium.org>
>> ---
>
> The idea is sound and has worked well in practise for a long
> time. However, please see the comments inline.
>
>>  drivers/input/mouse/synaptics.c |   15 +++++++++++----
>>  1 files changed, 11 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
>> index 8081a0a..746dbcc 100644
>> --- a/drivers/input/mouse/synaptics.c
>> +++ b/drivers/input/mouse/synaptics.c
>> @@ -568,17 +568,22 @@ static void synaptics_report_semi_mt_slot(struct input_dev *dev, int slot,
>>       }
>>  }
>>
>> +static bool finger_touched(const struct synaptics_hw_state *hw)
>> +{
>> +     return (hw->z > 30);
>> +}
>> +
>>  static void synaptics_report_semi_mt_data(struct input_dev *dev,
>>                                         const struct synaptics_hw_state *a,
>>                                         const struct synaptics_hw_state *b,
>>                                         int num_fingers)
>>  {
>> -     if (num_fingers >= 2) {
>> +     if ((num_fingers >= 2) && finger_touched(a) && finger_touched(b)) {
>>               synaptics_report_semi_mt_slot(dev, 0, true, min(a->x, b->x),
>>                                             min(a->y, b->y));
>>               synaptics_report_semi_mt_slot(dev, 1, true, max(a->x, b->x),
>>                                             max(a->y, b->y));
>> -     } else if (num_fingers == 1) {
>> +     } else if ((num_fingers == 1) && finger_touched(a)) {
>>               synaptics_report_semi_mt_slot(dev, 0, true, a->x, a->y);
>>               synaptics_report_semi_mt_slot(dev, 1, false, 0, 0);
>>       } else {
>
> So if num_fingers == 2 and only one of a and b returns
> finger_touched() == true, we fall back to zero fingers?

Actually, yes.   In this case, we will have 2 x's and 2 y's, but not
know which belong to a good finger and which belong to a too light
finger....  sigh... synaptics... sigh...

>
>> @@ -1040,8 +1045,10 @@ static void synaptics_process_packet(struct psmouse *psmouse)
>>        * BTN_TOUCH has to be first as mousedev relies on it when doing
>>        * absolute -> relative conversion
>>        */
>> -     if (hw.z > 30) input_report_key(dev, BTN_TOUCH, 1);
>> -     if (hw.z < 25) input_report_key(dev, BTN_TOUCH, 0);
>> +     if (finger_touched(&hw))
>> +             input_report_key(dev, BTN_TOUCH, 1);
>> +     if (hw.z < 25)
>> +             input_report_key(dev, BTN_TOUCH, 0);
>>
>>       if (num_fingers > 0) {
>>               input_report_abs(dev, ABS_X, hw.x);
>
> Why not introduce hysteresis for all fingers here? There is an example
> implementation in bcm5974.c in the same directory.

Good idea, can it be in a different, follow-up patch?

>
> Thanks,
> Henrik

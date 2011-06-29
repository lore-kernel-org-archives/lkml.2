Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480Ab1F2Qsr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 12:48:47 -0400
Received: from smtp-out.google.com ([216.239.44.51]:57460 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757242Ab1F2Qsk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 12:48:40 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:from:
	date:x-google-sender-auth:message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=tgKTl+VZzX1ZfW7eDOSuEIJF5VvPF9zZ2LuMHQ93Y/Tju5bV8JtnKtaYMzWeuw9jh
	eFqtW+iSNuAqSEXbmX7rA==
MIME-Version: 1.0
In-Reply-To: <BANLkTinX-mkjQ=qMXra5GLeMK+cb9w+9_Q@mail.gmail.com>
References: <1309324042-22943-1-git-send-email-djkurtz@chromium.org>
 <1309324042-22943-4-git-send-email-djkurtz@chromium.org> <BANLkTinX-mkjQ=qMXra5GLeMK+cb9w+9_Q@mail.gmail.com>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Thu, 30 Jun 2011 00:48:17 +0800
X-Google-Sender-Auth: 20rWbLaN8mcOX_lGDHJ1jFq6eKI
Message-ID: <CAGS+omCXmc-4WXJDeQKY3uo8h7xBgqfZi=rmDHg2xwWK2OQxMg@mail.gmail.com>
Subject: Re: [PATCH 03/12] Input: synaptics - fix minimum reported ABS_TOOL_WIDTH
To: Chris Bagwell <chris@cnpbagwell.com>
Cc: dmitry.torokhov@gmail.com, rydberg@euromail.se,
        chase.douglas@canonical.com, rubini@cvml.unipv.it,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        derek.foreman@collabora.co.uk, daniel.stone@collabora.co.uk,
        olofj@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

Thanks for taking a look!

On Wed, Jun 29, 2011 at 9:28 PM, Chris Bagwell <chris@cnpbagwell.com> wrote:
> On Wed, Jun 29, 2011 at 12:07 AM,  <djkurtz@chromium.org> wrote:
>> From: Daniel Kurtz <djkurtz@chromium.org>
>>
>> Synaptics touchpads report a 'w' value in each data report.
>> For touchpads that support palm detection, when there is a single finger
>> on the pad, the 'w' value reports its width in the range 4 to 15.
>> Thus, the minimum valid width is 4.
>
> FYI: I had debated on this as well.  When driver was first modified to
> report min/max width, the min width of zero was chosen because when
> not touching the pad a value of zero is forced by driver to user.  So
> the range is 0, 4-15.

Yup, good catch.  I now see that this is true for the legacy single-touch case.
For consistency with the existing implementation, I'm ok to drop this patch.

I think we can still keep the range 4-15 for the ABS_MT_TOUCH_MAJOR
axis, though, right?
A pure-mt userspace app can get the correct width range, and deduce 0
fingers from the fact that all MT-B slots have tracking_id == -1.

-Dan

>>
>> Note: Other values of 'w' are used to report special conditions:
>>  w=0: 2 fingers are on the pad
>>  w=1: 3 or more fingers are on the pad
>>  w=2: the packet contains "Advanced Gesture Mode" data.
>>
>> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
>> ---
>>  drivers/input/mouse/synaptics.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
>> index f6d0c04..a4b7801 100644
>> --- a/drivers/input/mouse/synaptics.c
>> +++ b/drivers/input/mouse/synaptics.c
>> @@ -706,7 +706,7 @@ static void set_input_params(struct input_dev *dev, struct synaptics_data *priv)
>>        }
>>
>>        if (SYN_CAP_PALMDETECT(priv->capabilities))
>> -               input_set_abs_params(dev, ABS_TOOL_WIDTH, 0, 15, 0, 0);
>> +               input_set_abs_params(dev, ABS_TOOL_WIDTH, 4, 15, 0, 0);
>>
>>        __set_bit(EV_KEY, dev->evbit);
>>        __set_bit(BTN_TOUCH, dev->keybit);
>> --
>> 1.7.3.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-input" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

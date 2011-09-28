Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802Ab1I1XXC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 19:23:02 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39817 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810Ab1I1XW5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 19:22:57 -0400
MIME-Version: 1.0
In-Reply-To: <20110927115207.GA3701@polaris.bitmath.org>
References: <1316311297-12765-1-git-send-email-martinez.javier@gmail.com>
 <1316311297-12765-2-git-send-email-martinez.javier@gmail.com> <20110927115207.GA3701@polaris.bitmath.org>
From: Javier Martinez Canillas <martinez.javier@gmail.com>
Date: Thu, 29 Sep 2011 01:22:41 +0200
Message-ID: <CAAwP0s0Jrc4zRAw4RUBWvSpiKNT0TqxYizqQZVihkkEy5+gcMw@mail.gmail.com>
Subject: Re: [PATCH V3 1/3] Input: cyttsp - Cypress TTSP capacitive
 multi-touch screen support
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kevin McNeely <kev@cypress.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 1:52 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi Javier,
>
>> Cypress TrueTouch(tm) Standard Product controllers are found in
>> a wide range of embedded devices. This driver add support for a
>> variety of TTSP controllers.
>
> please find some comments below.
>

Hello Henrik,

Thanks a lot for the review

>> +/* Slots management */
>> +#define CY_MAX_FINGER               4
>> +#define CY_UNUSED                   0
>> +#define CY_USED                     1
>
> These two look like bool, please use as bool instead.
>
>> +#define CY_MAX_ID                   15
>
> Why not 16 here?
>

Because as far as I know there are only 14 possible tracking ids
(1-14), not 16. 15 and 0 are not valid track ids.

When a contact lifts off the hardware reports a magic number (15) for
it. Also, the sequence always start with 1 which is the track id that
gets the first contact reported by the touch.

>> +
>> +/* TrueTouch Standard Product Gen3 interface definition */
>> +struct cyttsp_xydata {
>> +     u8 hst_mode;
>> +     u8 tt_mode;
>> +     u8 tt_stat;
>> +     struct cyttsp_tch tch1;
>> +     u8 touch12_id;
>> +     struct cyttsp_tch tch2;
>> +     u8 gest_cnt;
>> +     u8 gest_id;
>> +     struct cyttsp_tch tch3;
>> +     u8 touch34_id;
>> +     struct cyttsp_tch tch4;
>> +     u8 tt_undef[3];
>> +     u8 act_dist;
>> +     u8 tt_reserved;
>> +} __packed;
>
> Too bad the touches are not an array here...
>

Yes, the problem is that the offset between touches is not uniform.
For tch1 and tch2 is only 8 bits but the offset between tch2 and tch3
is 16 (u8 * 2) for example.

>> +     int slot_curr[CY_MAX_ID];
>> +     int slot_prev[CY_MAX_ID];
>
> These two are not needed; the input core will take care of duplicates,
> so slot_prev can be removed. Also, the set of current slots can be
> tracked using a temporary bitmask, so slot_curr can be removed as well.

Perfect, I'll remove both. I didn't know that the input core took care
of duplicates, sorry for not getting this from the docs.

>> +
>> +static void cyttsp_get_tch(struct cyttsp_xydata *xy_data, int idx,
>> +                        struct cyttsp_tch **tch)
>> +{
>> +     switch (idx) {
>> +     case 0:
>> +             *tch = &xy_data->tch1;
>> +             break;
>> +     case 1:
>> +             *tch = &xy_data->tch2;
>> +             break;
>> +     case 2:
>> +             *tch = &xy_data->tch3;
>> +             break;
>> +     case 3:
>> +             *tch = &xy_data->tch4;
>> +             break;
>> +     }
>> +}
>
> How about returning a const struct cyttsp_tch* here instead.
>

Ok, will return a struct pointer instead.

>> +
>> +     cyttsp_extract_track_ids(&xy_data, ids);
>> +
>> +     for (i = 0; i < num_cur_tch; i++) {
>> +             ts->slot_curr[ids[i] - 1] = CY_USED;
>
> Why the -1 here? Since the values are provably between 0 and 15, there
> is no need to change them further.

As I told you before is a HW thing. I looked at the track ids reported
by the touchscreen and their values are always between 1 and 14. So I
did the -1 to avoid having and unused element in the array. (I don't
have the HW datasheet so maybe I'm wrong with this)

Kevin?

>
> Also, the above line could be replaced by "used |= 1 << ids[i]", for instance.
>
>> +
>> +             cyttsp_get_tch(&xy_data, i, &tch);
>> +
>> +             x = be16_to_cpu(tch->x);
>> +             y = be16_to_cpu(tch->y);
>> +             z = tch->z;
>> +
>> +             cyttsp_report_slot(ts->input, ids[i] - 1, x, y, z);
>
> Ditto, -1.
>
>> +     }
>> +
>> +     for (i = 0; i < CY_MAX_ID; i++) {
>> +             if (ts->slot_prev[i] == CY_USED &&
>> +                 ts->slot_curr[i] == CY_UNUSED)
>> +                     cyttsp_report_slot_empty(ts->input, i);
>> +             ts->slot_prev[i] = ts->slot_curr[i];
>> +             ts->slot_curr[i] = CY_UNUSED;
>> +     }
>
> Input core handles duplicate calls, so the above could be simplified.
>

Perfect, will clean this code.

>> +
>> +     for (i = 0; i < CY_MAX_ID; i++) {
>> +             ts->slot_prev[i] = CY_UNUSED;
>> +             ts->slot_curr[i] = CY_UNUSED;
>> +     }
>
> Could be removed.
>

Yes, I'll do that.

>
> Thanks,
> Henrik
>

Thanks for your comments, I will work on these issues and resubmit a
new version of the patch-set.

Best regards,

-- 
Javier Martínez Canillas
(+34) 682 39 81 69
Barcelona, Spain

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab1BHLk0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 06:40:26 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:57103 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811Ab1BHLkZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 06:40:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RAV0b5MwyUYB9VYy6xHR1CUgvecz/+tj35r6qs34SwgNbAvmoXZc2U9sJXCb7tPGWd
         Fk2RvssUG/dNmbGRiQQIFfSkNIkPmt9STQInmp+Bji38j/UpkXLLq3382OPb4c3hTpN0
         J4qTlBN/reBk4ustBz2rFyElt9EyeeKg9DhUw=
MIME-Version: 1.0
In-Reply-To: <4D4F4B18.6030502@metafoo.de>
References: <1296953291-10373-1-git-send-email-lars@metafoo.de>
	<AANLkTimN1ACy=rREGhvAqTwfywHb7_Td7ZeKosQc9txC@mail.gmail.com>
	<4D4F4B18.6030502@metafoo.de>
Date: Tue, 8 Feb 2011 13:40:24 +0200
Message-ID: <AANLkTimgejf7D9LWyxa=W7Hc4MTWEotMnr7h2SC9iPCQ@mail.gmail.com>
Subject: Re: [PATCH 00/14] POWER: BQ27x00: New Properties, fixes, bq27000 support
From: Grazvydas Ignotas <notasas@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 7, 2011 at 3:30 AM, Lars-Peter Clausen <lars@metafoo.de> wrote:
> On 02/07/2011 01:58 AM, Grazvydas Ignotas wrote:
>> On Sun, Feb 6, 2011 at 2:47 AM, Lars-Peter Clausen <lars@metafoo.de> wrote:
>>> This series has so far been tested with the bq27000 and the bq27200 battery, but
>>> not with the bq27500 battery, so it would be nice if somebody with a board
>>> containing such a battery could test the patches to make sure that there are no
>>> regressions.
>>
>> Trying this on pandora board (bq27500 over i2c) and it seems there is
>> something wrong with the cache, I'm always getting the old values. I'm
>> reading them manually over sysfs, uptime is over 25min but values
>> still match ones on boot, even after turning off the backlight.
>>
>> Looking at the code delayed_work handling looks suspicious,
>> bq27x00_battery_get_property() flushes it and nothing ever reschedules
>> it. Other than that all new property values looks sane.
>
> Hi
>
> Hm, I tought that rescheduling from withing the work function would work, even when
> flushing the work, at least it did here.
> But the current code is broken if poll_interval is 0 anyway, cause then it wont
> reschedule itself and is never run again.
>
> Could you try:
>
> if (time_is_before_jiffies(di->last_update + 6 * HZ)) {
>        cancel_delayed_work_sync(&di->work);
>        bq27x00_battery_work(&di->work);
> }

That works. However I wonder about the delay, I've experimentally
determined that bq27500 refreshes in about a second, so before this
series I could for example run 'watch -n 1 cat current_now' and see
current changes almost in realtime (when toggling backlight, for
example). Maybe we could have different cache timeout for different
chips or have quickly changing properties (like current and voltage)
bypass the cache.

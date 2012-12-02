Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796Ab2LBMSe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 07:18:34 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:62334 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab2LBMSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 07:18:33 -0500
X-Greylist: delayed 479 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Dec 2012 07:18:32 EST
MIME-Version: 1.0
In-Reply-To: <CAPVoSvRssJSzjg1wZ8g9-05Y50xVkVcQqsnZ92Ru6mWZgGrfKg@mail.gmail.com>
References: <CAPVoSvQNVnz=NrkNaZ4G_k76WuVaAJ24uEXkAyJvDNLHHPs1Kw@mail.gmail.com>
	<20121127120528.637099aa@notabene.brown>
	<CAPVoSvRssJSzjg1wZ8g9-05Y50xVkVcQqsnZ92Ru6mWZgGrfKg@mail.gmail.com>
Date: Sun, 2 Dec 2012 13:10:33 +0100
Message-ID: <CAPVoSvTOQT65zYbz++jbbaT63VbVKchYdhip58R8S6cPxbW2cw@mail.gmail.com>
Subject: Re: Hang in md-raid1 with 3.7-rcX
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 8:08 AM, Torsten Kaiser
<just.for.lkml@googlemail.com> wrote:
> On Tue, Nov 27, 2012 at 2:05 AM, NeilBrown <neilb@suse.de> wrote:
>> Can you test to see if this fixes it?
>
> Patch applied, I will try to get it stuck again.
> I don't have a reliable reproducers, but if the problem persists I
> will definitly report back here.

With this patch I was not able to recreate the hang. Lacking an 100%
way of recreating this, I can't be completely sure of the fix, but as
you understood from the code how this hang could happen, I'm quite
confident that the fix is working.

(As I do not use the raid10 personality only patching raid1.c was
sufficient for me, I didn't test the version that also patched
raid10.c as its not even compiled on my kernel.)

Thanks for the fix!

Torsten

>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index 636bae0..a0f7309 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -963,7 +963,7 @@ static void raid1_unplug(struct blk_plug_cb *cb, bool from_schedule)
>>         struct r1conf *conf = mddev->private;
>>         struct bio *bio;
>>
>> -       if (from_schedule) {
>> +       if (from_schedule || current->bio_list) {
>>                 spin_lock_irq(&conf->device_lock);
>>                 bio_list_merge(&conf->pending_bio_list, &plug->pending);
>>                 conf->pending_count += plug->pending_cnt;
>>

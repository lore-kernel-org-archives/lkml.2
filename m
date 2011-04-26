Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307Ab1DZIrX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 04:47:23 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:43484 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab1DZIrV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 04:47:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vOwyhfefNXDT46A09nI+FXimlgJRL1gADj9gomuAJqBQ2QHFz912qPeJftv4+l50et
         Ga4QG6ePc2uU2WG0GNPlgPIXmGz+80sO44tcdu6DKlRlqNNY/UGOP6CWw6EDRQ0Oe57c
         MSTrK8JwyeMQFSKPGDwwjJ7sDdJjf8u0rwP1o=
MIME-Version: 1.0
In-Reply-To: <20110426162438.F393.A69D9226@jp.fujitsu.com>
References: <20110426154037.F38B.A69D9226@jp.fujitsu.com>
	<BANLkTikXR-A-za7dd6FDqc6B0fLhi4LbJg@mail.gmail.com>
	<20110426162438.F393.A69D9226@jp.fujitsu.com>
Date: Tue, 26 Apr 2011 16:47:19 +0800
Message-ID: <BANLkTinosxKZ9WnAHsfbaOgNx2q1+CxFRw@mail.gmail.com>
Subject: Re: [PATCH 1/2] virtio_balloon: disable oom killer when fill balloon
From: Dave Young <hidave.darkstar@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 3:22 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> On Tue, Apr 26, 2011 at 2:38 PM, KOSAKI Motohiro
>> <kosaki.motohiro@jp.fujitsu.com> wrote:
>> >> When memory pressure is high, virtio ballooning will probably cause oom killing.
>> >> Even if alloc_page with GFP_NORETRY itself does not directly trigger oom it
>> >> will make memory becoming low then memory alloc of other processes will trigger
>> >> oom killing. It is not desired behaviour.
>> >>
>> >> Here disable oom killer in fill_balloon to address this issue.
>> >>
>> >> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
>> >> ---
>> >>  drivers/virtio/virtio_balloon.c |    3 +++
>> >>  1 file changed, 3 insertions(+)
>> >>
>> >> --- linux-2.6.orig/drivers/virtio/virtio_balloon.c    2010-10-13 10:14:38.000000000 +0800
>> >> +++ linux-2.6/drivers/virtio/virtio_balloon.c 2011-04-26 11:38:43.979785141 +0800
>> >> @@ -25,6 +25,7 @@
>> >>  #include <linux/freezer.h>
>> >>  #include <linux/delay.h>
>> >>  #include <linux/slab.h>
>> >> +#include <linux/oom.h>
>> >>
>> >>  struct virtio_balloon
>> >>  {
>> >> @@ -102,6 +103,7 @@ static void fill_balloon(struct virtio_b
>> >>       /* We can only do one array worth at a time. */
>> >>       num = min(num, ARRAY_SIZE(vb->pfns));
>> >>
>> >> +     oom_killer_disable();
>> >
>> > I think this patch need proper comment at least. My first impression
>> > is, "Hm, __GFP_NORETRY should prevent oom, why is this necessary?".
>> > So, this actually prevent _another_ thread call out_of_memory().
>>
>> Thanks, will fix.
>>
>> > Also, Here doesn't have any exclusion against hibernation (ie another
>> > oom_killer_disable() callsite). It should be described why lock is
>> > unnecessary.
>>
>> Good catch, but lock should better be handled in oom_killer_disable
>> function itself,
>> What do you think?
>>
>> For oom killer multi user there's more problem, if process A disable
>> oom killer then Process B enable oom killer, it is not A want to see,
>> Any thoughts?
>
> If baloon and hibernation don't have any implicit exclusion, you are
> right.

For this case, hibernation will freeze balloon thread before call
oom_killer_disable, so there's no problem.

If we consider future users of oom_killer_disabled, we will
have to deal with it.

>
> Sorry, I don't virtio internal. please don't ask me.
>
>
>
>



-- 
Regards
dave

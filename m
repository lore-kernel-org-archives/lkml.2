Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab0L2PnH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 10:43:07 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54737 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab0L2PnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 10:43:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=S73tu3Od/zggDEy3RpNoHJZHcF8vzhCyhOiO0+pgiQyHTm5+Zz2k7nycCtD1u2eOVA
         rIEWe3xwocwlbW1h7+H0fexU16CRCxRvMKj6OX6K4jT0MnhSAfl2MboKwkx3Vz/i9npX
         a75ONnfAxktpgKJFWIEZWSt+zL1ItAx44VG5w=
MIME-Version: 1.0
In-Reply-To: <20101226131205.GA5757@zhy>
References: <AANLkTinvHP4rZ6PSyEOJ_ZJ2chRJX0ZyzuhNoCRrO1wK@mail.gmail.com>
	<AANLkTikVQU6ozp0H1u7ghd0=miYyUJL62uP=0FBZSLok@mail.gmail.com>
	<AANLkTimc0FwBhj5MsnibTTq94AgaQgqCKEXNSOvM_XjE@mail.gmail.com>
	<20101225021209.GA11183@zhy>
	<AANLkTimez6segEYEsdsvELqvHjrfY4rPQg6CG_7vyxCq@mail.gmail.com>
	<20101226131205.GA5757@zhy>
Date: Wed, 29 Dec 2010 23:43:03 +0800
Message-ID: <AANLkTimWTKsRnL_=kiD-8Nc7Gc2SeW024TdWCYChXJdP@mail.gmail.com>
Subject: Re: [PATCH] fix unsafe operation in high resolution timer
From: Hillf Danton <dhillf@gmail.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 26, 2010 at 9:12 PM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> On Sat, Dec 25, 2010 at 10:19:11PM +0800, Hillf Danton wrote:
>> > But for a hrtimer which is not free in its callback, like a
>> > static defined one. the hrtimer could be referenced at the same
>> > time. So here you cann't just delete the two lines.
>>
>> After callback, as you agree, it is hard to determine in the current
>> implementation if the hrtimer is static defined, though another bit
>> could be added, say, in the flag word of hrtimer
>
> Yeah, that is an option, like a flag FREE_IN_CALLBACK/ONESHOT which
> indicate that. Or just let the callback return another value like
> HRTIMER_FREED. But as I said before I'm not sure what's the best way
> to fix that. And maybe there's more suitable method.
>
> BTW, is there any user who free the hrtimer in its callback?
>
>> , so cutting the two
>> lines off is deserved.
>> And more, who will take care of the NORESTART again after callback?
>
> It's not related to NORESTART, just HRTIMER_STATE_CALLBACK.
> hrtimer'strategy somehow depends on HRTIMER_STATE_CALLBACK.
> You can take a look at the caller of hrtimer_callback_running().
>

Then the callback is responsible for signaling correctly.
Hillf
---

--- a/include/linux/hrtimer.h	2010-11-01 19:54:12.000000000 +0800
+++ b/include/linux/hrtimer.h	2010-12-29 23:43:16.000000000 +0800
@@ -44,6 +44,7 @@ enum hrtimer_mode {
 enum hrtimer_restart {
 	HRTIMER_NORESTART,	/* Timer is not restarted */
 	HRTIMER_RESTART,	/* Timer must be restarted */
+	HRTIMER_RECLAIM,	/* Timer is recycled */
 };

 /*
--- a/kernel/hrtimer.c	2010-11-01 19:54:12.000000000 +0800
+++ b/kernel/hrtimer.c	2010-12-29 23:45:48.000000000 +0800
@@ -1225,9 +1225,13 @@ static void __run_hrtimer(struct hrtimer
 	raw_spin_unlock(&cpu_base->lock);
 	trace_hrtimer_expire_entry(timer, now);
 	restart = fn(timer);
+	if (restart != HRTIMER_RECLAIM)
 	trace_hrtimer_expire_exit(timer);
 	raw_spin_lock(&cpu_base->lock);

+	if (restart == HRTIMER_RECLAIM)
+		return;
+
 	/*
 	 * Note: We clear the CALLBACK bit after enqueue_hrtimer and
 	 * we do not reprogramm the event hardware. Happens either in

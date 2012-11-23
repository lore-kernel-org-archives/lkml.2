Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296Ab2KWXmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 18:42:36 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:44104 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231Ab2KWXmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 18:42:35 -0500
MIME-Version: 1.0
In-Reply-To: <20121123232600.5e0c5aab.shmulik.ladkani@gmail.com>
References: <1353672809-4768-1-git-send-email-elezegarcia@gmail.com>
	<20121123232600.5e0c5aab.shmulik.ladkani@gmail.com>
Date: Fri, 23 Nov 2012 20:42:35 -0300
Message-ID: <CALF0-+VLju8MNu=T9_qVZJsQK6w7H9gq_qnTKTySKPQnZi5QTA@mail.gmail.com>
Subject: Re: [RFC/PATCH] ubi: Replace wear leveling thread with a workqueue
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Artem Bityutskiy <dedekind1@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shmulik,

Thanks for the review.

On Fri, Nov 23, 2012 at 6:26 PM, Shmulik Ladkani
<shmulik.ladkani@gmail.com> wrote:
[...]
>> -             spin_lock(&ubi->wl_lock);
>> -             if (list_empty(&ubi->works) || ubi->ro_mode ||
>
> Originally, 'ubi_thread' did nothing if 'ubi->ro_mode'.
> This filtering is missing from 'ubi_wl_do_work' implementation.
> How do we guarantee 'ubi_wl_do_work' is never queued when in RO mode?
>

I believe that we do this through ubi->wq_enabled. See here:

static void __schedule_ubi_work(struct ubi_device *ubi, struct ubi_work *wrk)
{
        spin_lock(&ubi->wl_lock);
        list_add_tail(&wrk->list, &ubi->works);
        ubi_assert(ubi->works_count >= 0);
        ubi->works_count += 1;
        if (ubi->wq_enabled && !ubi_dbg_is_bgt_disabled(ubi))
                queue_work(ubi->workqueue, &ubi->work);
        spin_unlock(&ubi->wl_lock);
}

As you can see from above, work is queued only if ubi->wq_enabled
(which should be a boolean and probably with inverse logic,
but that's not important).
Unless I've missed something, this patch doesn't change that.

[...]
>> +     if (failures++ > WL_MAX_FAILURES) {
>> +             /*
>> +              * Too many failures, disable the workqueue and
>> +              * switch to read-only mode.
>> +              */
>
> This condition will never be met (after your change), since 'failures'
> is local to 'ubi_wl_do_work' (per work invocation).
>
> Formerly, 'failures' was local to 'ubi_thread' (per ubi device's
> thread), hence it was possible that several 'do_works()' calls have
> failed during thread's lifetime, reaching the WL_MAX_FAILURES limit.
>
> If we'd like to preseve the 'failures' semantics, 'failures' should be
> an 'ubi_device' property.
>

Ah, totally right. I overlooked and assumed 'failures' was per-device.
Now I see it's local scoped. Will fix in V2.

> One last thing:
> Some variables and functions (debug and sysfs) are still named *bgt*,
> which is confusing.
>

I made specific reference to that in the commit message.
I didn't want to change any userspace related to prevent
userspace tools/scripts from stop working.

If we all agree (and specially Artem) I can rename everything
to something like wq_foo, wq_bar.

Thanks again!

    Ezequiel

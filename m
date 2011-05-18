Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809Ab1ERJrY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 05:47:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33008 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756378Ab1ERJrX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 05:47:23 -0400
MIME-Version: 1.0
In-Reply-To: <20110518050729.GA16870@mtj.dyndns.org>
References: <20110517102713.GJ20624@htj.dyndns.org> <20110517102824.GK20624@htj.dyndns.org>
 <20110517102853.GL20624@htj.dyndns.org> <BANLkTimj2guK6kw7QSijYZyvoRY+JKgbTg@mail.gmail.com>
 <20110517151107.GQ20624@htj.dyndns.org> <BANLkTikpwk-hJs+TF7TJB38JsvOvHk2UMQ@mail.gmail.com>
 <20110517152742.GR20624@htj.dyndns.org> <BANLkTi=-Ak5vhCFxgc2rt2rft0PE9XJiTA@mail.gmail.com>
 <20110518050729.GA16870@mtj.dyndns.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 18 May 2011 02:46:30 -0700
Message-ID: <BANLkTi=0_bv7s6=i2v-iP0vQmHHT3=tm8w@mail.gmail.com>
Subject: Re: [PATCH RESEND 2/3 v2.6.39-rc7] block: make disk_block_events()
 properly wait for work cancellation
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Sitsofe Wheeler <sitsofe@yahoo.com>,
        Borislav Petkov <bp@alien8.de>, Meelis Roos <mroos@linux.ee>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 10:07 PM, Tejun Heo <tj@kernel.org> wrote:
>
>> Just make the semaphore protect the count - and you're done.
>
> Yeah, with that gone, we don't even need the open-coding inside
> disk_check_events().  It can simply call syncing block and unblock.
> But, do you want that in -rc7?  Unnecessarily complicated as the
> current code may be, converting the lock to mutex is a larger change
> than adding an outer mutex and I think it would be better to do that
> during the next cycle.

Quite frankly. right now I think I need to just release 2.6.39, and
then for 2.6.40 merge the trivial

  mutex_lock(&ev->mutex);
  if (!ev->block++)
    cancel_delayed_work_sync(&ev->dwork);
  mutex_unlock(&ev->mutex);

with a cc: stable for backporting.

I'd _much_ prefer simple obvious code than have a outer mutex etc.
Just make the rule be that "blocked" is protected by the new
semaphore. I don't think it's used very often, and anybody who wants
to block disk events needs to be in blockable context in order to wait
for the delayed work cancel, right? So we can't be in some atomic
context inside some other spinlock anyway, afaik. And there can be no
lock order issues, since this would always be a new inner lock.

Hmm?

                          Linus

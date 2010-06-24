Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920Ab0FXTWH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 15:22:07 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44001 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab0FXTWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 15:22:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=mlspl4PyVCAmMKLzSfuNE5Q+T2/qqdPSDVW7GSyi3kzlnNRKkLvhwer4IoNoHZ3SqB
         o2LROh3Nq0t+OPDXGzu32SqArxqPeJvoKJXnCLvcI/WquSHmfxWsK2hGK11LWXjBeD/q
         8v9XFiRQSUkF2CjXHgYWs50fH/p3WadgA1d4A=
MIME-Version: 1.0
In-Reply-To: <AANLkTimE_BeA3yiCovC0ckn_MbbH3lpgctLD8zD5ir6j@mail.gmail.com>
References: <alpine.DEB.2.00.1006180940140.11575@router.home>
	<20100621200118.GA4021@nb-core2.darkstar.lan>
	<4C223657.3030507@colorfullife.com>
	<AANLkTimE_BeA3yiCovC0ckn_MbbH3lpgctLD8zD5ir6j@mail.gmail.com>
Date: Thu, 24 Jun 2010 21:22:00 +0200
Message-ID: <AANLkTinw8qzAkHTNB05PqfWMQmuya1Dq6AZCgz2nWx6_@mail.gmail.com>
Subject: Re: 2.6.35-rc3 deadlocks on semaphore operations
From: Luca Tettamanti <kronos.it@gmail.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Julia Lawall <julia@diku.dk>, Andrew Morton <akpm@linux-foundation.org>,
       maciej.rutecki@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 23, 2010 at 9:14 PM, Luca Tettamanti <kronos.it@gmail.com> wrote:
> On Wed, Jun 23, 2010 at 6:29 PM, Manfred Spraul
> <manfred@colorfullife.com> wrote:
>> Hi,
>>
>> I think I found it:
>> Previously, queue.status was never IN_WAKEUP when the semaphore spinlock was
>> held.
>>
>> The last patch changes that:
>> Now the change from IN_WAKEUP to the final result code happens after the the
>> semaphore spinlock is dropped.
>> Thus a task can observe IN_WAKEUP even when it acquired the semaphore
>> spinlock.
>>
>> As a result, semop() sometimes returned 1 (IN_WAKEUP) for a successful
>> operation.
>>
>> Attached is a patch that should fix the bug.
>
> Apache seems fine.

Argh, "seems" was indeed appropriate. Manfred your patch does
alleviate the problem but something is still wrong. I noticed (I'm
developing an ajax heavy web app) that sometimes an apache worker
hangs; I can reproduce the problem with ab (apache benchmark) and a
high concurrency level (I'm testing with 100 and 10k requests, and I
get only 2-5 dropped requests). This does not happen with 2.4.34.
Any idea on how I can debug this further?

Luca

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab2KEOBN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 09:01:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42281 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab2KEOBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 09:01:11 -0500
Message-ID: <5097C6A1.9000405@canonical.com>
Date: Mon, 05 Nov 2012 15:01:05 +0100
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Thomas Hellstrom <thellstrom@vmware.com>
CC: airlied@gmail.com, airlied@redhat.com, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 4/4] drm/ttm: Optimize reservation slightly
References: <1352122278-12896-1-git-send-email-thellstrom@vmware.com> <1352122278-12896-5-git-send-email-thellstrom@vmware.com>
In-Reply-To: <1352122278-12896-5-git-send-email-thellstrom@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

Op 05-11-12 14:31, Thomas Hellstrom schreef:
> Reservation locking currently always takes place under the LRU spinlock.
> Hence, strictly there is no need for an atomic_cmpxchg call; we can use
> atomic_read followed by atomic_write since nobody else will ever reserve
> without the lru spinlock held.
> At least on Intel this should remove a locked bus cycle on successful
> reserve.
>
> Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
>
Is that really a good thing to submit when I am busy killing lru lock around reserve? :-)

-	while (unlikely(atomic_cmpxchg(&bo->reserved, 0, 1) != 0)) {
+	while (unlikely(atomic_xchg(&bo->reserved, 1) != 0)) {

Works without lru lock too!

In fact mutexes are done in a similar way[1], except with some more magic, and unlocked state is 1, not 0.
However I do think that to get that right (saves a irq disable in unlock path, and less wakeups in contended
case), I should really just post the mutex extension patches for reservations and ride the flames. It's
getting too close to real mutexes so I really want it to be a mutex in that case. So lets convert it.. Soon! :-)

~Maarten

[1] See linux/include/asm-generic/mutex-xchg.h and linux/include/asm-generic/mutex-dec.h for how
archs generally implement mutex fastpaths.


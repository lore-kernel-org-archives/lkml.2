Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab2EHSDi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 14:03:38 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:60215 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab2EHSDh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 14:03:37 -0400
MIME-Version: 1.0
In-Reply-To: <20120508172352.GQ4802@phenom.ffwll.local>
References: <1336432421-17972-1-git-send-email-marcheu@chromium.org>
	<CA+55aFyd08=eemQsUFvtjerEVQdznhe647w4PmSrPkkEvjNuzg@mail.gmail.com>
	<20120508172352.GQ4802@phenom.ffwll.local>
Date: Tue, 8 May 2012 13:03:36 -0500
X-Google-Sender-Auth: lFy5wVXwxz9xYGRXAVdepzahR7M
Message-ID: <CAF6AEGu0c00py3debbk8YUEpBB-FvaakrFkVKbrH-NuavG3gJA@mail.gmail.com>
Subject: Re: [PATCH] mm: Work around Intel SNB GTT bug with some physical pages.
From: Rob Clark <rob.clark@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, rob.clark@linaro.org,
        =?ISO-8859-1?Q?St=E9phane_Marchesin?= <marcheu@chromium.org>,
        olofj@chromium.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 8, 2012 at 12:23 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Tue, May 08, 2012 at 08:25:38AM -0700, Linus Torvalds wrote:
>> On Mon, May 7, 2012 at 4:13 PM, Stéphane Marchesin <marcheu@chromium.org> wrote:
>> >
>> > In the end, I came up with the ugly workaround of just leaking the
>> > offending pages in shmem.c.
>>
>> Don't leak it.
>>
>> Instead, add it to some RCU list, and free it using RCU. Or some
>> one-second timer or something.
>>
>> That kind of approach should guarantee that it
>>
>>  (a) gets returned to the system
>>
>> but
>>
>>  (b) the returning to the system gets delayed sufficiently that if the
>> i915 driver is doing lots of allocations it will be getting other
>> pages.
>>
>> Hmm?
>
> The problem is also that this only affects Sandybdrige gpus, so we'd need
> to funnel this down to shmfs somehow ... Rob Clarke from Linaro will be
> working on a gemfs to make backing storage allocation more flexible - they
> need that to support some arm gpus. That way round we wouldn't need to put
> some ugly drm/i915 stuff into core shmfs. Rob?

Well, a bit hand-wavey at this point, but the idea is to let the
driver have control of the page allocation via 'struct
address_space_operations'.. but otherwise work in a similar way as
shmfs.

Something like get_xip_mem() is almost what we want, except we don't
want it to populate the pages, we don't want to force a kernel
mapping, and shmem doesn't use it..

I suppose we still need a short term fix for i915, but at least it
would only be temporary.

BR,
-R

> -Daniel
> --
> Daniel Vetter
> Mail: daniel@ffwll.ch
> Mobile: +41 (0)79 365 57 48
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

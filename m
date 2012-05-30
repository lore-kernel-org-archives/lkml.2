Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab2E3MiX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 08:38:23 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:59537 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316Ab2E3MiW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 08:38:22 -0400
MIME-Version: 1.0
X-Originating-IP: [109.186.47.116]
In-Reply-To: <4FC5DD74.4030202@codeaurora.org>
References: <1338017791-9442-1-git-send-email-ohad@wizery.com>
 <1338017791-9442-2-git-send-email-ohad@wizery.com> <4FC5DD74.4030202@codeaurora.org>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 30 May 2012 15:38:01 +0300
Message-ID: <CAK=WgbbwaMAnTGcivC9ZR8K-MtTqHAV3+BgUmk8WjCaayifJxw@mail.gmail.com>
Subject: Re: [PATCH 2/2] remoteproc: remove the now-redundant kref
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Fernando Guzman Lugo <fernando.lugo@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 11:42 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> I was hoping we could use class_for_each_device() and
> class_find_device() to replace all this code. Then we wouldn't need all
> this klist stuff that the class is taking care of already.

Awesome! This really is worth a shot.

>> +/**
>> + * rproc_class_release() - release a remote processor instance
>> + * @dev: the rproc's device
>> + *
>> + * This function should _never_ be called directly.
>> + *
>> + * It will be called by the driver core when no one holds a valid pointer
>> + * to @dev anymore.
>> + */
>
> Why is this added now and not in the previous patch?

Hmm, probably because it was copied from rproc_release, which was
killed in this patch. I can probably shift it to the first patch since
I'm anyway doing some changes.

>> -     /* the rproc will only be released after its refcount drops to zero */
>> -     kref_put(&rproc->refcount, rproc_release);
>> +     /* unroll rproc_alloc. TODO: we may want to let the users do that */
>> +     put_device(&rproc->dev);
>
> Yes I think we want rproc_free() to actually call put_device() the last
> time and free the resources.

Yeah that was one of the options I considered.

In general, we have three options here:
1. Remove this last put_device invocation, and require users to call
rproc_free() even after they call rproc_unregister().
2. Let rproc_unregister() still do this, by calling rproc_free().
3. Let rproc_unregister() still do this, by invoking put_device().

I think that (1) looks better since it makes the interface symmetric
and straight forward.

(2) and (3) may be simper because users only need to call
rproc_unregister and that's it.

I eventually decided against (1) because I was concerned it will only
confuse users at this point.

But if you think that (1) is nicer too then maybe we should go ahead
and do that change.

Thanks,
Ohad.

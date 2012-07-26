Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab2GZCv7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 22:51:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:32843 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab2GZCv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 22:51:58 -0400
MIME-Version: 1.0
In-Reply-To: <20120725135948.GD11152@aftab.osrc.amd.com>
References: <1343149213-10160-1-git-send-email-ming.lei@canonical.com>
	<1343149213-10160-6-git-send-email-ming.lei@canonical.com>
	<20120725135948.GD11152@aftab.osrc.amd.com>
Date: Thu, 26 Jul 2012 10:51:55 +0800
Message-ID: <CACVXFVOBdXubFi7ZRJ2aUHtd8syTzS=yG8GvsCjAOQmihhvwyQ@mail.gmail.com>
Subject: Re: [RFC PATCH 05/13] driver core: firmware loader: introduce firmware_buf
From: Ming Lei <ming.lei@canonical.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 9:59 PM, Borislav Petkov <bp@amd64.org> wrote:

> This is subtle: the caller of fw_free_buf might forget to assign NULL to
> the buf ptr.

Who is the caller? Since it is always called inside firmware loader, we should
make sure that.

> Why not pass struct firmware_priv *fw_priv to the function instead and ...

No, it shouldn't. The lifetime of fw_priv is just same with request_firmware or
its work_func pair, but firmware_buf may live much longer than fw_priv. You
will see that fw_free_buf is the release function of kref in firmware_buf.

>
>> +
>> +     for (i = 0; i < buf->nr_pages; i++)
>> +             __free_page(buf->pages[i]);
>> +     kfree(buf->pages);
>
> assign NULL to the ptr as a last step, when all is done:
>
>         fw_priv->buf = NULL;
>
> This way you're making sure ->buf is NULL after all pages are freed and
> your check above is always correct.

It has been done in _request_firmware_load


>> -             kunmap(fw_priv->pages[page_nr]);
>> +             kunmap(buf->pages[page_nr]);
>>               buffer += page_cnt;
>>               offset += page_cnt;
>>               count -= page_cnt;
>> @@ -320,12 +334,13 @@ out:
>
> While you're at it, you can indent this "out:" label one space to the
> right so that the diff can pick up the function name in the hunk tag
> above instead of the label.

Suppose you are right, it shouldn't be done in this patch since this patch
just converts to firmware_buf.


Thanks,
--
Ming Lei

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab1CGAyS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 19:54:18 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34582 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab1CGAyR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 19:54:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=TvXIlQ/NTULIoDVAk7pHWyqwwKr3656sQqMKB42hBLbLOsHfmlceyOPJ42fuBXrwPQ
         Sg2B3xngq+UNHCLmrbuiaM4Bmmj0HcGMwnc8thTniy4numdMguZ0tO7yujznl9rIRZpT
         +rAZz7MU+YSlvxAQw5cHXJ1Iq/KOU8idy+wPI=
MIME-Version: 1.0
In-Reply-To: <4D715E8A.5070006@fusionio.com>
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
	<1295659049-2688-6-git-send-email-jaxboe@fusionio.com>
	<AANLkTin8FoXX6oqUyW+scwhadyX-TfW16_oKjvngU9-m@mail.gmail.com>
	<20110303221353.GA10366@redhat.com>
	<AANLkTi=MfDzf+-eLbysoP-ZiXX6cV_tVxYE14Vr8FSak@mail.gmail.com>
	<20110304214359.GA18442@redhat.com>
	<4D715E8A.5070006@fusionio.com>
Date: Mon, 7 Mar 2011 08:54:15 +0800
X-Google-Sender-Auth: 1lzd1bqRyh8uoXfnvubGSxLFEH8
Message-ID: <AANLkTi=GNGpA+j18xTNHhUed9TYaDJaT+OkyNBA=L+AO@mail.gmail.com>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
From: Shaohua Li <shli@kernel.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Mike Snitzer <snitzer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/3/5 Jens Axboe <jaxboe@fusionio.com>:
> On 2011-03-04 22:43, Mike Snitzer wrote:
>> On Fri, Mar 04 2011 at  8:02am -0500,
>> Shaohua Li <shli@kernel.org> wrote:
>>
>>> 2011/3/4 Mike Snitzer <snitzer@redhat.com>:
>>>> I'm now hitting a lockdep issue, while running a 'for-2.6.39/stack-plug'
>>>> kernel, when I try an fsync heavy workload to a request-based mpath
>>>> device (the kernel ultimately goes down in flames, I've yet to look at
>>>> the crashdump I took)
>>>>
>>>>
>>>> =======================================================
>>>> [ INFO: possible circular locking dependency detected ]
>>>> 2.6.38-rc6-snitm+ #2
>>>> -------------------------------------------------------
>>>> ffsb/3110 is trying to acquire lock:
>>>>  (&(&q->__queue_lock)->rlock){..-...}, at: [<ffffffff811b4c4d>] flush_plug_list+0xbc/0x135
>>>>
>>>> but task is already holding lock:
>>>>  (&rq->lock){-.-.-.}, at: [<ffffffff8137132f>] schedule+0x16a/0x725
>>>>
>>>> which lock already depends on the new lock.
>>> I hit this too. Can you check if attached debug patch fixes it?
>>
>> Fixes it for me.
>
> The preempt bit in block/ should not be needed. Can you check whether
> it's the moving of the flush in sched.c that does the trick?
yes, it's not related to the lockdep issue. but I think we still need
it. if there is a preempt  between attempt_plub_merge(), we do queue
flush, then we might hit an incomplete list of request->biotail. Am I
missing anything?

Thanks,
Shaohua

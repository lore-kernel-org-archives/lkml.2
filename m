Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab0DTSGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 14:06:21 -0400
Received: from mail-iw0-f197.google.com ([209.85.223.197]:62879 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab0DTSGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 14:06:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=Xj0jGH2FxXBFaYdAwuTdpAxEAMvzu1t7YoBdtopgiJwGPN7puDThkbjhygA6b5T1Qq
         ksq8XLOdMbtib265xekzQks60sxe6/G8Ri758oqxRcqJm/dPTIGWDLo7qvsg2speNosZ
         ssGJdI6gVQq2va/qlnv06Vn3hJ4YsVTGBNh3A=
MIME-Version: 1.0
In-Reply-To: <20100420183252.0c61208f@lxorguk.ukuu.org.uk>
References: <y2kf16bc8301004200640r9485da73p920a2f5c3e2d949e@mail.gmail.com>
	 <20100420183252.0c61208f@lxorguk.ukuu.org.uk>
Date: Tue, 20 Apr 2010 14:06:19 -0400
Message-ID: <r2zf16bc8301004201106le0882f54sbcf4a0c842401695@mail.gmail.com>
Subject: Re: Should calculation of vm.overcommit_ratio be changed?
From: Dave Wright <wrightd@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your reply Alan.

>
> Sounds like the distribution should be tuning the value according to the [available memory?]

Yes, that's one approach and I'll probably recommend that to some
folks, however that would probably just be set at install time, and
there's no guarantee that memory/swap amounts wouldn't change later
(e.g. they added more RAM, and now find they can't "use" it because
overcommit ratio is too low).

>> max commit = min(swap, ram) * overcommit_ratio + max(swap, ram) ?
>>
>
> Which is wromg - some of your RAM ends up eaten by the kernel, by
> pagetables and buffers etc. 50% is probably very conservative but the
> point of VM overcommit is exactly that - and you end up deploying swap
> as a precaution against disaster rather than because you need it.
>

I actually think the current formula does the reverse - rather than
seeing swap as an overrun area, it includes the full amount of swap in
the max commit then adds only a percentage of main memory. I'm not
sure what the original motivation for that was - perhaps preventing a
page-file backed mmap from exhausting physical memory as well?

Setting overcommit to 100 in the absence of swap probably isn't a good
idea, however the default of 50 when there is less swap than RAM is a
problem.

I'm sure there will be resistance to any suggestion about changing the
calculation, since it works fine as long as you know about it and set
it properly for your situation, but I do think a more sensible default
can be found.
My first suggestion was above. Other possible options include:
1. Just changing the default % from 50 to 90

2. max commit = (ram + swap) * overcommit_ratio
[with a default ratio of 90% or more]

3. max commit = ram + swap + overcommit_bytes
[overcommit_bytes is a fixed number of bytes, rather than a
percentage, and can be negative to increase safety or positive to
allow aggressive overcommit]

Any of these options would increase the VM space (and thus usable RAM)
for scenarios where you had more RAM than swap. For scenarios where
you had more swap than RAM, they would allow more of it to be
committed than currently, but you're well into swap at that point
already so it's unlikely that it would hurt performance at all. Any of
them could still be manually tweaked to get a specific result, but the
starting value would make sense in a wider range of conditions.


-Dave Wright

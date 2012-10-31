Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935088Ab2JaIVf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 04:21:35 -0400
Received: from mail.cs.tut.fi ([130.230.4.42]:58847 "HELO mail.cs.tut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932520Ab2JaIV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 04:21:28 -0400
X-Greylist: delayed 605 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Oct 2012 04:21:18 EDT
Message-ID: <5090DD1A.8010801@tut.fi>
Date: Wed, 31 Oct 2012 10:11:06 +0200
From: Janne Kulmala <janne.t.kulmala@tut.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Stefani Seibold <stefani@seibold.net>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] kfifo: round up the fifo size power of 2
References: <1351238218-22648-1-git-send-email-yuanhan.liu@linux.intel.com> <20121029135935.bb8b0b2a.akpm@linux-foundation.org> <20121031055916.GC29509@yliu-dev.sh.intel.com> <1351665033.23165.6.camel@wall-e> <20121030235210.4dfc6ef7.akpm@linux-foundation.org>
In-Reply-To: <20121030235210.4dfc6ef7.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2012 08:52 AM, Andrew Morton wrote:
> On Wed, 31 Oct 2012 07:30:33 +0100 Stefani Seibold <stefani@seibold.net> wrote:
>
>>> Yes, and I guess the same to give them a 64-element one.
>>>
>>>>
>>>> If there's absolutely no prospect that the kfifo code will ever support
>>>> 100-byte fifos then I guess we should rework the API so that the caller
>>>> has to pass in log2 of the size, not the size itself.  That way there
>>>> will be no surprises and no mistakes.
>>>>
>>>> That being said, the power-of-2 limitation isn't at all intrinsic to a
>>>> fifo, so we shouldn't do this.  Ideally, we'd change the kfifo
>>>> implementation so it does what the caller asked it to do!
>>>
>>> I'm fine with removing the power-of-2 limitation. Stefani, what's your
>>> comment on that?
>>>
>>
>> You can't remove the power-of-2-limitation, since this would result in a
>> performance decrease (bit wise and vs. modulo operation).
>
> Probably an insignificant change in performance.
>
> It could be made much smaller by just never doing the modulus operation
> - instead do
>
> 	if (++index == max)
> 		index = 0;
>

This can not be done, since the index manipulation kfifo does not use locks.

> this does introduce one problem: it's no longer possible to distinguish
> the "full" and "empty" states by comparing the head and tail indices.
> But that is soluble.
>
>> Andrew is right, this is an API miss design.  So it would be good to
>> rework the kfifo_init () and kfifo_alloc() to pass in log2 of the size,
>> not the size itself.
>
> The power-of-2 thing is just a restriction in the current
> implementation - it's not a good idea to cement that into the
> interface.  Of course, it could later be uncemented if the
> implementation's restriction was later relaxed.

The index is just increased, and the access side masks the bottom bits 
from that to obtain the actual position. This exploit integer wrapping 
and the index will always wrap correctly to the begin of the fifo.

Using modulus and non-power-of-two size would produce wrong results and 
require adding locking.

-- 
Janne Kulmala <janne.t.kulmala@tut.fi>

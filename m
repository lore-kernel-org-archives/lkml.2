Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184Ab2IRUfY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 16:35:24 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:55489 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772Ab2IRUfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 16:35:21 -0400
MIME-Version: 1.0
In-Reply-To: <20120918192338.GA25845@phenom.dumpdata.com>
References: <20120918143504.GA30585@redhat.com> <CA+55aFxd08idQXqm+JJ6xD+uzX_f7Qa25zFHb-eWBRQcEDPhkg@mail.gmail.com>
 <20120918192338.GA25845@phenom.dumpdata.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 18 Sep 2012 13:35:00 -0700
X-Google-Sender-Auth: iUXNR_3bv3SJO7A_tDrNkwiN-1k
Message-ID: <CA+55aFy6=1vW4CN0_g8BgSKKdxZNZj9Yd2WG=0BFKjish=Vw=g@mail.gmail.com>
Subject: Re: 3.6rc6 slab corruption.
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Suzuki Poulose <suzuki@in.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 12:23 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
>>
>> It should be easyish to fix by just adding a lock around those things.
>
> Like this:

Not quite.

I suspect you need to protect the "read_from_buffer()" call too, since
otherwise the buffer can be free'd by another thread while being
copied to user space..

>>  - the whole format_array_alloc() code is one buggy piece of sh*t,
>> since afaik there is nothing that guarantees that the values cannot
>> change. So the notion of "let's format the output once to know how big
>> it is, and then a second time to actually print things into the array
>> we just allocated based on the first time" is pure and utter garbage,
>> afaik.
>
> Yikes. The fix could be to allocate a buffer large enough for the maximum
> that %u could take * array_size and not bother with the first pass.

That's the simple approach. An alternative approach would be to start
with a reasonable guess as to the size, and use krealloc() if needed
to expand.

What are the realistic array sizes? If we're talking about arrays of
just 16 words or something, just do the maximum (what, 12 bytes per
32-bit word? 11 bytes for the number, and then space/NUL after that).

If we're talking about potentially much bigger arrays, maybe we need
to use krealloc() to handle it without wasting tons of memory for the
common case..

             Linus

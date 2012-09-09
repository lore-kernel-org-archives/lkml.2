Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab2IIRBt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 13:01:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49067 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075Ab2IIRBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 13:01:48 -0400
Message-ID: <504CCB6D.7070005@zytor.com>
Date: Sun, 09 Sep 2012 10:01:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: suresh.b.siddha@intel.com, Sasha Levin <levinsasha928@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, dwmw2@infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org, linux-mm <linux-mm@kvack.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: mtd: kernel BUG at arch/x86/mm/pat.c:279!
References: <1340959739.2936.28.camel@lappy> <CA+1xoqdgKV_sEWvUbuxagL9JEc39ZFa6X9-acP7j-M7wvW6qbQ@mail.gmail.com> <CA+55aFzJCLxVP+WYJM-gq=aXx5gmdgwC7=_Gr2Tooj8q+Dz4dw@mail.gmail.com> <1347057778.26695.68.camel@sbsiddha-desk.sc.intel.com> <CA+55aFwW9Q+DM2gZy7r3JQJbrbMNR6sN+jewc2CY0i1wD_X=Tw@mail.gmail.com> <1347062045.26695.82.camel@sbsiddha-desk.sc.intel.com> <CA+55aFzeKcV5hROLJE31dNi3SEs+s6o0LL=96Kh8QGHPx=aZnA@mail.gmail.com> <1347202600.5876.7.camel@sbsiddha-ivb> <CA+55aFwej93o7aLe_xwV5CGuT0BDyAz54cyWm6Xe3wj-hCT3PA@mail.gmail.com>
In-Reply-To: <CA+55aFwej93o7aLe_xwV5CGuT0BDyAz54cyWm6Xe3wj-hCT3PA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2012 08:31 AM, Linus Torvalds wrote:
> On Sun, Sep 9, 2012 at 7:56 AM, Suresh Siddha <suresh.b.siddha@intel.com> wrote:
>>
>> yes but that is not a valid range I think because of the supported
>> physical address bit limits of the processor and also the max
>> architecture limit of 52 address bits.
>
> But how could the caller possibly know that? None of those internal
> PAT limits are exposed anywhere.
>
> So doing the BUG_ON() is wrong. I'd suggest changing it to an EINVAL.
>
> In fact, BUG_ON() is *always* wrong, unless it's a "my internal data
> structures are so messed up that I cannot continue".
>

I suspect the right answer is doing something like:

	u64 max_phys = 1ULL << boot_cpu_data.x86_phys_bits;

	if (start >= max_phys || end > max_phys || start >= end)
		return -EINVAL;

... although max_phys perhaps should be precalculated and stored in 
struct cpuinfo_x86 instead of being generated de novo.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


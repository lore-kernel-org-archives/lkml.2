Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab2ITC6n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 22:58:43 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:41482 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab2ITC6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 22:58:42 -0400
Message-ID: <505A8585.6030901@linux.vnet.ibm.com>
Date: Thu, 20 Sep 2012 08:25:01 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Suzuki Poulose <suzuki@in.ibm.com>
Subject: Re: 3.6rc6 slab corruption.
References: <20120918143504.GA30585@redhat.com> <CA+55aFxd08idQXqm+JJ6xD+uzX_f7Qa25zFHb-eWBRQcEDPhkg@mail.gmail.com> <20120918192338.GA25845@phenom.dumpdata.com> <CA+55aFy6=1vW4CN0_g8BgSKKdxZNZj9Yd2WG=0BFKjish=Vw=g@mail.gmail.com> <20120918203713.GB19300@phenom.dumpdata.com> <CA+55aFzZvFeCLF8fw=NYFN7C_8ObwJMeK13bN8xRodKQ0QJkTQ@mail.gmail.com> <20120919191652.GA14631@phenom.dumpdata.com> <alpine.DEB.2.00.1209191427460.6273@chino.kir.corp.google.com> <alpine.DEB.2.00.1209191438200.21378@chino.kir.corp.google.com> <505A7F75.8000405@linux.vnet.ibm.com> <alpine.DEB.2.00.1209191938490.10953@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1209191938490.10953@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12092002-3568-0000-0000-0000027D2EA4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2012 08:16 AM, David Rientjes wrote:
> On Thu, 20 Sep 2012, Raghavendra K T wrote:
>
>> Only problem, I find is histogram data expands dynamically (because it
>> changes). I think having static allocation of 352 bytes as suggested
>> Linus is a good idea.
>>
>
> Certainly, but it's a different topic and would be a subsequent patch to
> either my patch or Konrad's patch.  Before that's done, I think we should
> fix the race condition that currently exists either by:
>
>   - merging my patch (which I can sign-off and write a changelog for if
>     Konrad agrees), or
>
>   - merging Konrad's patch and introducing a mutex so that it's possible to
>     do many reads to collect statistics after opening the file a single
>     time with a single fd.
>
> Since these files are incapable of doing lseek, it would seem that my
> patch would be best and you'd simply want to close() + open() to read new
> data, which also guarantees that all readers get the same information.
> The only reason I hesitate on that and will defer to Konrad's opinion is
> because the way the code is currently written looks like it was intended
> to copy the data are read() rather than open(); in other words, it almost
> seems as if they were made to be non-seekable after the u32_array_read()
> implementation was complete and it was at one time possible to do an
> lseek(SEEK_SET).

Yes. common use case is just open once,read and close.
i.e. cat /sys/kernel/debug/../histoblocked

I also don't see why we have to keep fd open to read it.
But yes let Konrad comment on that.


> After that's fixed, and to address your concern, we can simply do the
> allocation of file->private_data for the maximum size possible when the
> file is created as a follow-up patch.

I agree, missed that once we do a open and then read it we are done.


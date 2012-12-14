Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab2LNHgY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 02:36:24 -0500
Received: from mx1.fusionio.com ([66.114.96.30]:35406 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827Ab2LNHgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 02:36:22 -0500
X-ASG-Debug-ID: 1355470581-03d6a50cb5dd08a0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <50CAD6D9.5070703@fusionio.com>
Date: Fri, 14 Dec 2012 08:35:53 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Jack Wang <jack.wang.usish@gmail.com>
CC: Kent Overstreet <koverstreet@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "zab@redhat.com" <zab@redhat.com>, "bcrl@kvack.org" <bcrl@kvack.org>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 00/26] AIO performance improvements/cleanups, v2
References: <1354568322-29029-1-git-send-email-koverstreet@google.com> <20121213211808.GJ25017@kernel.dk> <CA+res+SKXjXTgrxPaj+kuekd-CZMp4POkSpsdJ7Csfg0HsD=bA@mail.gmail.com>
X-ASG-Orig-Subj: Re: [PATCH 00/26] AIO performance improvements/cleanups, v2
In-Reply-To: <CA+res+SKXjXTgrxPaj+kuekd-CZMp4POkSpsdJ7Csfg0HsD=bA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1355470581
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -1.90
X-Barracuda-Spam-Status: No, SCORE=-1.90 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=CN_BODY_332
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.116970
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.12 CN_BODY_332            BODY: CN_BODY_332
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-12-14 03:26, Jack Wang wrote:
> 2012/12/14 Jens Axboe <jaxboe@fusionio.com>:
>> On Mon, Dec 03 2012, Kent Overstreet wrote:
>>> Last posting: http://thread.gmane.org/gmane.linux.kernel.aio.general/3169
>>>
>>> Changes since the last posting should all be noted in the individual
>>> patch descriptions.
>>>
>>>  * Zach pointed out the aio_read_evt() patch was calling functions that
>>>    could sleep in TASK_INTERRUPTIBLE state, that patch is rewritten.
>>>  * Ben pointed out some synchronize_rcu() usage was problematic,
>>>    converted it to call_rcu()
>>>  * The flush_dcache_page() patch is new
>>>  * Changed the "use cancellation list lazily" patch so as to remove
>>>    ki_flags from struct kiocb.
>>
>> Kent, I ran a few tests, and the below patches still don't seem as fast
>> as the approach I took. To keep it fair, I used your aio branch and
>> applied by dio speedups too. As a sanity check, I ran with your branch
>> alone as well. The quick results below - kaio is kent-aio, just your
>> branch. kaio-dio is with the direct IO speedups too. jaio is my branch,
>> which already has the dio changes too.
>>
>> Devices         Branch          IOPS
>> 1               kaio            ~915K
>> 1               kaio-dio        ~930K
>> 1               jaio           ~1220K
>> 6               kaio           ~3050K
>> 6               kaio-dio       ~3080K
>> 6               jaio            3500K
>>
>> The box runs out of CPU driving power, which is why it doesn't scale
>> linearly, otherwise I know that jaio at least does. It's basically
>> completion limited for the 6 device test at the moment.
>>
>> I'll run some profiling tomorrow morning and get you some better
>> results. Just thought I'd share these at least.
>>
>> --
>> Jens Axboe
>>
> 
> A really good performance, woo.
> 
> I think the device tested is really fast PCIe SSD builded by fusionio
> with fusionio in house block driver?

It is pci-e flash storage, but it is not fusion-io.

> any compare number with current mainline?

Sure, I should have included that. Here's the table again, this time
with mainline as well.

Devices         Branch          IOPS
1               mainline        ~870K
1               kaio            ~915K
1               kaio-dio        ~930K
1               jaio           ~1220K
6               kaio           ~3050K
6               kaio-dio       ~3080K
6               jaio           ~3500K
6               mainline       ~2850K


-- 
Jens Axboe


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab1CHUH2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 15:07:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374Ab1CHUH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 15:07:27 -0500
Message-ID: <4D768C6E.6010202@redhat.com>
Date: Tue, 08 Mar 2011 21:07:10 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101213 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>, dm-crypt@saout.de,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-crypt] dm-crypt: Performance Regression 2.6.37 -> 2.6.38-rc8
References: <20110308164508.GA8729@darkside.kls.lan> <4D7668C5.5050100@redhat.com> <20110308192341.GA8356@darkside.kls.lan>
In-Reply-To: <20110308192341.GA8356@darkside.kls.lan>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2011 08:23 PM, Mario 'BitKoenig' Holbe wrote:
> On Tue, Mar 08, 2011 at 06:35:01PM +0100, Milan Broz wrote:
>> On 03/08/2011 05:45 PM, Mario 'BitKoenig' Holbe wrote:
>>> dm-crypt in 2.6.38 changed to per-CPU workqueues to increase it's
>>> performance by parallelizing encryption to multiple CPUs.
>>> This modification seems to cause (massive) performance drops for
>>> multiple parallel dm-crypt instances...
>> Well, it depends. I never suggested this kind of workaround because
>> you basically hardcoded (in device stacking) how many parallel instances
>> (==cpu cores ideally) of dmcrypt can run effectively.
> 
> Yes. But it was the best to get :)

I know...

> 
>> With current design the IO is encrypted by the cpu which submitted it.
> ...
>> If you use one dmcrypt instance over RAID0, you will now get probably
>> much more better throughput. (Even with one process generating IOs
>> the bios are, surprisingly, submitted on different cpus. But this time
>> it runs really in parallel.)
> 
> Mh, not really. I just tested this with kernels fresh booted into
> emergency and udev started to create device nodes:
> 
> # cryptsetup -c aes-xts-plain -s 256 -h sha256 -d /dev/urandom create foo1 /dev/sdc
> ...
> # cryptsetup -c aes-xts-plain -s 256 -h sha256 -d /dev/urandom create foo4 /dev/sdf
> # mdadm -B -l raid0 -n 4 -c 256 /dev/md/foo /dev/mapper/foo[1-4]
> # dd if=/dev/md/foo of=/dev/null bs=1M count=20k
> 
> 2.6.37: 291MB/s		2.6.38: 139MB/s
> 
> # mdadm -B -l raid0 -n 4 -c 256 /dev/md/foo /dev/sd[c-f]
> # cryptsetup -c aes-xts-plain -s 256 -h sha256 -d /dev/urandom create foo /dev/md/foo
> # dd if=/dev/mapper/foo of=/dev/null bs=1M count=20k
> 
> 2.6.37: 126MB/s		2.6.38: 138MB/s
> 
> So... performance drops on .37 (as expected) and nothing changes on .38
> (unlike expected).

Could you please try also writes? I get better results than reads here.

Anyway, the patch provides parallel processing if it is submitted from
different CPUs, it does not provide any load balancing if everything is submitted
from one process.
(Seems it is side effect of something else...)

So unfortunately for someone it is huge improvement, in this case it causes
just troubles.

We need to investigate if some change on top of current code can provide
better results here.

Milan

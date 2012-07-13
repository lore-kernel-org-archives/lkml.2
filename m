Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182Ab2GMKEW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 06:04:22 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33923 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557Ab2GMKEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 06:04:21 -0400
MIME-Version: 1.0
In-Reply-To: <20120713094232.GD18079@mudshark.cambridge.arm.com>
References: <CAK2TD5ygowdy9t1TpfxAPbpvNQfMnMB-3Zp8TKMsTYtBZdGW=Q@mail.gmail.com>
	<CAFNq8R6dNb0BrDVZScJ8s=P3B-OMgtr8tUdy8XqQcCAeUWuH+A@mail.gmail.com>
	<CAK2TD5z2DticZAQ-Pxzo7YT9tx=YWZkwcn-YZJ3aQa4AFoE_Cw@mail.gmail.com>
	<20120713094232.GD18079@mudshark.cambridge.arm.com>
Date: Fri, 13 Jul 2012 18:04:20 +0800
Message-ID: <CAK2TD5yE90+fU==Yw6vyZT8Nc5fXqUBAWiTJ4yu3_YCzfqgdOg@mail.gmail.com>
Subject: Re: ARM: why smp_mb() is not needed in the "__mutex_fastpath_lock"
 and "__mutex_fastpath_unlock" functions
From: shan kang <kangshan0910@gmail.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Li Haifeng <omycle@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        dittohuang@gmail.com, jumperz@live.cn
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, a customer reported an issue to me.
After my investigation, I found the problem may be the lack of "dmb"
in mutex_lock and mutex_unlock functions.
Moreover, the issue could be resolved after the "dmb" was added.

2012/7/13 Will Deacon <will.deacon@arm.com>:
> On Fri, Jul 13, 2012 at 10:10:52AM +0100, shan kang wrote:
>> For example, in the following scenario, Process2  may get the wrong value;
>> Process1:
>> mutex_lock(&lock);
>> write data; (store operation)
>> mutex_unlock(&lock);
>>
>> Process2:
>> mutex_lock(&lock);
>> read data; (load operation)
>> mutex_unlock(&lock);
>
> Yes, it looks like we can screw things up in the uncontended case (where
> nobody blocks on the mutex). We could add an smp_mb after the lock operation
> and another one before the unlock, but I'm tempted just to use
> asm-generic/mutex-dec.h instead. The latter approach will subtly change the
> current behaviour, so I'll post a patch when I'm happy with it.
>
> Curious: did you find this by inspection or did you observe it going wrong?
>
> Cheers,
>
> Will

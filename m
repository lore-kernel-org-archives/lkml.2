Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323Ab1F1Lfh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 07:35:37 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:45008 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757143Ab1F1LfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 07:35:22 -0400
Message-ID: <4E09BC89.40306@free-electrons.com>
Date: Tue, 28 Jun 2011 13:35:37 +0200
From: David Wagner <david.wagner@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UBI: new module ubiblk: block layer on top of UBI
References: <1308922482-14967-1-git-send-email-david.wagner@free-electrons.com>	<1308922482-14967-2-git-send-email-david.wagner@free-electrons.com> <1309202771.24805.11.camel@koala>
In-Reply-To: <1309202771.24805.11.camel@koala>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 06/27/2011 09:26 PM, Artem Bityutskiy wrote:
> On Fri, 2011-06-24 at 15:34 +0200, david.wagner@free-electrons.com
> wrote:
>> +	/* Stolen from mtd_blkdevs.c */
>> +	/* Create processing thread */
>> +	dev->thread = kthread_run(ubi_ubiblk_thread, dev, "%s%d_%d",
>> +				  "kubiblkd", dev->ubi_num, dev->vol_id);
>> +	if (IS_ERR(dev->thread)) {
>> +		ret = PTR_ERR(dev->thread);
>> +		goto out_thread;
>> +	}
> 
> Why we need a kernel thread? Could you please describe when exactly it
> is needed and why we cannot avoid having it?

Do you mean that there could be another/better way ?
I read that workqueues could be used for that but since they seem to
internally use kthreads, I don't see the advantage yet. Simpler API ?

I also tried without a kthread altogether (and call do_ubiblk_request
directly within the callback registered with blk_init_queue) but got
lost in locks/context debugging ...

It seems that do_ubiblk_request needs to be in process context because
there are thousands causes for blocking (locking, page fault, for
instance, are the one I encountered). And on the other hand,
blk_run_queue must not block ; So we need to wake the thread up and
return (what ubi_ubiblk_request does).
So, would this be a sufficient justification ?


It's probably possible, however, to have only one thread for the whole
module instead of having one for each volume ; but that seemed good
enough on first approach.


I fixed the read errors issue with filesystems != SquashFS, so they
should all work, now.
I'll send the next iteration, probably later today.

-- 
David Wagner, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com

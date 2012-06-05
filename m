Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761577Ab2FEJut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 05:50:49 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:52089 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758120Ab2FEJus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 05:50:48 -0400
X-AuditID: b753bd60-996f1ba000000f6c-9e-4fcdd6757f8f
X-AuditID: b753bd60-996f1ba000000f6c-9e-4fcdd6757f8f
Message-ID: <4FCDD65B.6090402@hitachi.com>
Date: Tue, 05 Jun 2012 18:50:19 +0900
From: YOSHIDA Masanori <masanori.yoshida.tv@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@mit.edu>, Ingo Molnar <mingo@elte.hu>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>, Kevin Hilman <khilman@ti.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Tejun Heo <tj@kernel.org>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH 0/4 V2] introduce: livedump
References: <20120525091207.10256.18614.stgit@t3500.sdl.hitachi.co.jp> <20120604210912.GA18354@redhat.com>
In-Reply-To: <20120604210912.GA18354@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Vivek and Peter

Thank you for your replies.

Yes, I agree that it is terrible to consume a half of memory only for
this purpose.

I think buffer size can be reduced by dumping memory to disk
on-the-fly with buffer of limited size.
However, this means that page fault(PF) handling may sleep if the
buffer is temporarily full.
It is never acceptable when PF happens in preempt_disable()ed path,
but I think size of pages updated in the path is not much.

To reduce buffer size, we can introduce two types of buffers as below;
(1)Buffer dedicated for non-preemptible path
(2)Buffer for the rest

If the first buffer is full, tracking updated pages partially fails.
To avoid this, users need to allocate enough memory for this buffer.

We don't need to care about the second buffer being full,
because PF handling can wait for space by sleeping.

Regards,
Masanori

Yokohama Research Laboratory,
Hitachi, Ltd.


On 2012/06/05 6:09, Vivek Goyal wrote:
> On Fri, May 25, 2012 at 06:12:07PM +0900, YOSHIDA Masanori wrote:
>
> [..]
>> (4) It allocates about 50% of physical RAM to store dumped pages. Currently
>>      Live Dump saves all dumped data on memory once, and after that a user
>>      becomes able to use the dumped data. Live Dump itself has no feature to
>>      save dumped data onto a disk or any other storage device.
>
> People complain when kdump reserves 128M of memory when system crashes.
> I am skeptical that reserving 50% of memory for livedumps is going to fly.
>
> Thanks
> Vivek


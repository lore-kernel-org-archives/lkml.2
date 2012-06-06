Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255Ab2FFOoh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 10:44:37 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:53867 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987Ab2FFOof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 10:44:35 -0400
X-AuditID: b753bd60-a2688ba000000655-31-4fcf6cd09cbc
X-AuditID: b753bd60-a2688ba000000655-31-4fcf6cd09cbc
Message-ID: <4FCF6CCC.1050808@hitachi.com>
Date: Wed, 06 Jun 2012 23:44:28 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Anthony Liguori <anthony@codemonkey.ws>, Borislav Petkov <bp@amd64.org>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Grant Likely <grant.likely@secretlab.ca>, qemu-devel@nongnu.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        Borislav Petkov <borislav.petkov@amd.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>, systemtap@sourceware.org,
        Joerg Roedel <joerg.roedel@amd.com>, yrl.pp-manager.tt@hitachi.com,
        Cam Macdonell <cam@cs.ualberta.ca>,
        Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Subject: Re: [Qemu-devel] [RFC PATCH 1/2] ivring: Add a ring-buffer driver
 on IVShmem
References: <20120605104954.15442.62695.stgit@ltc189.sdl.hitachi.co.jp> <20120605130117.15479.32680.stgit@ltc189.sdl.hitachi.co.jp> <20120605131031.GF13495@aftab.osrc.amd.com> <4FCE902A.3060603@codemonkey.ws> <20120605232210.GA8858@kroah.com>
In-Reply-To: <20120605232210.GA8858@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/06 8:22), Greg Kroah-Hartman wrote:
> On Wed, Jun 06, 2012 at 07:03:06AM +0800, Anthony Liguori wrote:
>> On 06/05/2012 09:10 PM, Borislav Petkov wrote:
>>> On Tue, Jun 05, 2012 at 10:01:17PM +0900, Yoshihiro YUNOMAE wrote:
>>>> This patch adds a ring-buffer driver for IVShmem device, a virtual RAM device in
>>>> QEMU. This driver can be used as a ring-buffer for kernel logging or tracing of
>>>> a guest OS by recording kernel programing or SystemTap.
>>>>
>>>> This ring-buffer driver is implemented very simple. First 4kB of shared memory
>>>> region is control structure of a ring-buffer. In this region, some values for
>>>> managing the ring-buffer is stored such as bits and mask of whole memory size,
>>>> writing position, threshold value for notification to a reader on a host OS.
>>>> This region is used by the reader to know writing position. Then, "total
>>>> memory size - 4kB" equals to usable memory region for recording data.
>>>> This ring-buffer driver records any data from start to end of the writable
>>>> memory region.
>>>>
>>>> When writing size exceeds a threshold value, this driver can notify a reader
>>>> to read data by using writel(). As this later patch, reader does not have any
>>>> function for receiving the notification. This notification feature will be used
>>>> near the future.
>>>>
>>>> As a writer records data in this ring-buffer, spinlock function is used to
>>>> avoid competing by some writers in multi CPU environment. Not to use spinlock,
>>>> lockless ring-buffer like as ftrace and one ring-buffer one CPU will be
>>>> implemented near the future.
>>>
>>> Yet another ring buffer?
>>>
>>> We already have an ftrace and perf ring buffer, can't you use one of those?
>>
>> Not to mention virtio :-)
>>
>> Why not just make a virtio device for this kind of thing?
> 
> Yeah, that's exactly what I was thinking, why reinvent things again?

Agreed. Actually, we think this is just a concept prototype.
Because of many restrictions of this device, especially for
scalability (which Yoshihiro will give a talk in LinuxCon Japan),
we are considering to move onto a virtio-based shmem device.

Afaics, it seems possible to use it virtio-ballon like way to pass
actual pages of the guest ring buffer to host. Then the reader
can read the pages directly from qemu.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com

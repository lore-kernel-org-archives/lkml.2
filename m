Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab1ILAp0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 20:45:26 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35942 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab1ILApZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 20:45:25 -0400
MIME-Version: 1.0
In-Reply-To: <CAF_S4t8pjpOhvNG+U-RUP1QerEJ1of7Me9smXvrFDiOQtzD_Vg@mail.gmail.com>
References: <CADDb1s1pLQMMipe-zoHM6u4C_ZmUm_r4rsYxfft9mFQ56+Wgaw@mail.gmail.com>
	<CADDb1s2hN0Pi336_gn_+HxJ+i4kd6Ce5XBOjEKoPzdovxVBt5g@mail.gmail.com>
	<CAF_S4t8pjpOhvNG+U-RUP1QerEJ1of7Me9smXvrFDiOQtzD_Vg@mail.gmail.com>
Date: Mon, 12 Sep 2011 09:45:23 +0900
Message-ID: <CAKYAXd_kwtRjWxm_UcxZvNgLwBBc-M9YMc7DZx1Kv2vsd1SJJA@mail.gmail.com>
Subject: Re: Issue with lazy umount and closing file descriptor in between
From: NamJae Jeon <linkinjeon@gmail.com>
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Bryan Donlan <bdonlan@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/12 Bryan Donlan <bdonlan@gmail.com>:
> On Wed, Sep 7, 2011 at 12:37, Amit Sahrawat <amit.sahrawat83@gmail.com> wrote:
>> I know that lazy umount was designed keeping in mind that the
>> mountpoint is not accesible to all future I/O but for the ongoing I/O
>> it will continute to work. It is only after the I/O is finished that
>> the umount will actually occur. But this can be tricky at times
>> considering there are situations where the operation will continue to
>> be executed than what is expected duration, and you cannot unplug the
>> device during that period because there are chances of filesystem
>> corruption on doing so.
>> Is there anything which could be done in this context? because simply
>> reading the fd-table and closing fd's will not serve the purpose and
>> there is every chance of a OOPs occuring due to this closing.
>> Signalling from this point to the all the process's with open fd's on
>> that mountpoint to close fd i.e., handling needs to be done from the
>> user space applications...? Does this make sense
>>
>> Please through some insight into this. I am not looking for exact
>> solution it is just mere opinion's on this that can add to this.
>
> Essentially what you want here is a 'forced unmount' option.
>
> It's difficult to do this directly in the existing VFS model; you'd
> need to essentially change the operations structure for all open
> files/inodes for that filesystem in a race-free manner, _and_ wait for
> any outstanding operations to complete. The VFS isn't really designed
> to support something like this. What you could try doing, however, is
> creating a wrapper filesystem - one that redirects all requests to an
> underlying filesystem, but supports an operation to:
>
> 1) Make all future requests fail with -EIO
> 2) Invalidate any existing VMA mappings
> 3) Wait for all outstanding requests to complete
> 4) Unmount (ie, unreference) the underlying filesystem
>
> This will result in some overhead, of course, but would seem to be the
> safest route.
>

I have a idea to resolve this problem. plz try to do like this.

1. first, fd is set to -1 or .. in fdtable about opened file. If then,
when user app try next write, BAD desctriptor error will be faced.(it
can not cause BAD descrpitor, plz check condition of BAD descriptor).
2. second, plz flush dirty page and request in i/o scheduler.
3. third , try to close fd after previous I/O is finished like above trying.

Thanks.

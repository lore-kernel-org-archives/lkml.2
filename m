Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab0GZNns (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 09:43:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752811Ab0GZNnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 09:43:47 -0400
Date: Mon, 26 Jul 2010 09:43:29 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Heinz Diehl <htd@fancy-poultry.org>
Cc: linux-kernel@vger.kernel.org, jaxboe@fusionio.com, nauman@google.com,
        dpshah@google.com, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
        czoccolo@gmail.com, Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH] cfq-iosched: IOPS mode for group scheduling and new
 group_idle tunable
Message-ID: <20100726134329.GB12449@redhat.com>
References: <1279834172-4227-1-git-send-email-vgoyal@redhat.com>
 <20100723140343.GA8478@fancy-poultry.org>
 <20100723141303.GB13104@redhat.com>
 <20100723145631.GA8844@fancy-poultry.org>
 <20100723183720.GD13104@redhat.com>
 <20100724080613.GA6554@fancy-poultry.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100724080613.GA6554@fancy-poultry.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 24, 2010 at 10:06:13AM +0200, Heinz Diehl wrote:
> On 23.07.2010, Vivek Goyal wrote: 
> 
> > Anyway, for fs_mark problem, can you give following patch a try.
> > https://patchwork.kernel.org/patch/113061/
> 
> Ported it to 2.6.35-rc6, and these are my results using the same fs_mark
> call as before:
> 
> slice_idle = 0
> 
> FSUse%        Count         Size    Files/sec     App Overhead
>     28         1000        65536        241.6            39574
>     28         2000        65536        231.1            39939
>     28         3000        65536        230.4            39722
>     28         4000        65536        243.2            39646
>     28         5000        65536        227.0            39892
>     28         6000        65536        224.1            39555
>     28         7000        65536        228.2            39761
>     28         8000        65536        235.3            39766
>     28         9000        65536        237.3            40518
>     28        10000        65536        225.7            39861
>     28        11000        65536        227.2            39441
> 
> 
> slice_idle = 8
> 
> FSUse%        Count         Size    Files/sec     App Overhead
>     28         1000        65536        502.2            30545
>     28         2000        65536        407.6            29406
>     28         3000        65536        381.8            30152
>     28         4000        65536        438.1            30038
>     28         5000        65536        447.5            30477
>     28         6000        65536        422.0            29610
>     28         7000        65536        383.1            30327
>     28         8000        65536        415.3            30102
>     28         9000        65536        397.6            31013
>     28        10000        65536        401.4            29201
>     28        11000        65536        408.8            29720
>     28        12000        65536        391.2            29157
> 
> Huh...there's quite a difference! It's definitely the slice_idle settings
> which affect the results here.

In this case it is not slice_idle. This patch puts both fsync writer and
jbd thread on same service tree. That way once fsync writer is done there
is no idling after that and jbd thread almost immediately gets to dispatch
requests to disk hence we see improved throughput.

> Besides, this patch gives noticeably bad desktop interactivity on my system.
> 

How do you measure it? IOW, are you running something else also on the
desktop in the background. Like a heavy writer etc and then measuring
how interactive desktop feels?

> Don't know if this is related, but I'm not quite shure if XFS (which I use
> exclusively) uses the jbd/jbd2 journaling layer at all.

I also don't know. But because this patch is making a difference with your
XFS file system performance, may be it does use.

CCing Christoph, he can tell us.

Thanks
Vivek

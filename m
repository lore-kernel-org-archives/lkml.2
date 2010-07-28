Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab0G1UW3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 16:22:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752611Ab0G1UW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 16:22:27 -0400
Date: Wed, 28 Jul 2010 16:22:12 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Heinz Diehl <htd@fancy-poultry.org>
Cc: linux-kernel@vger.kernel.org, jaxboe@fusionio.com, nauman@google.com,
        dpshah@google.com, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
        czoccolo@gmail.com
Subject: Re: [RFC PATCH] cfq-iosched: IOPS mode for group scheduling and new
 group_idle tunable
Message-ID: <20100728202212.GD16314@redhat.com>
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


> Besides, this patch gives noticeably bad desktop interactivity on my system.

Heinz,

I also ran linus torture test and fsync-tester on ext3 file system on my
SATA disk and with this corrado's fsync patch applied in fact I see better
results.

2.6.35-rc6 kernel
=================
fsync time: 1.2109
fsync time: 2.7531
fsync time: 1.3770
fsync time: 2.0839
fsync time: 1.4243
fsync time: 1.3211
fsync time: 1.1672
fsync time: 2.8345
fsync time: 1.4798
fsync time: 0.0170
fsync time: 0.0199
fsync time: 0.0204
fsync time: 0.2794
fsync time: 1.3525
fsync time: 2.2679
fsync time: 1.4629
fsync time: 1.5234
fsync time: 1.5693
fsync time: 1.7263
fsync time: 3.5739
fsync time: 1.4114
fsync time: 1.5517
fsync time: 1.5675
fsync time: 1.3818
fsync time: 1.8127
fsync time: 1.6394

2.6.35-rc6-fsync
================
fsync time: 3.8638
fsync time: 0.1209
fsync time: 2.3390
fsync time: 3.1501
fsync time: 0.1348
fsync time: 0.0879
fsync time: 1.0642
fsync time: 0.2153
fsync time: 0.1166
fsync time: 0.2744
fsync time: 0.1227
fsync time: 0.2072
fsync time: 0.0666
fsync time: 0.1818
fsync time: 0.2170
fsync time: 0.1814
fsync time: 0.0501
fsync time: 0.0198
fsync time: 0.1950
fsync time: 0.2099
fsync time: 0.0877
fsync time: 0.8291
fsync time: 0.0821
fsync time: 0.0777
fsync time: 0.0258
fsync time: 0.0574
fsync time: 0.1152
fsync time: 1.1466
fsync time: 0.2349
fsync time: 0.9589
fsync time: 1.1013
fsync time: 0.1681
fsync time: 0.0902
fsync time: 0.2052
fsync time: 0.0673

I also did "time firefox &" testing to see how long firefox takes to
launch when linus torture test is running and without patch it took
around 20 seconds and with patch it took around 17 seconds. 

So to me above test results suggest that this patch does not worsen
the performance. In fact it helps. (at least on ext3 file system.)

Not sure why are you seeing different results with XFS.

Thanks
Vivek

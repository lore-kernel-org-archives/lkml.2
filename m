Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab1DQErF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 00:47:05 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38716 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab1DQErB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 00:47:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=qOyK6wOv88XwccZQK8tsXS20IsmTk0+Mwy942vUdh4sOh+B1TKtIK5QLCmkHNRZSnR
         ovl7ccReljCoZc1Gxmpb2DoVpn8OkFzHgVMDRW2YORzC3KFiXDqfoQTG+q1qaqSw7akD
         pP6aIEkFUit/uGmdwqjaxOR5tP9SAkhfRkUlM=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110417041003.GA17032@localhost>
References: <20110416132546.765212221@intel.com>
	<BANLkTimY3t6Kc-+=00k3QR+AK2uqJpph4g@mail.gmail.com>
	<20110417014430.GA9419@localhost>
	<BANLkTik+Bcw7uz9aMi6OrAzwg1rJZmJL0Q@mail.gmail.com>
	<20110417041003.GA17032@localhost>
Date: Sun, 17 Apr 2011 06:46:58 +0200
Message-ID: <BANLkTikAu1iZ38Gm-Wzk9wS1g7femXet9g@mail.gmail.com>
Subject: Re: [PATCH 00/12] IO-less dirty throttling v7
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Chris Mason <chris.mason@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        linux-mm <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 17, 2011 at 6:10 AM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> On Sun, Apr 17, 2011 at 11:18:43AM +0800, Sedat Dilek wrote:
>> On Sun, Apr 17, 2011 at 3:44 AM, Wu Fengguang <fengguang.wu@intel.com> wrote:
>> > Hi Sedat,
>> >
>> > On Sun, Apr 17, 2011 at 12:27:58AM +0800, Sedat Dilek wrote:
>> >
>> >> I pulled your tree into linux-next (next-20110415) on an i386 Debian host.
>> >>
>> >> My build breaks here:
>> >> ...
>> >>   MODPOST vmlinux.o
>> >>   GEN     .version
>> >>   CHK     include/generated/compile.h
>> >>   UPD     include/generated/compile.h
>> >>   CC      init/version.o
>> >>   LD      init/built-in.o
>> >>   LD      .tmp_vmlinux1
>> >> mm/built-in.o: In function `bdi_position_ratio':
>> >> page-writeback.c:(.text+0x5c83): undefined reference to `__udivdi3'
>> >
>> > Yes it can be fixed by the attached patch.
>> >
>> >> mm/built-in.o: In function `calc_period_shift.part.10':
>> >> page-writeback.c:(.text+0x6446): undefined reference to `____ilog2_NaN'
>> >
>> > I cannot reproduce this error. In the git tree, calc_period_shift() is
>> > actually quite simple:
>> >
>> > static int calc_period_shift(void)
>> > {
>> >        return 2 + ilog2(default_backing_dev_info.avg_write_bandwidth);
>> > }
>> >
>> > where avg_write_bandwidth is of type "unsigned long".
>> >
>> >> make[4]: *** [.tmp_vmlinux1] Error
>> >>
>> >> BTW, which kernel-config options have to be set besides
>> >> CONFIG_BLK_DEV_THROTTLING=y?
>> >
>> > No. I used your kconfig on 2.6.39-rc3 and it compiles OK for i386.
>> >
>> > I've pushed two patches into the git tree fixing the compile errors.
>> > Thank you for trying it out and report!
>> >
>> > Thanks,
>> > Fengguang
>> >
>>
>> Thanks for your patch.
>>
>> The 1st part of the build-error is gone, but 2nd part still remains:
>>
>>   LD      .tmp_vmlinux1
>> mm/built-in.o: In function `calc_period_shift.part.10':
>> page-writeback.c:(.text+0x6458): undefined reference to `____ilog2_NaN'
>> make[4]: *** [.tmp_vmlinux1] Error 1
>>
>> I have attached some disasm-ed files.
>
> OK. I tried next-20110415 and your kconfig and still got no error.
>
> Please revert the last commit. It's not necessary anyway.
>
> commit 84a9890ddef487d9c6d70934c0a2addc65923bcf
> Author: Wu Fengguang <fengguang.wu@intel.com>
> Date:   Sat Apr 16 18:38:41 2011 -0600
>
>    writeback: scale dirty proportions period with writeout bandwidth
>
>    CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
>    Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
>
>> Unfortunately, I don't see any new commits in your GIT tree.
>
> Yeah I cannot see it in the web interface, too:
>
> http://git.kernel.org/?p=linux/kernel/git/wfg/writeback.git;a=shortlog;h=refs/heads/dirty-throttling-v7
>
> But they are in the dirty-throttling-v7 branch at kernel.org:
>
> commit d0e30163e390d87387ec13e3b1c2168238c26793
> Author: Wu Fengguang <fengguang.wu@intel.com>
> Date:   Sun Apr 17 11:59:12 2011 +0800
>
>    Revert "writeback: scale dirty proportions period with writeout bandwidth"
>
>    This reverts commit 84a9890ddef487d9c6d70934c0a2addc65923bcf.
>
>    sedat.dilek@gmail.com:
>
>        LD      .tmp_vmlinux1
>      mm/built-in.o: In function `calc_period_shift.part.10':
>      page-writeback.c:(.text+0x6458): undefined reference to `____ilog2_NaN'
>      make[4]: *** [.tmp_vmlinux1] Error 1
>
> commit fc5c8b04119a5bcc46865e66eec3e6133ecb56e9
> Author: Wu Fengguang <fengguang.wu@intel.com>
> Date:   Sun Apr 17 09:22:41 2011 -0600
>
>    writeback: quick CONFIG_BLK_DEV_THROTTLING=n compile fix
>
>    Reported-by: Sedat Dilek <sedat.dilek@googlemail.com>
>    Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
>
> commit c4a7e3f48dcfae71d0e3d2c55dcc381b3def1919
> Author: Wu Fengguang <fengguang.wu@intel.com>
> Date:   Sun Apr 17 09:04:44 2011 -0600
>
>    writeback: i386 compile fix
>
>    mm/built-in.o: In function `bdi_position_ratio':
>    page-writeback.c:(.text+0x5c83): undefined reference to `__udivdi3'
>    mm/built-in.o: In function `calc_period_shift.part.10':
>    page-writeback.c:(.text+0x6446): undefined reference to `____ilog2_NaN'
>    make[4]: *** [.tmp_vmlinux1] Error
>
>    Reported-by: Sedat Dilek <sedat.dilek@googlemail.com>
>    Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
>
>
> Thanks,
> Fengguang
>

The 2nd part disappears here, when I switch from gcc-4.6 to gcc-4.5.

- Sedat -

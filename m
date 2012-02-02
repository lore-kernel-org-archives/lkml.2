Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221Ab2BBVAY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 16:00:24 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62523 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183Ab2BBVAW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 16:00:22 -0500
MIME-Version: 1.0
In-Reply-To: <20120202121912.c82a185e.akpm@linux-foundation.org>
References: <CABeCy1aPp4=v90v_wAsw-KWDwNs59CwwYSJ-36+4t8kMuCaK0w@mail.gmail.com>
	<1328055439-9441-1-git-send-email-venki@google.com>
	<20120201140125.c656df41.akpm@linux-foundation.org>
	<87d39xj955.fsf@rustcorp.com.au>
	<20120202121912.c82a185e.akpm@linux-foundation.org>
Date: Thu, 2 Feb 2012 13:00:21 -0800
Message-ID: <CABeCy1YGnYexANsNrppxsMEam+fGC1nFHUfq3BdurCzG_jtT0g@mail.gmail.com>
Subject: Re: [PATCH] Avoid mask based num_possible_cpus and num_online_cpus -v5
From: Venki Pallipadi <venki@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mike Travis <travis@sgi.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 2, 2012 at 12:19 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Fri, 03 Feb 2012 06:33:02 +1030
> Rusty Russell <rusty@rustcorp.com.au> wrote:
>
>> On Wed, 1 Feb 2012 14:01:25 -0800, Andrew Morton <akpm@linux-foundation.org> wrote:
>> > > Though most of the callers of these two routines are init time (with few
>> > > exceptions of runtime calls), it is cleaner to use variables
>> > > and not go through this repeated mask based calculation.
>> >
>> > Looks good to me.
>>
>> But, I wonder who's asking num_possible_cpus().  It's not a very useful
>> thing to know, though some arch's "know" it's contiguous, so can cheat.
>>
>> Optimizing it seems particularly foolish.
>
> We're fools for optimisations!
>

I would think that if we are giving an API people will abuse it sooner
or later :-).

>> We either audit and wean
>> everyone off who's using it incorrectly, or insist on contiguous CPU
>> numbers and drop the mask altogether.
>
> drivers/block/nvme.c looks like it's assuming a contiguous map.  Maybe
> also drivers/scsi/bnx2fc (wtf?).  I didn't see anything else outside
> arch code.
>

Yes. I found a bunch of them which seemed obviously wrong.  Doing
things like allocating space based on num_possible_cpus() and
accessing the space with get_cpu() or doing cou_online() check etc.

arch/x86/kernel/apic/x2apic_uv_x.c
arch/x86/kernel/cpu/mcheck/mce-inject.c
arch/x86/platform/uv/tlb_uv.c
drivers/scsi/bnx2fc/bnx2fc_io.c
kernel/debug/kdb/kdb_bt.c

I have a patch to fix these obvious ones. But, there are other users
which were not very obvious to me and also I am know of code in older
kernels (code which since have been rewritten) which can get benefit
of this API change.

Thanks,
Venki

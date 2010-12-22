Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770Ab0LVU2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 15:28:32 -0500
Received: from smtp-out.google.com ([216.239.44.51]:44381 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab0LVU2a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 15:28:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jI82D4M9pka6Iaw+IW50ZxHN6xSUS/8XIsM9D3LOSEJO+b9UADdrIX/JZApxtCAi6n
         lFz8FuI3kxfXokN6V6iw==
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1012212230580.9505@chino.kir.corp.google.com>
References: <20101111100628.GA24728@localhost>
	<1289478978.2084.74.camel@laptop>
	<20101111124015.GA9706@localhost>
	<1289480656.2084.80.camel@laptop>
	<20101113084018.GA23098@localhost>
	<1289644224.2084.521.camel@laptop>
	<20101113120030.GA31517@localhost>
	<1289653078.2084.675.camel@laptop>
	<20101113131042.GA5522@localhost>
	<4CDEE314.6090107@kernel.org>
	<20101113235746.GA9458@localhost>
	<4CDF3DA1.2090806@kernel.org>
	<4D093ABB.4030206@zytor.com>
	<4D0943D5.1090404@kernel.org>
	<4D094703.7080701@zytor.com>
	<4D0AD464.2020408@kernel.org>
	<4D0AD486.9020704@kernel.org>
	<AANLkTin-LGig2RHHmvvy5H04jQRus_1mmS1Cr4KDWKsN@mail.gmail.com>
	<4D0BB9AD.90506@kernel.org>
	<AANLkTimw_nvDEb4t1nOQFCtY8fx6fvg5Mmy+6vZw8mw1@mail.gmail.com>
	<AANLkTi=VYooLbwWkTCSfQ38z=UO_kQZyQyKaw-5+kyYn@mail.gmail.com>
	<alpine.DEB.2.00.1012212230580.9505@chino.kir.corp.google.com>
Date: Wed, 22 Dec 2010 12:28:25 -0800
Message-ID: <AANLkTim7GbOJzjt9Wdba-pdAj+GUR1xZCqOv+bDmypTj@mail.gmail.com>
Subject: Re: [PATCH -v2 2/2] x86, acpi: Parse all SRAT cpu entries even have
 cpu num limitation
From: Venkatesh Pallipadi <venki@google.com>
To: David Rientjes <rientjes@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Nikanth Karthikesan <knikanth@suse.de>,
        "Zheng, Shaohui" <shaohui.zheng@intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>, Nikhil Rao <ncrao@google.com>,
        Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 10:43 PM, David Rientjes <rientjes@google.com> wrote:
> On Mon, 20 Dec 2010, Venkatesh Pallipadi wrote:
>
>> git bisect seems to narrow this down to the change below.
>>
>> Thanks,
>> Venki
>>
>> $ git bisect visualize
>> commit 50f2d7f682f9c0ed58191d0982fe77888d59d162
>> Author: Nikanth Karthikesan <knikanth@suse.de>
>> Date:   Thu Sep 30 17:34:10 2010 +0530
>>
>>     x86, numa: Assign CPUs to nodes in round-robin manner on fake NUMA
>>
>>     commit d9c2d5ac6af87b4491bff107113aaf16f6c2b2d9 "x86, numa: Use near(er)
>>     online node instead of roundrobin for NUMA" changed NUMA initialization on
>>     Intel to choose the nearest online node or first node.  Fake NUMA would be
>>     better of with round-robin initialization, instead of the all CPUS on
>>     first node.  Change the choice of first node, back to round-robin.
>>
>>     For testing NUMA kernel behaviour without cpusets and NUMA aware
>>     applications, it would be better to have cpus in different nodes, rather
>>     than all in a single node.  With cpusets migration of tasks scenarios
>>     cannot not be tested.
>>
>>     I guess having it round-robin shouldn't affect the use cases for all cpus
>>     on the first node.
>>
>>     The code comments in arch/x86/mm/numa_64.c:759 indicate that this used to
>>     be the case, which was changed by commit d9c2d5ac6.  It changed from
>>     roundrobin to nearer or first node.  And I couldn't find any reason for
>>     this change in its changelog.
>>
>>     Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
>>     Cc: David Rientjes <rientjes@google.com>
>>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>>
>
> Peter just merged my NUMA emulation fixes into the x86 tree, could you try
> applying Yinghai's series on top of x86/linux-2.6-tip.git#x86/numa and see
> if the problem persists?
>
> On a different topic: Yinghai, do you think you could base your series off
> of Tejun's x86_32/x86_64 NUMA unification series since it already
> duplicates some of the work?
>

Yes. #x86/numa kernel works fine both with and without Yinghai's series.
I am assuming those changes are lined up for .38. Is there any
specific fix that can make into .37 to fix this regression?

Thanks,
Venki

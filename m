Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110Ab2FFTLG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 15:11:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40099 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987Ab2FFTLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 15:11:02 -0400
Message-ID: <4FCFAB3D.6080000@gmail.com>
Date: Wed, 06 Jun 2012 15:10:53 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>, david@lang.hm,
        Christoph Lameter <cl@linux.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@google.com>, Dave Jones <davej@redhat.com>,
        Mel Gorman <mgorman@suse.de>, stable@vger.kernel.org, hughd@google.com,
        sivanich@sgi.com
Subject: Re: [PATCH 0/6] mempolicy memory corruption fixlet
References: <1338368529-21784-1-git-send-email-kosaki.motohiro@gmail.com> <CA+55aFzoVQ29C-AZYx=G62LErK+7HuTCpZhvovoyS0_KTGGZQg@mail.gmail.com> <alpine.DEB.2.00.1205301328550.31768@router.home> <20120530184638.GU27374@one.firstfloor.org> <alpine.DEB.2.00.1205301349230.31768@router.home> <20120530193234.GV27374@one.firstfloor.org> <alpine.DEB.2.00.1205301441350.31768@router.home> <CAHGf_=ooVunBpSdBRCnO1uOoswqxcSy7Xf8xVcgEUGA2fXdcTA@mail.gmail.com> <20120530201042.GY27374@one.firstfloor.org> <CAHGf_=r_ZMKNx+VriO6822otF=U_huj7uxoc5GM-2DEVryKxNQ@mail.gmail.com> <alpine.DEB.2.02.1205311744280.17976@asgard.lang.hm> <alpine.DEB.2.00.1206010850430.6302@router.home> <alpine.DEB.2.02.1206011230170.17976@asgard.lang.hm> <CAHGf_=qDy79cvHX3ym7RvkX7q9+2TDKhgtBHVj6+XHORczj94A@mail.gmail.com> <CA+55aFx6s34ss=5tjD4DT7X0WKRZfEsdk1ZiE-fkL3qao27z-A@mail.gmail.com> <20120605121711.bb392118.akpm@linux-foundation.org>
In-Reply-To: <20120605121711.bb392118.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(6/5/12 3:17 PM), Andrew Morton wrote:
> On Tue, 5 Jun 2012 12:02:25 -0700
> Linus Torvalds<torvalds@linux-foundation.org>  wrote:
>
>> I'm coming back to this email thread, because I didn't apply the
>> series due to all the ongoing discussion and hoping that somebody
>> would put changelog fixes and ack notices etc together.
>>
>> I'd also really like to know that the people who saw the problem that
>> caused the current single patch (that this series reverts) would test
>> the whole series. Maybe that happened and I didn't notice it in the
>> threads, but I don't think so.

I'm not surprised this. If many people are interesting to review this area,
mempolicy wouldn't have break so a lot.


>> In fact, right now I'm assuming that the series will eventually come
>> to me through Andrew. Andrew, correct?
>
> yup.
>
> I expect there will be a v2 series (at least).  It's unclear what
> we'll be doing with [2/6]: whether the patch will be reworked, or
> whether Andi misunderstood its effects?

Maybe because Andi didn't join bug fix works in this area for several years?


Currently, mbind(2) is completely broken. A primary role of mbind(2) is to
update memory policy of some vmas and Mel's fix remvoed it. Then, mbind is
almostly no-op. it's a regression.

I'm not clear which point you seems unclear. So, let's repeat a description of
[2/6].

There are two problem now, alloc_pages_vma() has strong and wrong assumption.
vma->policy never have MPOL_F_SHARED and shared_policy->policy must have it.
And, cpusets rebinding ignore mpol->refcnt and updates it forcibly.

The final point is to implement cow. But for it, we need rewrite mpol->rebind
family completely. It doesn't fit for 3.5 timeframe.


The downside of patch [2/6] is very small. because,

A memplicy is only shared three cases, 1) mbind() updates multiple
vmas 2) mbind() updates shmem vma 3) A shared policy splits into two regions
by a part region update.

All of them are rare. Because nobody hit kernel panic until now. Then I don't
think my patch increase memory footprint.



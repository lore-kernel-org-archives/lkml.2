Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967494Ab2EPNno (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 09:43:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932296Ab2EPNnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 09:43:43 -0400
Message-ID: <4FB3AF06.4070307@redhat.com>
Date: Wed, 16 May 2012 16:43:34 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
CC: Xudong Hao <xudong.hao@linux.intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, haitao.shan@intel.com,
        xiantao.zhang@intel.com, xudong.hao@intel.com
Subject: Re: [PATCH 0/4] KVM: Enable EPT access bit feature
References: <20120516010439.GA14256@hp-xd.sh.intel.com> <4FB371B1.7000407@redhat.com> <20120516223519.4f7d6fdc864a552ce67161e9@gmail.com>
In-Reply-To: <20120516223519.4f7d6fdc864a552ce67161e9@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2012 04:35 PM, Takuya Yoshikawa wrote:
> On Wed, 16 May 2012 12:21:53 +0300
> Avi Kivity <avi@redhat.com> wrote:
>
> > On 05/16/2012 04:04 AM, Xudong Hao wrote:
> > > EPT A/D bits enable VMMs to efficiently implement memory management and page classification algorithms to optimize VM memory operations such as de-fragmentation, paging, live-migration, and check-pointing.
> > >
> > > The series of patches enable the EPT access bit in KVM.
> > >
> > > PATCH 1: Add EPT A/D bits definition.
> > > PATCH 2: Add kernel parameter to control EPT A/D bits support, the feature is on by default.
> > > PATCH 3: Enable EPT A/D bits if supported by turning on relevant bit in EPTP.
> > > PATCH 4: Enabling Access bit when doing memory swapping.
> > >
> > 
> > Minor comment on patch 2, but otherwise looks good.
>
> Except for being white space damaged and based on old kvm.git?

Ugh, I didn't notice that.  Xudong, please rebase on kvm.git 'next', and
repost using git send-email.

> BTW, we can use this for dirty logging as you suggested.
>
> Although we need to traverse each spte from rmap 

That should be cheap.  Also, we might be able to cheat for direct-mapped
pages: if all pages in a 2M area are mapped just once, in a
direct-mapped page, we can skip rmap and iterate over the page
directly.  We can store this hint in lpage_info.

There's a chance that this optimization will gain nothing since the
processor may be able to unroll the loop and hide the rmap costs for the
next spte behind the atomic access cost for the current spte.

> and sync with dirty
> bitmap, I think it will work well by using with range based GET_DIRTY_LOG
> to restrict the cost for one call.

I'm in favour of that as well (even more, since the install base will be
dominated by non-AD-capable hosts for some time).

-- 
error compiling committee.c: too many arguments to function


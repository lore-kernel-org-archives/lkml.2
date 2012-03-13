Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760470Ab2CMKMj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 06:12:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13082 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760195Ab2CMKMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 06:12:37 -0400
Message-ID: <4F5F1D91.6030706@redhat.com>
Date: Tue, 13 Mar 2012 12:12:33 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
CC: mtosatti@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] KVM: Avoid checking huge page mappings in get_dirty_log()
References: <20120301193007.04b2db8e.yoshikawa.takuya@oss.ntt.co.jp> <20120301193216.b14538bb.yoshikawa.takuya@oss.ntt.co.jp> <4F5E3AAB.7020603@redhat.com> <20120313182045.97f42399.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20120313182045.97f42399.yoshikawa.takuya@oss.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2012 11:20 AM, Takuya Yoshikawa wrote:
> Avi Kivity <avi@redhat.com> wrote:
>
> > It occurs to me that we should write-protect huge page tables, since it
> > makes write protection much faster (we make up for this later at write
> > fault time, but that might not occur, and even if it does we reduce
> > guest jitter).  In fact I once proposed a more involved variant, called
>
> Do you mean protecting huge page tables when we start logging and dropping
> them, one by one, at the time of write fault?

Yes.  Even more generally, protecting PML4Es, then at fault time
un-protecting the faulting PML4E and write-protecting all underlying
PDPEs except the one for the faulting address, and similarly for PDEs
and PTEs.

> If so, we do not need to change get_dirty_log() implementation.
> Changing kvm_mmu_remove_write_access() and fault handler seems to be enough.
>
> > O(1) write protection, in which we write-protect the topmost page table
> > only and only un-write-protect the paths that fault.
>
> > That can be done later however and shouldn't affect this patchset.
>
> I have some additional patches to optimize rmap handling which seems to
> improve get_dirty_log() about 10% in the worst case.

Great, looking forward.

> After that, I want to take some time to prepare for further developments
> because my current test tools are not enough now.
>

-- 
error compiling committee.c: too many arguments to function


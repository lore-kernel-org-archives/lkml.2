Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155Ab2BBOo7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 09:44:59 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35267 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071Ab2BBOo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 09:44:57 -0500
Date: Thu, 2 Feb 2012 23:44:50 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
        Peter Zijlstra <peterz@infradead.org>, paulmck@linux.vnet.ibm.com,
        Oleg Nesterov <oleg@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>
Subject: Re: [test result] dirty logging without srcu update -- Re:
 [RFC][PATCH] srcu: Implement call_srcu()
Message-Id: <20120202234450.20b75999de0e3b05043ffb71@gmail.com>
In-Reply-To: <4F2A6D46.6010406@redhat.com>
References: <1328016724.2446.229.camel@twins>
	<4F27F0E6.1040309@redhat.com>
	<1328017807.2446.230.camel@twins>
	<20120131222447.GH2391@linux.vnet.ibm.com>
	<1328091749.2760.34.camel@laptop>
	<4F29178A.1090306@redhat.com>
	<4F2918D5.4050104@redhat.com>
	<4F291B56.30600@oss.ntt.co.jp>
	<4F291B92.8070402@redhat.com>
	<4F291E1F.3030505@oss.ntt.co.jp>
	<4F293D14.5030008@redhat.com>
	<20120202144633.1fc9b997.yoshikawa.takuya@oss.ntt.co.jp>
	<4F2A611E.6090005@redhat.com>
	<4F2A63B9.8000405@oss.ntt.co.jp>
	<4F2A63C6.7030301@redhat.com>
	<4F2A682C.7090109@oss.ntt.co.jp>
	<4F2A6D46.6010406@redhat.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity <avi@redhat.com> wrote:

> > I have one concern about correctness issue though:
> >
> >     concurrent rmap write protection may not be safe due to
> >     delayed tlb flush ... cannot happen?
> 
> What do you mean by concurrent rmap write protection?
> 

Not sure, but other codes like:

- mmu_sync_children()
	for_each_sp(pages, sp, parents, i)
		protected |= rmap_write_protect(vcpu->kvm, sp->gfn);

		if (protected)
			kvm_flush_remote_tlbs(vcpu->kvm);

- kvm_mmu_get_page()
	if (rmap_write_protect(vcpu->kvm, gfn))
		kvm_flush_remote_tlbs(vcpu->kvm);

I just wondered what can happen if GET_DIRTY_LOG is being processed
behind these processing?

They may find nothing to write protect and won't do kvm_flush_remote_tlbs()
if the gfn has been already protected by GET_DIRTY_LOG.

But GET_DIRTY_LOG may still be busy write protecting other pages and
others can return before.  (My code releases mmu_lock to not include
__put_user() in the critical section.)

I am not still enough familier with these code yet.
(maybe empty concern)

	Takuya

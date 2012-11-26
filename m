Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933199Ab2KZRxt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:53:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51975 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933121Ab2KZRxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:53:43 -0500
Date: Mon, 26 Nov 2012 19:53:27 +0200
From: Gleb Natapov <gleb@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v8 1/2] x86/kexec: add a new atomic notifier list for
 kdump
Message-ID: <20121126175327.GG12969@redhat.com>
References: <50ADE0C2.1000106@cn.fujitsu.com>
 <50ADE11A.401@cn.fujitsu.com>
 <87ip8sxuyh.fsf@xmission.com>
 <20121126172054.GF12969@redhat.com>
 <87fw3wuuoh.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fw3wuuoh.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2012 at 11:43:10AM -0600, Eric W. Biederman wrote:
> Gleb Natapov <gleb@redhat.com> writes:
> 
> > On Mon, Nov 26, 2012 at 09:08:54AM -0600, Eric W. Biederman wrote:
> >> Zhang Yanfei <zhangyanfei@cn.fujitsu.com> writes:
> >> 
> >> > This patch adds an atomic notifier list named crash_notifier_list.
> >> > Currently, when loading kvm-intel module, a notifier will be registered
> >> > in the list to enable vmcss loaded on all cpus to be VMCLEAR'd if
> >> > needed.
> >> 
> >> crash_notifier_list ick gag please no.  Effectively this makes the kexec
> >> on panic code path undebuggable.
> >> 
> >> Instead we need to use direct function calls to whatever you are doing.
> >> 
> > The code walks linked list in kvm-intel module and calls vmclear on
> > whatever it finds there. Since the function have to resides in kvm-intel
> > module it cannot be called directly. Is callback pointer that is set
> > by kvm-intel more acceptable?
> 
> Yes a specific callback function is more acceptable.  Looking a little
> deeper vmclear_local_loaded_vmcss is not particularly acceptable. It is
> doing a lot of work that is unnecessary to save the virtual registers
> on the kexec on panic path.
> 
What work are you referring to in particular that may not be acceptable?

> In fact I wonder if it might not just be easier to call vmcs_clear to a
> fixed per cpu buffer.
> 
There may be more than one vmcs loaded on a cpu, hence the list.

> Performing list walking in interrupt context without locking in
> vmclear_local_loaded vmcss looks a bit scary.  Not that locking would
> make it any better, as locking would simply add one more way to deadlock
> the system.  Only an rcu list walk is at all safe.  A list walk that
> modifies the list as vmclear_local_loaded_vmcss does is definitely not safe.
> 
The list vmclear_local_loaded walks is per cpu. Zhang's kvm patch
disables kexec callback while list is modified.

--
			Gleb.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab1G0Hv1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 03:51:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13667 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826Ab1G0HvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 03:51:24 -0400
Date: Wed, 27 Jul 2011 10:51:19 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 03/11] KVM: x86: fast emulate repeat string write
 instructions
Message-ID: <20110727075119.GB7966@redhat.com>
References: <4E2EA3DB.7040403@cn.fujitsu.com>
 <4E2EA476.9070607@cn.fujitsu.com>
 <20110726122710.GM4404@redhat.com>
 <4E2F6E48.7030802@cn.fujitsu.com>
 <20110727042602.GA7966@redhat.com>
 <4E2FB10B.9080805@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E2FB10B.9080805@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 02:32:43PM +0800, Xiao Guangrong wrote:
> On 07/27/2011 12:26 PM, Gleb Natapov wrote:
> > On Wed, Jul 27, 2011 at 09:47:52AM +0800, Xiao Guangrong wrote:
> >> On 07/26/2011 08:27 PM, Gleb Natapov wrote:
> >>> On Tue, Jul 26, 2011 at 07:26:46PM +0800, Xiao Guangrong wrote:
> >>>> We usually use repeat string instructions to clear the page, for example,
> >>> By "we" do you mean Linux guest?
> >>>
> >>
> >> I do not know other guests except linux, but, generally rep instruction is
> >> not used to update a page table which is been using.
> >>
> >>>> we call memset to clear a page table, stosb is used in this function, and 
> >>>> repeated for 1024 times, that means we should occupy mmu lock for 1024 times
> >>>> and walking shadow page cache for 1024 times, it is terrible
> >>>>
> >>>> In fact, if it is the repeat string instructions emulated and it is not a
> >>>> IO/MMIO access, we can zap all the corresponding shadow pages and return to the
> >>>> guest, then the mapping can became writable and directly write the page
> >>>>
> >>
> >>
> >>> So this patch does two independent things as far as I can see. First it
> >>> stops reentering guest if rep instruction is done on memory and second
> >>
> >> No.
> >> Oppositely, it enters guest as soon as possible if rep instruction is done
> >> on memory ;-)
> > Oops. Indeed. I read it other way around. So why not just return
> > X86EMUL_UNHANDLEABLE from emulator_write_emulated_onepage() which should
> > have the same effect?
> > 
> 
> It seams not, the count register(RCX) is not decreased, and redundant work
> need to be done by handling EMULATION_FAILED.
The only difference is that with your approach one rep is emulated and then
control goes back to a guest. With EMULATION_FAILED kvm returns to a guest
immediately, so RCX shouldn't be decreased. There shouldn't a be big difference
performance wise and if there is it is likely on EMULATION_FAILED side.
Last but not least emulate.c knows nothing about the hack.

> So, emulator_write_emulated_onepage() is not a good place i think. :-)

--
			Gleb.

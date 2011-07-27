Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833Ab1G0E0L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 00:26:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887Ab1G0E0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 00:26:09 -0400
Date: Wed, 27 Jul 2011 07:26:02 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 03/11] KVM: x86: fast emulate repeat string write
 instructions
Message-ID: <20110727042602.GA7966@redhat.com>
References: <4E2EA3DB.7040403@cn.fujitsu.com>
 <4E2EA476.9070607@cn.fujitsu.com>
 <20110726122710.GM4404@redhat.com>
 <4E2F6E48.7030802@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E2F6E48.7030802@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 09:47:52AM +0800, Xiao Guangrong wrote:
> On 07/26/2011 08:27 PM, Gleb Natapov wrote:
> > On Tue, Jul 26, 2011 at 07:26:46PM +0800, Xiao Guangrong wrote:
> >> We usually use repeat string instructions to clear the page, for example,
> > By "we" do you mean Linux guest?
> > 
> 
> I do not know other guests except linux, but, generally rep instruction is
> not used to update a page table which is been using.
> 
> >> we call memset to clear a page table, stosb is used in this function, and 
> >> repeated for 1024 times, that means we should occupy mmu lock for 1024 times
> >> and walking shadow page cache for 1024 times, it is terrible
> >>
> >> In fact, if it is the repeat string instructions emulated and it is not a
> >> IO/MMIO access, we can zap all the corresponding shadow pages and return to the
> >> guest, then the mapping can became writable and directly write the page
> >>
> 
> 
> > So this patch does two independent things as far as I can see. First it
> > stops reentering guest if rep instruction is done on memory and second
> 
> No.
> Oppositely, it enters guest as soon as possible if rep instruction is done
> on memory ;-)
Oops. Indeed. I read it other way around. So why not just return
X86EMUL_UNHANDLEABLE from emulator_write_emulated_onepage() which should
have the same effect?

> After this patch, we only need to emulate one time for a rep instruction.
> 
> > it drops shadow pages if access to shadowed page table is rep. Why not
> > separate those in different patches?  
> 
> Umm, i will zap shadow page firstly and stop emulation rep instruction in
> the second patch.
> 
> > BTW not entering guest periodically
> > increases interrupt latencies.
> 
> Oppositely, It reduces the latencies. :-)
> 
> > Why not zap shadow, make page writable
> > and reenter the guest instead of emulation, it should be much faster (do we
> > care to optimize for old cpus by complicating the code anyway?).
> > 
> 
> We do better lazily update the mapping to writable, it can be done by the later access.

--
			Gleb.

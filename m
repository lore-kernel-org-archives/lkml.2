Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932602Ab1ETMzE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 08:55:04 -0400
Received: from mx1.vsecurity.com ([209.67.252.12]:55712 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064Ab1ETMzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 08:55:03 -0400
Subject: Re: [BUG] perf: bogus correlation of kernel symbols
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, davej@redhat.com, kees.cook@canonical.com,
        davem@davemloft.net, eranian@google.com, torvalds@linux-foundation.org,
        adobriyan@gmail.com, penberg@kernel.org
In-Reply-To: <20110520120750.GJ14745@elte.hu>
References: <1305292059.1949.0.camel@dan> <1305293345.1949.22.camel@dan>
	 <20110516153527.GC21107@elte.hu> <1305852966.3005.19.camel@dan>
	 <20110520120750.GJ14745@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 May 2011 08:54:53 -0400
Message-ID: <1305896093.3005.24.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-20 at 14:07 +0200, Ingo Molnar wrote:
> * Dan Rosenberg <drosenberg@vsecurity.com> wrote:
> 
> > I was able to boot a relocatable kernel with the decompression location at a 
> > hard-coded offset without too much trouble.  Everything seems to work fine.
> 
> Nice!
> 
> > However, it occurred to me that even if the kernel image's base address were 
> > randomized at boot, assuming a binary distro kernel it would still be 
> > possible to sidt the address of the IDT and calculate symbol offsets relative 
> > to that.  Any thoughts on how to avoid that?  Seems difficult. Another hurdle 
> > will be to find a reasonable source of entropy that early in the boot 
> > process.
> 
> I do not think it's an issue.
> 
> If an attacker can execute arbitrary privileged instructions like SIDT then 
> it's game over. There's plenty of CPU state, the IDT, GDT, various MSRs that 
> would tell roughly where the kernel is, etc.
> 

Except that SIDT isn't a privilege instruction, it's accessible as ring
3.

> The attack randomization protects against is when the attacker has a limited 
> amount of control over a stack return address (due to a buffer overflow for 
> example) and can redirect kernel execution to some 'interesting' place that 
> allows more control. With SMEP and kernel image randomization this would be 
> rather difficult to pull off: the kernel wont jump to a pre-prepared user-space 
> shellcode buffer (due to SMEP) while the location of already existing, 
> executable, supervisor-privileged pages is randomized.
> 

Yes, all true, except are you specifically considering remote-only
attack vectors?

> So when you have implemented this i'd suggest enabling CONFIG_X86_PTDUMP=y to 
> get access to a dump of all pagetables, in the /debug/kernel_page_tables file. 
> There you can check every single executable, kernel-privileged mapping on a 
> live system and make sure it's not easily discovered.
> 

I'll do this too, but first I'd like to address the above.

Thanks,
Dan

> Thanks,
> 
> 	Ingo



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758725Ab2JSRag (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 13:30:36 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35065 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744Ab2JSRae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 13:30:34 -0400
Date: Fri, 19 Oct 2012 18:30:29 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linus-arch@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        David Howells <dhowells@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Michal Simek <monstr@monstr.eu>, Jonas Bonn <jonas@southpole.se>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Richard Kuo <rkuo@codeaurora.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Lennox Wu <lennox.wu@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Mundt <lethal@linux-sh.org>, Chris Zankel <chris@zankel.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>
Subject: Re: new execve/kernel_thread design
Message-ID: <20121019173029.GO2616@ZenIV.linux.org.uk>
References: <20121016223508.GR2616@ZenIV.linux.org.uk>
 <20121019154901.GK2616@ZenIV.linux.org.uk>
 <3908561D78D1C84285E8C5FCA982C28F19D57A82@ORSMSX108.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F19D57A82@ORSMSX108.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 05:16:50PM +0000, Luck, Tony wrote:
> > Surprisingly enough, ia64 one seems to work on actual hardware; I have sent
> > Tony an incremental patch cleaning copy_thread() up, waiting for results of
> > testing that on SMP box.
> 
> Tiny bit faster than plain 3.7-rc1. lmbench3 reports fork+execve test at between
> 558 to 567 usec with the new code, compared with 562-572 usec with the old.

Are you OK with the state of comments in call_payload() in the current
form of that sucker?  Right now in #arch-ia64 is looks so:
ENTRY(call_payload)
        .prologue ASM_UNW_PRLG_RP|ASM_UNW_PRLG_PFS, ASM_UNW_PRLG_GRSAVE(0)
        /* call the kernel_thread payload; fn is in r4, arg - in r5 */
        alloc loc1=ar.pfs,0,3,1,0
        mov loc0=rp
        mov loc2=gp
        mov out0=r5             // arg
        ld8 r14 = [r4], 8       // fn.address
        ;;
        mov b6 = r14
        ld8 gp = [r4]           // fn.gp
        ;;
        br.call.sptk.many rp=b6 // fn(arg)
.ret12: mov gp=loc2
        mov rp=loc0
        mov ar.pfs=loc1
        /* ... and if it has returned, we are going to userland */
        cmp.ne pKStk,pUStk=r0,r0
        br.ret.sptk.many rp
END(call_payload)

IIRC, the lack of comments on function with unusual calling conventions was
the last remaining issue...

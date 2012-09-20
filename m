Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687Ab2ITOto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 10:49:44 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:41760 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753295Ab2ITOtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 10:49:42 -0400
Date: Thu, 20 Sep 2012 20:13:11 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/5] uprobes: Fix UPROBE_SKIP_SSTEP checks in
 handle_swbp()
Message-ID: <20120920144311.GF27880@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120914171513.GA29599@redhat.com>
 <20120914171557.GA29642@redhat.com>
 <20120915073957.GD7588@in.ibm.com>
 <20120915150120.GA20608@redhat.com>
 <20120917172052.GK28033@linux.vnet.ibm.com>
 <20120918160738.GA22995@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120918160738.GA22995@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 12092014-8974-0000-0000-00000E183B7C
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000294; HX=3.00000196; KW=3.00000007;
 PH=3.00000001; SC=3.00000007; SDB=6.00175765; UDB=6.00039797; UTC=2012-09-20
 14:49:40
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-09-18 18:07:38]:

> >
> > > Probably this is fine, at least this is
> > > fine if it finds "nop" eventually. But I can't undestand what
> > > "0x66* { 0x90 | 0x0f 0x1f | 0x0f 0x19 | 0x87 0xc0 }" means.
> > > OK, 0x66 and 0x90 are clear. But, say, 0x0f 0x1f ?
> >
> > we skip is 0x66 ..0x66 0x0f 0x1f
> >
> > So we have a check
> > if (i == (MAX_UINSN_BYTES - 1))
> >
> > so this ensures that we are consider 0x0f 0x1f as nop if and only if
> > they are at the end and preceeded by 0x66.
> 
> Hmm. How so? The code does
> 
> 	if (i == (MAX_UINSN_BYTES - 1))
> 		break;
> 
> 	if ((auprobe->insn[i] == 0x0f) && (auprobe->insn[i+1] == 0x1f))
> 		return true;
> 
> 
> So, afaics, if the intent was to skip 1f0f at the end only, it should do

Its 0f1f and not 1f0f

> 
> 	if (i == (MAX_UINSN_BYTES - 1)) {
> 		if ((auprobe->insn[i] == 0x0f) && (auprobe->insn[i+1] == 0x1f))
> 			return true;
> 		...
> 	}
> 
> "and preceeded by 0x66" above doesn't look true too, perhaps you
> meant "may be preceeded by 0x66".
> 

Yup, as always you are right. We expect 0x0f 0x1f preceeded by 0x66 to
be nop instructions.

> > So are you suggesting extending the list of nops or is it that we are
> > considering non nop instructions as nops?
> 
> No, I am trying to understand which insns arch_skip tries to skip.
> In particular, what "0x0f 0x1f" means.
> 
> > > I compiled this program
> > >
> > > 	int main(void)
> > > 	{
> > > 		asm volatile (".word 0x1f0f");
> > > 		return 0;
> > > 	}
> > >
> > > and objdump reports:
> > >
> > > 	000000000040047c <main>:
> > > 	  40047c:       0f 1f 31                nopl   (%rcx)
> >
> > Current uprobes code wouldnt skip the above insn because it has 31
> > following it.
> 
> See above.
> 
> And again, could you explain which insn has 1f0f (at the end or not) ?
> IOW, what we are trying to skip?

Again its 0f1f and not 1f0f

for example 
0f 1f 40 00
0f 1f 44 00 00
66 0f 1f 44 00 00

I referred arch/x86/include/asm/nops.h, arch/x86/lib/x86-opcode-map.txt
and disassembly of libc.  And ofcourse Jim Keniston helped me in most of
the x86 stuff.

--
thanks and regards
Srikar


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758506Ab2HHO5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 10:57:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30884 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755330Ab2HHO5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 10:57:19 -0400
Date: Wed, 8 Aug 2012 16:53:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Roland McGrath <roland@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakaynahalli <ananth@in.ibm.com>, stan_shebs@mentor.com
Subject: Re: [PATCH 2/5] x86/uprobes: implement x86 specific
	arch_uprobe_*_step
Message-ID: <20120808145345.GA8171@redhat.com>
References: <1344355952-2382-1-git-send-email-bigeasy@linutronix.de> <1344355952-2382-3-git-send-email-bigeasy@linutronix.de> <20120808125709.GA4504@redhat.com> <50226700.9000606@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50226700.9000606@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08, Sebastian Andrzej Siewior wrote:
>
> On 08/08/2012 02:57 PM, Oleg Nesterov wrote:
>>> +static int insn_changes_flags(struct arch_uprobe *auprobe)
>>> +{
>>> +	/* popf reads flags from stack */
>>> +	if (auprobe->insn[0] == 0x9d)
>>> +		return 1;
>>
>> Ah, somehow I didn't think about this before.
>>
>> ->insn[0] doesn't look right, we should skip the prefixes.
>
> Why? I tried 'lock popf' and I got invalid instruction. The same for
> 'rep popf'.

	int main(void)
	{
		asm volatile ("pushf; rep; popf");

		return 0;
	}

objdump:

	00000000040047c <main>:
	  40047c:       55                      push   %rbp
	  40047d:       48 89 e5                mov    %rsp,%rbp
	  400480:       9c                      pushfq
	  400481:       f3 9d                   repz popfq
	  400483:       b8 00 00 00 00          mov    $0x0,%eax
	  400488:       c9                      leaveq
	  400489:       c3                      retq



OK, probably nobody should do this (although the kernel should not
assume this imho), but

	asm volatile ("pushfw; popfw");

doesn't look bad and the code is

	000000000040047c <main>:
	  40047c:       55                      push   %rbp
	  40047d:       48 89 e5                mov    %rsp,%rbp
	  400480:       66 9c                   pushfw
	  400482:       66 9d                   popfw
	  400484:       b8 00 00 00 00          mov    $0x0,%eax
	  400489:       c9                      leaveq
	  40048a:       c3                      retq



And in any case it would be better to re-use auprobe->fixups.

Oleg.


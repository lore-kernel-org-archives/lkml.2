Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444Ab2CMUGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 16:06:46 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:38258 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab2CMUGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 16:06:45 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Dave Jones <davej@redhat.com>
Cc: netdev@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
References: <20120313034201.GA13156@redhat.com>
	<m1vcm8e537.fsf@fess.ebiederm.org> <20120313182646.GB11500@redhat.com>
Date: Tue, 13 Mar 2012 13:10:06 -0700
In-Reply-To: <20120313182646.GB11500@redhat.com> (Dave Jones's message of
	"Tue, 13 Mar 2012 14:26:46 -0400")
Message-ID: <m1wr6oclep.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/HDa2sjpovU0sMo3b0aieLxZ5pM6HffWQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  3.0 XMGappySubj_01 Very gappy subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1501]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Dave Jones <davej@redhat.com>
X-Spam-Relay-Country: **
Subject: Re: tun oops dereferencing garbage nsproxy-> address.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones <davej@redhat.com> writes:

> On Tue, Mar 13, 2012 at 11:19:40AM -0700, Eric W. Biederman wrote:
>
>  > > oops happened here..
>  > >
>  > >         tfile->net = get_net(current->nsproxy->net_ns);
>  > >      548:       48 8b 92 50 05 00 00    mov    0x550(%rdx),%rdx
>  > >      54f:       48 8b 52 28             mov    0x28(%rdx),%rdx
>  > >
>  > > My guess is the fuzzer called some syscall that set current->nsproxy
>  > > to garbage (0x0000000100000001), which later got dereferenced when it
>  > > subsequently randomly did an open() on tun.
>  > >
>  > > Any thoughts ?
>  > 
>  > It smells like a memory stomp.  current->nsproxy is always supposed to
>  > have a valid value, and it never would have an odd value.  The value
>  > should always be at least 8 byte aligned.
>  > 
>  > Since the value is impossible this doesn't feel like a path where the
>  > error handling is wrong.
>
> 0x0000000100000001 looks like one of strange values my fuzzer passes syscalls
> when they ask for an address.
>
> So something managed to get that set as nsproxy.  The fuzzer avoids calling
> clone(), so are there other syscalls that might set this ?

setns and unshare might touch the nsproxy for the same reasons as clone,
but the rules are very similar to clone.

>  > So I am guessing this is a memory stomp.  My guess it would take the
>  > same sequence of system calls on the same kernel build to reproduce
>  > this problem in the same place.
>  > 
>  > Do you have any more information?
>
> I've not managed to reproduce it, and that run sadly had logging turned off,
> so I don't have the exact syscall sequence that caused it.

Grr.  All of the interesting failures seem to happen with logging turned off.

Eric

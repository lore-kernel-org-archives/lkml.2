Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758567Ab1BRUjC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 15:39:02 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:33789 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891Ab1BRUi7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 15:38:59 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Ingo Molnar <mingo@elte.hu>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        Pavel Emelyanov <xemul@openvz.org>,
        Daniel Lezcano <daniel.lezcano@free.fr>
References: <AANLkTikPKpNHxDQAYBd3fiQsmVozLtCVDsNn=+eF_q2r@mail.gmail.com>
	<20110217163531.GF14168@elte.hu> <m1pqqqfpzh.fsf@fess.ebiederm.org>
	<AANLkTinB=EgDGNv-v-qD-MvHVAmstfP_CyyLNhhotkZx@mail.gmail.com>
	<20110218122938.GB26779@tiehlicka.suse.cz>
	<20110218162623.GD4862@tiehlicka.suse.cz>
	<AANLkTimO=M5xG_mnDBSxPKwSOTrp3JhHVBa8=wHsiVHY@mail.gmail.com>
	<m17hcx43m3.fsf@fess.ebiederm.org>
	<AANLkTikh4oaR6CBK3NBazer7yjhE0VndsUB5FCDRsbJc@mail.gmail.com>
	<20110218190128.GF13211@ghostprotocols.net>
	<20110218191146.GG13211@ghostprotocols.net>
Date: Fri, 18 Feb 2011 12:38:49 -0800
In-Reply-To: <20110218191146.GG13211@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Fri, 18 Feb 2011 17:11:46 -0200")
Message-ID: <m1sjvl2i3q.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/oGA3b61HaEiatdlxrH2t+JYjFN4zYPV8=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Arnaldo Carvalho de Melo <acme@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: BUG: Bad page map in process udevd (anon_vma: (null)) in 2.6.38-rc4
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo Carvalho de Melo <acme@redhat.com> writes:

> Em Fri, Feb 18, 2011 at 05:01:28PM -0200, Arnaldo Carvalho de Melo escreveu:
>> Em Fri, Feb 18, 2011 at 10:48:18AM -0800, Linus Torvalds escreveu:
>> > This seems to be a fairly straightforward bug.
>> > 
>> > In net/ipv4/inet_timewait_sock.c we have this:
>> > 
>> >   /* These are always called from BH context.  See callers in
>> >    * tcp_input.c to verify this.
>> >    */
>> > 
>> >   /* This is for handling early-kills of TIME_WAIT sockets. */
>> >   void inet_twsk_deschedule(struct inet_timewait_sock *tw,
>> >                             struct inet_timewait_death_row *twdr)
>> >   {
>> >           spin_lock(&twdr->death_lock);
>> >           ..
>> > 
>> > and the intention is clearly that that spin_lock is BH-safe because
>> > it's called from BH context.
>> > 
>> > Except that clearly isn't true. It's called from a worker thread:
>> > 
>> > > stack backtrace:
>> > > Pid: 10833, comm: kworker/u:1 Not tainted 2.6.38-rc4-359399.2010AroraKernelBeta.fc14.x86_64 #1
>> > > Call Trace:
>> > >  [<ffffffff81460e69>] ? inet_twsk_deschedule+0x29/0xa0
>> > >  [<ffffffff81460fd6>] ? inet_twsk_purge+0xf6/0x180
>> > >  [<ffffffff81460f10>] ? inet_twsk_purge+0x30/0x180
>> > >  [<ffffffff814760fc>] ? tcp_sk_exit_batch+0x1c/0x20
>> > >  [<ffffffff8141c1d3>] ? ops_exit_list.clone.0+0x53/0x60
>> > >  [<ffffffff8141c520>] ? cleanup_net+0x100/0x1b0
>> > >  [<ffffffff81068c47>] ? process_one_work+0x187/0x4b0
>> > >  [<ffffffff81068be1>] ? process_one_work+0x121/0x4b0
>> > >  [<ffffffff8141c420>] ? cleanup_net+0x0/0x1b0
>> > >  [<ffffffff8106a65c>] ? worker_thread+0x15c/0x330
>> > 
>> > so it can deadlock with a BH happening at the same time, afaik.
>> > 
>> > The code (and comment) is all from 2005, it looks like the BH->worker
>> > thread has broken the code. But somebody who knows that code better
>> > should take a deeper look at it.
>> > 
>> > Added acme to the cc, since the code is attributed to him back in 2005
>> > ;). Although I don't know how active he's been in networking lately
>> > (seems to be all perf-related). Whatever, it can't hurt.
>> 
>> Original code is ANK's, I just made it possible to use with DCCP, and
>> yeah, the smiley is appropriate, something 6 years old and the world
>> around it changing continually... well, thanks for the git blame ;-)
>
> But yeah, your analisys seems correct, with the bug being introduced by
> one of these world around it changing continually issues, networking
> namespaces broke the rules of the game on its cleanup_net() routine,
> adding Pavel to the CC list since it doesn't hurt ;-)

Which probably gets the bug back around to me.

I guess this must be one of those ipv4 cases that where the cleanup
simply did not exist in the rmmod sense that we had to invent.

I think that was Daniel who did the time wait sockets.  I do remember
they were a real pain.

Would a bh_disable be sufficient?  I guess I should stop remembering and
look at the code now.

Eric

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab1BNRjy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 12:39:54 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:37670 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754792Ab1BNRjv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 12:39:51 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alex Riesen <raa.lkml@gmail.com>, David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
References: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com>
	<m1hbce46fw.fsf@fess.ebiederm.org>
	<AANLkTikJL_4-7F_2oSuefSpL7ak3+OWLk7F+bDqWT8XJ@mail.gmail.com>
	<m1bp2ly41q.fsf@fess.ebiederm.org>
	<AANLkTimGH5mU+OLRKb=H3WgLXPZaSc5heR+4w5gj2aD4@mail.gmail.com>
	<AANLkTikj-ZTS58uAqUmKQEWzdD3f5DJeox=gOJ9z8rSb@mail.gmail.com>
	<AANLkTinjsimbe6-YgcSK0-zqDuoZ=8xCReHnKZoG4GU9@mail.gmail.com>
	<m14o87wev8.fsf@fess.ebiederm.org>
	<AANLkTimO3h80Wk44OhpfkjzxpzdDKnf6emj2fNObn_jD@mail.gmail.com>
	<m1r5bbthan.fsf@fess.ebiederm.org> <m1fwrrtc0m.fsf@fess.ebiederm.org>
	<m139nqsk3q.fsf@fess.ebiederm.org>
	<AANLkTikt-PhqRHT8+Zp+ZuGoVNaP8G3yqxMHpGZ_Z98w@mail.gmail.com>
Date: Mon, 14 Feb 2011 09:39:45 -0800
In-Reply-To: <AANLkTikt-PhqRHT8+Zp+ZuGoVNaP8G3yqxMHpGZ_Z98w@mail.gmail.com>
	(Linus Torvalds's message of "Mon, 14 Feb 2011 08:37:21 -0800")
Message-ID: <m1k4h2qzvi.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+t/wqNwyaGUo919lr+hzUunw9Zhc/CDUc=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: linux-foundation.org]
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_XMDrugObfuBody_12 obfuscated drug references
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: Re: Heads up Linux 2.6.38-rc4 compile problems.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Mon, Feb 14, 2011 at 7:37 AM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>>
>> 795abaf1e4e188c4171e3cd3dbb11a9fcacaf505  is not fairing too well.
>>
>> The Bad PMDs may be happening more frequently but the oops that killed
>> me was a NULL pointer dereference in acct_collect this time.  Ugh.
>
> So you also have a fair amount of those user-level SIGSEGV reports.
> Which is consistent with memory corruption - most of the time the
> corruption is not something that gets caught as a kernel data
> structure corruption, but some random other data.
>
> The PTE corruption does show a interesting patterns, though:
>
>  - it's always two consecutive page table entries (that have the same
> value, and it looks like a kernel pointer)
>
>    This implies to me that it's a list operation. Please enable
> CONFIG_DEBUG_LIST.
>
>    The fact that the words are the same also tends to imply that it's
> likely a bogus "list_init()" on free'd (or re-used) memory.
>
>  - The values have a pattern, they look like this:
>
>    ffff88000aea5748
>    ffff88000af0d748
>    ffff88000af0f748
>    ffff88001dae1748
>    ffff88004b41f748
>    ffff8800aeb67748
>    ffff8801178f5748
>    ffff880192d85748
>    ffff8801e07a9748
>    ffff8801e50ef748
>    ffff880282177748
>
>    which means that they are always at the same offset (0x1748) of a
> 8kB allocation
>
>  - The page table addresses have a pattern too (the count there is the
> uniq count - there's one pair of addresses that shows up twice):
>
>       1 00000000082e9000
>       1 00000000082ea000
>       1 000000000bae9000
>       1 000000000baea000
>       1 00000000c2ce9000
>       1 00000000c2cea000
>       1 00000000eeae9000
>       1 00000000eeaea000
>       1 00000000ef4e9000
>       1 00000000ef4ea000
>       1 00000000f04e9000
>       1 00000000f04ea000
>       1 00000000f3ce9000
>       1 00000000f3cea000
>       1 00000000f42e9000
>       1 00000000f42ea000
>       2 00000000f50e9000
>       2 00000000f50ea000
>       1 00000000f66e9000
>       1 00000000f66ea000
>
>    and turning "virtual address" into "page table address" (shift down
> by page size, shift up by page table entry size), you get
>
>       00041748
>       00041750
>       0005d748
>       0005d750
>       00616748
>       00616750
>       00775748
>       00775750
>       0077a748
>       0077a750
>       00782748
>       00782750
>       0079e748
>       0079e750
>       007a1748
>       007a1750
>       007a8748
>       007a8750
>       007b3748
>       007b3750
>
>   which shows the same 0x748 pattern (the "1750" pattern is just the
> next word address). Which is *exactly* what you'd expect from an empty
> list (list pointer pointing to itself, and the low 12 bits are
> identical in virtual address - the high bits will obviously differ,
> since they are all about the allocation of the page tables
> themselves).
>
> In other words: I can pretty much guarantee that this is a "struct
> list" that is in a 8kB allocation at offset 0x1748. And that gets
> re-initialized after it got freed.

Interesting.

> Now, I don't know what the actual 8kB allocation is. And most
> structures end up having very different offsets based on various
> config options, so I can't even guess. And it is possible that there
> is some other reason for the 8kB thing (for example, you clearly are
> doing things with networking and promiscuous mode, and maybe the
> particular skb allocation pattern or something ends up using a SLUB
> entry that is always two pages etc.

It could be.  I also use a lot of transient network namespaces, so
potentially it could be just about anything in the networking stack.
They make testing all kinds networking behavior easy, especially when
all you have is a single machine.  Since we sniff the traffic to make
certain the right traffic is in transit we also get a lot of network
interfaces in promiscuous mode.

Eric

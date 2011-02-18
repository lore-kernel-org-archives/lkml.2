Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416Ab1BRDQa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 22:16:30 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:34834 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab1BRDQZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 22:16:25 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
References: <20110216185234.GA11636@tiehlicka.suse.cz>
	<20110216193700.GA6377@elte.hu>
	<AANLkTinDxxbVjrUViCs=UaMD9Wg9PR7b0ShNud5zKE3w@mail.gmail.com>
	<AANLkTi=xnbcs5BKj3cNE_aLtBO7W5m+2uaUacu7M8g_S@mail.gmail.com>
	<20110217090910.GA3781@tiehlicka.suse.cz>
	<AANLkTikPKpNHxDQAYBd3fiQsmVozLtCVDsNn=+eF_q2r@mail.gmail.com>
	<20110217163531.GF14168@elte.hu> <m1pqqqfpzh.fsf@fess.ebiederm.org>
	<AANLkTinB=EgDGNv-v-qD-MvHVAmstfP_CyyLNhhotkZx@mail.gmail.com>
Date: Thu, 17 Feb 2011 19:16:17 -0800
In-Reply-To: <AANLkTinB=EgDGNv-v-qD-MvHVAmstfP_CyyLNhhotkZx@mail.gmail.com>
	(Linus Torvalds's message of "Thu, 17 Feb 2011 11:11:51 -0800")
Message-ID: <m1sjvm822m.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX183IDoRn4HiNZtq9i4Vs06ewx+KPGltVqQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: linux-foundation.org]
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: Re: BUG: Bad page map in process udevd (anon_vma: (null)) in 2.6.38-rc4
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Thu, Feb 17, 2011 at 10:57 AM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>>
>> fedora 14
>> ext4 on all filesystems
>
> Your dmesg snippets had ext3 mentioned, though:
>
>   <6>EXT3-fs (sda1): recovery required on readonly filesystem
>   <6>EXT3-fs (sda1): write access will be enabled during recovery
>   <6>EXT3-fs: barriers not enabled
>   ..
>   <6>EXT3-fs (sda1): recovery complete
>   <6>EXT3-fs (sda1): mounted filesystem with ordered data mode
>   <6>dracut: Mounted root filesystem /dev/sda1
>
> not that I see that it should matter, but there's been some bigger
> ext3 changes too (like the batched discard).
>
> I don't really think ext3 is the issue, though.
>
>> I was about to say this happens with DEBUG_PAGEALLOC enabled but it
>> appears that options keeps eluding my fingers when I have a few minutes
>> to play with it.  Perhaps this time will be the charm.
>
> Please do. You seem to be much better at triggering it than anybody
> else. And do the DEBUG_LIST and DEBUG_SLUB_ON things too (even if the
> DEBUG_LIST thing won't catch list_move())

Interesting.  I just got this with DEBUG_PAGEALLOC
It looks like something in DEBUG_PAGEALLOC is interfering with taking a
successful crashdump.

Given how many network namespaces I create and destroy this might be a
code path I exercise more than most people.

BUG: unable to handle kernel paging request at ffff8801adf8d760
IP: [<ffffffff8140c7ca>] unregister_netdevice_queue+0x3a/0xb0
Oops: 0002 [#1] SMP DEBUG_PAGEALLOC
last sysfs file: /sys/devices/system/cpu/cpu7/cache/index2/shared_cpu_map
Stack:
Call Trace:
Code: 24 08 48 89 fb 49 89 f4 e8 f4 c8 00 00 85 c0 74 6d 4d 85 e4 74 3b 48 8b 93 a0 00 00 00 48 8b 83 a8 00 00 00 48 8d bb a0 00 00 00 <48> 89 42 08 48 89 10 4c 89 e2 49 8b 74 24 08 e8 32 75 e7 ff 48 
RIP  [<ffffffff8140c7ca>] unregister_netdevice_queue+0x3a/0xb0
CR2: ffff8801adf8d760

Eric

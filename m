Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505Ab1AUUOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 15:14:17 -0500
Received: from racecourse.oldelvet.net ([93.93.128.81]:46630 "EHLO
	racecourse.oldelvet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab1AUUOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 15:14:15 -0500
Message-ID: <4D39E913.8060104@oldelvet.org.uk>
Date: Fri, 21 Jan 2011 20:14:11 +0000
From: Richard Mortimer <richm@oldelvet.org.uk>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: David Miller <davem@davemloft.net>, rostedt@goodmis.org,
        609371@bugs.debian.org, ben@decadent.org.uk,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@redhat.com
Subject: Re: Bug#609371: linux-image-2.6.37-trunk-sparc64: module scsi_mod:
 Unknown relocation: 36
References: <20110119221327.GA23544@Krystal> <20110119.142137.184823805.davem@davemloft.net> <20110119223339.GD23544@Krystal> <20110119.164107.135521108.davem@davemloft.net> <20110121000421.GA5014@Krystal> <4D39CB0C.8070308@oldelvet.org.uk> <20110121185259.GA13198@Krystal>
In-Reply-To: <20110121185259.GA13198@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/01/2011 18:52, Mathieu Desnoyers wrote:
> * Richard Mortimer (richm@oldelvet.org.uk) wrote:
...

>> I'm also getting a lot of Kernel unaligned access errors from the
>> kernel. I don't know if they are related to this or not and this is the
>> first time that I personally have got 2.6.37 to boot on sparc64. The
>> messages that I am getting seem to be repeats of
>>
>> [ 4376.807811] Kernel unaligned access at TPC[456e94]
>> try_to_wake_up+0x58/0xec
>> [ 4376.807908] Kernel unaligned access at TPC[75541c] schedule+0x454/0x660
>> [ 4376.808044] Kernel unaligned access at TPC[75541c] schedule+0x454/0x660
>> [ 4376.808871] Kernel unaligned access at TPC[456e94]
>> try_to_wake_up+0x58/0xec
>> [ 4376.808965] Kernel unaligned access at TPC[75541c] schedule+0x454/0x660
>> [ 4381.813354] log_unaligned: 337 callbacks suppressed
>>
>> I have to go out now but will be around later/over the weekend.
>
> Can you send me your .config ? I'd really like to see which of tracepoint/static
> jump patching are enabled.
>
It is basically a clone of the Debian 2.6.37 experimental kernel 
.config. It has been through a couple of make oldconfig cycles with 
different kernel versions so it should be pretty similar to what the 
Debian folks intend. Anyhow if it is still useful you can download it from

http://bridge.oldelvet.org.uk/download/110121_linux-2.6.37_sparc64.config

> Do you get this message as soon as the system boots, or only when you enable
> tracing ?
Good question. Looking back through the logs it started about 14 minutes 
after I booted. I don't remember how that relates to me starting to play 
around with tracing but I'm guessing that you have a good idea what is 
happening.

I've managed to grab disassembly of the two locations that are reporting 
problems just in case that helps.

0000000000456e3c <try_to_wake_up>:
   456e3c:       9d e3 bf 50     save  %sp, -176, %sp
   456e40:       a5 52 00 00     rdpr  %pil, %l2
   456e44:       82 14 a0 0e     or  %l2, 0xe, %g1
   456e48:       91 90 60 00     wrpr  %g1, 0, %pil
   456e4c:       c2 5e 00 00     ldx  [ %i0 ], %g1
   456e50:       b2 0e 40 01     and  %i1, %g1, %i1
   456e54:       02 ce 40 2b     brz  %i1, 456f00 <try_to_wake_up+0xc4>
   456e58:       a2 10 20 00     clr  %l1
   456e5c:       c2 06 20 70     ld  [ %i0 + 0x70 ], %g1
   456e60:       80 a0 60 00     cmp  %g1, 0
   456e64:       12 48 00 07     bne  %icc, 456e80 <try_to_wake_up+0x44>
   456e68:       03 00 22 a5     sethi  %hi(0x8a9400), %g1
   456e6c:       90 10 00 18     mov  %i0, %o0
   456e70:       7f ff ff dd     call  456de4 <T.1233>
   456e74:       92 10 20 01     mov  1, %o1
   456e78:       a2 10 20 01     mov  1, %l1
   456e7c:       03 00 22 a5     sethi  %hi(0x8a9400), %g1
   456e80:       a6 10 00 11     mov  %l1, %l3
   456e84:       c4 00 62 80     ld  [ %g1 + 0x280 ], %g2
   456e88:       80 a0 a0 00     cmp  %g2, 0
   456e8c:       02 48 00 0f     be  %icc, 456ec8 <try_to_wake_up+0x8c>
   456e90:       a8 0c 60 ff     and  %l1, 0xff, %l4
   456e94:       e0 58 62 94     ldx  [ %g1 + 0x294 ], %l0
   456e98:       02 c4 00 0d     brz,pn   %l0, 456ecc <try_to_wake_up+0x90>
   456e9c:       11 00 21 93     sethi  %hi(0x864c00), %o0
   456ea0:       a9 3d 20 00     sra  %l4, 0, %l4
   456ea4:       c2 5c 00 00     ldx  [ %l0 ], %g1
   456ea8:       92 10 00 18     mov  %i0, %o1
   456eac:       94 10 00 14     mov  %l4, %o2
   456eb0:       d0 5c 20 08     ldx  [ %l0 + 8 ], %o0
   456eb4:       9f c0 40 00     call  %g1
   456eb8:       a0 04 20 10     add  %l0, 0x10, %l0
   456ebc:       c2 5c 00 00     ldx  [ %l0 ], %g1


...
   7553f8:       81 58 00 00     flushw
   7553fc:       05 00 22 a5     sethi  %hi(0x8a9400), %g2
   755400:       84 10 a2 c8     or  %g2, 0x2c8, %g2     ! 8a96c8 
<__tracepoint_sched_switch>
   755404:       c2 00 a0 08     ld  [ %g2 + 8 ], %g1
   755408:       80 a0 60 00     cmp  %g1, 0
   75540c:       22 48 00 11     be,a   %icc, 755450 <schedule+0x488>
   755410:       e4 5c 21 50     ldx  [ %l0 + 0x150 ], %l2
   755414:       07 00 22 a5     sethi  %hi(0x8a9400), %g3
   755418:       86 10 e2 e4     or  %g3, 0x2e4, %g3     ! 8a96e4 
<__tracepoint_sched_switch+0x1c>
   75541c:       e4 58 c0 00     ldx  [ %g3 ], %l2
   755420:       22 c4 80 0c     brz,a,pn   %l2, 755450 <schedule+0x488>
   755424:       e4 5c 21 50     ldx  [ %l0 + 0x150 ], %l2
   755428:       c2 5c 80 00     ldx  [ %l2 ], %g1

Regards

Richard

P.S. I saw your followup mail so hopefully this matches what you have found!

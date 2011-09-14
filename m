Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521Ab1INHcF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 03:32:05 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:64229 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab1INHcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 03:32:02 -0400
MIME-Version: 1.0
In-Reply-To: <1315983230.2565.28.camel@edumazet-laptop>
References: <1315941801.2565.19.camel@edumazet-laptop>
	<CA+55aFyG3-3_gqGjqUmsTAHWfmNLMdQVf4XqUZrDAGMBxgur=Q@mail.gmail.com>
	<CA+55aFz9DFFJyjMusVkUcBdCBX02RrmH0uCRASw0EQHC3SdaUA@mail.gmail.com>
	<1315983230.2565.28.camel@edumazet-laptop>
Date: Wed, 14 Sep 2011 15:32:01 +0800
X-Google-Sender-Auth: 60bv_qDmZuw79EqD1nNiEdTdu4Q
Message-ID: <CANejiEXK524dgYZ+TSfqytZHE9CLjtP70cmvTPSNPR5zeDYkxw@mail.gmail.com>
Subject: Re: [BUG] infinite loop in find_get_pages()
From: Shaohua Li <shli@kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>
Content-Type: multipart/mixed; boundary=0016e650581091523604ace1c198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e650581091523604ace1c198
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

it appears we didn't account skipped swap entry in find_get_pages().
does the attached patch help?

Thanks,
Shaohua
2011/9/14 Eric Dumazet <eric.dumazet@gmail.com>:
> Le mardi 13 septembre 2011 =E0 23:48 -0700, Linus Torvalds a =E9crit :
>> Re-sending, because apparently none of my email in the last few days
>> have actually gone out due to LF problems..
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Linus
>>
>> On Tue, Sep 13, 2011 at 12:48 PM, Linus Torvalds
>> <torvalds@linux-foundation.org> wrote:
>> > On Tue, Sep 13, 2011 at 12:23 PM, Eric Dumazet <eric.dumazet@gmail.com=
> wrote:
>> >>
>> >> It seems current kernels (3.1.0-rc6) are really unreliable, or maybe =
I
>> >> expect too much from them.
>> >
>> > No, by now, they should be damn well reliable.
>> >
>> >> On my 4GB x86_64 machine (2 quad-core cpus, 2 threads per core), I ca=
n
>> >> have a cpu locked in
>> >>
>> >> =A0find_get_pages -> radix_tree_gang_lookup_slot -> __lookup
>> >
>> > Hmm. There hasn't been many changes in this area, so the few changes
>> > that *do* exist are obviously very suspicious.
>> >
>> > In particular, the only real change to that whole setup is the changes
>> > by Hugh to make the swap entries use the radix tree. So I'm bringing
>> > Hugh and Andrew to the discussion (and Rik, since he acked a few of
>> > those changes).
>> >
>> > The fact that some light swapping activity seems to accompany the
>> > problem just makes me more certain it's Hugh's swap/radix tree work.
>> >
>> > We're talking only a handful of patches, so maybe Hugh could create a
>> > revert patch just to confirm that yes, that's the problem.
>> >
>> > Hugh?
>> >
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Linus
>> >
>> > --- quoting the rest of the email for Hugh/Andrew ---
>> >> Problem is : A bisection will be very hard, since a lot of kernels
>> >> simply destroy my disk (the PCI MRRS horror stuff).
>> >>
>> >> Messages at console :
>> >>
>> >> INFO: rcu_preempt_state detected stalls on CPUs/tasks: {} (detected b=
y
>> >> 11 t=3D60002 jiffies)
>> >>
>> >> perf top -C 1
>> >>
>> >> Events: 3K cycles
>> >> + =A0 =A0 43,08% =A0bash =A0[kernel.kallsyms] =A0[k] __lookup
>> >> + =A0 =A0 41,51% =A0bash =A0[kernel.kallsyms] =A0[k] find_get_pages
>> >> + =A0 =A0 15,31% =A0bash =A0[kernel.kallsyms] =A0[k] radix_tree_gang_=
lookup_slot
>> >>
>> >> =A0 =A043.08% =A0 =A0 bash =A0[kernel.kallsyms] =A0[k] __lookup
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 |
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 --- __lookup
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0|
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0|--97.09%-- radix_tree_gang_lookup=
_slot
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A0 =A0 =A0 =A0find_get_page=
s
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A0 =A0 =A0 =A0pagevec_looku=
p
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A0 =A0 =A0 =A0invalidate_ma=
pping_pages
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A0 =A0 =A0 =A0drop_pagecach=
e_sb
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A0 =A0 =A0 =A0iterate_super=
s
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A0 =A0 =A0 =A0drop_caches_s=
ysctl_handler
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A0 =A0 =A0 =A0proc_sys_call=
_handler.isra.3
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A0 =A0 =A0 =A0proc_sys_writ=
e
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A0 =A0 =A0 =A0vfs_write
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A0 =A0 =A0 =A0sys_write
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A0 =A0 =A0 =A0system_call_f=
astpath
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A0 =A0 =A0 =A0__write
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0|
>> >>
>> >>
>> >> Steps to reproduce :
>> >>
>> >> In one terminal, kernel builds in a loop (defconfig + hpsa driver)
>> >>
>> >> cd /usr/src/linux
>> >> while :
>> >> do
>> >> =A0make clean
>> >> =A0make -j128
>> >> done
>> >>
>> >>
>> >> In another term :
>> >>
>> >> while :
>> >> do
>> >> =A0echo 3 >/proc/sys/vm/drop_caches
>> >> =A0sleep 20
>> >> done
>> >>
>> >>
>> >> Before the lock, I can see in another terminal some swapping activity=
.
>> >>
>> >> $ vmstat 1
>> >> procs -----------memory---------- ---swap-- -----io---- -system-- ---=
-cpu----
>> >> =A0r =A0b =A0 swpd =A0 free =A0 buff =A0cache =A0 si =A0 so =A0 =A0bi=
 =A0 =A0bo =A0 in =A0 cs us sy id wa
>> >> =A02 =A02 =A017728 3443924 =A011520 328020 =A0 =A00 =A0 =A00 =A0 256 =
12076 16250 =A0554 =A00 =A06 82 12
>> >> =A01 =A01 =A017728 3444776 =A011584 328072 =A0 =A00 =A0 =A00 =A0 100 =
=A02868 16223 =A0267 =A00 =A06 86 =A07
>> >> =A01 =A01 =A017728 3442200 =A012100 328348 =A0 =A00 =A0 =A00 =A0 868 =
=A0 =A0 0 16600 1778 =A00 =A07 88 =A06
>> >> =A01 =A01 =A017728 3438032 =A013036 329048 =A0 =A00 =A0 =A00 =A01628 =
=A0 =A0 0 16862 2480 =A00 =A07 87 =A05
>> >> =A01 =A01 =A017728 3546864 =A013988 220256 =A0 =A00 =A0 =A00 =A01000 =
=A0 =A0 0 16313 =A0931 =A00 =A07 87 =A06
>> >> =A01 =A01 =A017728 3544260 =A016024 220256 =A0 =A00 =A0 =A00 =A02036 =
=A0 =A0 0 16513 1531 =A00 =A06 88 =A06
>> >> =A01 =A01 =A017728 3542896 =A017196 220256 =A0 =A00 =A0 =A00 =A01160 =
=A0 556 16324 =A0893 =A00 =A06 88 =A06
>> >> =A01 =A01 =A017728 3540748 =A018756 220256 =A0 =A00 =A0 =A00 =A01560 =
=A0 =A0 0 16398 1172 =A00 =A06 88 =A06
>> >> =A01 =A01 =A017728 3538692 =A020168 220256 =A0 =A00 =A0 =A00 =A01412 =
=A0 =A0 0 16544 1088 =A00 =A06 88 =A06
>> >> =A02 =A00 =A017728 3536676 =A021816 220248 =A0 =A00 =A0 =A00 =A01648 =
=A0 =A0 0 16447 1246 =A00 =A06 88 =A06
>> >> =A01 =A01 =A017728 3535052 =A022544 220256 =A0 =A00 =A0 =A00 =A0 728 =
=A0 =A0 0 16215 =A0605 =A01 =A06 87 =A05
>> >> =A01 =A01 =A017728 3533672 =A023404 220244 =A0 =A00 =A0 =A00 =A0 860 =
=A04240 16264 =A0705 =A00 =A06 88 =A06
>> >> =A01 =A01 =A017728 3532688 =A024232 220244 =A0 =A00 =A0 =A00 =A0 828 =
=A0 =A0 0 16272 =A0685 =A00 =A06 87 =A06
>> >> =A01 =A01 =A017728 3531552 =A025080 220244 =A0 =A00 =A0 =A00 =A0 848 =
=A0 =A0 0 16294 =A0700 =A00 =A06 88 =A06
>> >> =A01 =A01 =A017728 3529584 =A026532 220256 =A0 =A00 =A0 =A00 =A01452 =
=A0 =A0 0 16376 1104 =A00 =A06 87 =A06
>> >> =A01 =A02 =A017728 3545232 =A027848 199176 =A0 =A00 =A0 =A00 =A01312 =
=A0 =A052 16392 =A0911 =A00 =A07 85 =A08
>> >> =A01 =A02 =A017728 3659060 =A029576 =A084420 =A0 =A00 =A0 =A00 =A0173=
6 =A0 =A040 16570 =A0959 =A00 =A07 81 12
>> >> 38 =A03 =A017728 3640652 =A029984 =A069976 =A0 =A00 =A0 =A00 =A0 688 =
=A0 =A0 0 16885 2987 =A03 =A08 80 =A09
>> >> =A05 =A02 =A017728 3601716 =A030208 =A075628 =A0 =A00 =A0 =A00 =A0467=
6 =A0 =A0 4 18080 5727 11 10 66 12
>> >> procs -----------memory---------- ---swap-- -----io---- -system-- ---=
-cpu----
>> >> =A0r =A0b =A0 swpd =A0 free =A0 buff =A0cache =A0 si =A0 so =A0 =A0bi=
 =A0 =A0bo =A0 in =A0 cs us sy id wa
>> >> 103 27 =A017728 2286372 =A030376 =A078952 =A0 =A00 =A0 =A00 =A03044 =
=A0 =A0 8 17772 6803 49 16 34 =A01
>> >> 128 =A01 =A017728 1337588 =A030416 =A079952 =A0 =A00 =A0 =A00 =A0 732=
 =A04080 16389 4874 91 =A09 =A00 =A00
>> >> 122 =A07 =A017728 730264 =A030472 =A081056 =A0 =A00 =A0 =A00 =A0 540 =
=A01300 16535 5451 91 =A09 =A00 =A00
>> >> 99 16 =A017728 996308 =A030544 =A083136 =A0 =A00 =A0 =A00 =A0 492 =A0=
 452 16951 6629 92 =A08 =A00 =A00
>> >> 89 23 =A017728 1150640 =A030592 =A088288 =A0 =A00 =A0 =A00 =A03232 =
=A0 224 17286 7312 91 =A09 =A00 =A00
>> >> 114 =A07 =A017728 1344768 =A030660 =A092104 =A0 =A00 =A0 =A00 =A01668=
 =A0 228 17395 7297 89 11 =A00 =A00
>> >> 99 =A03 =A017728 848716 =A030696 =A093684 =A0 =A00 =A0 =A00 =A0 688 =
=A02072 16947 6368 92 =A08 =A00 =A00
>> >> 112 =A09 =A017728 609908 =A030748 =A096036 =A0 =A00 =A0 =A00 =A0 620 =
=A0 272 17221 7640 90 10 =A00 =A00
>> >> 111 =A08 =A017728 480244 =A030808 =A098268 =A0 =A00 =A0 =A00 =A0 788 =
=A0 320 17227 7391 92 =A08 =A00 =A00
>> >> 115 =A07 =A017728 549564 =A030852 100552 =A0 =A00 =A0 =A00 =A0 656 =
=A0 232 17583 7807 92 =A09 =A00 =A00
>> >> 107 =A09 =A017728 666776 =A030888 102904 =A0 =A00 =A0 =A00 =A0 716 =
=A0 =A0 0 17406 7781 91 =A09 =A00 =A00
>> >> 124 =A05 =A017728 685368 =A030960 105544 =A0 =A00 =A0 =A00 =A01056 =
=A0 944 17281 7713 90 10 =A00 =A00
>> >> 130 =A01 =A017728 538832 =A031000 108080 =A0 =A00 =A0 =A00 =A0 776 =
=A0 =A0 0 16943 7347 91 =A09 =A00 =A00
>> >> 130 =A00 =A017728 364476 =A031032 110252 =A0 =A00 =A0 =A00 =A0 676 =
=A0 =A0 0 16767 6948 91 =A09 =A00 =A00
>> >> 129 =A00 =A017728 149332 =A031064 111848 =A0 =A00 =A0 =A00 =A0 540 =
=A0 =A032 16673 6272 92 =A08 =A00 =A00
>> >> 129 =A00 =A017728 274664 =A031096 114052 =A0 =A00 =A0 =A00 =A0 628 =
=A0 =A0 0 17207 7694 92 =A08 =A00 =A00
>> >> 128 =A03 =A017728 589736 =A031160 117420 =A0 =A00 =A0 =A00 =A0 816 =
=A0 996 17381 8443 90 10 =A00 =A00
>> >> 126 =A05 =A017728 485300 =A031172 119544 =A0 =A00 =A0 =A00 =A0 416 =
=A0 =A0 0 17024 7186 91 =A09 =A00 =A00
>> >> 130 =A00 =A017728 349500 =A031216 122344 =A0 =A00 =A0 =A00 =A0 492 =
=A0 =A0 0 17046 7358 91 =A09 =A00 =A00
>> >> procs -----------memory---------- ---swap-- -----io---- -system-- ---=
-cpu----
>> >> =A0r =A0b =A0 swpd =A0 free =A0 buff =A0cache =A0 si =A0 so =A0 =A0bi=
 =A0 =A0bo =A0 in =A0 cs us sy id wa
>> >> 130 =A02 =A017728 416972 =A031248 125404 =A0 =A00 =A0 =A00 =A0 496 =
=A0 120 17112 7124 91 =A09 =A00 =A00
>> >> 125 =A05 =A017308 188608 =A029444 106888 =A0 =A00 =A0576 =A01436 =A0 =
612 40020 9430 91 =A08 =A00 =A00
>> >> 113 16 =A017308 218700 =A029528 110336 =A0 32 =A0 =A00 =A01908 =A0 =
=A0 0 17210 7214 92 =A08 =A00 =A00
>> >> =A01 145 =A020292 =A015688 =A026884 108200 =A0 40 3020 =A0 188 =A0466=
0 27003 3664 30 =A07 =A00 63
>> >> =A01 145 =A021128 =A015920 =A024212 107420 =A0 =A00 =A0836 =A0 =A0 0 =
=A03824 16813 =A0430 =A01 =A06 =A00 93
>> >> =A02 144 =A022904 =A016020 =A020780 106780 =A0 =A00 1776 =A0 =A0 0 =
=A06548 16611 =A0505 =A01 =A06 =A00 93
>> >> =A01 146 =A023496 =A015788 =A017476 106160 =A0 32 =A0596 =A0 =A060 =
=A03620 16610 =A0308 =A01 =A06 =A00 93
>> >> =A01 147 =A023924 =A016216 =A016028 105852 =A0 32 =A0432 =A0 =A032 =
=A05012 16477 =A0156 =A00 =A06 =A00 93
>> >> =A01 145 =A024428 =A015904 =A014744 103452 =A0 20 =A0504 =A0 =A020 =
=A03112 16776 =A0125 =A01 =A06 =A00 93
>> >> =A01 146 =A025304 =A016184 =A014688 =A097712 =A0 =A00 =A0876 =A0 =A01=
6 =A03352 16759 =A0447 =A02 =A06 =A00 92
>> >> =A01 147 =A026984 =A015908 =A014588 =A088348 =A0 96 1680 =A0 =A096 =
=A06352 17006 =A0235 =A01 =A06 =A00 93
>> >> =A01 146 =A028724 =A016112 =A014152 =A077132 =A0 32 1740 =A0 =A044 =
=A03536 16739 =A0375 =A02 =A06 =A00 92
>> >> =A01 151 =A029900 =A015896 =A012072 =A068484 =A0156 1184 =A0 192 =A02=
068 16860 =A0576 =A02 =A06 =A00 91
>> >> =A02 152 =A033724 =A033908 =A0 9536 =A058616 =A0184 3856 =A0 512 =A06=
764 16536 =A0492 =A02 =A06 =A03 88
>> >> =A01 142 =A033276 427352 =A0 8964 =A058988 1096 =A0120 =A02624 =A0 12=
0 16730 1129 =A06 =A07 =A08 79
>> >> =A02 142 =A033000 421512 =A0 8988 =A060944 1560 =A0 =A00 =A03512 =A0 =
=A0 0 16771 1220 =A01 =A06 =A09 84
>> >> =A02 143 =A032604 392952 =A0 9012 =A062308 1176 =A0 =A00 =A02436 =A0 =
=A0 0 16690 1173 =A02 =A07 10 82
>> >> =A08 134 =A032400 255348 =A0 9044 =A064696 =A0688 =A0 =A00 =A02584 =
=A0 =A0 0 17105 2181 16 =A08 14 62
>> >> =A06 136 =A031796 142068 =A0 9092 =A066024 1060 =A0 =A00 =A01828 =A0 =
=A0 0 17040 2226 37 10 12 41
>> >> procs -----------memory---------- ---swap-- -----io---- -system-- ---=
-cpu----
>> >> =A0r =A0b =A0 swpd =A0 free =A0 buff =A0cache =A0 si =A0 so =A0 =A0bi=
 =A0 =A0bo =A0 in =A0 cs us sy id wa
>> >> =A02 143 =A031664 =A015844 =A0 9152 =A067452 =A0580 =A0 64 =A01324 =
=A0 292 16973 2066 37 10 11 43
>> >> =A04 141 =A031876 =A056160 =A0 9052 =A067528 =A0 48 =A0328 =A0 140 =
=A01724 16476 =A0696 =A06 =A07 =A00 87
>> >> =A04 141 =A032420 176260 =A0 8896 =A068808 =A0108 =A0732 =A0 760 =A02=
280 17449 3081 24 =A09 =A00 67
>> >> 11 134 =A032540 119868 =A0 8484 =A070568 =A0108 =A0852 =A01140 =A0140=
8 17436 3788 45 12 =A01 43
>> >> 17 129 =A032880 =A057044 =A0 8256 =A073008 =A0 =A00 =A0364 =A01212 =
=A0 364 17489 4000 59 13 =A00 28
>> >> 11 135 =A033468 107128 =A0 7660 =A073124 =A0200 1044 =A0 888 =A02076 =
17043 1956 23 =A09 =A00 69
>> >> =A01 144 =A034788 =A016076 =A0 6948 =A071572 =A0180 1524 =A0 276 =A01=
908 16787 =A0967 13 =A07 =A00 79
>> >> =A01 145 =A035472 =A016188 =A0 5868 =A070348 =A0112 =A0768 =A0 120 =
=A01284 16696 =A0561 =A01 =A06 =A00 93
>> >> =A01 145 =A036056 =A016696 =A0 5492 =A068240 =A0 16 =A0596 =A0 =A016 =
=A03356 16456 =A0202 =A00 =A06 =A00 93
>> >> =A01 143 =A038200 =A015952 =A0 3168 =A063968 =A0 32 2168 =A0 =A052 =
=A06460 16834 =A0423 =A01 =A07 =A00 92
>> >> =A09 131 =A040128 139084 =A0 3064 =A061060 =A0172 2144 =A0 644 =A0219=
2 17701 2250 19 =A09 =A00 72
>> >> =A09 133 =A040548 110308 =A0 3092 =A060492 =A0468 =A0620 =A0 900 =A01=
852 17516 1983 35 =A09 =A00 55
>> >> 10 132 =A040448 =A079476 =A0 3132 =A061808 1020 =A0 =A00 =A01480 =A0 =
=A0 0 17505 3254 35 10 =A00 55
>> >> 12 132 =A040532 139396 =A0 3156 =A063204 =A0776 =A0260 =A01272 =A0 89=
2 17457 3179 44 11 =A00 45
>> >> 11 132 =A040392 =A066336 =A0 3256 =A065264 =A0788 =A0 =A00 =A01536 =
=A0 =A0 0 17551 3860 46 11 =A00 43
>> >> =A01 142 =A041112 =A015796 =A0 3296 =A065680 1176 =A0812 =A01636 =A02=
568 17026 1798 28 =A09 =A00 63
>> >> =A01 140 =A041500 =A015960 =A0 3244 =A064828 =A0 92 =A0472 =A0 116 =
=A04008 16445 =A0443 =A04 =A07 =A00 90
>> >> =A01 140 =A042252 =A016740 =A0 3232 =A064356 =A0 =A00 =A0764 =A0 =A0 =
0 =A01500 16403 =A0185 =A00 =A06 =A00 94
>> >> =A01 139 =A049636 =A016024 =A0 2928 =A060652 =A0 52 7376 =A0 =A052 =
=A07376 17507 1236 =A00 =A07 =A00 93
>> >> procs -----------memory---------- ---swap-- -----io---- -system-- ---=
-cpu----
>> >> =A0r =A0b =A0 swpd =A0 free =A0 buff =A0cache =A0 si =A0 so =A0 =A0bi=
 =A0 =A0bo =A0 in =A0 cs us sy id wa
>> >> =A02 140 =A055780 =A016444 =A0 2548 =A055948 =A0176 6200 =A0 332 =A06=
260 17160 =A0592 =A01 =A07 =A00 92
>> >> =A03 145 =A059800 358088 =A0 2404 =A055468 =A0100 4108 =A01092 =A0413=
2 18514 3864 17 =A08 =A00 75
>> >> =A03 143 =A060712 =A027028 =A0 2416 =A057184 =A0816 =A0964 =A02392 =
=A01288 18089 3476 43 10 =A00 47
>> >> =A04 141 =A061296 154136 =A0 2516 =A058024 =A0424 =A0980 =A01312 =A0 =
980 17298 2489 28 =A09 =A00 62
>> >> 21 122 =A062544 =A083120 =A0 2528 =A058372 =A0100 1456 =A0 788 =A0145=
6 17717 2738 64 12 =A00 24
>> >> 24 120 =A062780 =A053328 =A0 2580 =A062216 =A0 16 =A0292 =A02528 =A0 =
292 17163 4076 85 14 =A00 =A01
>> >> =A01 143 =A065088 =A016096 =A0 2492 =A061524 =A0152 2708 =A0 764 =A02=
712 16734 1474 16 =A08 =A00 76
>> >> =A03 141 =A065672 =A034232 =A0 2476 =A060536 =A0 56 =A0672 =A0 240 =
=A03208 16726 =A0661 =A04 =A07 =A00 89
>> >> =A01 144 =A065584 =A016044 =A0 2488 =A060440 =A0808 =A0 68 =A0 948 =
=A01532 17187 1353 10 =A08 =A00 82
>> >> =A04 141 =A070836 =A017216 =A0 2444 =A058024 =A0 64 5272 =A0 =A064 =
=A06968 16957 =A0437 =A00 =A06 =A00 93
>> >> =A06 134 =A073728 =A031940 =A0 2424 =A056880 =A0436 3092 =A0 748 =A03=
188 16950 1269 =A08 =A07 =A00 85
>> >> =A02 139 =A076036 107996 =A0 2408 =A056404 =A0 92 2420 =A0 476 =A0278=
4 16869 =A0690 =A06 =A07 =A00 87
>> >> =A06 135 =A076112 =A082792 =A0 2436 =A057884 1108 =A0476 =A01632 =A0 =
724 16999 1711 18 =A08 =A00 73
>> >> =A01 139 =A077184 =A017872 =A0 2444 =A057860 =A0996 1084 =A01168 =A02=
320 16644 =A0748 11 =A08 =A00 81
>> >> =A01 141 =A091136 =A015952 =A0 2300 =A051868 =A0100 14088 =A0 128 141=
52 17494 1284 =A01 =A07 =A05 87
>> >> =A01 143 =A098356 204144 =A0 2256 =A048168 =A0640 7496 =A01148 =A0758=
0 17471 1840 =A06 =A07 12 74
>> >> =A03 139 =A097344 174272 =A0 2276 =A048968 2636 =A0 =A00 =A03216 =A0 =
=A0 0 16962 1499 13 =A08 11 69
>> >> =A09 133 =A097220 123464 =A0 2352 =A050584 1348 =A0 =A00 =A02320 =A0 =
500 17100 2255 27 =A09 =A08 56
>> >> =A09 134 =A097092 =A033672 =A0 2396 =A051780 1292 =A0108 =A02028 =A0 =
108 16821 1547 27 =A08 =A08 57
>> >> procs -----------memory---------- ---swap-- -----io---- -system-- ---=
-cpu----
>> >> =A0r =A0b =A0 swpd =A0 free =A0 buff =A0cache =A0 si =A0 so =A0 =A0bi=
 =A0 =A0bo =A0 in =A0 cs us sy id wa
>> >> 11 134 =A095068 =A075744 =A0 2448 =A053444 =A0852 =A0 =A00 =A01696 =
=A0 =A0 0 17318 2630 34 10 =A02 54
>> >> =A01 143 =A095104 =A015972 =A0 2504 =A054544 =A0116 =A0 44 =A0 696 =
=A0 =A044 16545 1209 20 =A08 =A05 67
>> >> ^C
>> >>
>> >>
>> >>
>> >>
>> >
>
> It appears bisection was not so horrific (I was out of the PCI/MRSS bug
> window), It will complete shortly :
>
> # git bisect bad
> Bisecting: 33 revisions left to test after this (roughly 5 steps)
> [c299eba3c5a801657f275d33be588b34831cd30e] Merge branch 'release' of git:=
//git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6
> # git bisect log
> git bisect start
> # bad: [003f6c9df54970d8b19578d195b3e2b398cdbde2] lib/sha1.c: quiet spars=
e noise about symbol not declared
> git bisect bad 003f6c9df54970d8b19578d195b3e2b398cdbde2
> # good: [02f8c6aee8df3cdc935e9bdd4f2d020306035dbe] Linux 3.0
> git bisect good 02f8c6aee8df3cdc935e9bdd4f2d020306035dbe
> # good: [d5ef642355bdd9b383ff5c18cbc6102a06eecbaf] Merge branch 'tty-next=
' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty-2.6
> git bisect good d5ef642355bdd9b383ff5c18cbc6102a06eecbaf
> # good: [664a41b8a91bf78a01a751e15175e0008977685a] Merge branch 'v4l_for_=
linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6
> git bisect good 664a41b8a91bf78a01a751e15175e0008977685a
> # bad: [585df1d90cb07a02ca6c7a7d339e56e46d50dafb] xhci: Remove TDs from T=
D lists when URBs are canceled.
> git bisect bad 585df1d90cb07a02ca6c7a7d339e56e46d50dafb
> # good: [60ad4466821a96913a9b567115e194ed1087c2d7] Merge branch 'for_linu=
s' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4
> git bisect good 60ad4466821a96913a9b567115e194ed1087c2d7
> # bad: [7f3bf7cd348cead84f8027b32aa30ea49fa64df5] Merge branch 'next' of =
git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx
> git bisect bad 7f3bf7cd348cead84f8027b32aa30ea49fa64df5
> # good: [9e8ed3ae924b65ab5f088fe63ee6f4326f04590f] [S390] signal: use set=
_restore_sigmask() helper
> git bisect good 9e8ed3ae924b65ab5f088fe63ee6f4326f04590f
> # bad: [31475dd611209413bace21651a400afb91d0bd9d] mm: a few small updates=
 for radix-swap
> git bisect bad 31475dd611209413bace21651a400afb91d0bd9d
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" i=
n
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at =A0http://www.tux.org/lkml/
>

--0016e650581091523604ace1c198
Content-Type: text/x-patch; charset=US-ASCII; name="filemap-dbg.patch"
Content-Disposition: attachment; filename="filemap-dbg.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gsjzw4770

ZGlmZiAtLWdpdCBhL21tL2ZpbGVtYXAuYyBiL21tL2ZpbGVtYXAuYwppbmRleCA2NDVhMDgwLi5m
MTc3ZTk2IDEwMDY0NAotLS0gYS9tbS9maWxlbWFwLmMKKysrIGIvbW0vZmlsZW1hcC5jCkBAIC04
MjcsMTMgKzgyNywxNCBAQCB1bnNpZ25lZCBmaW5kX2dldF9wYWdlcyhzdHJ1Y3QgYWRkcmVzc19z
cGFjZSAqbWFwcGluZywgcGdvZmZfdCBzdGFydCwKIHsKIAl1bnNpZ25lZCBpbnQgaTsKIAl1bnNp
Z25lZCBpbnQgcmV0OwotCXVuc2lnbmVkIGludCBucl9mb3VuZDsKKwl1bnNpZ25lZCBpbnQgbnJf
Zm91bmQsIG5yX3NraXA7CiAKIAlyY3VfcmVhZF9sb2NrKCk7CiByZXN0YXJ0OgogCW5yX2ZvdW5k
ID0gcmFkaXhfdHJlZV9nYW5nX2xvb2t1cF9zbG90KCZtYXBwaW5nLT5wYWdlX3RyZWUsCiAJCQkJ
KHZvaWQgKioqKXBhZ2VzLCBOVUxMLCBzdGFydCwgbnJfcGFnZXMpOwogCXJldCA9IDA7CisJbnJf
c2tpcCA9IDA7CiAJZm9yIChpID0gMDsgaSA8IG5yX2ZvdW5kOyBpKyspIHsKIAkJc3RydWN0IHBh
Z2UgKnBhZ2U7CiByZXBlYXQ6CkBAIC04NTYsNiArODU3LDcgQEAgcmVwZWF0OgogCQkJICogaGVy
ZSBhcyBhbiBleGNlcHRpb25hbCBlbnRyeTogc28gc2tpcCBvdmVyIGl0IC0KIAkJCSAqIHdlIG9u
bHkgcmVhY2ggdGhpcyBmcm9tIGludmFsaWRhdGVfbWFwcGluZ19wYWdlcygpLgogCQkJICovCisJ
CQlucl9za2lwKys7CiAJCQljb250aW51ZTsKIAkJfQogCkBAIC04NzYsNyArODc4LDcgQEAgcmVw
ZWF0OgogCSAqIElmIGFsbCBlbnRyaWVzIHdlcmUgcmVtb3ZlZCBiZWZvcmUgd2UgY291bGQgc2Vj
dXJlIHRoZW0sCiAJICogdHJ5IGFnYWluLCBiZWNhdXNlIGNhbGxlcnMgc3RvcCB0cnlpbmcgb25j
ZSAwIGlzIHJldHVybmVkLgogCSAqLwotCWlmICh1bmxpa2VseSghcmV0ICYmIG5yX2ZvdW5kKSkK
KwlpZiAodW5saWtlbHkoIXJldCAmJiBucl9mb3VuZCAmJiAobnJfZm91bmQgIT0gbnJfc2tpcCkp
KQogCQlnb3RvIHJlc3RhcnQ7CiAJcmN1X3JlYWRfdW5sb2NrKCk7CiAJcmV0dXJuIHJldDsK
--0016e650581091523604ace1c198--

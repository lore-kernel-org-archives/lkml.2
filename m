Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab1IDVlv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 17:41:51 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60944 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609Ab1IDVlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 17:41:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "H.J. Lu" <hjl.tools@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Valdis.Kletnieks@vt.edu,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Kuo <rkuo@codeaurora.org>, Mark Salter <msalter@redhat.com>,
        Jonas Bonn <jonas@southpole.se>, Tobias Klauser <tklauser@distanz.ch>
Subject: Re: RFD: x32 ABI system call numbers
Date: Sun, 04 Sep 2011 23:41:03 +0200
Message-ID: <3634139.5BAXH7nXYb@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <CAMe9rOrANCdgbhoY1F-hMc7Rbov_2O34A+MHTeYF3eieTP2EGw@mail.gmail.com>
References: <4E582577.2060805@zytor.com> <33733402.CzI6MIxaEn@wuerfel> <CAMe9rOrANCdgbhoY1F-hMc7Rbov_2O34A+MHTeYF3eieTP2EGw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:TkZqcdspA1JtTKaH4kqfQUpmVaFHxdCllvjnfnYMfth
 SXJnHmO8Q5VyaPg4+td5qK3LtfFXzg10GcQ1xQPEPHlMVdKsx8
 LhQ78pVUJbbD8OR2IP/4bBZp3SI6JJrSNINFYwao1vs+aY40LI
 RP7bJc3+xJnHoIapJZGTK//2Zwov2q5DMht02UmKeGnTpPECLT
 alKD/ZGkr05WnAI9Zja7Uk0ebxfB52bUDs9NRfZ8mnqIYuplP6
 X4ZJkaLkGna/qU4Tu9wJ7w/4H7kZ7+cqpWhEm17sqfuqOYAWMf
 Ceocrd1ADI041hwbigvCRxRpO0x9B8Fv+kSWdZJ/o3rtTMUYKk
 BKKg9UlnJe3dA+wUdtOQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 September 2011 14:25:53 H.J. Lu wrote:
> >> >> #define __NR_x32_recvfrom
> >> >> #define __NR_x32_sendmsg
> >> >> #define __NR_x32_recvmsg
> >> >> #define __NR_x32_recvmmsg
> >> >> #define __NR_x32_sendmmsg
> >> >
> >> > These today use the MSG_CMSG_COMPAT flag to distinguish native and compat
> >> > calls. Do you plan to have another flag here to handle cmsg time values?
> >>
> >> I am using x86-32 calls for them.
> >>
> >> > What about things like mq_{get,set}attr, quotactl and semtimedop?
> >> >
> >>
> >> I am using 64bit system calls for x32.
> >
> > But isn't that broken? These all pass u64 or time_t values at some point.
> >
> 
> time_t isn't a problem since time_t/timeval/timespec are identical for
> x32 and x86-64.  As for u64, I added NATIVE_LONG_TYPE, which is
> defined as long long for x32,  and use it instead of long in types for
> 64bit system calls.

Sorry, I misread you as saying you use the compat syscalls for these.
If you use the native 64 bit syscalls, you have the opposite problem:
Some network protocols (e.g. netlink or rxrpc) use other data structures
that require conversion, e.g. 'long' members that x32 will get wrong.

For quotactl I guess you are right, using the 64 bit call instead
of the x86_32 call will just work on x32 like they do on other compat
architectures. The same should be true for semtimedop, I had misinterpreted
that one thinking that you would still need to convert struct sembuf
(you would need that on another architecture which uses 32 bit struct
alignment in one ABI but the other).

For mq_{get,set}attr, I think you will either have to use the 32 bit
call or conditionally define struct mq_attr to contain 'long long'
members.

	Arnd

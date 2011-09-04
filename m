Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab1IDWN0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 18:13:26 -0400
Received: from mail-qw0-f42.google.com ([209.85.216.42]:47026 "EHLO
	mail-qw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab1IDWNT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 18:13:19 -0400
MIME-Version: 1.0
In-Reply-To: <3634139.5BAXH7nXYb@wuerfel>
References: <4E582577.2060805@zytor.com>
	<33733402.CzI6MIxaEn@wuerfel>
	<CAMe9rOrANCdgbhoY1F-hMc7Rbov_2O34A+MHTeYF3eieTP2EGw@mail.gmail.com>
	<3634139.5BAXH7nXYb@wuerfel>
Date: Sun, 4 Sep 2011 15:13:18 -0700
Message-ID: <CAMe9rOrU0wcrRxPoTRcmVRd+2hDwjCta_73Ji-MMiRRXR-3ndw@mail.gmail.com>
Subject: Re: RFD: x32 ABI system call numbers
From: "H.J. Lu" <hjl.tools@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Valdis.Kletnieks@vt.edu,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Kuo <rkuo@codeaurora.org>, Mark Salter <msalter@redhat.com>,
        Jonas Bonn <jonas@southpole.se>, Tobias Klauser <tklauser@distanz.ch>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 4, 2011 at 2:41 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Sunday 04 September 2011 14:25:53 H.J. Lu wrote:
>> >> >> #define __NR_x32_recvfrom
>> >> >> #define __NR_x32_sendmsg
>> >> >> #define __NR_x32_recvmsg
>> >> >> #define __NR_x32_recvmmsg
>> >> >> #define __NR_x32_sendmmsg
>> >> >
>> >> > These today use the MSG_CMSG_COMPAT flag to distinguish native and compat
>> >> > calls. Do you plan to have another flag here to handle cmsg time values?
>> >>
>> >> I am using x86-32 calls for them.
>> >>
>> >> > What about things like mq_{get,set}attr, quotactl and semtimedop?
>> >> >
>> >>
>> >> I am using 64bit system calls for x32.
>> >
>> > But isn't that broken? These all pass u64 or time_t values at some point.
>> >
>>
>> time_t isn't a problem since time_t/timeval/timespec are identical for
>> x32 and x86-64.  As for u64, I added NATIVE_LONG_TYPE, which is
>> defined as long long for x32,  and use it instead of long in types for
>> 64bit system calls.
>
> Sorry, I misread you as saying you use the compat syscalls for these.
> If you use the native 64 bit syscalls, you have the opposite problem:
> Some network protocols (e.g. netlink or rxrpc) use other data structures
> that require conversion, e.g. 'long' members that x32 will get wrong.

For those, I use x86-32 calls.

> For quotactl I guess you are right, using the 64 bit call instead
> of the x86_32 call will just work on x32 like they do on other compat
> architectures. The same should be true for semtimedop, I had misinterpreted
> that one thinking that you would still need to convert struct sembuf
> (you would need that on another architecture which uses 32 bit struct
> alignment in one ABI but the other).

I make sure that x32  struct sembuf is identical to 64bit struct sembuf.

> For mq_{get,set}attr, I think you will either have to use the 32 bit
> call or conditionally define struct mq_attr to contain 'long long'
> members.

I have

struct mq_attr
{
  __SNATIVE_LONG_TYPE mq_flags;		/* Message queue flags.  */
  __SNATIVE_LONG_TYPE mq_maxmsg;	/* Maximum number of messages.  */
  __SNATIVE_LONG_TYPE mq_msgsize;	/* Maximum message size.  */
  __SNATIVE_LONG_TYPE mq_curmsgs;	/* Number of messages currently queued.
 */
  __SNATIVE_LONG_TYPE __pad[4];
};

__SNATIVE_LONG_TYPE is long long for x32.


-- 
H.J.

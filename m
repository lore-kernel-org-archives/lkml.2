Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933718Ab1IIVCK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 17:02:10 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:61611 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933345Ab1IIVCI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 17:02:08 -0400
MIME-Version: 1.0
In-Reply-To: <CAMe9rOo2JdzerzfTAFER8rZEOGZkp6HxstdT4_3_s0x6UwTPow@mail.gmail.com>
References: <4E582577.2060805@zytor.com>
	<3634139.5BAXH7nXYb@wuerfel>
	<CAMe9rOrU0wcrRxPoTRcmVRd+2hDwjCta_73Ji-MMiRRXR-3ndw@mail.gmail.com>
	<2722845.TegCUU4bu0@wuerfel>
	<CAMe9rOo2JdzerzfTAFER8rZEOGZkp6HxstdT4_3_s0x6UwTPow@mail.gmail.com>
Date: Fri, 9 Sep 2011 14:02:07 -0700
Message-ID: <CAMe9rOphmkxPSMqRbr4kYtS=Xg1jqk93sXOh7rXw3azJ8MsjCA@mail.gmail.com>
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

On Mon, Sep 5, 2011 at 8:11 AM, H.J. Lu <hjl.tools@gmail.com> wrote:
> On Mon, Sep 5, 2011 at 12:48 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Sunday 04 September 2011 15:13:18 H.J. Lu wrote:
>>> On Sun, Sep 4, 2011 at 2:41 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>>> > On Sunday 04 September 2011 14:25:53 H.J. Lu wrote:
>>> >> >> >> #define __NR_x32_recvfrom
>>> >> >> >> #define __NR_x32_sendmsg
>>> >> >> >> #define __NR_x32_recvmsg
>>> >> >> >> #define __NR_x32_recvmmsg
>>> >> >> >> #define __NR_x32_sendmmsg
>>> >> >> >
>>> >> >> > These today use the MSG_CMSG_COMPAT flag to distinguish native and compat
>>> >> >> > calls. Do you plan to have another flag here to handle cmsg time values?
>>> >> >>
>>> >> >> I am using x86-32 calls for them.
>>> >> >
>>> >> > But isn't that broken? These all pass u64 or time_t values at some point.
>>> >> >
>>> >>
>>> >> time_t isn't a problem since time_t/timeval/timespec are identical for
>>> >> x32 and x86-64.  As for u64, I added NATIVE_LONG_TYPE, which is
>>> >> defined as long long for x32,  and use it instead of long in types for
>>> >> 64bit system calls.
>>> >
>>> > Sorry, I misread you as saying you use the compat syscalls for these.
>>> > If you use the native 64 bit syscalls, you have the opposite problem:
>>> > Some network protocols (e.g. netlink or rxrpc) use other data structures
>>> > that require conversion, e.g. 'long' members that x32 will get wrong.
>>>
>>> For those, I use x86-32 calls.
>>
>> So to ask again, what do you plan to do about SCM_TIMESTAMP*?
>>
>
> I added MSG_CMSG_COMPAT64 and new compat system calls with
> 64bit timespec/val to support it.  See the enclosed patch.
>

I decided to define

#define COMPAT_USE_64BIT_TIME \
  ((task_pt_regs(current)->orig_ax & __X32_SYSCALL_BIT) != 0)

instead of adding MSG_CMSG_COMPAT64.  It can be used to check
64bit time_t, timespec and timeval in any system calls.

-- 
H.J.

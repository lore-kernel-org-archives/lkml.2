Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab1IDV0A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 17:26:00 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:41426 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717Ab1IDVZy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 17:25:54 -0400
MIME-Version: 1.0
In-Reply-To: <33733402.CzI6MIxaEn@wuerfel>
References: <4E582577.2060805@zytor.com>
	<1914350.DTEPrFeNfA@wuerfel>
	<CAMe9rOofkcOarfWE1PcHcgLwM+hKdTkXZZr4e_n3v-Avb+bN=g@mail.gmail.com>
	<33733402.CzI6MIxaEn@wuerfel>
Date: Sun, 4 Sep 2011 14:25:53 -0700
Message-ID: <CAMe9rOrANCdgbhoY1F-hMc7Rbov_2O34A+MHTeYF3eieTP2EGw@mail.gmail.com>
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

On Sun, Sep 4, 2011 at 2:13 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Sunday 04 September 2011 12:31:25 H.J. Lu wrote:
>> On Sun, Sep 4, 2011 at 12:06 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> >> #define __NR_x32_ioctl
>> >
>> > What do you plan to do for ioctl? Does this mean you want to
>> > have a third file_operations pointer besides ioctl and compat_ioctl?
>> > I would hope that you manage this by using different ioctl command
>> > numbers in the few cases where the x32 version has to differ from
>> > the x86-32 data structure.
>>
>> This requires some kernel changes since x32 has 32bit pointers and 64bit
>> time_t/timespec/timeval.   We can't use straight x86-32 nor x86-64.
>
> I understand that it's not easy, but how do you want to get there?
> There is no central implementation of ioctl, it's all in the device drivers!
>
> My point was that the part that you do control is the ABI for x32, so
> you can change the driver's header files to do things like
>
> #ifndef __x32__
> struct foo_ioctl_data {
>        time_t  time;
>        long            something_else;
>        __u64           something_big;
> };
> #else
> struct foo_ioctl_data {
>        time_t  time;
>        long long       something_else;
>        __u64           something_big;
> };
> #endif
>
> #define FOO_IOCTL_BAR _IOR('f', 0, struct foo_ioctl_data)
>
> #ifdef __KERNEL__
> struct compat_foo_ioctl_data {
>        compat_time_t   time;
>        compat_long_t   something_else;
>        compat_u64              something_big;
> };
> #define FOO_IOCTL32_BAR _IOR('f', 0, struct compat_foo_ioctl_data)
>
> static long foo_compat_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
> {
>        void __user *uptr = compat_ptr(arg)
>
>        switch (cmd) {
>                case FOO_IOCTL32_BAR: /* regular compat case */
>                        return foo_compat_ioctl_bar(filp, uptr);
>                case FOO_IOCTL_BAR: /* x32 passing native struct */
>                        return foo_ioctl_bar(filp, uptr);
>        }
>        return -ENOIOCTLCMD;
> }
>
> This way, the same compat_ioctl function can easily support both x86-32 and
> x32. In fact, many compat_ioctl handlers already contain two code paths for the
> compat_u64 case, where they fall back on the native handler for anything but x86.

This is one way to deal with itoctl.  I will leave it to Peter.

>> >> #define __NR_x32_recvfrom
>> >> #define __NR_x32_sendmsg
>> >> #define __NR_x32_recvmsg
>> >> #define __NR_x32_recvmmsg
>> >> #define __NR_x32_sendmmsg
>> >
>> > These today use the MSG_CMSG_COMPAT flag to distinguish native and compat
>> > calls. Do you plan to have another flag here to handle cmsg time values?
>>
>> I am using x86-32 calls for them.
>>
>> > What about things like mq_{get,set}attr, quotactl and semtimedop?
>> >
>>
>> I am using 64bit system calls for x32.
>
> But isn't that broken? These all pass u64 or time_t values at some point.
>

time_t isn't a problem since time_t/timeval/timespec are identical for
x32 and x86-64.  As for u64, I added NATIVE_LONG_TYPE, which is
defined as long long for x32,  and use it instead of long in types for
64bit system calls.


-- 
H.J.

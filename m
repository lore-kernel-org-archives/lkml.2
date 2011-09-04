Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790Ab1IDVNw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 17:13:52 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:59348 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587Ab1IDVNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 17:13:47 -0400
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
Date: Sun, 04 Sep 2011 23:13:10 +0200
Message-ID: <33733402.CzI6MIxaEn@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <CAMe9rOofkcOarfWE1PcHcgLwM+hKdTkXZZr4e_n3v-Avb+bN=g@mail.gmail.com>
References: <4E582577.2060805@zytor.com> <1914350.DTEPrFeNfA@wuerfel> <CAMe9rOofkcOarfWE1PcHcgLwM+hKdTkXZZr4e_n3v-Avb+bN=g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:hgllUivN902pEO+4iB4Anprv9sIH4ULPCyGyNNhm3Kn
 wwDCR8V7Ag3zgsITIc7DQ0cCM49f8IcNwnYtttHSP3rjmiy4UN
 Ba7HGlqBe/tLDNyeOK4/bkLiqvo0w0+T6vK/AJ/z1UqY73UsLL
 Y+uMmLQw2EMB06mbiNsrxD9yZec7dStfTy+2MHSiMLonsjhspX
 DRupwmb6EujXz7ggpAsj0MNRww0G+zFsFzLWVmN50T65QJdd/I
 MCoaex+XNlxmJ+2aGfyvksCa5Ke039ONT3xtinmjKX3eSXB4vb
 eUIS4aMf5UNoaV1CaO7iTeKJXdfmUyxYEM3tP/J8mt/ZYU1r2U
 iZxKB1B+RPFVhUan3MfI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 September 2011 12:31:25 H.J. Lu wrote:
> On Sun, Sep 4, 2011 at 12:06 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> >> #define __NR_x32_ioctl
> >
> > What do you plan to do for ioctl? Does this mean you want to
> > have a third file_operations pointer besides ioctl and compat_ioctl?
> > I would hope that you manage this by using different ioctl command
> > numbers in the few cases where the x32 version has to differ from
> > the x86-32 data structure.
> 
> This requires some kernel changes since x32 has 32bit pointers and 64bit
> time_t/timespec/timeval.   We can't use straight x86-32 nor x86-64.

I understand that it's not easy, but how do you want to get there?
There is no central implementation of ioctl, it's all in the device drivers!

My point was that the part that you do control is the ABI for x32, so
you can change the driver's header files to do things like

#ifndef __x32__
struct foo_ioctl_data {
	time_t	time;
	long		something_else;
	__u64		something_big;
};
#else
struct foo_ioctl_data {
	time_t	time;
	long long	something_else;
	__u64		something_big;
};
#endif

#define FOO_IOCTL_BAR _IOR('f', 0, struct foo_ioctl_data)

#ifdef __KERNEL__
struct compat_foo_ioctl_data {
	compat_time_t	time;
	compat_long_t	something_else;
	compat_u64		something_big;
};
#define FOO_IOCTL32_BAR _IOR('f', 0, struct compat_foo_ioctl_data)

static long foo_compat_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
{
	void __user *uptr = compat_ptr(arg)

	switch (cmd) {
		case FOO_IOCTL32_BAR: /* regular compat case */
			return foo_compat_ioctl_bar(filp, uptr);
		case FOO_IOCTL_BAR: /* x32 passing native struct */
			return foo_ioctl_bar(filp, uptr);
	}
	return -ENOIOCTLCMD;
}

This way, the same compat_ioctl function can easily support both x86-32 and
x32. In fact, many compat_ioctl handlers already contain two code paths for the
compat_u64 case, where they fall back on the native handler for anything but x86.

> >> #define __NR_x32_recvfrom
> >> #define __NR_x32_sendmsg
> >> #define __NR_x32_recvmsg
> >> #define __NR_x32_recvmmsg
> >> #define __NR_x32_sendmmsg
> >
> > These today use the MSG_CMSG_COMPAT flag to distinguish native and compat
> > calls. Do you plan to have another flag here to handle cmsg time values?
> 
> I am using x86-32 calls for them.
>
> > What about things like mq_{get,set}attr, quotactl and semtimedop?
> >
> 
> I am using 64bit system calls for x32.

But isn't that broken? These all pass u64 or time_t values at some point.

	Arnd 

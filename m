Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952Ab1IERXA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 13:23:00 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:55494 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab1IERWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 13:22:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "H.J. Lu" <hjl.tools@gmail.com>
Subject: Re: RFD: x32 ABI system call numbers
Date: Mon, 5 Sep 2011 19:21:59 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: "H. Peter Anvin" <hpa@zytor.com>, Valdis.Kletnieks@vt.edu,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Kuo <rkuo@codeaurora.org>, Mark Salter <msalter@redhat.com>,
        Jonas Bonn <jonas@southpole.se>, Tobias Klauser <tklauser@distanz.ch>
References: <4E582577.2060805@zytor.com> <2722845.TegCUU4bu0@wuerfel> <CAMe9rOo2JdzerzfTAFER8rZEOGZkp6HxstdT4_3_s0x6UwTPow@mail.gmail.com>
In-Reply-To: <CAMe9rOo2JdzerzfTAFER8rZEOGZkp6HxstdT4_3_s0x6UwTPow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109051921.59776.arnd@arndb.de>
X-Provags-ID: V02:K0:iXYuxQLXrPMOI2KKogFYTSgOybQhFrNIEx4wuoJjryV
 qdXrfXasCev7yOwlKvQth2WJS/fC810anTcpmPbvwNqcrM1RkD
 94Y+yGoQdm3qsTodaW/9wWSeEiOkgj+bVzbeoh4K16iCqQc1zJ
 hAmH89H6BbVSoyQBcnPhqOLfbNjhWdDpcsISFiWtqwhLfA6ooI
 5MDYxDA5TSq34wXz0ciEikJ83Mp7gBA5Jn8qSt9IyzxyauAuoU
 415b9Zub6neUTILlsF3VBV2H/X+R9lgUbHdCA8TYyzSqBSi5o/
 USoSZ1DElyaWP8vXWY3GCzPyD6QYCk1zOXwjAID8uC3/OmeMNl
 pxm2OmcFH4WBp5F9mbdk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 September 2011, H.J. Lu wrote:
> I added MSG_CMSG_COMPAT64 and new compat system calls with
> 64bit timespec/val to support it.  See the enclosed patch.

Yes, looks good. Maybe there should be an #ifdef in there though,
so the other compat architectures don't get the extra code.

> BTW, I also added
> 
> compat_sys_preadv64(unsigned long fd, const struct compat_iovec __user *vec,
>          unsigned long vlen, loff_t pos)
> compat_sys_pwritev64(unsigned long fd, const struct compat_iovec __user *vec,
>          unsigned long vlen, loff_t pos)
> 
> to support 32bit compat_iovec * and 64bit offset.

Does that make much of a difference? I would guess that it's just as
easy to do in libc by splitting the pos argument and calling the
existing compat_sys_preadv. Alternatively, you could make glibc
copy the iovec array to the 64 bit format and call the native syscall,
because compat_rw_copy_check_uvector() otherwise just ends up doing that
in kernel space. Or you just define the x32 libc iovec to 

struct iovec {
	void *iov_base;
	unsigned int __pad; /* gets cleared by libc */
	__u64 iov_len;
}

	Arnd

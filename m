Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030883Ab2CPMwf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 08:52:35 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:57873 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932495Ab2CPMwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 08:52:33 -0400
Message-ID: <4F63378D.80105@gmail.com>
Date: Fri, 16 Mar 2012 13:52:29 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Greg KH <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: stable-3.0: s390 build breakage [was: Linux 3.0.24]
References: <20120312203451.GA16773@kroah.com> <4F61C911.5010204@suse.cz> <4F62186E.4050806@suse.cz> <20120315164624.GB25159@kroah.com> <20120315164954.GR2264@1wt.eu> <4F621E1A.5000602@gmail.com>
In-Reply-To: <4F621E1A.5000602@gmail.com>
X-Enigmail-Version: 1.4
Content-Type: multipart/mixed;
 boundary="------------010007060204020503090006"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010007060204020503090006
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 03/15/2012 05:51 PM, Jiri Slaby wrote:
> On 03/15/2012 05:49 PM, Willy Tarreau wrote:
>> On Thu, Mar 15, 2012 at 09:46:24AM -0700, Greg KH wrote:
>>> On Thu, Mar 15, 2012 at 05:27:26PM +0100, Jiri Slaby wrote:
>>>> On 03/15/2012 11:48 AM, Jiri Slaby wrote:
>>>>> On 03/12/2012 09:34 PM, Greg KH wrote:
>>>>>> I'm announcing the release of the 3.0.24 kernel.
>>>>> ...
>>>>>> Heiko Carstens (1): compat: fix compile breakage on s390
>>>>>
>>>>> It looks like we need the same fix as for 2.6.32.59:
>>>>> arch/s390/kernel/setup.c: In function 'setup_addressing_mode':
>>>>> arch/s390/kernel/setup.c:328: error: 'PSW32_ASC_PRIMARY' undeclared
>>>>> (first use in this function)
>>>>> arch/s390/kernel/setup.c:328: error: (Each undeclared identifier is
>>>>> reported only once
>>>>> arch/s390/kernel/setup.c:328: error: for each function it appears in.)
>>>>
>>>> And when that one is fixed, there is another error:
>>>> drivers/s390/char/fs3270.c: In function 'fs3270_ioctl':
>>>> drivers/s390/char/fs3270.c:335: error: implicit declaration of function
>>>> 'compat_ptr'
>>>> drivers/s390/char/fs3270.c:335: warning: assignment makes pointer from
>>>> integer without a cast
>>>
>>> Ick, have a patch for this?
>>
>> This one is declared in arch/s390/include/asm/compat.h:
>>
>> static inline void __user *compat_ptr(compat_uptr_t uptr)
>> {
>>         return (void __user *)(unsigned long)(uptr & 0x7fffffffUL);
>> }
>>
>> In 2.6.32, fs3270.c include linux/compat.h. In 3.0 it includes asm/compat.h
>> instead. I would have thought the later would have been enough.
> 
> But it was changed to linux/compat.h in 3.0.24 -- that's why it doesn't
> build. So the same fix as for setup.c should help here.

It is attached. With that patch (and the previous one), s390 builds fine
now.

thanks,
-- 
js

--------------010007060204020503090006
Content-Type: text/x-patch;
 name="compat-Re-add-missing-asm-compat.h-include.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="compat-Re-add-missing-asm-compat.h-include.patch"

From: Jiri Slaby <jslaby@suse.cz>
Date: Mon, 5 Mar 2012 14:06:38 +0100
Subject: compat: Re-add missing asm/compat.h include to fix compile breakage on s390

For 3.0 stable kernel the backport of 048cd4e51d24ebf7f3552226d03c769d6ad91658
"compat: fix compile breakage on s390" breaks compilation...

Re-add a single #include <asm/compat.h> in order to fix this.

This patch is _not_ necessary for upstream, only for stable kernels
which include the "build fix" mentioned above.

One fix for arch/s390/kernel/setup.c was already sent and applied. But
we need a similar patch for drivers/s390/char/fs3270.c.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/s390/char/fs3270.c |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/s390/char/fs3270.c
+++ b/drivers/s390/char/fs3270.c
@@ -16,6 +16,7 @@
 #include <linux/types.h>
 #include <linux/compat.h>
 
+#include <asm/compat.h>
 #include <asm/ccwdev.h>
 #include <asm/cio.h>
 #include <asm/ebcdic.h>

--------------010007060204020503090006--

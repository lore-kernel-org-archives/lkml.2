Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450Ab0INDHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 23:07:55 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:10658 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab0INDHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 23:07:54 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6105"; a="54373359"
Message-ID: <4C8EE708.5000109@codeaurora.org>
Date: Mon, 13 Sep 2010 20:07:52 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] ARM: uaccess: Implement strict user copy checks
References: <4C61EE55.5030506@codeaurora.org>	<201008251414.16411.arnd@arndb.de>	<20100825125451.GH2153@osiris.boeblingen.de.ibm.com>	<201008251555.53653.arnd@arndb.de>	<20100825144040.GI2153@osiris.boeblingen.de.ibm.com>	<4C7867D4.10404@codeaurora.org> <20100828074304.GA2183@osiris.boeblingen.de.ibm.com> <4C81CFEF.6060701@codeaurora.org>
In-Reply-To: <4C81CFEF.6060701@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2010 09:49 PM, Stephen Boyd wrote:
> On 08/28/2010 12:43 AM, Heiko Carstens wrote:
>> On Fri, Aug 27, 2010 at 06:35:16PM -0700, Stephen Boyd wrote:
>>> On 08/25/2010 07:40 AM, Heiko Carstens wrote:
>>>> On Wed, Aug 25, 2010 at 03:55:53PM +0200, Arnd Bergmann wrote:
>>>>>
>>>>> If you don't want to see the warnings, then just remove the strict checks.
>>>>> We already concluded that there is little value in them on s390 since it only
>>>>> shows false postives.
>>>>>
>>>>> Maybe the easiest way would be to rename the option on s390 and move all
>>>>> the other ones into a common place.
>>>>
>>>> Yes, feel free to do that.
>>>
>>> Can you put up the false positives somewhere? I don't have easy access
>>> to an s390 toolchain to test build with and I'm interested to see how
>>> bad the false positives are.
>>>
>>> I'm slightly concerned that we'll just have this problem again when
>>> another arch comes along with false positives. But ignoring that issue
>>> is probably fine. I'll respin with a patch to move s390 to something
>>> like DEBUG_WARN_USER_COPY_CHECKS.
>>
>> Sure:
>>
>> In function 'copy_from_user',
>>     inlined from 'write_enabled_file_bool' at kernel/kprobes.c:1973:
>> /linux-2.6/arch/s390/include/asm/uaccess.h:297: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
>> In function 'copy_from_user',
>>     inlined from 'perf_copy_attr' at kernel/perf_event.c:4988,
>>     inlined from 'SYSC_perf_event_open' at kernel/perf_event.c:5092,
>>     inlined from 'SyS_perf_event_open' at kernel/perf_event.c:5077:
> [snip]
>>     inlined from 'compat_sys_socketcall' at net/compat.c:783:
>> /linux-2.6/arch/s390/include/asm/uaccess.h:297: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
>>
> 
> Thanks. I'm a bit confused now since these files are compiled on x86 too
> and I don't see any warnings on that architecture. Which compiler is wrong?
> 
> Anyway, tile has joined the strict copy from user checks arena and it's
> acting like s390 by only enabling warnings when the option is set. Sigh....
> 
> I would really like to just merge all this code. How about a config
> DEBUG_USER_COPY_CHECKS which just does warnings, and then a config
> DEBUG_STRICT_USER_COPY_CHECKS that depends on DEBUG_USER_COPY_CHECKS
> that upgrades the warnings to errors? This would allow us to merge most
> of the code and still be mostly backwards compatible.
> 

Ok, I wasn't aware that only x86_32 has support for user copy checks. So
I hacked support for that on x86_64 and then saw the kprobes.c failure.
Great! Now for the weird(?) part.

Changing the buf_size variable from an int to a size_t makes the warning
go away. Perhaps this is because gcc can't reliably eliminate the else
case when the lower bound isn't 0? Overflow? I'm not really sure. Does
the kernel/kprobes.c part of this patch work for you?

--->8----8<----

diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index 316708d..904684b 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -44,6 +44,14 @@ _copy_from_user(void *to, const void __user *from, unsigned len);
 __must_check unsigned long
 copy_in_user(void __user *to, const void __user *from, unsigned len);
 
+extern void copy_from_user_overflow(void)
+#ifdef CONFIG_DEBUG_STRICT_USER_COPY_CHECKS
+	__compiletime_error("copy_from_user() buffer size is not provably correct")
+#else
+	__compiletime_warning("copy_from_user() buffer size is not provably correct")
+#endif
+;
+
 static inline unsigned long __must_check copy_from_user(void *to,
 					  const void __user *from,
 					  unsigned long n)
@@ -53,10 +61,8 @@ static inline unsigned long __must_check copy_from_user(void *to,
 	might_fault();
 	if (likely(sz == -1 || sz >= n))
 		n = _copy_from_user(to, from, n);
-#ifdef CONFIG_DEBUG_VM
 	else
-		WARN(1, "Buffer overflow detected!\n");
-#endif
+		copy_from_user_overflow();
 	return n;
 }
 
diff --git a/arch/x86/lib/usercopy_64.c b/arch/x86/lib/usercopy_64.c
index b7c2849..d7a5d9a 100644
--- a/arch/x86/lib/usercopy_64.c
+++ b/arch/x86/lib/usercopy_64.c
@@ -181,3 +181,9 @@ copy_user_handle_tail(char *to, char *from, unsigned len, unsigned zerorest)
 			break;
 	return len;
 }
+
+void copy_from_user_overflow(void)
+{
+	WARN(1, "Buffer overflow detected!\n");
+}
+EXPORT_SYMBOL(copy_from_user_overflow);
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 282035f..fa4e0f9 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1967,7 +1967,7 @@ static ssize_t write_enabled_file_bool(struct file *file,
 	       const char __user *user_buf, size_t count, loff_t *ppos)
 {
 	char buf[32];
-	int buf_size;
+	size_t buf_size;
 
 	buf_size = min(count, (sizeof(buf)-1));
 	if (copy_from_user(buf, user_buf, buf_size))


-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

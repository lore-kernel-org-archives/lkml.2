Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab1GMV2l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 17:28:41 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:52557 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab1GMV2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 17:28:40 -0400
Message-ID: <4E1E0E04.8030200@suse.cz>
Date: Wed, 13 Jul 2011 23:28:36 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net,
        Joe Perches <joe@perches.com>
Subject: Re: Linux 2.6.32.43
References: <20110713034559.GA16150@kroah.com> <4E1E0B40.1030905@suse.cz> <4E1E0C59.1030100@suse.cz>
In-Reply-To: <4E1E0C59.1030100@suse.cz>
X-Enigmail-Version: 1.2pre
Content-Type: multipart/mixed;
 boundary="------------090702000402000103020000"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090702000402000103020000
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Cced Joe.

On 07/13/2011 11:21 PM, Jiri Slaby wrote:
> On 07/13/2011 11:16 PM, Jiri Slaby wrote:
>> On 07/13/2011 05:45 AM, Greg KH wrote:
>>> Joe Perches (2):
>>>       bug.h: Add WARN_RATELIMIT
>>>       net: filter: Use WARN_RATELIMIT
>>
>> Hi, this causes a build failure on PPC with minimalistic config (PS3) [1]:
>> net/core/filter.c: In function 'sk_run_filter':
>> net/core/filter.c:297: error: implicit declaration of function
>> 'WARN_RATELIMIT'
>>
>> net/core/filter.c should include linux/bug.h (or linux/kernel.h).
> 
> Ah, no, PS3 doesn't have CONFIG_BUG set.

A fix attached. Upstream doesn't need it. There it is all in
linux/ratelimit.h

>> [1]
>> http://gitorious.org/opensuse/kernel-source/blobs/SLE11-SP1/config/ppc/ps3
>>
>> regards,
-- 
js
suse labs

--------------090702000402000103020000
Content-Type: text/x-patch;
 name="ppc-fix-net-core-build.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ppc-fix-net-core-build.patch"

From: Jiri Slaby <jslaby@suse.cz>
Subject: PPC: fix net core build
Patch-mainline: not yet

After "net: filter: Use WARN_RATELIMIT" was applied as a part of
patches.kernel.org/patch-2.6.32.42-43 we are choking at:
net/core/filter.c: In function 'sk_run_filter':
net/core/filter.c:297: error: implicit declaration of function 'WARN_RATELIMIT'
on configs without CONFIG_BUG.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/asm-generic/bug.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -126,6 +126,13 @@ extern void warn_slowpath_null(const cha
 })
 #endif
 
+#ifndef WARN_RATELIMIT
+#define WARN_RATELIMIT(condition, format...) ({				\
+	int __ret_warn_on = !!(condition);				\
+	unlikely(__ret_warn_on);					\
+})
+#endif
+
 #endif
 
 #define WARN_ON_ONCE(condition)	({				\

--------------090702000402000103020000--

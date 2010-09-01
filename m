Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab0IAN3m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 09:29:42 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:5480 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753219Ab0IAN3k convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 09:29:40 -0400
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2cK1432N98dN148cM1b0bM7cf0izz1202hzz8275bhz32i2a8h5bep5bfs61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L82LED-02-9L4-02
X-M-MSG: 
Date: Wed, 1 Sep 2010 15:07:48 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Matt Fleming <matt@console-pimps.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] oprofile, x86: fix init_sysfs error handling
Message-ID: <20100901130748.GK22783@erda.amd.com>
References: <1283107921-21464-1-git-send-email-will.deacon@arm.com>
 <1283107921-21464-2-git-send-email-will.deacon@arm.com>
 <1283107921-21464-3-git-send-email-will.deacon@arm.com>
 <1283107921-21464-4-git-send-email-will.deacon@arm.com>
 <20100830090929.GU22783@erda.amd.com>
 <1283244880.645.17.camel@e102144-lin.cambridge.arm.com>
 <20100831090518.GZ22783@erda.amd.com>
 <1283247089.4063.2.camel@e102144-lin.cambridge.arm.com>
 <20100831103001.GC22783@erda.amd.com>
 <20100901095117.GA4246@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20100901095117.GA4246@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.09.10 05:51:17, Ingo Molnar wrote:
> > @@ -774,7 +781,10 @@ int __init op_nmi_init(struct oprofile_operations *ops)
> >  
> >  	mux_init(ops);
> >  
> > -	init_sysfs();
> > +	ret = init_sysfs();
> 
> FYI, this causes a build error if CONFIG_PM is off:
> 
>    arch/x86/oprofile/nmi_int.c:784: error: expected expression before ‘do’
> 
> Due to this assymetric form of the wrapper:
> 
>   #define init_sysfs() do { } while (0)
> 
> The wrapper should be changed to return 0 i suspect, via something like 
> this:
> 
>   static inline int init_sysfs(void) { return 0; }
> 
> (untested)

Ingo, thanks for catching this, fix below.

-Robert

--

>From 3f60c6b21399280c4ab079deefb794253becdaca Mon Sep 17 00:00:00 2001
From: Robert Richter <robert.richter@amd.com>
Date: Wed, 1 Sep 2010 14:50:50 +0200
Subject: [PATCH] oprofile, x86: fix init_sysfs() function stub
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The use of the return value of init_sysfs() with commit

 10f0412 oprofile, x86: fix init_sysfs error handling

discovered the following build error for !CONFIG_PM:

 .../linux/arch/x86/oprofile/nmi_int.c: In function ‘op_nmi_init’:
 .../linux/arch/x86/oprofile/nmi_int.c:784: error: expected expression before ‘do’
 make[2]: *** [arch/x86/oprofile/nmi_int.o] Error 1
 make[1]: *** [arch/x86/oprofile] Error 2

This patch fixes this.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 73a41d3..cfe4faa 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -585,8 +585,10 @@ static void exit_sysfs(void)
 }
 
 #else
-#define init_sysfs() do { } while (0)
-#define exit_sysfs() do { } while (0)
+
+static inline int  init_sysfs(void) { return 0; }
+static inline void exit_sysfs(void) { }
+
 #endif /* CONFIG_PM */
 
 static int __init p4_init(char **cpu_type)
-- 
1.7.1.1


-- 
Advanced Micro Devices, Inc.
Operating System Research Center


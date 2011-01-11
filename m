Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab1AKK0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 05:26:46 -0500
Received: from www.tglx.de ([62.245.132.106]:59089 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577Ab1AKK0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 05:26:39 -0500
Date: Tue, 11 Jan 2011 11:26:11 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, johnstul@us.ibm.com, williams@redhat.com,
        schwidefsky@de.ibm.com, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/tsc] x86: Improve TSC calibration using a delayed
 workqueue
In-Reply-To: <20110111095640.GC22867@shutemov.name>
Message-ID: <alpine.LFD.2.00.1101111124590.12146@localhost6.localdomain6>
References: <1289003985-29060-1-git-send-email-johnstul@us.ibm.com> <tip-08ec0c58fb8a05d3191d5cb6f5d6f81adb419798@git.kernel.org> <20110111081352.GA22867@shutemov.name> <alpine.LFD.2.00.1101110926040.12146@localhost6.localdomain6> <20110111083054.GB22867@shutemov.name>
 <alpine.LFD.2.00.1101110936291.12146@localhost6.localdomain6> <20110111095640.GC22867@shutemov.name>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Jan 2011, Kirill A. Shutemov wrote:
> On Tue, Jan 11, 2011 at 09:37:15AM +0100, Thomas Gleixner wrote:
> > Does the patch below fix it ? We can end up with tsc_khz=0 there :(
> 
> Yes, it does.
> 
> Bisected-and-tested-by: Kirill A. Shutemov <kas@openvz.org>

Looking deeper, we should avoid to schedule the delayed init
completely. Does that work as well ?

Thanks,

	tglx
---

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 03d2ea8..823f79a 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -965,7 +965,7 @@ out:
 
 static int __init init_tsc_clocksource(void)
 {
-	if (!cpu_has_tsc || tsc_disabled > 0)
+	if (!cpu_has_tsc || tsc_disabled > 0 || !tsc_khz)
 		return 0;
 
 	if (tsc_clocksource_reliable)

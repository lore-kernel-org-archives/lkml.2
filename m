Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab1AONJU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 08:09:20 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46508 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911Ab1AONJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 08:09:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dIbL9A8OB64W1slMCsi1bCbf9FdXMYdpnXS6zCWoTfv0HGpvbwYbJ94hvXHZHcGEXF
         TQRTEDn/b9gDhfteJ2ozL3Ka23ZAwhWP4NNLG8V6SnRWK2H6B0+tjdvK8NileycPRbBO
         /krkoOYyVXUfBWSJkhUk9b5FqWYVJ63SvGY98=
Date: Sat, 15 Jan 2011 14:09:13 +0100
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Greg KH <greg@kroah.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: set percpu cpu0 lpj to default
Message-ID: <20110115130913.GA27123@htj.dyndns.org>
References: <20110113224450.GA14918@kroah.com>
 <alpine.LFD.2.00.1101132349590.2678@localhost6.localdomain6>
 <4D2F84FC.7000804@kernel.org>
 <20110113234852.GB17904@kroah.com>
 <4D2F9948.8000804@kernel.org>
 <20110114004428.GA26847@kroah.com>
 <4D2FA305.2030808@kernel.org>
 <alpine.DEB.2.00.1101140846560.2423@router.home>
 <4D30BE98.7060809@kernel.org>
 <alpine.DEB.2.00.1101141527400.10415@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1101141527400.10415@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

It doesn't seem like Christoph's recent patches had anything to do
with it.  The problem is the default loops_per_jiffy has initial value
of 1 << 12 but the per cpu one used on x86 starts as zero triggering
warning if delay is used before calibration.

So, all that's necessary is just to initialize it with the same
constant when defining the per cpu variable like the following.  It
probably would be better to define a named constant for it tho.

Thanks.

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 763df77..1898c70 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -131,7 +131,10 @@ DEFINE_PER_CPU(cpumask_var_t, cpu_core_map);
 EXPORT_PER_CPU_SYMBOL(cpu_core_map);
 
 /* Per CPU bogomips and other parameters */
-DEFINE_PER_CPU_SHARED_ALIGNED(struct cpuinfo_x86, cpu_info);
+DEFINE_PER_CPU_SHARED_ALIGNED(struct cpuinfo_x86, cpu_info) =
+{
+	.loops_per_jiffy	= 1 << 12,
+};
 EXPORT_PER_CPU_SYMBOL(cpu_info);
 
 atomic_t init_deasserted;

-- 
tejun

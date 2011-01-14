Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757665Ab1ANOue (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 09:50:34 -0500
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:27127 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752245Ab1ANOu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 09:50:27 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: jOsX.00VM1mP5mBWEWUQucRXlCMtFdo21qwkKLodaiLwrAE
 Da8cHl9PAEQ41GRX5KjEr0QDlAZgnayLhC9XWHDrRhie9crQWLO_jOiC62Xc
 BAun6_QGahZnvE6UJ52hhmcdd73j6gMOsSvapGuHFXK5AEF.6qn8ZBb26xSh
 UtVs_R2mTZGofv5aU__V1x3.AP_rkq1YCzuIZ4xK7yeUbPN8bPXP8TmOJllq
 _zNjXiOk9aimbLx3GgiF0mHj8tx23fSEIByE2M2GzPw--
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 14 Jan 2011 08:50:23 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Yinghai Lu <yinghai@kernel.org>
cc: Greg KH <greg@kroah.com>, Jason Wessel <jason.wessel@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH] x86: Add safe_udelay() and safe_msleep()
In-Reply-To: <4D2FA305.2030808@kernel.org>
Message-ID: <alpine.DEB.2.00.1101140846560.2423@router.home>
References: <AANLkTika_bZxXO3PKek+BHoYqgYGPBPER-H9KJJXjJzn@mail.gmail.com> <20110111135655.GA6901@kroah.com> <4D2CFEAD.6070206@kernel.org> <1294799565.9586.13.camel@pasglop> <4D2F7AE9.2000809@kernel.org> <20110113224450.GA14918@kroah.com>
 <alpine.LFD.2.00.1101132349590.2678@localhost6.localdomain6> <4D2F84FC.7000804@kernel.org> <20110113234852.GB17904@kroah.com> <4D2F9948.8000804@kernel.org> <20110114004428.GA26847@kroah.com> <4D2FA305.2030808@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Jan 2011, Yinghai Lu wrote:

> from code review, we should not use udelay() that early.
>
> in arch/x86/lib/delay.c we have
> inline void __const_udelay(unsigned long xloops)
> {
>         int d0;
>
>         xloops *= 4;
>         asm("mull %%edx"
>                 :"=d" (xloops), "=&a" (d0)
>                 :"1" (xloops), "0"
>                 (this_cpu_read(cpu_info.loops_per_jiffy) * (HZ/4)));

^^^^ this line was recently changed through the commit included at the end
of the message. Solution would be to revert the commit or set the
loops_per_jiffy in the early per cpu segment (as done in the last patch I
saw from you).

commit 357089fca91f639dd005ae0721f5f932b4f276ab
Author: Christoph Lameter <cl@linux.com>
Date:   Thu Dec 16 12:14:43 2010 -0600

    x86: udelay: Use this_cpu_read to avoid address calculation

    The code will use a segment prefix instead of doing the lookup and
    calculation.

    Signed-off-by: Christoph Lameter <cl@linux.com>
    Acked-by: "H. Peter Anvin" <hpa@zytor.com>
    Signed-off-by: Tejun Heo <tj@kernel.org>

diff --git a/arch/x86/lib/delay.c b/arch/x86/lib/delay.c
index ff485d3..fc45ba8 100644
--- a/arch/x86/lib/delay.c
+++ b/arch/x86/lib/delay.c
@@ -121,7 +121,7 @@ inline void __const_udelay(unsigned long xloops)
        asm("mull %%edx"
                :"=d" (xloops), "=&a" (d0)
                :"1" (xloops), "0"
-               (cpu_data(raw_smp_processor_id()).loops_per_jiffy *
(HZ/4)));
+               (this_cpu_read(cpu_info.loops_per_jiffy) * (HZ/4)));

        __delay(++xloops);
 }


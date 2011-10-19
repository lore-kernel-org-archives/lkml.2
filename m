Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab1JSQfe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 12:35:34 -0400
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:29312
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751791Ab1JSQfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 12:35:33 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zz146fK1432N98dKzz1202hzz8275bhz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LTBNES-01-98O-02
X-M-MSG: 
Date: Wed, 19 Oct 2011 18:33:28 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: Re: [PATCH 4/5] oprofile: Remove exit function for timer mode
Message-ID: <20111019163328.GG24346@erda.amd.com>
References: <1318861624-715-1-git-send-email-robert.richter@amd.com>
 <1318861624-715-5-git-send-email-robert.richter@amd.com>
 <20111018061346.GD16304@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111018061346.GD16304@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.10.11 02:13:47, Ingo Molnar wrote:
> 
> * Robert Richter <robert.richter@amd.com> wrote:
> 
> >  	/* failed */
> > -	if (timer_mode)
> > -		oprofile_timer_exit();
> > -	else
> > +	if (!timer_mode)
> >  		oprofile_arch_exit();
> 
> > -	if (timer_mode)
> > -		oprofile_timer_exit();
> > -	else
> > +	if (!timer_mode)
> >  		oprofile_arch_exit();
> 
> ... and the ugliness didnt improve much here either.
> 
> Any reason why oprofile_arch_exit() couldnt check timer_mode?

The two fixes are the smallest possible solution for stable kernels.
... and they don't look nice.

Moving the check to oprofile_arch_exit() would mean to make timer_mode
global and to touch all oprofile_arch_exit() functions for all archs.
But we could get rid of timer_mode if the exit function would be part
of struct oprofile_operations. For this we would have to touch the
code for all architectures too, and I actually want to avoid this. But
it would be a nice solution.

Anyway, I have some improvements in patch #5 that make the code looks a
bit better. See below for a preview, will post a v2 patch set after
testing. As said, I could remove variable timer_mode completely by
moving exit functions to oprofile_operations. This could be on top of
the changes below.

-Robert



diff --git a/drivers/oprofile/oprof.c b/drivers/oprofile/oprof.c
index f7cd069..d2994e7 100644
--- a/drivers/oprofile/oprof.c
+++ b/drivers/oprofile/oprof.c
@@ -246,26 +246,23 @@ static int __init oprofile_init(void)
        int err;
 
        /* always init architecture to setup backtrace support */
+       timer_mode = 0;
        err = oprofile_arch_init(&oprofile_ops);
-
-       timer_mode = err || timer;      /* fall back to timer mode on errors */
-       if (timer_mode) {
-               if (!err)
-                       oprofile_arch_exit();
-               err = oprofile_timer_init(&oprofile_ops);
-               if (err)
-                       return err;
+       if (!err) {
+               if (!timer && oprofilefs_register())
+                       return 0;
+               oprofile_arch_exit();
        }
 
-       err = oprofilefs_register();
-       if (!err)
-               return 0;
-
-       /* failed */
-       if (!timer_mode)
-               oprofile_arch_exit();
+       /* setup timer mode */
+       timer_mode = 1;
+       err = op_nmi_timer_init(&oprofile_ops);
+       if (err)
+               err = oprofile_timer_init(&oprofile_ops);
+       if (err)
+               return err;
 
-       return err;
+       return oprofilefs_register();
 }
 
 




-- 
Advanced Micro Devices, Inc.
Operating System Research Center


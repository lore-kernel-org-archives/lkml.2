Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758574Ab0DWSBw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 14:01:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54549 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758540Ab0DWSBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 14:01:39 -0400
Message-ID: <4BD1E061.8030605@zytor.com>
Date: Fri, 23 Apr 2010 11:01:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Samuel Thibault <samuel.thibault@labri.fr>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org, olivier.aumage@inria.fr, yannick.martin@inria.fr
Subject: Re: X86_64 BUG: missing FS/GS LDT reload on fork()
References: <20100423170449.GV4997@const.bordeaux.inria.fr>
In-Reply-To: <20100423170449.GV4997@const.bordeaux.inria.fr>
Content-Type: multipart/mixed;
 boundary="------------010300080205060909080902"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010300080205060909080902
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 04/23/2010 10:04 AM, Samuel Thibault wrote:
> Hello,
> 
> I have an issue with FS/GS LDT reload in the child of fork(). The
> attached testcase fails quite often.  It sets an LDT entry up, uses
> prctl to set gs's base to a 64bit value, then loads gs with the LDT
> entry. The LDT entry is now in effect. After a fork call, the LDT entry
> is not in effect any more, the 64bit base is back!
> 

Okay... I have to say that I'm more than a bit confused why you're doing
this, but the __switch_no code in process_64.c has the following:

                /*
                 * Check if the user used a selector != 0; if yes
                 *  clear 64bit base, since overloaded base is always
                 *  mapped to the Null selector
                 */
                if (fsindex)
                        prev->fs = 0;

[and the same for gs]

However, copy_thread() doesn't have the equivalent code, and __switch_to
clearly expects that to be maintained as an invariant -- it doesn't
check on entry, only on exit.

The following patch looks like it should address that.

	-hpa

--------------010300080205060909080902
Content-Type: text/plain;
 name="diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="diff"

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index dc9690b..17cb329 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -276,12 +276,12 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 
 	set_tsk_thread_flag(p, TIF_FORK);
 
-	p->thread.fs = me->thread.fs;
-	p->thread.gs = me->thread.gs;
 	p->thread.io_bitmap_ptr = NULL;
 
 	savesegment(gs, p->thread.gsindex);
+	p->thread.gs = p->thread.gsindex ? 0 : me->thread.gs;
 	savesegment(fs, p->thread.fsindex);
+	p->thread.fs = p->thread.fsindex ? 0 : me->thread.fs;
 	savesegment(es, p->thread.es);
 	savesegment(ds, p->thread.ds);
 

--------------010300080205060909080902--

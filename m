Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893Ab2BUCgw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 21:36:52 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:22010 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab2BUCgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 21:36:51 -0500
X-AuditID: cbfee612-b7c09ae0000024ca-1b-4f42fab211c6
Date: Tue, 21 Feb 2012 02:00:18 +0000 (GMT)
From: Jongman Heo <jongman.heo@samsung.com>
Subject: Re: Re: [PATCH v2 3/3] i387: support lazy restore of FPU state
To: Josh Boyer <jwboyer@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: jongman.heo@samsung.com
MIME-version: 1.0
X-MTR: 20120221015526974@jongman.heo
Msgkey: 20120221015526974@jongman.heo
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120221015526974@jongman.heo
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <12130999.96471329789614858.JavaMail.weblogic@epml01>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q1L2awdo015830


> Sender : Josh Boyer<jwboyer@gmail.com>
> Date : 2012-02-21 10:50 (GMT+09:00)
> Title : Re: [PATCH v2 3/3] i387: support lazy restore of FPU state
>
> > On Mon, Feb 20, 2012 at 2:48 PM, Linus Torvalds
> > wrote:
> >
> > From: Linus Torvalds 
> > Date: Sun, 19 Feb 2012 13:27:00 -0800
> > Subject: [PATCH v2 3/3] i387: support lazy restore of FPU state
> > 
> > This makes us recognize when we try to restore FPU state that matches
> > what we already have in the FPU on this CPU, and avoids the restore
> > entirely if so.
> >
> > To do this, we add two new data fields:
> >
> >  - a percpu 'fpu_owner_task' variable that gets written any time we
> >   update the "has_fpu" field, and thus acts as a kind of back-pointer
> >   to the task that owns the CPU.  The exception is when we save the FPU
> >   state as part of a context switch - if the save can keep the FPU
> >   state around, we leave the 'fpu_owner_task' variable pointing at the
> >   task whose FP state still remains on the CPU.
> >
> >  - a per-thread 'last_cpu' field, that indicates which CPU that thread
> >   used its FPU on last.  We update this on every context switch
> >   (writing an invalid CPU number if the last context switch didn't
> >   leave the FPU in a lazily usable state), so we know that *that*
> >   thread has done nothing else with the FPU since.
> >
> > These two fields together can be used when next switching back to the
> > task to see if the CPU still matches: if 'fpu_owner_task' matches the
> > task we are switching to, we know that no other task (or kernel FPU
> > usage) touched the FPU on this CPU in the meantime, and if the current
> > CPU number matches the 'last_cpu' field, we know that this thread did no
> > other FP work on any other CPU, so the FPU state on the CPU must match
> > what was saved on last context switch.
> >
> > In that case, we can avoid the 'f[x]rstor' entirely, and just clear the
> > CR0.TS bit.
> >
> > Signed-off-by: Linus Torvalds 
> 
> I haven't tried really figuring this out yet, but building the Fedora kernel
> on x86_64 with your latest tree results in:
> 
> ERROR: "fpu_owner_task" [lib/raid6/raid6_pq.ko] undefined!
> ERROR: "fpu_owner_task" [arch/x86/kvm/kvm.ko] undefined!
> ERROR: "fpu_owner_task" [arch/x86/crypto/sha1-ssse3.ko] undefined!
> ERROR: "fpu_owner_task" [arch/x86/crypto/serpent-sse2-x86_64.ko] undefined!
> ERROR: "fpu_owner_task" [arch/x86/crypto/ghash-clmulni-intel.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
> + exit 1
> 
> Since this patch went in as 7e16838d94b566a1, I'm guessing it's at least
> related.
> 
> I'm building again with more verbose output but I thought I'd send this out
> quickly.
> 
> josh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Similar here, with 32bit x86 build.

[snip]
  LD      net/built-in.o
  LD      vmlinux.o
  MODPOST vmlinux.o
  GEN     .version
  CHK     include/generated/compile.h
  UPD     include/generated/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
arch/x86/built-in.o: In function `__thread_clear_has_fpu':
/usr/src/linux/arch/x86/include/asm/i387.h:300: undefined reference to `fpu_owner_task'
arch/x86/built-in.o: In function `__thread_set_has_fpu':
/usr/src/linux/arch/x86/include/asm/i387.h:307: undefined reference to `fpu_owner_task'
arch/x86/built-in.o: In function `fpu_lazy_restore':
/usr/src/linux/arch/x86/include/asm/i387.h:354: undefined reference to `fpu_owner_task'
arch/x86/built-in.o: In function `__thread_set_has_fpu':
/usr/src/linux/arch/x86/include/asm/i387.h:307: undefined reference to `fpu_owner_task'
arch/x86/built-in.o: In function `__thread_clear_has_fpu':
/usr/src/linux/arch/x86/include/asm/i387.h:300: undefined reference to `fpu_owner_task'
arch/x86/built-in.o:/usr/src/linux/arch/x86/include/asm/i387.h:300: more undefined references to `fpu_owner_task' follow
make: *** [.tmp_vmlinux1] Error 


In case you need my .config, please let me know~.

Jongman Heo.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

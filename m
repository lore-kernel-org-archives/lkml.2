Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934554Ab1ETAwz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:52:55 -0400
Received: from gate.crashing.org ([63.228.1.57]:44296 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932618Ab1ETAwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:52:54 -0400
Subject: Re: [PATCH 3/7] [RFC] add support for BlueGene/P FPU
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Michael Neuling <mikey@neuling.org>
Cc: Eric Van Hensbergen <ericvh@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, bg-linux@lists.anl-external.org
In-Reply-To: <425.1305784718@neuling.org>
References: <1305753895-24845-1-git-send-email-ericvh@gmail.com>
	 <1305753895-24845-3-git-send-email-ericvh@gmail.com>
	 <425.1305784718@neuling.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 May 2011 10:52:38 +1000
Message-ID: <1305852758.7481.103.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-19 at 15:58 +1000, Michael Neuling wrote:

> > +
> >  #define SAVE_2GPRS(n, base)	SAVE_GPR(n, base); SAVE_GPR(n+1, base)
> >  #define SAVE_4GPRS(n, base)	SAVE_2GPRS(n, base); SAVE_2GPRS(n+2, base)
> >  #define SAVE_8GPRS(n, base)	SAVE_4GPRS(n, base); SAVE_4GPRS(n+4, base)
> > @@ -97,18 +104,26 @@ END_FW_FTR_SECTION_IFSET(FW_FEATURE_SPLPAR)
> >  #define REST_8GPRS(n, base)	REST_4GPRS(n, base); REST_4GPRS(n+4, base)
> >  #define REST_10GPRS(n, base)	REST_8GPRS(n, base); REST_2GPRS(n+8, base)
> >  
> > -#define SAVE_FPR(n, base)	stfd	n,THREAD_FPR0+8*TS_FPRWIDTH*(n)(base)
> > -#define SAVE_2FPRS(n, base)	SAVE_FPR(n, base); SAVE_FPR(n+1, base)
> > -#define SAVE_4FPRS(n, base)	SAVE_2FPRS(n, base); SAVE_2FPRS(n+2, base)
> > -#define SAVE_8FPRS(n, base)	SAVE_4FPRS(n, base); SAVE_4FPRS(n+4, base)
> > -#define SAVE_16FPRS(n, base)	SAVE_8FPRS(n, base); SAVE_8FPRS(n+8, base)
> > -#define SAVE_32FPRS(n, base)	SAVE_16FPRS(n, base); SAVE_16FPRS(n+16, base)
> > -#define REST_FPR(n, base)	lfd	n,THREAD_FPR0+8*TS_FPRWIDTH*(n)(base)
> > -#define REST_2FPRS(n, base)	REST_FPR(n, base); REST_FPR(n+1, base)
> > -#define REST_4FPRS(n, base)	REST_2FPRS(n, base); REST_2FPRS(n+2, base)
> > -#define REST_8FPRS(n, base)	REST_4FPRS(n, base); REST_4FPRS(n+4, base)
> > -#define REST_16FPRS(n, base)	REST_8FPRS(n, base); REST_8FPRS(n+8, base)
> > -#define REST_32FPRS(n, base)	REST_16FPRS(n, base); REST_16FPRS(n+16, base)
> > +#ifdef CONFIG_BGP
> > +#define SAVE_FPR(n, b, base)	li b, THREAD_FPR0+(16*(n)); STFPDX(n, base, b)
> > +#define REST_FPR(n, b, base)	li b, THREAD_FPR0+(16*(n)); LFPDX(n, base, b)
> 
> 16*?  Are these FP regs 64 or 128 bits wide?  If 128 you are doing to
> have to play with TS_WIDTH to get the size of the FPs correct in the
> thread_struct.
> 
> I think there's a bug here.

Regardless of that, btw, I don't think it's very sane to change those
macros that way. I'd rather have a separate set to save/restore the BG
stuff and separate code alltogether for loading/saving/flushing/etc...
like FSP SPE. The FPU save/restore code is already too complex as it is.

Also, should we aim to have this co-exist with other 4xx platforms in a
multiplatform kernel ? In that case it should not break the normal FP
case. Feel free to use CPU feature bits, there are 2 or 3 left available
in the 32-bit space, maybe pick a "combo" one for BGP (or one for hummer
and a MMU bit for the odd SMP tricks).

Hrm... thinking of which, what about doing it using the alternate
feature section ? This allows two "alternate" piece of codes to overlay,
the kernel will replace the original one with the alternative one if the
feature bits match. That way you can just stick an alternate around
SAVE/REST_32FPRS that replace them with your new SAVE/REST_32HFPRS (or
whatever you want to call you new set of macros).

Of course you'll probably need a separate area in the thread
struct/pt_regs etc... which mean a userspace ABI change, a change of the
sig context etc etc ....

Cheers,
Ben.



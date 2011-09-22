Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153Ab1IVNAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 09:00:48 -0400
Received: from service87.mimecast.com ([91.220.42.44]:51813 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751941Ab1IVNAp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 09:00:45 -0400
Date: Thu, 22 Sep 2011 14:00:31 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Jon Medhurst (Tixy)" <jon.medhurst@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dave Martin <dave.martin@linaro.org>,
        Laura Abbott <lauraa@codeaurora.org>, Nicolas Pitre <nico@fluxnic.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm: Add unwinding annotations for 64bit division
 functions
Message-ID: <20110922130031.GK12025@e102109-lin.cambridge.arm.com>
References: <1316470297-5063-1-git-send-email-lauraa@codeaurora.org>
 <alpine.LFD.2.00.1109191913210.12663@xanadu.home>
 <2285dff3fee56758b6279062a5a30dc7.squirrel@www.codeaurora.org>
 <20110921113906.GB2872@arm.com>
 <20110921115553.GF17169@n2100.arm.linux.org.uk>
 <1316676488.2053.9.camel@linaro1>
 <CAHkRjk7B4Bmt2g6ptHO3TudXgrkr5rv4b--Hbx-mw7=MO9Q+BQ@mail.gmail.com>
 <1316689606.2053.29.camel@linaro1>
 <20110922115713.GJ12025@e102109-lin.cambridge.arm.com>
 <1316693581.2053.38.camel@linaro1>
MIME-Version: 1.0
In-Reply-To: <1316693581.2053.38.camel@linaro1>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 22 Sep 2011 13:00:38.0061 (UTC) FILETIME=[9FEBADD0:01CC7927]
X-MC-Unique: 111092214004103001
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 01:13:01PM +0100, Jon Medhurst (Tixy) wrote:
> On Thu, 2011-09-22 at 12:57 +0100, Catalin Marinas wrote:
> > On Thu, Sep 22, 2011 at 12:06:46PM +0100, Jon Medhurst (Tixy) wrote:
> > > On Thu, 2011-09-22 at 10:48 +0100, Catalin Marinas wrote:
> > > > We could improve things a bit in the unwinder and assume
> > > > that if the fault address is the same as the .fnstart address, the
> > > > return value is always in LR and the SP not affected (that's unwinding
> > > > bytecode 0xb0). For a few instructions into the function prologue we
> > > > can't reliably get the unwinding information.
> > > 
> > > That would help make it possible to unwind out of kprobes handlers to
> > > the probed function. The kprobes code itself would need work as well,
> > > and possibly the undef handler. Do we think it is worthwhile to do
> > > this? 
> > 
> > Does kprobes need to trace beyond the probed function? If not, you get
> > the address of the probed function via pt_regs anyway, so no need for
> > unwinding beyond that.
> 
> To be honest, I'm not very sure how kprobes get used in the real world.
> Though, if stack unwinding from their handlers currently doesn't work
> and people had a usecase for it, we would expect them to complain.

The unwinding fix should be simple (I haven't tested it yet):

8<-----------------------------
ARM: Ignore the unwinding information for the first instruction in a function

From: Catalin Marinas <catalin.marinas@arm.com>

When backtracing from the first instruction of a function, the prologue
has not been executed and the unwinding information is not valid. This
patch checks for this case and just assumes that the return address is
in LR.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/kernel/unwind.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/arm/kernel/unwind.c b/arch/arm/kernel/unwind.c
index d2cb0b3..946face 100644
--- a/arch/arm/kernel/unwind.c
+++ b/arch/arm/kernel/unwind.c
@@ -293,6 +293,16 @@ int unwind_frame(struct stackframe *frame)
 		return -URC_FAILURE;
 	}
 
+	/*
+	 * Check for backtrace on the first instruction of a function. The
+	 * prologue has not been executed yet and the unwinding information is
+	 * not valid. Assume that the return address is in LR.
+	 */
+	if (idx.addr == frame->pc) {
+		frame->pc = frame->lr;
+		return URC_OK;
+	}
+
 	ctrl.vrs[FP] = frame->fp;
 	ctrl.vrs[SP] = frame->sp;
 	ctrl.vrs[LR] = frame->lr;

-- 
Catalin


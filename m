Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190Ab1ITO57 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 10:57:59 -0400
Received: from service87.mimecast.com ([91.220.42.44]:54213 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751081Ab1ITO55 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 10:57:57 -0400
Date: Tue, 20 Sep 2011 15:57:45 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Laura Abbott <lauraa@codeaurora.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH] arm: Add unwinding annotations for 64bit division
 functions
Message-ID: <20110920145745.GG8545@e102109-lin.cambridge.arm.com>
References: <1316470297-5063-1-git-send-email-lauraa@codeaurora.org>
 <alpine.LFD.2.00.1109191913210.12663@xanadu.home>
 <2285dff3fee56758b6279062a5a30dc7.squirrel@www.codeaurora.org>
 <alpine.LFD.2.00.1109200922281.12663@xanadu.home>
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1109200922281.12663@xanadu.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 20 Sep 2011 14:57:51.0490 (UTC) FILETIME=[AB584620:01CC77A5]
X-MC-Unique: 111092015575302701
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 02:27:01PM +0100, Nicolas Pitre wrote:
> On Mon, 19 Sep 2011, Laura Abbott wrote:
> > On Mon, September 19, 2011 4:22 pm, Nicolas Pitre wrote:
> > > On Mon, 19 Sep 2011, Laura Abbott wrote:
> > >> @@ -189,7 +191,12 @@ ENTRY(__do_div64)
> > >>  	moveq	yh, xh
> > >>  	moveq	xh, #0
> > >>  	moveq	pc, lr
> > >> +UNWIND(.fnend)
> > >>
> > >> +UNWIND(.fnstart)
> > >> +UNWIND(.pad #4)
> > >> +UNWIND(.save {lr})
> > >> +Ldiv0_64:
> > >
> > > Why this phony fnend+fnstart here?
> >
> > If a division by 0 occurs, we need to be able to access the saved LR on
> > the stack which is setup right before calling the __div0 function. This
> > can't go at the top of __do_div64 because if we try to do a backtrace from
> > within __do_div64 the annotation won't be correct as the LR was never
> > saved on the stack.
> 
> I suppose the debug infrastructure always assume the same stack frame 
> for the whole function, hence you can't put that .pad and .save right 
> before the call to __div0 without the .fnstart and have it effective 
> only there?

An element in the unwinding table contains a pointer to the .fnstart
location and a set of instruction bytecodes (like .save) to the next
.fnend statement. If more 4 bytecodes (to fit in an int), it contains an
index to another table with more bytecodes. The elements in the
unwinding table are sorted by the .fnstart address.

So I think in the above case if we don't have the .fnend/.fnstart for
Ldiv0_64 we would get all the instructions in the __do_div64 unwinding
information. I don't think the unwinding bytecode is that smart to allow
other tricks like checking some conditions.

Unless anyone has a better idea to specify this:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>


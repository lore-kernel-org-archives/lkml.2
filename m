Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761465Ab0J2MrD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 08:47:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:59063 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab0J2MrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 08:47:01 -0400
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=ygIiTo8ZIjQA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=tNfoEJo-XNs0bUC9IPIA:9 a=UgC6mzC-xmbhUmzjPkUA:7 a=FeyJYdcZNtq34qFcgXFvcvbVfVUA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 2/2] jump label: disable due to compiler bug
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jason Baron <jbaron@redhat.com>, David Daney <ddaney@caviumnetworks.com>,
        rth@redhat.com, "H. Peter Anvin" <hpa@zytor.com>,
        mathieu.desnoyers@polymtl.ca, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        avi@redhat.com, davem@davemloft.net, vgoyal@redhat.com,
        sam@ravnborg.org, tony@bakeyournoodle.com, dsd@laptop.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101029122230.GA25663@elte.hu>
References: <cover.1288212485.git.jbaron@redhat.com>
	 <2d1b1d5d2b3930e1acb063cefffbcb2faf049854.1288212486.git.jbaron@redhat.com>
	 <ce4ff595-f9d1-4c17-b68e-82739b07ad3e@email.android.com>
	 <20101028141757.GA2875@redhat.com> <4CC9C724.3020004@caviumnetworks.com>
	 <20101028201112.GA4792@redhat.com> <20101029063450.GE29463@elte.hu>
	 <1288354687.18238.433.camel@gandalf.stny.rr.com>
	 <20101029122230.GA25663@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 29 Oct 2010 08:46:58 -0400
Message-ID: <1288356418.18238.454.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-29 at 14:22 +0200, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Fri, 2010-10-29 at 08:34 +0200, Ingo Molnar wrote:

> > Do you mean to have it dependent on !EMBEDDED, or perhaps !CC_OPTIMIZE_FOR_SIZE ?
> 
> CC_OPTIMIZE_FOR_SIZE dependency probably not. Might even leave out !EMBEDDED, to 
> make it generally configurable.
> 
> Also, we should make it default off - we need to see whether there are any compiler 
> bugs lurking.

Ah, so we should then add a:

config JUMP_LABEL
	prompt "Optimize trace point call sites"
	depends on HAVE_ARCH_JUMP_LABEL
	help
	  If it is detected that the compiler has support for
	  "asm goto", the kernel will compile trace points locations 
	  with just a nop instruction. When trace points are enabled
	  the nop will be converted to a jump to the trace function.
	  This technique lowers overhead and stress on the branch
	  prediction of the processor.

	  On i386, the options added to make this work may increase
	  the size of the kernel slightly.


Then in the code have:

-#if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_HAVE_ARCH_JUMP_LABEL)
+#if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_HAVE_ARCH_JUMP_LABEL) \
+	&& defined(JUMP_LABEL)
 # include <asm/jump_label.h>
 # define HAVE_JUMP_LABEL
 #endif


If you agree, I can write up a patch.

-- Steve
	  
> 
> > I can see people making a big stink about adding back a gcc option that makes the 
> > kernel bigger.
> 
> Depends on exactly how much .text we are talking about here. Plus it would be 
> default-off.
> 
> Thanks,
> 
> 	Ingo



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759653Ab2JaSoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 14:44:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20798 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215Ab2JaSoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 14:44:21 -0400
X-Authority-Analysis: v=2.0 cv=KcBQQHkD c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=ABHnkXzvXi4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=Md3eTqbCFe4A:10 a=20KFwNOVAAAA:8 a=Y8rKJ6_igN7ALWYlLeoA:9 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1351709060.4004.91.camel@gandalf.local.home>
Subject: Re: x86_64: undefined symbol 'mcount' in 3.7-rc1
From: Steven Rostedt <rostedt@goodmis.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 31 Oct 2012 14:44:20 -0400
In-Reply-To: <507F13DE.2010601@broadcom.com>
References: <507F13DE.2010601@broadcom.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-17 at 22:23 +0200, Arend van Spriel wrote:
> Hi Steven,
> 
> I have nightly test machines upgraded to 3.7-rc1 and on the 64-bit 
> platform I get MODPOST warning on 'mcount'.
> 
> It is conditionally exported in x8664_ksyms_64.c:
> #ifdef CONFIG_FUNCTION_TRACER
> /* mcount is defined in assembly */
> EXPORT_SYMBOL(mcount);
> #endif
> 
> #ifdef CONFIG_FUNCTION_TRACER
> #ifdef CC_USING_FENTRY
> # define MCOUNT_ADDR           ((long)(__fentry__))
> #else
> # define MCOUNT_ADDR           ((long)(mcount))
> #endif
> #define MCOUNT_INSN_SIZE       5 /* sizeof mcount call */
> 
> I have built the kernel on x86 machine with gcc 4.6.3 and the modules 
> are built during the test execution on test machine which has gcc 4.4.5. 
> Reading commit below
> 
> commit d57c5d51a30152f3175d2344cb6395f08bf8ee0c
> Author: Steven Rostedt <srostedt@redhat.com>
> Date:   Wed Feb 9 13:32:18 2011 -0500
> 
>      ftrace/x86: Add support for -mfentry to x86_64
> 
> I suppose the gcc version mismatch is causing my problem. Is that a 
> correct assumption?

Yes.

gcc 4.6.0 added a new option to gcc called '-mfentry'. The kernel build
checks to see if this option is supported and if so it will use it. What
this option does (when added to -pg), will not do the mcount calling but
instead call fentry. The two have different semantics and are not
compatible. When you built your kernel, the build process detected that
-mfentry is supported and used that.

Now when you built your modules with gcc 4.4.5, -mfentry was not
supported and it used the mcount feature instead. In general, it's not a
good idea to use two different gcc's to build the kernel and modules.

But if you really need to, then you should disable function tracing of
your modules, where the -pg and -mfentry wont be used.

-- Steve



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856Ab2FHENV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 00:13:21 -0400
Received: from ozlabs.org ([203.10.76.45]:45253 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817Ab2FHENU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 00:13:20 -0400
Message-ID: <1339128796.3330.7.camel@concordia>
Subject: Re: [PATCH 1/3][RFC] ftrace/ppc: Have PPC skip updating with
 stop_machine()
From: Michael Ellerman <michael@ellerman.id.au>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Date: Fri, 08 Jun 2012 14:13:16 +1000
In-Reply-To: <20120426183508.749515835@goodmis.org>
References: <20120426183116.857877522@goodmis.org>
	 <20120426183508.749515835@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-04-26 at 14:31 -0400, Steven Rostedt wrote:
> plain text document attachment
> (0001-ftrace-ppc-Have-PPC-skip-updating-with-stop_machine.patch)
> From: Steven Rostedt <srostedt@redhat.com>
> 
> PPC does not have the synchronization issues that x86 has with
> modifying code on one CPU while another CPU is executing it.
> The other CPU will either see the old or new code without any
> issues, unlike x86 which may issue a GPF.
> 
> Instead of calling the heavy stop_machine, just update the code.

This looks nice, but it's giving me this:

arch/powerpc/kernel/ftrace.c:497:13: error: static declaration of 'ftrace_replace_code' follows non-static declaration                                                
include/linux/ftrace.h:317:13: note: previous declaration of 'ftrace_replace_code' was here

I think the fix is just to make our ftrace_replace_code() non-static?

cheers


> +static void ftrace_replace_code(int enable)
> +{
> +	struct ftrace_rec_iter *iter;
> +	struct dyn_ftrace *rec;
> +	int ret;
> +
> +	for (iter = ftrace_rec_iter_start(); iter;
> +	     iter = ftrace_rec_iter_next(iter)) {
> +		rec = ftrace_rec_iter_record(iter);
> +		ret = __ftrace_replace_code(rec, enable);
> +		if (ret) {
> +			ftrace_bug(ret, rec->ip);
> +			return;
> +		}
> +	}
> +}
> +



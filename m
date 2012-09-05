Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758994Ab2IERIH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 13:08:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20391 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298Ab2IERIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 13:08:05 -0400
X-Authority-Analysis: v=2.0 cv=VPlfbqzX c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=noUg4i2VpmoA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=DaC62jvY2FQA:10 a=QDPu36kwqfYA:10 a=6wDlpXiA8UcA:10 a=g6A8ATvHqTsA:10 a=uYYJpDMnpMoA:10 a=_fdy-95lSkQA:10 a=-mxYRuTgxFkK934mZHAA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1346864883.27919.56.camel@gandalf.local.home>
Subject: Re: does gcc gives a false warning in
 kernel/trace/trace_events_filter.c ?
From: Steven Rostedt <rostedt@goodmis.org>
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Date: Wed, 05 Sep 2012 13:08:03 -0400
In-Reply-To: <50432132.90307@gmx.de>
References: <50432132.90307@gmx.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-09-02 at 11:04 +0200, Toralf Förster wrote:
> The current git tree of linux gave with gcc-4.6.3 :
> 
> kernel/trace/trace_events_filter.c: In function ‘ftrace_function_set_filter_cb’:
> kernel/trace/trace_events_filter.c:2074:8: warning: ‘ret’ may be used uninitialized in this function [-Wuninitialized] 
> 
> 
> which refers to this piece of code:
> 
> 
>   2061  static int ftrace_function_set_filter_cb(enum move_type move,
>   2062                                           struct filter_pred *pred,
>   2063                                           int *err, void *data)
>   2064  {
>   2065          /* Checking the node is valid for function trace. */
>   2066          if ((move != MOVE_DOWN) ||
>   2067              (pred->left != FILTER_PRED_INVALID)) {
>   2068                  *err = ftrace_function_check_pred(pred, 0);
>   2069          } else {
>   2070                  *err = ftrace_function_check_pred(pred, 1);
>   2071                  if (*err)
>   2072                          return WALK_PRED_ABORT;
>   2073 
>   2074                  *err = __ftrace_function_set_filter(pred->op == OP_EQ,
>   2075                                                      pred->regex.pattern,
>   2076                                                      pred->regex.len,
>   2077                                                      data);
>   2078          }
>   2079 
>   2080          return (*err) ? WALK_PRED_ABORT : WALK_PRED_DEFAULT;
>   2081  }
>   2082  
> 
> 
> >From a Gentoo forum user I got a hint :
> 
> "Maybe it's some kind of a weird inlining issue? I think it's
> referring to the ret in __ftrace_function_set_filter(), which would be
> uninitialized if the for-loop does not run (re_cnt ≤ 0)"
> 
> Now I'm wondering if re_cnt can become zero or if gcc is wrong here ?
> 

Strange, as ret is initialized to 'ret = -EINVAL;' in
__ftrace_function_set_filter(). I'm thinking that gcc got confused here.
Maybe report it to the gcc maintainers?

-- Steve



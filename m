Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761210Ab2D0Sqo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 14:46:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33155 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759022Ab2D0Sqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 14:46:42 -0400
X-Authority-Analysis: v=2.0 cv=IaEFqBWa c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=YAiA9tJJwu8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=Wjc7B1I3CYzanoRTeO0A:9 a=p6ILm6DmrjC-AHdWMZ0A:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1335552399.28106.228.camel@gandalf.stny.rr.com>
Subject: RFC: How to handle function tracing, frame pointers and -mfentry?
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Cc: Michal Marek <mmarek@suse.cz>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Fri, 27 Apr 2012 14:46:39 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have code that implements -mfentry for the function tracer.

For those that are unfamiliar with this, it was introduced into gcc in
4.6.0 for x86 only. Used with the -pg option, it replaces mcount with
fentry, and is placed at the first instruction of a function (instead of
after the frame has been built, as mcount does).

So what's my problem?  With -mfentry, function tracer does not depend on
frame pointers. As frame pointers may add overhead, some distros
(Debian) has disabled frame pointers from their kernels and with that,
has also disabled function tracing.

Currently, function tracing selects CONFIG_FRAME_POINTER for various
archs (including x86), as the kernel will not compile without it, if
function tracing is enabled. But if -mfentry is available with the
compiler, it does not have this dependency. The kernel will compile fine
with -pg -mfentry and without frame pointers.

My question is, how do I remove the dependency in kconfig based on the
compiler?

I've tried a few things and here's some ideas:

1) Have kconfig detect if -mfentry is supported with the current
compiler. If it is, then enable a "auto" config called
CONFIG_CC_HAS_FENTRY, and allow function tracer be able to select
FRAME_POINTER if that's not defined.

I actually got this to work, but it only works if the host compiler is
the same as the compiler building the kernel. Which in lots of cases is
not (my default setup does not have this).

2) Remove the select entirely. On build, if the compiler fails because
it does not support -pg running without frame pointers, have a big error
message telling the user they can't have function tracing without frame
pointers and that they either need to enable frame pointers or disable
function tracing.

3) Add frame pointers silently if gcc fails to build with gcc -pg.

I personally do not really care which approach is taken (or a new
approach that I didn't list). I just want to be able to build a kernel
with function tracing and without frame pointers on x86.

Thanks,

-- Steve



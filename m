Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab2A0UtF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 15:49:05 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:38709 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836Ab2A0UtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 15:49:02 -0500
X-Authority-Analysis: v=2.0 cv=fNy7LOme c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=AJ-IVAu0mgIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=X8UrhXtC-68ZDyafIksA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1327697341.22710.138.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 1/5] x86/jump-label: Use best default nops for inital
 jump label calls
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Baron <jbaron@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Michal Marek <mmarek@suse.cz>
Date: Fri, 27 Jan 2012 15:49:01 -0500
In-Reply-To: <4F230899.3020808@zytor.com>
References: <20120127201442.080360013@goodmis.org>
	 <20120127202030.887128048@goodmis.org> <4F230899.3020808@zytor.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Added Michal ]

On Fri, 2012-01-27 at 12:27 -0800, H. Peter Anvin wrote:
> On 01/27/2012 12:14 PM, Steven Rostedt wrote:
> > 
> > #define JUMP_LABEL_NOP_SIZE 5
> > 
> > -#define JUMP_LABEL_INITIAL_NOP ".byte 0xe9 \n\t .long 0\n\t" 
> > +#ifdef CONFIG_X86_64 +# define JUMP_LABEL_INIT_NOP P6_NOP5 +#else 
> > +# define JUMP_LABEL_INIT_NOP 0x3e, 0x8d, 0x74, 0x26, 0x00 +#endif
> > 
> 
> Why not just use ASM_NOP5_ATOMIC since you have configuration
> available here?

This eventually needs to match the code in the update_jump_label.c,
otherwise the checks will be incorrect on boot up, and we'll BUG the
kernel.

I need to find a way to get the config options of the kernel into the
compiling of the update_jump_label.c. Then I could use the nops.h file
with the set configs.

Michal, can we get host tools to compile with the configs set by
the .config file?

update_jump_label.c is built just like recordmcount.c is. It would be
great if it could be compiled with the same config.h defines as the
kernel is. That way I can make it (and even recordmcount.c) customize to
the type of kernel that is being built.

Then again, it would also need to be part of the dependencies that are
done with configs.

If not, at the very least, I'll add a comment (in the last patch) that
explains why we use our own "JUMP_LABEL_INIT_NOP" instead of
ASM_NOP5_ATOMIC.

-- Steve



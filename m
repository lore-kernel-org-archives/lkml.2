Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab3ACQ7B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 11:59:01 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13119 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab3ACQ67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 11:58:59 -0500
X-Authority-Analysis: v=2.0 cv=IsacgcDg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=HQJ7cb7SADkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=MBbGe7VapwAA:10 a=drOt6m5kAAAA:8 a=2FZd5QjmWb4xnD2iZhIA:9 a=PUjeQqilurYA:10 a=P4y-9_JJIZgA:10 a=0we4vyi6cfYA:10 a=EvD2fGRHhXBul_Ku:21 a=1eg56KShIjwCFCwC:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1357232337.10284.67.camel@gandalf.local.home>
Subject: Re: [PATCH 2/2] arm: make return_address available for ARM_UNWIND
From: Steven Rostedt <rostedt@goodmis.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Keun-O Park <kpark3469@gmail.com>, fweisbec@gmail.com, mingo@redhat.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sahara <keun-o.park@windriver.com>
Date: Thu, 03 Jan 2013 11:58:57 -0500
In-Reply-To: <20130103162359.GR2631@n2100.arm.linux.org.uk>
References: <1357207949-3349-1-git-send-email-kpark3469@gmail.com>
	 <1357207949-3349-2-git-send-email-kpark3469@gmail.com>
	 <20130103103815.GL2631@n2100.arm.linux.org.uk>
	 <CA+KhAHbmjD7zTw+wcw84Abg3V1dD=0Ea4kUpYdGENQf1UOWphw@mail.gmail.com>
	 <1357220165.10284.30.camel@gandalf.local.home>
	 <20130103141301.GQ2631@n2100.arm.linux.org.uk>
	 <1357229038.10284.46.camel@gandalf.local.home>
	 <20130103162359.GR2631@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-03 at 16:23 +0000, Russell King - ARM Linux wrote:
> On Thu, Jan 03, 2013 at 11:03:58AM -0500, Steven Rostedt wrote:
> > On Thu, 2013-01-03 at 14:13 +0000, Russell King - ARM Linux wrote:
> > > In summary, from what I can see in the patch, the reason why the ifdefs
> > > are the way they are, and the reason the warning is there has not been
> > > addressed; these patches just seem to be aimed just at removing a #warning
> > > statement to make the warning go away.
> > 
> > You're correct that this patch does not solve any of theses issues. Now,
> > I'm thinking that ftrace has matured where these issues don't exist, and
> > where they do, it will only cause noise in the trace than anything
> > serious. But, this needs to be looked deeper to make sure.
> 
> Looking back in the archives, it seems that we had a problem with ftrace
> and the unwinder polluting the trace information:
> 
> http://lists.arm.linux.org.uk/lurker/message/20090604.201745.1c41ee6c.en.html
> 
> There's quite a bit of discussion in that thread about this which details
> why we came up with what we have today.

Thanks for the link. In fact, I see I was even involved :-)

http://lists.arm.linux.org.uk/lurker/message/20090609.213448.b4e4d096.en.html

Just as I explained, the problem isn't a recursion bug, but just noise
in the trace.

Some of what is called by unwind_frame() will always be traced, and I
wouldn't want 'notrace' annotation on those.

If anything, I would just suggest another config option that lets the
user decide if they don't mind the messiness of the trace for the added
benefit of where the latency output came from.

Also, it's rather trivial to make the entire unwind.c not traced, by
adding in the Makefile:

CFLAGS_REMOVE_unwind.o = -pg

But that only stops the tracing of the unwind_*. Looks to be a lot of
those. But it wont stop the tracing of:

 kernel_text_address <-unwind_frame
 core_kernel_text <-unwind_frame
 search_index <-unwind_frame
 etc.

Heck, the user could just keep those from being traced by doing:

 echo kernel_text_address core_kernel_text search_index > \
   /sys/kernel/debug/tracing/set_ftrace_notrace

If DYNAMIC_FTRACE is defined.

-- Steve



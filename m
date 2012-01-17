Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751111Ab2AQCWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 21:22:37 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60937 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740Ab2AQCWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 21:22:36 -0500
Date: Tue, 17 Jan 2012 03:22:31 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, mingo@redhat.com, rostedt@goodmis.org,
        teravest@google.com, slavapestov@google.com, ctalbott@google.com,
        dhsharp@google.com, linux-kernel@vger.kernel.org, winget@google.com,
        namhyung@gmail.com, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 8/9] stacktrace: implement save_stack_trace_quick()
Message-ID: <20120117022227.GD24200@somewhere.redhat.com>
References: <1326220106-5765-1-git-send-email-tj@kernel.org>
 <1326220106-5765-9-git-send-email-tj@kernel.org>
 <20120111162642.GC7991@somewhere.redhat.com>
 <20120111163826.GC26832@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120111163826.GC26832@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 08:38:26AM -0800, Tejun Heo wrote:
> Hello, Frederic.
> 
> On Wed, Jan 11, 2012 at 05:26:44PM +0100, Frederic Weisbecker wrote:
> > On Tue, Jan 10, 2012 at 10:28:25AM -0800, Tejun Heo wrote:
> > > Implement save_stack_trace_quick() which only considers the usual
> > > contexts (ie. thread and irq) and doesn't handle links between
> > > different contexts - if %current is in irq context, only backtrace in
> > > the irq stack is considered.
> > 
> > The thing I don't like is the duplication that involves not only on
> > stack unwinding but also on the safety checks.
> 
> I'm not entirely convinced that this is necessary or we can just add
> more features to the existing backtrace facility (and maybe make that
> more efficient) and be done with it.

Yeah probably we can do that.

> 
> > > This is subset of dump_trace() done in much simpler way.  It's
> > > intended to be used in hot paths where the overhead of dump_trace()
> > > can be too heavy.
> > 
> > Is it? Have you found a measurable impact (outside the fact you record only
> > one stack).
> 
> As I wrote in the head message, I haven't done comparative test yet
> but in the preliminary tests the CPU overhead against memory backed
> device is quite visible (roughly ~20%), so I expect it to matter.
> Note that testing against memory backed device is actually relevant,
> on faster SSDs, CPU is already a bottleneck.
> 
> It would be best if we can extend the existing one to cover all the
> cases with acceptable overhead.  I needed to write this minimal
> version anyway for comparison so it's posted together but no matter
> how it turns out switching them isn't difficult.

Right. So there are two major differences that may affect performances
between save_stack_trace() and save_stack_trace_quick():

- save_stack_trace() does a full walk through the stack, but it rejects
unreliable entries. So to begin with, it should use print_context_stack_bp()
that does a frame pointer walk only (in CONFIG_FRAME_POINTER case).

- It links between stacks. Doing the ->stack() that returns a value should
help in this regard.

- And dump_stack() does various more checks, perhaps we can simplify
it a bit.

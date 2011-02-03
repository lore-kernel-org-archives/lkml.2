Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451Ab1BCTAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 14:00:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41270 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756316Ab1BCTAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 14:00:30 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=CoHOllCSD4cA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=KVCJTWEkoRX4aBonph4A:9 a=0H8cpb1T9Vzn6u0vn84A:7 a=mw_0R_kUq_zkLYelS1qV_oLoM-YA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC 0/4] tracing,x86_64 - function/graph trace without
 mcount/-pg/framepointer
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <20110203173543.GA1769@nowhere>
References: <1296747761-9082-1-git-send-email-jolsa@redhat.com>
	 <1296750805.10797.87.camel@gandalf.stny.rr.com>
	 <20110203173543.GA1769@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 03 Feb 2011 14:00:28 -0500
Message-ID: <1296759628.10797.96.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-03 at 18:35 +0100, Frederic Weisbecker wrote:

> > ftrace could do that now, but it would require a separate handler. I
> > would need to disable preemption before calling the module code function
> > handler.
> 
> Kprobes takes care of handlers from modules already.
> I'm not sure we want that, it makes the tracing code more sensitive.

Masami,

I'm looking at the optimize code, particularly
kprobes_optinsn_template_holder(), which looks to be the template that
is called on optimized kprobes. I don't see where preemption or
interrupts are disabled when a probe is called.

If modules can register probes, and we can call it in any arbitrary
location of the kernel, then preemption must be disabled prior to
calling the module code. Otherwise you risk crashing the system on
module unload.


module:
-------
register_kprobe(probe);


Core:
-----
hit break point
call probe

      module:
      -------
      in probe function
      preempted

module:
-------
unregister_kprobe(probe);
stop_machine();
<module unloaded>

Core:
-----
      module <zombie>:
      ----------------
      gets CPU again
      executes module code that's been freed
      DEATH BY ZOMBIES

Maybe I missed something. But does the optimize kprobes disable
preemption or interrupts before calling the optimized probe?

-- Steve



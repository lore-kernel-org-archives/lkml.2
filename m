Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab0JPATe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 20:19:34 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60349 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab0JPATd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 20:19:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HcSOulNf0eJqBdOfPFFjxXpSAxQE2GECd28qnHguknvkSrsHShpO+yg9wTWXCt7QUW
         yIfs2lvOqjOovbw2ICzYq+u9V8MQoCCOYmZ7ca0LGz+OzAkN11RGNJdIgqpsLkB1Ewpt
         UeIItJfGLtpccdXk+8ZNHhjrz/VUdWuvuIsgw=
Date: Sat, 16 Oct 2010 02:19:02 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [RFC PATCH 4/9] perf: Don't record frame pointer based user
	stacktraces if we dump stack and regs
Message-ID: <20101016001900.GA6512@nowhere>
References: <1286946421-32202-1-git-send-regression-fweisbec@gmail.com> <1286946421-32202-5-git-send-regression-fweisbec@gmail.com> <1286954586.29097.60.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286954586.29097.60.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 09:23:06AM +0200, Peter Zijlstra wrote:
> On Wed, 2010-10-13 at 07:06 +0200, Frederic Weisbecker wrote:
> > User and kernel stack might be selected for other uses than callchain
> > in the future, this probably shouldn't mess with the regular callchain
> > code. Instead we should probably have an exclude_callchain_user
> > attribute, that could be also useful to filter out user callchains
> > when people don't want them. 
> 
> Probably ;-)


There is another solution that would solve my vdso problem
in the meantime.

The problem with vdso is that if we entered the kernel with
a syscall, the first user entry in the callchain will be a
vdso address. But vdso doesn't have dwarf informations so we
can't unwind further.

One solution would be having max_callchain_user as an attribute.
If we do a normal frame pointer based callchain, set it to -1
and you won't have limitations in your callchain. Or you
can set it to n so that your callchains are bound to a maximum
depth.
If you don't want user callchains, set it to 0.
If you do a dwarf based callchain, set it to 2, so that if userspace
was in a vdso, we just deref the frame pointer to find what called
the vdso, and then we can start the dwarf unwinding from there.

I think I'll try that.


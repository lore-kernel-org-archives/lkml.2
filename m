Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab1BTRGj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 12:06:39 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48408 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187Ab1BTRGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 12:06:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=GS9K4JxfZU9jUDiFWw7RD7oG3dKX/Pz9gBpLrpF/OFbrRvrtvSgFrfM7xszGJvBECE
         0G0z7kXJdOMHKaZdm3Naatvddb8cvnfcrwszgtgEd+TnuVA6IMJqPazre89v96H2Dnqb
         iITvecNh2jlY03DlSXhgn7GHidtRBOvhCRho0=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Jan Kratochvil <jan.kratochvil@redhat.com>, torvalds@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after PTRACE_ATTACH
Date: Sun, 20 Feb 2011 18:06:30 +0100
User-Agent: KMail/1.8.2
Cc: Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
References: <20110220094050.GA7714@host1.dyn.jankratochvil.net>
In-Reply-To: <20110220094050.GA7714@host1.dyn.jankratochvil.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201102201806.30273.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 20 February 2011 10:40, Jan Kratochvil wrote:
> Sure by default GDB does not do anything special, it will respawn (using
> PTRACE_CONT(SIGSTOP)) any SIGSTOP it sees due to the default setting of:
> 	(gdb) handle SIGSTOP
> 	Signal        Stop  Print Pass to program Description
> 	SIGSTOP       Yes Yes Yes   Stopped (signal)
> 
> Therefore there happens the double SIGSTOP reporting as discussed before:
> 	(gdb) run
> 	Starting program: /bin/sleep 1h
> 	# external kill -STOP <inferior pid>
> 	Program received signal SIGSTOP, Stopped (signal).
> 	# State:	t (tracing stop)
> 	(gdb) continue 
> 	Continuing.
> 	Program received signal SIGSTOP, Stopped (signal).
> 	# State:	t (tracing stop)
> 	(gdb) continue 
> 	Continuing.
> 	# State:	S (sleeping)
> 
> Your proposal is I expect:
> 	(gdb) run
> 	Starting program: /bin/sleep 1h
> 	# external kill -STOP <inferior pid>
> 	Program received signal SIGSTOP, Stopped (signal).
> 	# State:	t (tracing stop)
> 	(gdb) continue 
> 	Continuing.
> 	# State:	T (stopped)

Not exactly. Even after we fix kernel so that it properly preserves
group-stop across ptrace-stops, gdb will still see TWO 
waitpid:SIGSTOP events, not one.

First one says "the tracee has received SIGSTOP", and after PTRACE_CONT(SIGSTOP),
second one says "the tracee has stopped because of SIGSTOP".
Currently, neither strace nor gdb understands that second one
is different from first.

Here is how strace can be improved by querying PTRACE_GETSIGINFO:

+                               entered_stopped_state = 0;
+                               if (WSTOPSIG(status) == SIGSTOP ||
+                                   WSTOPSIG(status) == SIGTSTP) {
+                                       /*
+                                        * PTRACE_GETSIGINFO fails if this was
+                                        * genuine *stop* notification,
+                                        * not *signal* notification
+                                        */
+                                       if (ptrace(PTRACE_GETSIGINFO, pid,
+                                                   0, &si) != 0)
+                                               entered_stopped_state = 1;
+                               }
                                printleader(tcp);
-                               tprintf("--- %s (%s) @ %lx (%lx) ---",
+                               tprintf(entered_stopped_state
+                                       ? "--- stopped by %s ---"
+                                       : "--- %s (%s) @ %lx (%lx) ---",
                                        signame(WSTOPSIG(status)),
                                        strsignal(WSTOPSIG(status)), pc, addr);


Before patch strace shows confusing log:

--- SIGSTOP (Stopped (signal)) @ 0 (0) ---
--- SIGSTOP (Stopped (signal)) @ 0 (0) ---

After it is more understandable:

--- SIGSTOP (Stopped (signal)) @ 0 (0) ---
--- stopped by SIGSTOP ---


I think you can use similar trick in gdb, so that second message says
"Program stopped due to signal SIGSTOP, Stopped (signal)",
not "Program received signal SIGSTOP, Stopped (signal)".

-- 
vda

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758237Ab1ELRce (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 13:32:34 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40792 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758037Ab1ELRcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 13:32:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bAnm0PNPmlpAvijnwmnB6xSrH2/50yRAjqk9UyiAbjyOR5v2UF5QPGl3V8Uvb5vZQD
         kvLvejuKZ0DoMoHuTHon+w/aP0JVsewvPfnsHWsmcHsbjeEgNVgnqt22ZGC/DgPEcMXG
         ksjUD/iqTFN6LYKGeEnvl3aL7gsABqpX7KkQg=
Date: Thu, 12 May 2011 19:32:28 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 09/11] job control: reorganize wait_task_stopped()
Message-ID: <20110512173228.GO1030@htj.dyndns.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <1304869745-1073-10-git-send-email-tj@kernel.org>
 <20110511154854.GB23688@redhat.com>
 <20110511192902.GC24245@mtj.dyndns.org>
 <20110512154247.GC18599@redhat.com>
 <20110512160253.GK1030@htj.dyndns.org>
 <20110512172506.GA23033@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110512172506.GA23033@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, May 12, 2011 at 07:25:06PM +0200, Oleg Nesterov wrote:
> > WNOHANG disables that mechanism.
> 
> Yes, this is clear. WNOHANG can "race" with the transitions above.
> But we do not care, this is like reading the word which can be
> changed by another thread, no?
> 
> But this bug is different. Say, the parent does wait(WNOWAIT) and
> gets CLD_STOPPED. After that it has all rights to assume that
> wait(WNOHANG) must report either STOPPED or CONTINUED.

They aren't that different.  Please consider the following program.

  #define PTRACE_SEIZE		0x4206
  #define PTRACE_INTERRUPT	0x4207

  #define PTRACE_SEIZE_DEVEL	0x80000000

  static const struct timespec ts1ms = { .tv_nsec = 1000000 };

  int main(int argc, char **argv)
  {
	  pid_t child, control;

	  child = fork();
	  if (!child)
		  while (1)
			  pause();

	  kill(child, SIGSTOP);
	  waitid(P_PID, child, NULL, WSTOPPED | WNOWAIT);

	  control = fork();
	  if (!control) {
		  while (1) {
			  kill(child, SIGCONT);
			  nanosleep(&ts1ms, NULL);
			  kill(child, SIGSTOP);
			  nanosleep(&ts1ms, NULL);
		  }
	  }

	  while (1) {
		  siginfo_t si = {};

		  waitid(P_PID, child, &si,
			 WSTOPPED | WCONTINUED | WNOWAIT | WNOHANG);
		  if (!si.si_pid)
			  break;
	  }

	  kill(control, SIGKILL);
	  kill(child, SIGKILL);
	  return 0;
  }

waitid(2) should always succeed as it's never consuming wait state,
but it does, with or without the patch.  All transitions need to be
made water tight to remove the bug.

Thanks.

-- 
tejun

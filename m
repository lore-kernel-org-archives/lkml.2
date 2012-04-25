Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab2DYPrI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 11:47:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997Ab2DYPrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 11:47:05 -0400
Date: Wed, 25 Apr 2012 17:46:11 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Roland McGrath <roland@hack.frob.com>
Subject: Re: [RFC] TIF_NOTIFY_RESUME, arch/*/*/*signal*.c and all such
Message-ID: <20120425154611.GA23672@redhat.com>
References: <CA+55aFzuTspDyyLaOA-g-dTWydaUeeWo9uVGR+rZ=ZJzPW_Ocw@mail.gmail.com> <20120420180748.GI6871@ZenIV.linux.org.uk> <20120423180150.GA6871@ZenIV.linux.org.uk> <20120424072617.GB6871@ZenIV.linux.org.uk> <20120425030659.GE6871@ZenIV.linux.org.uk> <20120425123746.GA15560@redhat.com> <20120425125042.GF6871@ZenIV.linux.org.uk> <20120425130329.GA16413@redhat.com> <20120425133238.GG6871@ZenIV.linux.org.uk> <20120425145239.GA21386@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120425145239.GA21386@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25, Oleg Nesterov wrote:
>
> On 04/25, Al Viro wrote:
> >
> > Point...  Still, since we are talking about an arbitrary wide window (the
> > damn thing is waiting for signals to arrive, after all) this doesn't
> > sound good;
> > ...
> > IMO it's
> > a QoI problem at the very least.
>
> and looks confusing, agreed.

OK, I didn't really try to think, and somehow I simply can't wake up today.
But perhaps we can do something the following? We add the new syscall

	sys_eintr(void)
	{
		return -EINTR;
	}

(perhaps not strictly needed, perhaps we can reuse sys_restart_syscal)

Now,

	--- x/arch/x86/kernel/signal.c
	+++ x/arch/x86/kernel/signal.c
	@@ -711,6 +711,13 @@ handle_signal(unsigned long sig, siginfo
				regs->ax = regs->orig_ax;
				regs->ip -= 2;
				break;
	+
	+		case -EINTR:
	+			break;
	+
	+		default:
	+			if (regs->orig_ax == NR_eintr)
	+				regs->ax = NR_eintr;
			}
		}
	 
	@@ -791,6 +798,7 @@ static void do_signal(struct pt_regs *re
			case -ERESTARTSYS:
			case -ERESTARTNOINTR:
				regs->ax = regs->orig_ax;
	+			regs->orig_ax = NR_eintr;
				regs->ip -= 2;
				break;
	 

this ignores ERESTART_RESTARTBLOCK for simplicity.

And I am not sure this can't confuse the tools like strace...

Oleg.


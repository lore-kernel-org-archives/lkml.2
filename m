Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759658Ab0FRKBW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 06:01:22 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:39865 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753046Ab0FRKBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 06:01:21 -0400
Date: Fri, 18 Jun 2010 11:00:53 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: "Gleb O. Raiko" <raiko@niisi.msk.ru>
Cc: David Daney <ddaney@caviumnetworks.com>, Jesper Nilsson <jesper@jni.nu>,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: MIPS: return after handling coprocessor 2 exception
Message-ID: <20100618100053.GA4466@linux-mips.org>
References: <20100617132554.GB24162@jni.nu>
 <4C1A57AE.9080706@caviumnetworks.com>
 <4C1B263E.7070906@niisi.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C1B263E.7070906@niisi.msk.ru>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 18, 2010 at 11:54:38AM +0400, Gleb O. Raiko wrote:

> >What happens when the call chain is empty, and the proper action *is*
> >SIGILL?
> 
> It's never empty, in fact. The default notifier declared at top of
> traps.c sends SIGILL. The problem that current code is sending
> SIGILL in all cases.

That's not really a problem.  The design idea is that a the default
notifier has the lowest priority, that is any user notifier installed
should have higher priority resulting in it getting run first.  To avoid
the default notifier from getting executed such an extra notifier should
set NOTIFY_STOP_MASK in its return like:

static int default_cu2_call(struct notifier_block *nfb, unsigned long action,
        void *data)
{
	...

	return NOTIFY_OK | NOTIFY_STOP;
}

The notifier list could also be used for example by perf but there it
we'd want the notifier function not to return NOTIFY_STOP as the result;

Arguably sending the signal for CU2 instructions has been delegated to the
hook so the I agree that the break stateement should be replaced with a
return and will apply the patch.

  Ralf

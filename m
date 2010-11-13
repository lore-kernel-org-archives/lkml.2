Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab0KMKOc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 05:14:32 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55680 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191Ab0KMKOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 05:14:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xAQjf6LmAPEUeBIWLO58TkLIR8TtEEJHaC2e0yW+gMywGLIXY0qnAX6U2Y4PabFKi6
         2PXoj+5mOocgxFjXCCLTWCw0EjW9R6P6R1OPmwBa78g3rNckko3EKmmgD6q8jgxEuaDM
         HS4V2bXAJTy86vjptSS8UEVZvkImLse2mSND4=
Date: Sat, 13 Nov 2010 18:17:32 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@suse.de>, Jan Beulich <JBeulich@novell.com>,
        Avi Kivity <avi@redhat.com>, Xen-devel <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 06/20] x86/ticketlock: make __ticket_spin_trylock common
Message-ID: <20101113101732.GH3837@hack>
References: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com> <4cea7b0804de5a2c1249034fc5c4840ade043ff4.1288794124.git.jeremy.fitzhardinge@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4cea7b0804de5a2c1249034fc5c4840ade043ff4.1288794124.git.jeremy.fitzhardinge@citrix.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 03, 2010 at 10:59:47AM -0400, Jeremy Fitzhardinge wrote:

>+	union {
>+		struct __raw_tickets tickets;
>+		__ticketpair_t slock;
>+	} tmp, new;
>+	int ret;
>+
>+	tmp.tickets = ACCESS_ONCE(lock->tickets);
>+	if (tmp.tickets.head != tmp.tickets.tail)
>+		return 0;
>+
>+	new.slock = tmp.slock + (1 << TICKET_SHIFT);
>+
>+	ret = cmpxchg(&lock->ticketpair, tmp.slock, new.slock) == tmp.slock;
>+	barrier();		/* just make nothing creeps before lock is claimed */

This one should be smp_wmb(), right? No CONFIG_X86_OOSTORE protected.

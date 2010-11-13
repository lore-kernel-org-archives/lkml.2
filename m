Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290Ab0KMKsv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 05:48:51 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51586 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab0KMKsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 05:48:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Q7iuH7/496AnZrKFjxCxl2knYIeuC/nm1XCOR3J/Ary7MW0SuZUJcjNMnPfcEUSUkV
         N2hpoCzfOGcYbrisbe0ffjRkV8MKqT+0bzuSvkV0XAnjPTDqC3Vltcv+MiIxFjMtuyxx
         wl7tD9qGhPTT+rEKEj0h7fZcsBR1Iq9HxPWp8=
Subject: Re: [PATCH 06/20] x86/ticketlock: make __ticket_spin_trylock common
From: Eric Dumazet <eric.dumazet@gmail.com>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@suse.de>, Jan Beulich <JBeulich@novell.com>,
        Avi Kivity <avi@redhat.com>, Xen-devel <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
In-Reply-To: <20101113101732.GH3837@hack>
References: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com>
	 <4cea7b0804de5a2c1249034fc5c4840ade043ff4.1288794124.git.jeremy.fitzhardinge@citrix.com>
	 <20101113101732.GH3837@hack>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 13 Nov 2010 11:48:41 +0100
Message-ID: <1289645321.2743.21.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 13 novembre 2010 à 18:17 +0800, Américo Wang a écrit :
> On Wed, Nov 03, 2010 at 10:59:47AM -0400, Jeremy Fitzhardinge wrote:
> 
> >+	union {
> >+		struct __raw_tickets tickets;
> >+		__ticketpair_t slock;
> >+	} tmp, new;
> >+	int ret;
> >+
> >+	tmp.tickets = ACCESS_ONCE(lock->tickets);
> >+	if (tmp.tickets.head != tmp.tickets.tail)
> >+		return 0;
> >+
> >+	new.slock = tmp.slock + (1 << TICKET_SHIFT);
> >+
> >+	ret = cmpxchg(&lock->ticketpair, tmp.slock, new.slock) == tmp.slock;
> >+	barrier();		/* just make nothing creeps before lock is claimed */
> 
> This one should be smp_wmb(), right? No CONFIG_X86_OOSTORE protected.

cmpxchg() is a full memory barrier, no need for smp_wmb() or barrier()




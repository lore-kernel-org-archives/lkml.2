Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361Ab2ACRbq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 12:31:46 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:41189 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136Ab2ACRbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 12:31:43 -0500
Message-ID: <1325611899.2320.111.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [PATCH] x86: fix and improve cmpxchg_double{,_local}()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: mingo@elte.hu, tglx@linutronix.de, Christoph Lameter <cl@linux.com>,
        linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        hpa@zytor.com
Date: Tue, 03 Jan 2012 18:31:39 +0100
In-Reply-To: <4F032E5E020000780006A36C@nat28.tlf.novell.com>
References: <4F01F12A020000780006A19B@nat28.tlf.novell.com>
	 <1325602830.2320.69.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <4F032E5E020000780006A36C@nat28.tlf.novell.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 03 janvier 2012 à 15:35 +0000, Jan Beulich a écrit :

> And in atomic64_set_cx8 it's the other way around: The comment
> explains why supposedly no LOCK prefix is needed, but that's again
> in conflict with above quoted paragraph from the manual.

BTW atomic64_set() asm() contraints are wrong :

static inline void atomic64_set(atomic64_t *v, long long i)
{
        unsigned high = (unsigned)(i >> 32);
        unsigned low = (unsigned)i;
        asm volatile(ATOMIC64_ALTERNATIVE(set)
                     : "+b" (low), "+c" (high)
                     : "S" (v)
                     : "eax", "edx", "memory"
                     );
}


ebx/ecx registers are not modified by cmpxchg8b (or the atomic64_set_386
emulation). Only eax/edx can be modified.




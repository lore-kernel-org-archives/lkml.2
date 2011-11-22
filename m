Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394Ab1KVDS6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 22:18:58 -0500
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:24889 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752300Ab1KVDS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 22:18:57 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: ScUS9NkVM1kt3bt6qIXicKynzoZXr1wskZzT1Wtjx4err8t
 orzeCR2YOzSIfRkPQSOkvIdGlt2fWpOsrk24Ty5LJzU_150vO5vctPqNmI0F
 hzEEZg57xq47f3RwOGK0jQnjBjc8MCluJqZU7iAwP1RNoL9XmAvxQg45S_Pu
 kXHv.YFcA94ZyTawO_5l8t96Gdo14nqPXgyfkn8MrFxMmeRz02XzgOb0qzfT
 w5V1msPUiR7p7j.nfce6FJMD_HPQZuKYtNMHc423mHynG3VsnK9NllIN1CBP
 U8_LKtEFLdVqRv9H_Pf0CqJ3Xb8YHuNQAwYsGx51Q_zDFKNN4PJvL5gTzQI7
 71UcMoMV0BnZLkRNLfasXVjU7pmgUpXyt0kyPKVXyShdpWRshYoy3yDZ23Ys
 _LJjBhjZbnpen76rEGg61eKfDDIX856_iievxOYd0ncxkKdK3lI4i4vn.IDQ
 uWhLpMywltJGbotM1ruFWOW86bWz8EFy55Jw0kSVKGIeQJfsKiVo1JW4-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 21 Nov 2011 21:18:52 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Christian Kujau <lists@nerdbynature.de>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Eric Dumazet <eric.dumazet@gmail.com>, "Alex,Shi" <alex.shi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: WARNING: at mm/slub.c:3357, kernel BUG at mm/slub.c:3413
In-Reply-To: <alpine.DEB.2.01.1111211617220.8000@trent.utfs.org>
Message-ID: <alpine.DEB.2.00.1111212105330.19606@router.home>
References: <20111121131531.GA1679@x4.trippels.de>  <1321884966.10470.2.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>  <20111121153621.GA1678@x4.trippels.de>  <1321890510.10470.11.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>  <20111121161036.GA1679@x4.trippels.de>
  <1321894353.10470.19.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>  <1321895706.10470.21.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>  <20111121173556.GA1673@x4.trippels.de>  <1321900743.10470.31.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>  <20111121185215.GA1673@x4.trippels.de>
  <20111121195113.GA1678@x4.trippels.de> <1321907275.13860.12.camel@pasglop> <alpine.DEB.2.01.1111211617220.8000@trent.utfs.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Nov 2011, Christian Kujau wrote:

> On Tue, 22 Nov 2011 at 07:27, Benjamin Herrenschmidt wrote:
> > Note that I hit a similar looking crash (sorry, I couldn't capture a
> > backtrace back then) on a PowerMac G5 (ppc64) while doing a large rsync
> > transfer yesterday with -rc2-something (cfcfc9ec) and
> > Christian Kujau (CC) seems to be able to reproduce something similar on
> > some other ppc platform (Christian, what is your setup ?)
>
> I seem to hit it with heavy disk & cpu IO is in progress on this PowerBook
> G4. Full dmesg & .config: http://nerdbynature.de/bits/3.2.0-rc1/oops/
>
> I've enabled some debug options and now it really points to slub.c:2166

Hmmm... That means that c->page points to page not frozen. Per cpu
partial pages are frozen until they are reused or until the partial list
is flushed.

Does this ever happen on x86 or only on other platforms? In put_cpu_partial() the
this_cpu_cmpxchg really needs really to be irq safe. this_cpu_cmpxchg is
only preempt safe.

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-11-21 21:15:41.575673204 -0600
+++ linux-2.6/mm/slub.c	2011-11-21 21:16:33.442336849 -0600
@@ -1969,7 +1969,7 @@
 		page->pobjects = pobjects;
 		page->next = oldpage;

-	} while (this_cpu_cmpxchg(s->cpu_slab->partial, oldpage, page) != oldpage);
+	} while (irqsafe_cpu_cmpxchg(s->cpu_slab->partial, oldpage, page) != oldpage);
 	stat(s, CPU_PARTIAL_FREE);
 	return pobjects;
 }

x

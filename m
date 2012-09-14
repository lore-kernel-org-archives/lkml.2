Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123Ab2INWKu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 18:10:50 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60495 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab2INWKt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 18:10:49 -0400
Message-ID: <1347660634.2341.5.camel@twins>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>, Nikolay Ulyanitsky <lystor@gmail.com>,
        Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Date: Sat, 15 Sep 2012 00:10:34 +0200
In-Reply-To: <CA+55aFwKEjsPKYNFkkNfrr9V=vyEO6M9o_48be4y9w6=h-06UQ@mail.gmail.com>
References: <CA+Medix98MHYzpKSDKKWf7Wew0H4zDFsUS74LrhsP2Lxemd3Mw@mail.gmail.com>
	 <20120914212717.GA29307@liondog.tnic> <1347658843.7172.90.camel@twins>
	 <CA+55aFz6SxLEr0MNubz7rcwcqki7EM33Vp-q3KFEvuLG6a61ZQ@mail.gmail.com>
	 <1347659777.7172.97.camel@twins>
	 <CA+55aFwKEjsPKYNFkkNfrr9V=vyEO6M9o_48be4y9w6=h-06UQ@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-14 at 15:01 -0700, Linus Torvalds wrote:
> Sure, it doesn't take tsk_cpus_allowed() into account while setting up
> the cache (since it's not dynamic enough), but *assuming* the common
> case is that people let threads be on any of the cores of a package,
> it should be possible to make the cache 100% equivalent with no
> semantic change. No? 

I'm not seeing how it could be. Only ever looking at 1 other cpu
(regardless which one) cannot be the same as checking 'all' of them.

Suppose we have the 6 core AMD chip, a task being woken on cpu0 would
look at cpus 1-6 (the entire package shares cache) to see if any of them
was idle. Only looking at a single cpu will avoid looking at the other
4.

The chance of finding an idle cpu to run on is much bigger the more cpus
you look at (also more expensive).


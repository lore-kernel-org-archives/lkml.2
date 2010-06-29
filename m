Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119Ab0F2Qc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 12:32:59 -0400
Received: from office.altell.ru ([80.246.246.162]:42698 "EHLO office.altell.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756581Ab0F2Qc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 12:32:57 -0400
X-Greylist: delayed 357 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Jun 2010 12:32:57 EDT
Date: Tue, 29 Jun 2010 20:26:43 +0400
From: Dan Kruchinin <kruchinin@altell.ru>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
       Herbert Xu <herbert@gondor.hengli.com.au>
Subject: [PATCH 0/2] padata: Separate cpumasks for cb_cpus and parallel
 workers
Message-ID: <20100629202643.00a80cfb@leibniz>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Altell-MailScanner-ID: 9724B46E0.09DB3
X-Altell-MailScanner: Found to be clean
X-Altell-MailScanner-From: kruchinin@altell.ru
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

The main point of my patches is to make two separate cpumasks. One for
parallel and another for serial workers(callback cpus). It'll perform to
bind non-intersecting groups of CPUs for serial and parallel workers and
do more thin tuning of padata subsystem.

My tests shows that proper configuration of serial and parallel cpu
masks gives a bit better performance. For example (aes-asm,
sha1-generic. Two 16-core machines):
1) 1 point-to-point connection:
Non-modified padata gives ~650Mbit of TCP and ~780Mbit of UDP
When I exclude callback CPUs from parallel cpumask padata gives
~750Mbit of TCP and ~900Mbit of UDP.
2) 2 IPSEC tunnels between 16-core machines and 4 clients
communicating via tunnels with each-other
Non-modified padata gives ~1.5Gbit of UDP
padata with non-intersecting cpumasks for parallel and serial workers
gives ~1.8Gbit

Besides the performance growth, there may be situations when serial job
takes a lot of time. For example if I add several dozens of firewall
rules, serial worker will work slower and padata_do_parallel will
continue to enqueue requests into the queue of CPU serial worker
executes on.
It may significantly slow down parallelization and reordering because
one CPU(that is shared by both parallel and serial workers) will always
have more requests in its parallel queue than others CPUs(because
serialization takes a lot of time). In such cases user may exclude
callback CPUs from cpumask for parallel workers.

-- 
W.B.R.
Dan Kruchinin

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398Ab1JNKes (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 06:34:48 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57363 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921Ab1JNKer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 06:34:47 -0400
Message-ID: <1318588503.2223.5.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: Regression in reading /proc/stat in the newer kernels with
 large SMP and NUMA configurations
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: "Oberman, Laurence (HAS GSE)" <Laurence.Oberman@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Seger, Mark" <mark.seger@hp.com>,
        "Cabaniols, Sebastien" <Sebastien.Cabaniols@hp.com>
Date: Fri, 14 Oct 2011 12:35:03 +0200
In-Reply-To: <alpine.DEB.2.00.1110140249310.21487@chino.kir.corp.google.com>
References: <8DC664164FA4D1449479E7B36CDCFB1F221E724322@GVW0676EXC.americas.hpqcorp.net>
	 <alpine.DEB.2.00.1110140249310.21487@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 14 octobre 2011 à 03:08 -0700, David Rientjes a écrit :

> The overhead is probably in kstat_irqs_cpu() which is called for each 
> possible irq for each of the 32 possible cpus, and /proc/stat actually 
> does the sum twice.  You would see the same type of overhead with 
> /proc/interrupts if it wasn't masked by the locking that it requires to 
> safely read irq_desc.  "dmesg | grep nr_irqs" will show how many percpu 
> variables are being read for every cpu twice.

One annoying thing with most HP servers is they claim more possible cpus
than reality. So each time we have to loop on possible cpus, we waste
time and memory cache lines.

For example, on this ProLiant BL460c G6, with two quad core cpus
(2x4x2), 32 'possible' cpus are found, instead of 16 :

setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:32 nr_node_ids:2
PERCPU: Embedded 26 pages/cpu @ffff88007dc00000 s76288 r8192 d22016 u131072
pcpu-alloc: s76288 r8192 d22016 u131072 alloc=1*2097152
pcpu-alloc: [0] 00 02 04 06 08 10 12 14 17 19 21 23 25 27 29 31 
pcpu-alloc: [1] 01 03 05 07 09 11 13 15 16 18 20 22 24 26 28 30 




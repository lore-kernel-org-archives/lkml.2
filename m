Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299Ab1JDNiq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 09:38:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:37067 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757252Ab1JDNip convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 09:38:45 -0400
Subject: Re: [PATCH v2] CPU hotplug, freezer: Fix bugs in CPU hotplug call
 path
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@ucw.cz, len.brown@intel.com,
        mingo@elte.hu, akpm@linux-foundation.org, suresh.b.siddha@intel.com,
        lucas.demarchi@profusion.mobi, linux-pm@lists.linux-foundation.org,
        rusty@rustcorp.com.au, vatsa@linux.vnet.ibm.com, ashok.raj@intel.com,
        linux-kernel@vger.kernel.org
Date: Tue, 04 Oct 2011 15:37:20 +0200
In-Reply-To: <4E8B09F3.4080800@linux.vnet.ibm.com>
References: <4E88BF33.10407@linux.vnet.ibm.com>
	 <1317636215.12973.16.camel@twins> <4E8B07EA.4020307@linux.vnet.ibm.com>
	 <4E8B09F3.4080800@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317735440.32543.4.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-04 at 18:58 +0530, Srivatsa S. Bhat wrote:
> +static int tasks_frozen;
> +
> +void set_tasks_frozen_flag(void)
> +{
> +       tasks_frozen = 1;
> +       smp_mb();
> +}
> +
> +void clear_tasks_frozen_flag(void)
> +{
> +       tasks_frozen = 0;
> +       smp_mb();
> +}
> +
> +int tasks_are_frozen(void)
> +{
> +       return tasks_frozen;
> +} 

See Documentation/memory-barriers.txt, memory barriers always come in
pairs, furthermore memory barriers always should have a comment
explaining the ordering and referring to the pair match.

I think you want at least an smp_rmb() before reading tasks_frozen,
possible you also want to use ACCESS_ONCE() to force the compiler to
emit the read.

Furthermore, do you really need this? isn't it both set and read from
the same task context, all under pm_mutex?

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420Ab1BJRpW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 12:45:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50916 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991Ab1BJRpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 12:45:21 -0500
Subject: Re: [Patch] idle governor: Avoid lock acquisition to read pm_qos
 before entering idle
From: James Bottomley <James.Bottomley@suse.de>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, mark gross <markgross@thegnar.org>,
        David Alan Gilbert <linux@treblig.org>, linux-kernel@vger.kernel.org,
        Len <len.brown@intel.com>, Andi Kleen <ak@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>
In-Reply-To: <1297300864.2645.128.camel@schen9-DESK>
References: <1297300864.2645.128.camel@schen9-DESK>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Feb 2011 11:45:13 -0600
Message-ID: <1297359914.4933.56.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-09 at 17:21 -0800, Tim Chen wrote:
> I noticed that before entering idle state, the menu idle governor will
> look up the current pm_qos value according to the list of qos request
> received.  This look up currently needs the acquisition of a lock to go
> down a list of qos requests to find the qos value, slowing down the
> entrance into idle state due to contention by multiple cpus to traverse
> this list.  The contention is severe when there are a lot of cpus waking
> and going into idle.  For example, for a simple workload that has 32
> pair of processes ping ponging messages to each other, where 64 cores
> cores are active in test system, I see the following profile:
> 
> -     37.82%          swapper  [kernel.kallsyms]          [k]
> _raw_spin_lock_irqsave
>    - _raw_spin_lock_irqsave
>       - 95.65% pm_qos_request             
>            menu_select                                             
>            cpuidle_idle_call                      
>          - cpu_idle                                                     
>               99.98% start_secondary
> 
> Perhaps a better approach will be to cache the updated pm_qos value so
> reading it does not require lock acquisition as in the patch below.   
> 
> Tim
> 
> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>

What you say is true as long as the value is 32 bits ... perhaps a note
of that should be made somewhere?

Otherwise, it looks like a good lockless optimisation on the read path,
so you can add my ack.

James



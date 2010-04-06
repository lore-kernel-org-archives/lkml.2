Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446Ab0DFPm7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 11:42:59 -0400
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:47565 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145Ab0DFPmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 11:42:53 -0400
Date: Tue, 6 Apr 2010 10:41:47 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
cc: Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       alex.shi@intel.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Ma, Ling" <ling.ma@intel.com>, "Chen, Tim C" <tim.c.chen@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: hackbench regression due to commit 9dfc6e68bfe6e
In-Reply-To: <1270542497.2078.123.camel@ymzhang.sh.intel.com>
Message-ID: <alpine.DEB.2.00.1004061033330.18750@router.home>
References: <1269506457.4513.141.camel@alexs-hp.sh.intel.com>  <alpine.DEB.2.00.1003250942080.2670@router.home>  <1269570902.9614.92.camel@alexs-hp.sh.intel.com>  <1270114166.2078.107.camel@ymzhang.sh.intel.com>  <alpine.DEB.2.00.1004011050340.16531@router.home>
  <1270195589.2078.116.camel@ymzhang.sh.intel.com>  <alpine.DEB.2.00.1004050853300.23149@router.home>  <i2z84144f021004051030k7ff5190cyc083aa12c552dfac@mail.gmail.com>  <4BBA8DF9.8010409@kernel.org> <1270542497.2078.123.camel@ymzhang.sh.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Apr 2010, Zhang, Yanmin wrote:

> Thanks. I tried 2 and 4 times and didn't see much improvement.
> I checked /proc/vamallocinfo and it doesn't have item of pcpu_get_vm_areas
> when I use 4 times of PERCPU_DYNAMIC_RESERVE.

> I used perf to collect dtlb misses and LLC misses. dtlb miss data is not
> stable. Sometimes, we have a bigger dtlb miss, but get a better result.
>
> LLC misses data are more stable. Only LLC-load-misses is the clear sign now.
> LLC-store-misses has no big difference.

LLC-load-miss is exactly what condition?

The cacheline environment in the hotpath should only include the following
cache lines (without debugging and counters):

1. The first cacheline from the kmem_cache structure

(This is different from the sitation before the 2.6.34 changes. Earlier
some critical values (object length etc) where available
from the kmem_cache_cpu structure.  The cacheline containing the percpu
structure array was needed to determome the kmem_cache_cpu address!)

2. The first cacheline from kmem_cache_cpu

3. The first cacheline of the data object (free pointer)

And in case of a kfree/ kmem_cache_free:

4. Cacheline that contains the page struct of the page the object resides
in.

Can you post the .config you are using and the bootup messages?


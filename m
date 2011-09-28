Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab1I1NAq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 09:00:46 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:6602 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504Ab1I1NAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 09:00:44 -0400
Message-ID: <4E831A79.1030402@tilera.com>
Date: Wed, 28 Sep 2011 09:00:41 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:7.0) Gecko/20110922 Thunderbird/7.0
MIME-Version: 1.0
To: Gilad Ben-Yossef <gilad@benyossef.com>
CC: <linux-kernel@vger.kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, <linux-mm@kvack.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 0/5] Reduce cross CPU IPI interference
References: <1316940890-24138-1-git-send-email-gilad@benyossef.com>
In-Reply-To: <1316940890-24138-1-git-send-email-gilad@benyossef.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/25/2011 4:54 AM, Gilad Ben-Yossef wrote:
> We have lots of infrastructure in place to partition a multi-core system such
> that we have a group of CPUs that are dedicated to specific task: cgroups,
> scheduler and interrupt affinity and cpuisol boot parameter. Still, kernel
> code will some time interrupt all CPUs in the system via IPIs for various
> needs. These IPIs are useful and cannot be avoided altogether, but in certain
> cases it is possible to interrupt only specific CPUs that have useful work to
> do and not the entire system.
>
> This patch set, inspired by discussions with Peter Zijlstra and Frederic
> Weisbecker when testing the nohz task patch set, is a first stab at trying to
> explore doing this by locating the places where such global IPI calls are
> being made and turning a global IPI into an IPI for a specific group of CPUs.
> The purpose of the patch set is to get  feedback if this is the right way to
> go for dealing with this issue and indeed, if the issue is even worth dealing
> with at all.

I strongly concur with your motivation in looking for and removing sources 
of unnecessary cross-cpu interrupts.  We have some code in our tree (not 
yet returned to the community) that tries to deal with some sources of 
interrupt jitter on tiles that are running isolcpu and want to be 100% in 
userspace.

> This first version creates an on_each_cpu_mask infrastructure API (derived from
> existing arch specific versions in Tile and Arm) and uses it to turn two global
> IPI invocation to per CPU group invocations.

The global version looks fine; I would probably make on_each_cpu() an 
inline in the !SMP case now that you are (correctly, I suspect) disabling 
interrupts when calling the function.

> The patch is against 3.1-rc4 and was compiled for x86 and arm in both UP and
> SMP mode (I could not get Tile to build, regardless of this patch)

Yes, our gcc changes are still being prepped for return to the community, 
so unless you want to grab the source code on the http://www.tilera.com/scm 
website, you won't have tile support in gcc yet.  (binutils has been 
returned, so gcc is next up.)
-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


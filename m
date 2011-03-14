Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834Ab1CNSNZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 14:13:25 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:42255 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465Ab1CNSNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 14:13:24 -0400
Date: Mon, 14 Mar 2011 23:43:15 +0530
From: Mahesh J Salgaonkar <mahesh@linux.vnet.ibm.com>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Anton Blanchard <anton@samba.org>, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org
Subject: Re: [PATCH 1/2] kdump: Allow shrinking of kdump region to be
 overridden
Message-ID: <20110314181315.GA16075@in.ibm.com>
Reply-To: mahesh@linux.vnet.ibm.com
References: <20100825002258.GD28360@kryten>
 <m139u37cii.fsf@fess.ebiederm.org>
 <4D771EE6.5050404@linux.vnet.ibm.com>
 <20110309122046.GC16951@cr0.redhat.com>
 <20110309234657.264d3080@kryten>
 <20110309142108.GD16951@cr0.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110309142108.GD16951@cr0.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 10:21:08PM +0800, Américo Wang wrote:
> On Wed, Mar 09, 2011 at 11:46:57PM +1100, Anton Blanchard wrote:
> >
> >Hi,
> >
> >> The crashkernel region is specified via kernel cmdline, so why
> >> not just drop a failure when it overlaps with RMO region?
> >> Am I missing something?
> >
> >Unfortunately a ppc64 kernel requires a chunk of RMO memory. We would
> >need the ability to specify multiple crashkernel regions - about 32MB
> >in the RMO and the rest can be anywhere. That sounds pretty fragile for
> >a user to configure successfully on the cmdline.
> >
> >Thats why the ppc64 crashkernel region begins mid way through the RMO
> >region. It means both kernels get a chunk of RMO and we only have to
> >deal with one crashkernel reservation in all the tools and
> >documentation.
> >
> 
> So, when I specify 128M in cmdline, 32M of them are RMO, and the
> rest 96M are normal memory? And when I want to free all of them,
> actually the 32M RMO will never be freed?

In ppc64 implementation the crashkernel region begins mid way through
the RMO and spans across into the normal memory. For e.g. on power system
with 128M RMO size, when user specifies 128M in cmdline, the crashkernel
starts from default offset 64M through 192M. Which means 64M in RMO region
and rest beyond RMO.

 <-------------------RMO--------------->
                             <---rtas-->
0                    64M               128M                     End
|=====================|=================|===========|============|
           Crash_start|<------------128M----------->| Crash End

During free we do free all of them including RMO region. But since the rtas
region is always on top of RMO, crashkernel memory overlaps rtas region and
we endup freeing that even, which is causing the crash.

> 
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec

-- 
Signed-off-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab2DRPP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 11:15:56 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52189 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752022Ab2DRPPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 11:15:55 -0400
Date: Wed, 18 Apr 2012 16:15:45 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        majianpeng <majianpeng@gmail.com>
Subject: Re: Possible memory leaks in proc_sysctl.c
Message-ID: <20120418151545.GI1505@arm.com>
References: <20120418101231.GE1505@arm.com>
 <m1wr5d18fy.fsf@fess.ebiederm.org>
 <20120418141851.GG1505@arm.com>
 <m1ipgxrt11.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ipgxrt11.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 03:52:58PM +0100, Eric W. Biederman wrote:
> Catalin Marinas <catalin.marinas@arm.com> writes:
> > On Wed, Apr 18, 2012 at 02:22:09PM +0100, Eric W. Biederman wrote:
> >> Catalin Marinas <catalin.marinas@arm.com> writes:
> >> > Following your commit f728019bb (sysctl: register only tables of sysctl
> >> > files), I get several kmemleak reports. They all seem to be header
> >> > allocations with kzalloc() in __register_sysctl_table() and
> >> > __register_sysctl_paths(). The patch isn't simple to quickly figure out
> >> > what may be wrong.
> >> 
> >> Due to a change in the data structure places where we register the
> >> sysctl permanently and ignore the result from the register_sysctl_...
> >> family of functions now report this leak.
> >
> > But is the header (or subheader, basically any pointer inside the
> > kmalloc'ed object) never referenced from anywhere? I'm just trying to
> > understand why kmemleak reports it as it seems that the header object is
> > inserted in a ctl_dir.
> 
> It is never reference from anywhere because we never free the structure.
> The job of the header is to be the structure that tells us how to free
> things.
> 
> I see a couple of things going on.
> - For compatibility the header that is returned is a dummy that just
>   points to the real headers.
> 
> - Even without the compatibility we can get the same symptom if
>   we register an empty directory.
> 
> So simply saying kmemleak shut up this is deliberate in these few cases
> where we don't intend to unregister the structure and have a deliberate
> leak seems the clean and maintainable way to go.

OK, I got it now, sounds fair. But please add a comment to the
kmemleak_not_leak() annotations so that others know it's a deliberate
leak (rather than a false positive).

Also the patch should include the linux/kmemleak.h file for the
kmemleak_not_leak() prototype as header changes in the future may cause
problems (I think the one you posted did not include it).

Thanks.

-- 
Catalin

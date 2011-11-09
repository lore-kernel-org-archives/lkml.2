Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab1KIPER (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 10:04:17 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:65493 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356Ab1KIPEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 10:04:16 -0500
Date: Wed, 9 Nov 2011 09:44:41 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, len.brown@intel.com,
        tglx@linutronix.de, jeremy@goop.org, hpa@zytor.com, bp@alien8.de,
        tj@kernel.org, trenn@suse.de, mingo@redhat.com,
        xen-devel@lists.xensource.com, stable@kernel.org
Subject: Re: [PATCH 1/3] cpuidle: If disable_cpuidle() is called, set pm_idle
 to default_idle.
Message-ID: <20111109144440.GB8410@phenom.dumpdata.com>
References: <1320786914-10541-1-git-send-email-konrad.wilk@oracle.com>
 <1320786914-10541-2-git-send-email-konrad.wilk@oracle.com>
 <4EBA53C5.9040603@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EBA53C5.9040603@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A020201.4EBA9652.00C8,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

. snip..
> > 
> >      ..scribble on pm_idle and access default_idle,
> >     have it simply disable_cpuidle() so acpi_idle will not load and
> >     architecture default HLT will be used.
> > 
> > .. but the default HLT does not get used. Instead we end up in the

Hey Deepthi,

> > +	if (cpuidle_disabled()) {
> > +		pm_idle = default_idle;
> > +		return;
> > +	}
> 
> 
> The above check is needed to initialise pm_idle to default_idle if
> cpuidle is disabled but this requirement here is Zen specific. 
> On other architectures, if cpuidle is disabled on boot then we 
> rather would want mwait_idle or amd_e400_idle to be enabled than 
> default_idle. Can we make this check Zen specific ? 

We do? Why? I would have thought that if you want to disable the cpuidle
you would want the default_idle. 

Perhaps there is another way do this is:

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index becd6d9..04b10a4 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -38,6 +38,7 @@ int cpuidle_disabled(void)
 void disable_cpuidle(void)
 {
 	off = 1;
+	pm_idle = default_idle;
 }

which would do almost the same thing as this patch (well, except
that if you run cpuidle.off=1 you still end up with amd_e400_idle
instead of default_idle, so it is not the complete solution).

> 
> ...  if(ZEN_ARCH && cpuidle_disabled()) ... 

That would not work very well. For one thing you would need to call
'xen_domain()', and pull in a lots of header files. Second of, it
looks quite ugly and kernel folks like pretty code.

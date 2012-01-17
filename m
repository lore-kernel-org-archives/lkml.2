Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab2AQRQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 12:16:32 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:38245 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120Ab2AQRQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 12:16:29 -0500
Date: Tue, 17 Jan 2012 12:13:14 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: liang tang <liang.tang@oracle.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "mike.mcclurg@citrix.com" <mike.mcclurg@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stefan.bader@canonical.com" <stefan.bader@canonical.com>,
        "rjw@sisk.pl" <rjw@sisk.pl>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Yu, Ke" <ke.yu@intel.com>, "konrad@kernel.org" <konrad@kernel.org>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "Nakajima, Jun" <jun.nakajima@intel.com>
Subject: Re: [Xen-devel] [PATCH 3/8] ACPI: processor: add
 __acpi_processor_[un]register_driver helpers.
Message-ID: <20120117171314.GB5494@phenom.dumpdata.com>
References: <20111219142626.GB27772@andromeda.dapyr.net>
 <625BA99ED14B2D499DC4E29D8138F1506E01AAC03A@shsmsx502.ccr.corp.intel.com>
 <20111220153145.GB13253@andromeda.dapyr.net>
 <625BA99ED14B2D499DC4E29D8138F1506E01AAC469@shsmsx502.ccr.corp.intel.com>
 <20111223030103.GA7218@andromeda.dapyr.net>
 <AADFC41AFE54684AB9EE6CBC0274A5D10145B9@SHSMSX102.ccr.corp.intel.com>
 <20120103205925.GI17472@phenom.dumpdata.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D102D62B@SHSMSX102.ccr.corp.intel.com>
 <20120113222451.GA6922@phenom.dumpdata.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D10FCD37A9@SHSMSX102.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D10FCD37A9@SHSMSX102.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4F15ACAC.0076,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I was trying to figure out how difficult it would be to just bring Pxx states to
> > the Xen hypervisor using the existing ACPI interfaces. And while it did not pass
> > all the _Pxx states (seems that all the _PCT, _PSS, _PSD, _PPC flags need to
> > be enabled in the hypercall to make this work), it demonstrates what I had in
> > mind. 

.. snip..
> > 	/* TODO: Under Xen, the C-states information is not present.
> >  	 * Figure out why. */
> 
> it's possible related to this long thread:
> 
> http://lists.xen.org/archives/html/xen-devel/2011-08/msg00511.html
> 
> IOW, Xen doesn't export mwait capability to dom0, which impacts _PDC setting.
> Final solution is to have a para-virtualized PDC call for that.

Aaah. Let me play with that a bit. Thanks for the pointer.

.. snip..
> the prerequisites for this module to work correctly, is that dom0 has the right
> configurations to have all necessary Cx/Px information ready before this 
> module is loaded. That may mean enabling full CONFIG_CPU_IDLE and CONFIG_CPUFREQ,

Right.
> which in current form may add some negative impact, e.g. dom0 will try to control
> Px/Cx to conflict with Xen. So some tweaks may be required in that part.

Yup. Hadn't even looked at the cpufreq tries to do yet.
> 
> given our purpose now, is to come up a cleaner approach which tolerate some
> assumptions (e.g. #VCPU of dom0 == #PCPU), there's another option following this
> trend (perhaps compensate your idea). We can register a Xen-cpuidle and 
> xen-cpufreq driver to current Linux cpuidle and cpufreq framework, which plays 
> mainly two roles:
> 	- a dummy driver to prevent dom0 touching actual Px/Cx
> 	- parse ACPI Cx/Px information to Xen, in a similar way you did above

Yeah, I like where you are heading.
> 
> there may have some other trickiness, but the majority code will be self-contained.

<nods>
> 
> Thanks
> Kevin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

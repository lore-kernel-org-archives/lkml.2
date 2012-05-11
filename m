Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761037Ab2EKUyg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 16:54:36 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:32756 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760950Ab2EKUyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 16:54:33 -0400
Date: Fri, 11 May 2012 16:48:24 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: "'xen-devel@lists.xensource.com'" <xen-devel@lists.xensource.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 3/3] Xen physical cpus interface
Message-ID: <20120511204824.GA2156@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC8292335154F3E@SHSMSX101.ccr.corp.intel.com>
 <20120420192439.GA32170@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923351B5807@SHSMSX101.ccr.corp.intel.com>
 <20120510145745.GO26152@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923351B5A2E@SHSMSX101.ccr.corp.intel.com>
 <DE8DF0795D48FD4CA783C40EC82923351B873F@SHSMSX101.ccr.corp.intel.com>
 <20120511142758.GA29677@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923351BC88D@SHSMSX101.ccr.corp.intel.com>
 <20120511190041.GA3785@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923351BCD16@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923351BCD16@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 08:31:15PM +0000, Liu, Jinsong wrote:
> Konrad Rzeszutek Wilk wrote:
> > On Fri, May 11, 2012 at 06:04:21PM +0000, Liu, Jinsong wrote:
> >> Konrad Rzeszutek Wilk wrote:
> >>> On Fri, May 11, 2012 at 01:12:13PM +0000, Liu, Jinsong wrote:
> >>>> Liu, Jinsong wrote:
> >>>>> Just notice your reply (so quick :)
> >>>>> 
> >>>>> Agree and will update later, except 1 concern below.
> >>>>> 
> >>>>> Konrad Rzeszutek Wilk wrote:
> >>>>>>> 
> >>>>>>> Hmm, it's good if it's convenient to do it automatically via
> >>>>>>> dev->release. However, dev container (pcpu) would be free at
> >>>>>>> some other error cases, so I prefer do it 'manually'.
> >>>>>> 
> >>>>>> You could also call pcpu_release(..) to do it manually.
> >>>>>> 
> >>>>> 
> >>>>> that means kfree(pcpu) would be done twice at some error cases,
> >>>>> do you think it really good? 
> >>>>> 
> >>>> 
> >>>> Ping.
> >>>> 
> >>>> I think error recovery should be kept inside error logic level
> >>>> itself, if try to recover upper level error would bring trouble.
> >>>> 
> >>>> In our example, there are 2 logic levels:
> >>>> pcpu level (as container), and dev level (subfield used for sys)
> >>> 
> >>> So you need to untangle free_pcpu from doing both. Meaning one does
> >>> the SysFS and the other deals with free-ing the structure and
> >>> removing itself from the list.
> >>> 
> >> 
> >> free_cpu is very samll, just consist of the 2 parts your said:
> >> * pcpu_sys_remove() deal with sysfs
> >> * list_del/kfree(pcpu) deal with pcpu
> >> 
> >>> 
> >>>> dev->release should only recover error occurred at dev/sys level,
> >>>> and the pcpu error should be recovered at pcpu level.
> >>>> 
> >>>> If dev->release try to recover its container pcpu level error, like
> >>>> list_del/kfree(pcpu), it would make confusing. i.e., considering
> >>>> pcpu_sys_create(), 2 error cases: device_register fail, and
> >>>> device_create_file fail --> how can the caller decide kfree(pcpu)
> >>>> or not?
> >>> 
> >>> Then you should free it manually. But you can do this by a wrapper
> >>> function: 
> >>> 
> >>> __pcpu_release(..) {
> >>> 	..
> >>> 	/* Does the removing itself from the list and kfree the pcpu */ }
> >>> pcpu_release(..) {
> >>> 	struct pcpcu *p= container_of(..)
> >>> 	__pcpu_release(p);
> >>> }
> >>> 
> >>> dev->release = &pcpu_release;
> >>> 
> >> 
> >> Too weird way. If we want to release dev itself it's good to use
> >> dev->release, but for pcpu I doubt it. (consider the example I gave
> >> --> why we create issue (it maybe solved in weird method I agree),
> >> just for using dev->release?)  
> >> 
> >> In kernel many dev->release keep NULL.
> >> An example of using dev->release is cpu/mcheck/mce.c -->
> >> mce_device_release(), it *just* deal dev itself. 
> > 
> > OK? I am not sure what are we arguing here anymore?
> > I think using 'kfree(pcpu)' on the error paths (as long as it is
> > done before device_register) is OK. I think that seperating
> > the SysFS deletion from the pcpu deletion should be done to
> > avoid races. Perhaps the SysFS deletion function should also
> > remove the pcpu from the list.
> 
> How about static array pcpu[NR_CPUS]?
> It seems solve all issues we argued :)

Ugh. That could mean a structure of more than 4K of items.
Lets stick with making it dynamic.

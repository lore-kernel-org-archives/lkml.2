Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760335Ab2EKOeM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 10:34:12 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:34769 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757321Ab2EKOeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 10:34:09 -0400
Date: Fri, 11 May 2012 10:27:58 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: "'xen-devel@lists.xensource.com'" <xen-devel@lists.xensource.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] Xen physical cpus interface
Message-ID: <20120511142758.GA29677@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC8292335154F3E@SHSMSX101.ccr.corp.intel.com>
 <20120420192439.GA32170@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923351B5807@SHSMSX101.ccr.corp.intel.com>
 <20120510145745.GO26152@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923351B5A2E@SHSMSX101.ccr.corp.intel.com>
 <DE8DF0795D48FD4CA783C40EC82923351B873F@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923351B873F@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 01:12:13PM +0000, Liu, Jinsong wrote:
> Liu, Jinsong wrote:
> > Just notice your reply (so quick :)
> > 
> > Agree and will update later, except 1 concern below.
> > 
> > Konrad Rzeszutek Wilk wrote:
> >>> 
> >>> Hmm, it's good if it's convenient to do it automatically via
> >>> dev->release. However, dev container (pcpu) would be free at some
> >>> other error cases, so I prefer do it 'manually'.
> >> 
> >> You could also call pcpu_release(..) to do it manually.
> >> 
> > 
> > that means kfree(pcpu) would be done twice at some error cases, do
> > you think it really good? 
> > 
> 
> Ping.
> 
> I think error recovery should be kept inside error logic level itself, if try to recover upper level error would bring trouble.
> 
> In our example, there are 2 logic levels:
> pcpu level (as container), and dev level (subfield used for sys)

So you need to untangle free_pcpu from doing both. Meaning one does the
SysFS and the other deals with free-ing the structure and removing itself
from the list.


> dev->release should only recover error occurred at dev/sys level, and the pcpu error should be recovered at pcpu level.
> 
> If dev->release try to recover its container pcpu level error, like list_del/kfree(pcpu), it would make confusing. i.e., considering pcpu_sys_create(), 2 error cases:
> device_register fail, and device_create_file fail --> how can the caller decide kfree(pcpu) or not?

Then you should free it manually. But you can do this by a wrapper
function:

__pcpu_release(..) {
	..
	/* Does the removing itself from the list and kfree the pcpu */
}
pcpu_release(..) {
	struct pcpcu *p= container_of(..)
	__pcpu_release(p);
}

dev->release = &pcpu_release;

> 
> So how about recover pcpu error manually and explicitly?
> 
> Thanks,
> Jinsong

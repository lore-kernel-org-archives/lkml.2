Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab0FKFDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 01:03:17 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:56514 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752491Ab0FKFDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 01:03:16 -0400
Date: Fri, 11 Jun 2010 10:26:00 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, kvm <kvm@vger.kernel.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC/T/D][PATCH 2/2] Linux/Guest cooperative unmapped page cache
 control
Message-ID: <20100611045600.GE5191@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20100608155140.3749.74418.sendpatchset@L34Z31A.ibm.com>
 <20100608155153.3749.31669.sendpatchset@L34Z31A.ibm.com>
 <4C10B3AF.7020908@redhat.com>
 <20100610142512.GB5191@balbir.in.ibm.com>
 <1276214852.6437.1427.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1276214852.6437.1427.camel@nimitz>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dave Hansen <dave@linux.vnet.ibm.com> [2010-06-10 17:07:32]:

> On Thu, 2010-06-10 at 19:55 +0530, Balbir Singh wrote:
> > > I'm not sure victimizing unmapped cache pages is a good idea.
> > > Shouldn't page selection use the LRU for recency information instead
> > > of the cost of guest reclaim?  Dropping a frequently used unmapped
> > > cache page can be more expensive than dropping an unused text page
> > > that was loaded as part of some executable's initialization and
> > > forgotten.
> > 
> > We victimize the unmapped cache only if it is unused (in LRU order).
> > We don't force the issue too much. We also have free slab cache to go
> > after.
> 
> Just to be clear, let's say we have a mapped page (say of /sbin/init)
> that's been unreferenced since _just_ after the system booted.  We also
> have an unmapped page cache page of a file often used at runtime, say
> one from /etc/resolv.conf or /etc/passwd.
> 
> Which page will be preferred for eviction with this patch set?
>

In this case the order is as follows

1. First we pick free pages if any
2. If we don't have free pages, we go after unmapped page cache and
slab cache
3. If that fails as well, we go after regularly memory

In the scenario that you describe, we'll not be able to easily free up
the frequently referenced page from /etc/*. The code will move on to
step 3 and do its regular reclaim. 

-- 
	Three Cheers,
	Balbir

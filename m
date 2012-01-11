Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934066Ab2AKVpV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 16:45:21 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:60954 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758148Ab2AKVpS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 16:45:18 -0500
MIME-Version: 1.0
Message-ID: <1caa64c1-a36d-4779-a757-1a653ecd88d6@default>
Date: Wed, 11 Jan 2012 13:44:49 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Nitin Gupta <ngupta@vflare.org>,
        Brian King <brking@linux.vnet.ibm.com>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: RE: [PATCH 1/5] staging: zsmalloc: zsmalloc memory allocation library
References: <<1326149520-31720-1-git-send-email-sjenning@linux.vnet.ibm.com>>
 <<1326149520-31720-2-git-send-email-sjenning@linux.vnet.ibm.com>>
 <b5b5a961-85e5-4ce1-8280-7ca382cb0e0f@default>
 <4F0DCAA7.4000601@linux.vnet.ibm.com>
In-Reply-To: <4F0DCAA7.4000601@linux.vnet.ibm.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4F0E02E2.00B2,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> Subject: Re: [PATCH 1/5] staging: zsmalloc: zsmalloc memory allocation library
> 
> On 01/11/2012 11:19 AM, Dan Magenheimer wrote:
> >> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> >> Subject: [PATCH 1/5] staging: zsmalloc: zsmalloc memory allocation library
> >>
> >> From: Nitin Gupta <ngupta@vflare.org>
> >>
> >> This patch creates a new memory allocation library named
> >> zsmalloc.
> >>
> >> +/*
> >> + * Allocate a zspage for the given size class
> >> + */
> >> +static struct page *alloc_zspage(struct size_class *class, gfp_t flags)
> >> +{
> >> +	int i, error;
> >> +	struct page *first_page = NULL;
> >> +
> >> +	/*
> >> +	 * Allocate individual pages and link them together as:
> >> +	 * 1. first page->private = first sub-page
> >> +	 * 2. all sub-pages are linked together using page->lru
> >> +	 * 3. each sub-page is linked to the first page using page->first_page
> >> +	 *
> >> +	 * For each size class, First/Head pages are linked together using
> >> +	 * page->lru. Also, we set PG_private to identify the first page
> >> +	 * (i.e. no other sub-page has this flag set) and PG_private_2 to
> >> +	 * identify the last page.
> >> +	 */
> >> +	error = -ENOMEM;
> >> +	for (i = 0; i < class->zspage_order; i++) {
> >> +		struct page *page, *prev_page;
> >> +
> >> +		page = alloc_page(flags);
> >
> > Hmmm... I thought we agreed offlist that the new allocator API would
> > provide for either preloads or callbacks (which may differ per pool)
> > instead of directly allocating raw pages from the kernel.  The caller
> > (zcache or ramster or ???) needs to be able to somehow manage maximum
> > memory capacity to avoid OOMs.
> >
> > Or am I missing the code that handles that?
> 
> No, you aren't missing it; it's not there.  And I agree that we
> should add that.
> 
> However, the existing allocator, xvmalloc, doesn't support callback
> functionality either.  Would it be simpler to add the that as
> a separate patch, that way we can keep the changes to zcache/zram
> in this patchset isolated to just changing the xvmalloc calls to
> zsmalloc calls?

OK, I'll buy that.  Since you haven't changed any of the policy
code, and the allocator is (purportedly) more storage-efficient on
any sequence of chunks stored in it, the potential for OOMs shouldn't
get any worse.

Dan

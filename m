Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab1LHKEv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 05:04:51 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:48908 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550Ab1LHKEt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 05:04:49 -0500
X-IronPort-AV: E=Sophos;i="4.71,319,1320624000"; 
   d="scan'208";a="9358303"
From: Paul Durrant <Paul.Durrant@citrix.com>
To: ANNIE LI <annie.li@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>
Date: Thu, 8 Dec 2011 10:04:57 +0000
Subject: RE: [PATCH V2 1/2] xen/granttable: Support sub-page grants
Thread-Topic: [PATCH V2 1/2] xen/granttable: Support sub-page grants
Thread-Index: Acy1kHCd7Z+Z9eCOTU6spp2HTbgTwwAAD44Q
Message-ID: <291EDFCB1E9E224A99088639C4762022B5988E552D@LONPMAILBOX01.citrite.net>
References: <1323336940-5382-1-git-send-email-annie.li@oracle.com>
 <1323337048-5426-1-git-send-email-annie.li@oracle.com>
 <291EDFCB1E9E224A99088639C4762022B5988E5528@LONPMAILBOX01.citrite.net>
 <4EE08B0D.80504@oracle.com>
In-Reply-To: <4EE08B0D.80504@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: ANNIE LI [mailto:annie.li@oracle.com]
> Sent: 08 December 2011 10:02
> To: Paul Durrant
> Cc: xen-devel@lists.xensource.com; linux-kernel@vger.kernel.org;
> konrad.wilk@oracle.com; jeremy@goop.org; Ian Campbell;
> kurt.hackel@oracle.com
> Subject: Re: [PATCH V2 1/2] xen/granttable: Support sub-page grants
> 
> 
> >> +
> >> +int gnttab_grant_foreign_access_subpage(domid_t domid, unsigned
> >> long frame,
> >> +					int flags, unsigned page_off,
> >> +					unsigned length)
> >> +{
> >> +	int ref;
> >> +
> >> +	if (flags&  (GTF_accept_transfer | GTF_reading |
> >> +		     GTF_writing | GTF_transitive))
> >> +		return -EPERM;
> >> +
> >> +	if (gnttab_interface->update_subpage_entry == NULL)
> >> +		return -ENOSYS;
> >> +
> >> +	ref = get_free_entries(1);
> >> +	if (unlikely(ref<  0))
> >> +		return -ENOSPC;
> >> +
> >> +	gnttab_interface->update_subpage_entry(ref, domid, frame,
> >> flags,
> >> +					       page_off, length);
> >> +
> >> +	return ref;
> >> +}
> >> +EXPORT_SYMBOL_GPL(gnttab_grant_foreign_access_subpage);
> > There's quite a lot of duplicated code here. What about something
> along the lines of:
> >
> > #define get_free_entry()	get_free_entries(1)
> >
> > int gnttab_grant_foreign_access_subpage(domid_t domid, unsigned
> long frame,
> > 					int flags, unsigned page_off,
> > 					unsigned length)
> > {
> > 	int ref;
> >
> > 	ref = get_free_entry();
> > 	if (unlikely(ref<  0))
> > 		return -ENOSPC;
> >
> > 	rc = gnttab_grant_foreign_access_subpage_ref(ref, domid,
> frame, flags, page_off, length);
> > 	if (rc<  0)
> > 		put_free_entry(ref);
> >
> > 	return (rc<  0) rc : ref;
> > }
> > EXPORT_SYMBOL_GPL(gnttab_grant_foreign_access_subpage);
> >
> > I think this is more akin to the format for existing non-ref
> variants.
> >
> I hesitated between those two implement ways before sending them
> out.
> Those two ways all have shortcoming, one has duplicated code, but is
> simple when condition does not meet. The other way you pointed out
> added more put_free_entry process when _ref function fails.
> 

I say let's be optimistic :-) Yes, there's more overhead in the failure case, but that's not what we should be optimising for.

  Paul

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab1LHKCM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 05:02:12 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:61518 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977Ab1LHKCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 05:02:06 -0500
Message-ID: <4EE08B0D.80504@oracle.com>
Date: Thu, 08 Dec 2011 18:01:49 +0800
From: ANNIE LI <annie.li@oracle.com>
Organization: Oracle Corporation
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.23) Gecko/20110920 Thunderbird/3.1.15
MIME-Version: 1.0
To: Paul Durrant <Paul.Durrant@citrix.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>
Subject: Re: [PATCH V2 1/2] xen/granttable: Support sub-page grants
References: <1323336940-5382-1-git-send-email-annie.li@oracle.com> <1323337048-5426-1-git-send-email-annie.li@oracle.com> <291EDFCB1E9E224A99088639C4762022B5988E5528@LONPMAILBOX01.citrite.net>
In-Reply-To: <291EDFCB1E9E224A99088639C4762022B5988E5528@LONPMAILBOX01.citrite.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090201.4EE08B1A.009E,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> +
>> +int gnttab_grant_foreign_access_subpage(domid_t domid, unsigned
>> long frame,
>> +					int flags, unsigned page_off,
>> +					unsigned length)
>> +{
>> +	int ref;
>> +
>> +	if (flags&  (GTF_accept_transfer | GTF_reading |
>> +		     GTF_writing | GTF_transitive))
>> +		return -EPERM;
>> +
>> +	if (gnttab_interface->update_subpage_entry == NULL)
>> +		return -ENOSYS;
>> +
>> +	ref = get_free_entries(1);
>> +	if (unlikely(ref<  0))
>> +		return -ENOSPC;
>> +
>> +	gnttab_interface->update_subpage_entry(ref, domid, frame,
>> flags,
>> +					       page_off, length);
>> +
>> +	return ref;
>> +}
>> +EXPORT_SYMBOL_GPL(gnttab_grant_foreign_access_subpage);
> There's quite a lot of duplicated code here. What about something along the lines of:
>
> #define get_free_entry()	get_free_entries(1)
>
> int gnttab_grant_foreign_access_subpage(domid_t domid, unsigned long frame,
> 					int flags, unsigned page_off,
> 					unsigned length)
> {
> 	int ref;
>
> 	ref = get_free_entry();
> 	if (unlikely(ref<  0))
> 		return -ENOSPC;
>
> 	rc = gnttab_grant_foreign_access_subpage_ref(ref, domid, frame, flags, page_off, length);
> 	if (rc<  0)
> 		put_free_entry(ref);
>
> 	return (rc<  0) rc : ref;
> }
> EXPORT_SYMBOL_GPL(gnttab_grant_foreign_access_subpage);
>
> I think this is more akin to the format for existing non-ref variants.
>
I hesitated between those two implement ways before sending them out. 
Those two ways all have shortcoming, one has duplicated code, but is 
simple when condition does not meet. The other way you pointed out added 
more put_free_entry process when _ref function fails.

Thanks
Annie

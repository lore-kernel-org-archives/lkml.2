Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953Ab1LFR0H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 12:26:07 -0500
Received: from claw.goop.org ([74.207.240.146]:54220 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846Ab1LFRZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 12:25:53 -0500
Message-ID: <4EDE4EC4.8070802@goop.org>
Date: Tue, 06 Dec 2011 09:20:04 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: "annie.li@oracle.com" <annie.li@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>,
        Paul Durrant <Paul.Durrant@citrix.com>
Subject: Re: [PATCH 1/2] xen/granttable: Support sub-page grants
References: <4EDDF41E.8070200@oracle.com>  <1323168999-4434-1-git-send-email-annie.li@oracle.com> <1323171726.23681.65.camel@zakaz.uk.xensource.com>
In-Reply-To: <1323171726.23681.65.camel@zakaz.uk.xensource.com>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2011 03:42 AM, Ian Campbell wrote:
>> +{
>> +	int ref;
>> +
>> +	ref = get_free_entries(1);
>> +	if (unlikely(ref < 0))
>> +		return -ENOSPC;
>> +
>> +	gnttab_grant_foreign_access_ref_subpage_v2(ref, domid, frame, flags,
>> +						   page_off, length);
>> +
>> +	return ref;
>> +}
>> +EXPORT_SYMBOL_GPL(gnttab_grant_foreign_access_subpage_v2);
>> +
>> +void gnttab_grant_foreign_access_ref_subpage_v2(grant_ref_t ref, domid_t domid,
>> +						unsigned long frame, int flags,
>> +						unsigned page_off,
>> +						unsigned length)
>> +{
>> +	BUG_ON(flags & (GTF_accept_transfer | GTF_reading |
>> +			GTF_writing | GTF_transitive));
>> +	BUG_ON(grant_table_version == 1);
> Returning -Esomething might be less drastic? ENOSYS perhaps?

Yeah, BUG_ON shouldn't be used for API misuse unless there's absolutely
no other way to handle it.

>
>> +	gnttab_shared.v2[ref].sub_page.frame = frame;
>> +	gnttab_shared.v2[ref].sub_page.page_off = page_off;
>> +	gnttab_shared.v2[ref].sub_page.length = length;
>> +	gnttab_shared.v2[ref].hdr.domid = domid;
>> +	wmb();
>> +	gnttab_shared.v2[ref].hdr.flags =
>> +				GTF_permit_access | GTF_sub_page | flags;
>> +}
>> +EXPORT_SYMBOL_GPL(gnttab_grant_foreign_access_ref_subpage_v2);
>> +
>> +bool gnttab_subpage_trans_grants_available(void)
>> +{
>> +	return grant_table_version == 2;
>> +}
> It's not clear this adds anything over and above letting the user query
> the grant table version. It's hard to tell since there are no users
> presented here though. Perhaps separate subpage and transitive functions
> would be cleaner?

Well, in general, specifically testing for features rather than
interface versions is better.

    J

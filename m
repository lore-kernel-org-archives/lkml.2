Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261Ab1HVQpa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 12:45:30 -0400
Received: from smtp-out.google.com ([216.239.44.51]:7969 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab1HVQp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 12:45:26 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:x-system-of-record;
	b=iejF9a9sIWWnMytcCY7569y7PCccc1S8FRVMZaNL1ibGKZSMe49hQgt1/ACcYE3OY
	lgbTKXy5fYn1UcDd9fm7g==
MIME-Version: 1.0
In-Reply-To: <4E520149.3010802@intel.com>
References: <CAG1a4rs4Cr1z50gGuK9SLE6aOvibE1sdV_GSLPv+gqYC8g+ORQ@mail.gmail.com>
 <CAErSpo4FfBoGDUquoLNsJ9=z-M-x6NQgP8xJL_VqEXpsL2H5PA@mail.gmail.com> <4E520149.3010802@intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 22 Aug 2011 10:45:03 -0600
Message-ID: <CAErSpo71XHyuji1HxZwShtg-YQCavgkgcdH23ic38q3COB3MgQ@mail.gmail.com>
Subject: Re: APEI: Can not request iomem region for GARs
To: Huang Ying <ying.huang@intel.com>
Cc: Pavel Ivanov <paivanof@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 1:12 AM, Huang Ying <ying.huang@intel.com> wrote:
> Do you have time to try the patch attached with the mail?
> acpi_nvs.patch should go first.

I'm sure these patches make the messages go away, but I think this is
the wrong way to fix the problem.

We mark things "busy" in the resource trees as a mutual exclusion
mechanism -- normally when a driver claims a resource and nothing else
should be allowed to touch it.

e820_reserve_resources() marks everything (except "reserved" regions)
as busy.  That probably makes sense for available RAM, since RAM is
allocated and managed via other mechanisms.  But I think it's wrong in
this case because e820 is not a driver that is using the ACPI NVS
region.

In this case, we have an ACPI NVS region, and the APEI code is
essentially a driver for some registers that reside there.  APEI is
the entity that manages those registers, and it needs to enforce
mutual exclusion so nobody else touches them behind its back, so I
think it makes sense for it to request the register regions and mark
them busy.

My proposal is to change e820 so it either leaves ACPI NVS out of the
iomem_resource tree or puts it in but leaves it non-busy.

Bjorn

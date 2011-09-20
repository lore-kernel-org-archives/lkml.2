Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317Ab1ITQ1O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 12:27:14 -0400
Received: from smtp-out.google.com ([216.239.44.51]:45555 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab1ITQ1M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 12:27:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=d9ijK4UDjRgGVLsB5cgF51ZLnUtOsqPTMaf75CeCSAjXnyC5v69fHGGujSvq+8fV6
	XXLsdTHefrOZ1RJzmgzKA==
MIME-Version: 1.0
In-Reply-To: <4E77FBA4.3080907@intel.com>
References: <1316482741-21799-1-git-send-email-ying.huang@intel.com>
 <1316482741-21799-5-git-send-email-ying.huang@intel.com> <CAErSpo4_syhxOi8jGo5oyrWBimsO7PdsXEky1vwPY_130OuPMA@mail.gmail.com>
 <4E77FBA4.3080907@intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 20 Sep 2011 10:26:49 -0600
Message-ID: <CAErSpo5pUY8g7U0NeUe+Yf+R8kraExZN3Sheo6h+fb9B+RO7rw@mail.gmail.com>
Subject: Re: [PATCH 4/8] ACPI, APEI, Resolve false conflict between ACPI NVS
 and APEI
To: Huang Ying <ying.huang@intel.com>
Cc: Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 19, 2011 at 8:34 PM, Huang Ying <ying.huang@intel.com> wrote:
> On 09/20/2011 10:09 AM, Bjorn Helgaas wrote:
>> On Mon, Sep 19, 2011 at 7:38 PM, Huang Ying <ying.huang@intel.com> wrote:
>>> Some firmware will access memory in ACPI NVS region via APEI.  That
>>> is, instructions in APEI ERST/EINJ table will read/write ACPI NVS
>>> region.  The original resource conflict checking in APEI code will
>>> check memory/ioport accessed by APEI via general resource management
>>> mech.  But ACPI NVS region is marked as busy already, so that the
>>> false resource conflict will prevent APEI ERST/EINJ to work.
>>>
>>> To fix this, this patch excludes ACPI NVS regions when APEI components
>>> request resources.  So that they will not conflict with ACPI NVS
>>> regions.
>>
>> I think this is much, much too complicated.
>>
>> Yinghai's three-line e820.c patch to leave ACPI NVS regions in the
>> iomem_resource tree, but as not busy, is far better.
>
> ACPI NVS should only be used by firmware or firmware interpreter instead
> of the ordinary drivers.  So I think that is reasonable to make it busy
> in iomem resource tree.

"My driver is not like ordinary drivers" is a common excuse for adding
special cases. I don't buy it.

These patches (3 and 4) add a lot of complexity but I don't believe
they add any real protection.

Regions are marked busy by their owners, i.e., by drivers that claim
devices and know how to operate them.  The e820 code is not an owner
of ACPI NVS regions, so it should not mark them busy.

I don't really think we have a problem here that needs to be solved.
Ordinary drivers have no way of learning an address in ACPI NVS, so
they aren't even going to try to use it.

Bjorn

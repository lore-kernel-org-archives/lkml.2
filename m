Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab1H2OtI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 10:49:08 -0400
Received: from smtp-out.google.com ([74.125.121.67]:19453 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887Ab1H2Osz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 10:48:55 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=nHU0OEgxYIU38IFvLophid5b8iNTYaG0jAHZ3RCAJXdozay5msT9td0ynIS14H1UX
	L4RjyahupBUeBVoN4msjg==
MIME-Version: 1.0
In-Reply-To: <4E5AEAF4.3000800@intel.com>
References: <CAG1a4rs4Cr1z50gGuK9SLE6aOvibE1sdV_GSLPv+gqYC8g+ORQ@mail.gmail.com>
 <CAErSpo4FfBoGDUquoLNsJ9=z-M-x6NQgP8xJL_VqEXpsL2H5PA@mail.gmail.com>
 <4E520149.3010802@intel.com> <CAG1a4rtMnDXSGLkmwE+6N9smoghWp0W4b5-X_gogzJ9fDLTeBg@mail.gmail.com>
 <4E571D66.1070302@intel.com> <CAErSpo5L1X49hfeJ69o_hwfuzMT6R+7TKhGbYCkyqtqVpf4tEw@mail.gmail.com>
 <4E5AEAF4.3000800@intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 29 Aug 2011 08:48:28 -0600
Message-ID: <CAErSpo7=SZ1XKBY0dDUg-c+_d-GoZF7uNypQc3Ecm+iofkXTMA@mail.gmail.com>
Subject: Re: APEI: Can not request iomem region for GARs
To: Huang Ying <ying.huang@intel.com>
Cc: Pavel Ivanov <paivanof@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 28, 2011 at 7:27 PM, Huang Ying <ying.huang@intel.com> wrote:
> On 08/26/2011 09:43 PM, Bjorn Helgaas wrote:
>> On Thu, Aug 25, 2011 at 10:13 PM, Huang Ying <ying.huang@intel.com> wrote:
>>> Hi, Pavel,
>>>
>>> Sorry,  there is a minor issue in the patch.  Do you have time to try
>>> the updated version attached.
>>
>> I think Yinghai's patch is a better approach (though it needs a changelog).
>>
>> The ACPI NVS space should not be marked as "busy" by the e820 code in
>> the iomem_resource tree.
>>
>> It's way too complicated to mess around with registering NVS space and
>> trying to deal with it specially in APEI.
>
> ACPI NVS is different, it can be used only by firmware, and its
> interpreter, such as ACPI AML interpreter and APEI interpreter.  It can
> not be used by ordinary driver.  If my understanding is correct, this is
> why ACPI NVS is marked as busy.

I don't understand why ACPI NVS is different.  If we reserve it in
iomem_resource (without marking it busy), it's already unavailable to
anything else unless you know something connected to the NVS region.

The only way to allocate space inside NVS is to first discover the
ACPI NVS resource, so you could pass it to request_resource() or
allocate_resource() as the "root" to allocate from.  There's no
mechanism for locating that resource, so it's already protected in
that sense.

To use request_mem_region() (which marks the region busy), you all you
need is an address.  The only way for a driver to learn an address
inside NVS is from the ACPI tables.  So I think it's effectively
limited to APEI there, too.

Bjorn

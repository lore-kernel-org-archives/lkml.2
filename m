Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039Ab1HSVtJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 17:49:09 -0400
Received: from smtp-out.google.com ([216.239.44.51]:12735 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab1HSVtH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 17:49:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=pqkK38HLkf93IPVyexnkG/NUa5o+eU5ECbLFGqMflTPxAolzKfcV+BCczNT2vEjGx
	pbjmYT1UfRFVju9Dv5yfQ==
MIME-Version: 1.0
In-Reply-To: <CAG1a4rs4Cr1z50gGuK9SLE6aOvibE1sdV_GSLPv+gqYC8g+ORQ@mail.gmail.com>
References: <CAG1a4rs4Cr1z50gGuK9SLE6aOvibE1sdV_GSLPv+gqYC8g+ORQ@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 19 Aug 2011 15:48:45 -0600
Message-ID: <CAErSpo4FfBoGDUquoLNsJ9=z-M-x6NQgP8xJL_VqEXpsL2H5PA@mail.gmail.com>
Subject: Re: APEI: Can not request iomem region for GARs
To: Pavel Ivanov <paivanof@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Huang Ying <ying.huang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 9:43 PM, Pavel Ivanov <paivanof@gmail.com> wrote:
> Ever since I switched from kernel 2.6.38 to 3.0 and later versions I
> always get the following error message on each boot:
>
> [    2.844242] APEI: Can not request iomem region
> <00000000bf7b522a-00000000bf7b522c> for GARs.
>
> If it was only in dmesg I wouldn't even notice it. But it's always
> printed on the console which is kind of annoying.
> I don't quite understand what this message is about and couldn't find
> anything on the internet. Does this message mean some error that I
> could fix? If no, is there any way I can suppress it (besides lowering
> the error level of messages printed on console, of course)?

[+cc Huang Ying, APEI author]

BIOS-e820: 00000000bf79e000 - 00000000bf7d0000 (ACPI NVS)
APEI: Can not request iomem region <00000000bf7b522a-00000000bf7b522c> for GARs.

This register is in the ACPI NVS region, which is type E820_NVS (not
E820_RESERVED), so e820_reserve_resources() reserves it as
IORESOURCE_BUSY.  My guess is that Huang tested this on machines where
the EINJ/ERST registers are in "reserved" regions, not ACPI NVS
regions.  The "reserved" regions are not marked IORESOURCE_BUSY.

Huang, when you fix this, please include something like the following
(mangled) patch so the error message is more consistent with other
resource messages.

Could you also remove the ERST/EINJ/HEST "Table is not found"
messages?  As far as I can tell, these tables are optional, and
printing the message is confusing to users, e.g.,
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/599715

Bjorn

diff --git a/drivers/acpi/apei/apei-base.c b/drivers/acpi/apei/apei-base.c
index 8041248..6f97b59 100644
--- a/drivers/acpi/apei/apei-base.c
+++ b/drivers/acpi/apei/apei-base.c
@@ -460,9 +460,9 @@ int apei_resources_request(struct apei_resources *resources,
                                       desc);
                if (!r) {
                        pr_err(APEI_PFX
-               "Can not request iomem region <%016llx-%016llx> for GARs.\n",
+               "can not request [mem %#010llx-%#010llx] for %s registers\n",
                               (unsigned long long)res->start,
-                              (unsigned long long)res->end);
+                              (unsigned long long)res->end, desc);
                        res_bak = res;
                        goto err_unmap_iomem;
                }
@@ -472,9 +472,9 @@ int apei_resources_request(struct apei_resources *resources,
                r = request_region(res->start, res->end - res->start, desc);
                if (!r) {
                        pr_err(APEI_PFX
-               "Can not request ioport region <%016llx-%016llx> for GARs.\n",
+               "can not request [io  %#06llx-%#06llx] for %s registers\n",
                               (unsigned long long)res->start,
-                              (unsigned long long)res->end);
+                              (unsigned long long)res->end, desc);
                        res_bak = res;
                        goto err_unmap_ioport;
                }

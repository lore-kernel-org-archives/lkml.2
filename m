Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab2CVVnu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 17:43:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56454 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab2CVVns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 17:43:48 -0400
Message-ID: <4F6B9D0E.2040308@canonical.com>
Date: Thu, 22 Mar 2012 17:43:42 -0400
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120313 Thunderbird/11.0
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Regression introduced in v3.2.12 stable
References: <4F6B7A37.3020300@canonical.com> <20120322212644.GA30888@kroah.com>
In-Reply-To: <20120322212644.GA30888@kroah.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 03/22/2012 05:26 PM, Greg KH wrote:
> On Thu, Mar 22, 2012 at 03:15:03PM -0400, Joseph Salisbury wrote:
>> I figured I'd send a heads up regarding a possible regression in v3.2.12
>> stable.  The issue prevents systems from booting.
>>
>> There have been a few bugs[0] reported against the Ubuntu kernel, which
>> was recently rebased to 3.2.12.  We're in the process of bisecting now
>> and will post an update..
> 
> What specifically happens here when the system does not boot?  Any error
> message?  Are you sure this isn't the known pci express issue showing up
> here?
> 
> Can you run 'git bisect' to trace it down to a specific patch please?
> 
> thanks,
> 
> greg k-h

Hi Greg,

Thanks for the response.

We did some bisecting/testing and identified the bad commit in 3.2.12 as
the following:

f043ddb60c84ea64a23b755004572afe922e653c PCI: ignore pre-1.1 ASPM
quirking when ASPM is disabled
diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 1cfbf22..24f049e 100644
- --- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -500,6 +500,9 @@ static int pcie_aspm_sanity_check(struct pci_dev *pdev)
        int pos;
        u32 reg32;

+       if (aspm_disabled)
+               return 0;
+
        /*
         * Some functions in a slot might not all be PCIe functions,
         * very strange. Disable ASPM for the whole slot


Building a test kernel with this commit reverted allows the machines to
boot.  I see there has already been some discussion on this commit[0]

Thanks,

Joe

[0] https://lkml.org/lkml/2012/3/19/408
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPa50OAAoJEGzvPSfKWxQe1owP/2esbjlmY9UsZwNTRUeH2Ujz
uNejdESt+Wj40pEvofs8xSWYLik/G7ogn9jpSBkjo0D9sgESKeQENtSRzACmy4dr
ZmLiIp46uvLhFLIokMYOle6/OZ73A9GFAkr++MqPzYV7XGWSCxxDS9ly73CBT1wy
vfZGWg9l/qDXdHmJDiJYiR+GQsno0pFJtroAdqNqDEXTRjJCWVcD03aotxXw8BWy
MxOVBQHsq61IUFPRyf7IrEOhj1myxzAdVqwuUubJ5Yvzo1/6NWY7y6CB3YJ/gtnZ
uaQ4fNdzAY2jIoKE2fBLz/fFPETW/vkb1tsh4of4Jalcsf2Whh6cPAgYeGPRNB+C
ToQ0VLiIkKKm1en+PmUQ+bOqkyh3dvIppUFiyIEX85YeuCxSOryJ9WXDcUuWNLbn
h2ru9HkSW0pctUuU+quR7tyo5mYlxgxR7Ox9oMO0i86BW6HMVeGDDc1BSZgzHYcj
WClxLysuVkXvMHG3p3wCrJpSSyLS23+S3278RnnqmxM4Xul0VCxLDLZfQG5hZB2L
sZYVwjlPphZJOoNdnRLqTdPeBjVKRM2r9nSe21naxhDXI0MbaDpzpJTDx9h1n7Pb
9D7pzeEiprUi/5/9qnwVtjuhTRdB7QwYUA6rKWBqyf0lOItDOU6n3iPqp2llx7EJ
GK6MOek8ODPzV2smclb7
=IDuC
-----END PGP SIGNATURE-----

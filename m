Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab1FODxs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 23:53:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:63166 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754245Ab1FODxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 23:53:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,368,1304319600"; 
   d="scan'208";a="13648529"
Message-ID: <4DF82CBC.5070400@intel.com>
Date: Wed, 15 Jun 2011 11:53:32 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110510 Iceowl/1.0b2 Icedove/3.1.10
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH] ACPI, APEI, Add APEI _OSC support
References: <1306303538-30524-1-git-send-email-ying.huang@intel.com> <20110614145246.GA17469@srcf.ucam.org>
In-Reply-To: <20110614145246.GA17469@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Matthew,

On 06/14/2011 10:52 PM, Matthew Garrett wrote:
> On Wed, May 25, 2011 at 02:05:38PM +0800, Huang Ying wrote:
> 
>> To gain full APEI power on these machines, a special APEI _OSC needs
>> to be evaluated to tell firmware that Linux has full APEI support.
>> This patch add the APEI _OSC support.
> 
> (snip)
> 
>> +	static DEFINE_MUTEX(mutex);
>> +	static int status = APEI_OSC_SETUP_UNKNOWN;
>> +	static u8 apei_uuid_str[] = "ed855e0c-6c90-47bf-a62a-26de0fc5ad5c";
> 
> This is the WHEA UUID, right? 

Yes.

>> +	u32 capbuf[3];
>> +	struct acpi_osc_context context = {
>> +		.uuid_str	= apei_uuid_str,
>> +		.rev		= 1,
>> +		.cap.length	= sizeof(capbuf),
>> +		.cap.pointer	= capbuf,
>> +	};
>> +
>> +	mutex_lock(&mutex);
>> +	if (status == APEI_OSC_SETUP_UNKNOWN) {
>> +		capbuf[OSC_QUERY_TYPE] = OSC_QUERY_ENABLE;
>> +		capbuf[OSC_SUPPORT_TYPE] = 0;
>> +		capbuf[OSC_CONTROL_TYPE] = 0;
>> +
>> +		if (ACPI_FAILURE(acpi_get_handle(NULL, "\\_SB", &handle))
>> +		    || ACPI_FAILURE(acpi_run_osc(handle, &context))) {
>> +			pr_err(APEI_PFX "APEI _OSC failed!\n");
>> +			status = APEI_OSC_SETUP_FAILED;
>> +		} else {
>> +			kfree(context.ret.pointer);
>> +			status = APEI_OSC_SETUP_SUCCEEDED;
>> +		}
>> +	}
>> +	mutex_unlock(&mutex);
>> +
>> +	return status == APEI_OSC_SETUP_SUCCEEDED ? 0 : -EIO;
> 
> So we fail if the platform doesn't implement WHEA...
> 
>> +	rc = apei_osc_setup();
>> +	if (rc) {
>> +		ghes_remove(ghes_dev);
>> +		return rc;
>> +	}
>> +
> 
> And then tear down GHES. This seems wrong. A platform could predicate 
> APEI functionality on the ACPI spec APEI indication (which we currently 
> don't pass) without implementing WHEA, but with this patch we'd refuse 
> to enable GHES support? We should probably try both the standard method 
> and the WHEA method and only disable GHES if both fail.

You means the "APEI Support" bit for standard UUID?  Do you know which
machine uses this bit?  I can write the code, but I have no machine to
test it.

BTW, it is better for us to enable APEI firmware first mode (that is,
what is enabled by evaluating the WHEA UUID) after GHES reporting is
ready (that is, after GHES module is successfully loaded).  That is
later than current ACPI _OSC evaluation with standard UUID.  Is it
possible to evaluate _OSC with standard UUID twice?  So that we can
enable APEI firmware first mode later.

> (Also, are there any other sideeffects of indicating that we support 
> WHEA?)

After evaluating _OSC with this UUID, firmware will produce error record
to OS, otherwise only unknown NMI.

Best Regards,
Huang Ying

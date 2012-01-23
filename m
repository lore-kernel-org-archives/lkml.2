Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab2AWUyU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 15:54:20 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:32940 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753672Ab2AWUyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 15:54:18 -0500
Message-ID: <4F1DC8A3.60901@linux.vnet.ibm.com>
Date: Mon, 23 Jan 2012 15:52:51 -0500
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110928 Fedora/3.1.15-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.15
MIME-Version: 1.0
To: Jonathan Nieder <jrnieder@gmail.com>
CC: John Hughes <john@atlantech.com>, Jeff Layton <jlayton@poochiereds.net>,
        linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Eric Paris <eparis@redhat.com>
Subject: Re: [Sony Vaio TX3] TPM chip prevents machine from suspending a second
 time
References: <20110328100846.0ba2e039@tlielax.poochiereds.net> <4D90C472.3090908@linux.vnet.ibm.com> <20110328141241.06a435f8@tlielax.poochiereds.net> <20110328154543.1bb979fd@tlielax.poochiereds.net> <4D91157F.2020502@linux.vnet.ibm.com> <20120121170157.GA18053@burratino>
In-Reply-To: <20120121170157.GA18053@burratino>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12012320-5518-0000-0000-000001BE357F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2012 12:01 PM, Jonathan Nieder wrote:
> Hi Stefan et al,
>
> John Hughes wrote[1]:
>
>> On a sony vaio tx3 when tpm_tis is loaded suspend only works once.
>
>> Well, we now could (once) probe the TPM after the resume and send a test
>> command to it and see whether it returns error code 38 and if so send
>> the TPM_Startup() from the driver -- as a work-around for your broken BIOS.
> Versions tested and found to exhibit the problem:
>
>   - Debian 2.6.35~rc6-1~experimental.1 (close to v2.6.35-rc6)
>   - Debian 2.6.36-1~experimental.1 (close to v2.6.36)
>   - Debian 2.6.37~rc5-1~experimental.3 (close to v2.6.37-rc5)
>   - Debian 2.6.37-1 (close to v2.6.37)
>   - v3.2-rc2 + Vaio keyboard fixes
>   - Debian 3.2.1-1 (close to v3.2.1)
>   - v3.3-rc1 + Vaio keyboard fixes
>
> Known problem?  Any hints for getting this to work out of the box?  (If
> there's no generic fix, maybe it would be possible to use a quirks
> table of some kind?)

Can you apply the patch below to your tpm_tis.c (or somewhere else in 
the kernel) and let me/us know what it reports in 'dmesg' upon a 
'modprobe tpm_tis'? You can cut out serial numbers and UUIDs if you 
want. I am also not sure whether it's a good idea to use DMI information 
for quirks in general, but the idea would be to have a table of systems 
with known problems, identify them using their SMBIOS information and 
only apply the work-arounds to them. As stated previously what needs to 
be sent upon resume is a TPM_Startup(ST_STATE). Even though it shouldn't 
hurt to send this command two times to the TPM in general (from BIOS and 
Linux) even on working machines I don't want to find out about side 
effects ... for sure that would be much easier and much less code...

    Stefan


---
  drivers/char/tpm/tpm_tis.c |    5 +++++
  1 file changed, 5 insertions(+)

Index: linux-2.6/drivers/char/tpm/tpm_tis.c
===================================================================
--- linux-2.6.orig/drivers/char/tpm/tpm_tis.c
+++ linux-2.6/drivers/char/tpm/tpm_tis.c
@@ -27,6 +27,7 @@
  #include <linux/wait.h>
  #include <linux/acpi.h>
  #include <linux/freezer.h>
+#include <linux/dmi.h>
  #include "tpm.h"

  enum tis_access {
@@ -535,6 +536,10 @@ static int tpm_tis_init(struct device *d

      vendor = ioread32(chip->vendor.iobase + TPM_DID_VID(0));

+    for (i = 0; i < DMI_STRING_MAX; i++)
+        dev_info(dev, "dmi: %d: %s\n",
+                 i, dmi_get_system_info(i));
+
      dev_info(dev,
           "1.2 TPM (device-id 0x%X, rev-id %d)\n",
           vendor >> 16, ioread8(chip->vendor.iobase + TPM_RID(0)));


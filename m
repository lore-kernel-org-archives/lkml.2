Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab1DDBcK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 21:32:10 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:60767 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592Ab1DDBcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 21:32:09 -0400
Date: Sun, 3 Apr 2011 18:31:50 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Dr. David Alan Gilbert" <linux@treblig.org>
Cc: linux-kernel@vger.kernel.org, joe@perches.com, segooon@gmail.com,
        randy.dunlap@oracle.com, russ.gorby@intel.com,
        akpm@linux-foundation.org
Subject: Re: Outstanding patches for errors picked up via sparse
Message-Id: <20110403183150.a49c1857.randy.dunlap@oracle.com>
In-Reply-To: <20110403231902.GB25913@gallifrey>
References: <20110403231902.GB25913@gallifrey>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4D991F8A.0103:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Apr 2011 00:19:02 +0100 Dr. David Alan Gilbert wrote:

> Hi,
>   I've been trawling through sparse logs for a few months now, and I've noticed
> that there are a few fixes for errors that have been out there for a while.
> This mail summarises those, so anyone else trawling through sparse knows not to
> bother digging.
> 
> Note that these all fix actual screwups as opposed to just removing warnings.
> 
> (It would also be nice if it gently pushed them forward into the main kernel)
> 
> Dave
> --
> 
> Fixed by Randy Dunlap 2010-06-07
> http://kerneltrap.org/mailarchive/linux-scsi/2010/6/8/6885298
> 
> minor firmware version printing problem:
> 
> drivers/scsi/megaraid.c:313:65: warning: right shift by bigger than source value
> drivers/scsi/megaraid.c:315:65: warning: right shift by bigger than source value
> drivers/scsi/megaraid.c:319:67: warning: right shift by bigger than source value
> drivers/scsi/megaraid.c:321:67: warning: right shift by bigger than source value
> 
>                          adapter->product_info.fw_version[1] >> 8,
>                          adapter->product_info.fw_version[1] & 0x0f,
>                          adapter->product_info.fw_version[0] >> 8,
>                          adapter->product_info.fw_version[0] & 0x0f);
>                 sprintf (adapter->bios_version, "%c%d%d.%d%d",
>                          adapter->product_info.bios_version[2],
>                          adapter->product_info.bios_version[1] >> 8,
>                          adapter->product_info.bios_version[1] & 0x0f,
>                          adapter->product_info.bios_version[0] >> 8,
>                          adapter->product_info.bios_version[0] & 0x0f);
> 
> yet megaraid.h has:
>         u8      fw_version[16];         /* printable ASCI string */
>         u8      bios_version[16];       /* printable ASCI string */
> 
> Although you do have to wonder if the comment is right there then maybe the sprintf
> is more wrong than the fix fixes.
> 
> --

Here is an updated version of that patch:

---

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix sparse warnings of right shift bigger than source value size:

drivers/scsi/megaraid.c:311:65: warning: right shift by bigger than source value
drivers/scsi/megaraid.c:313:65: warning: right shift by bigger than source value
drivers/scsi/megaraid.c:317:67: warning: right shift by bigger than source value
drivers/scsi/megaraid.c:319:67: warning: right shift by bigger than source value

Patch suggestion from email by Al Viro:

"Since both are claimed to be strings, I really suspect that this >> 8 is
misspelled >> 4 and they have a character followed by pair of two-digit
packed decimals in there..."

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>
---
 drivers/scsi/megaraid.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-2.6.35-rc2.orig/drivers/scsi/megaraid.c
+++ linux-2.6.35-rc2/drivers/scsi/megaraid.c
@@ -308,15 +308,15 @@ mega_query_adapter(adapter_t *adapter)
 	if (adapter->product_info.subsysvid == HP_SUBSYS_VID) {
 		sprintf (adapter->fw_version, "%c%d%d.%d%d",
 			 adapter->product_info.fw_version[2],
-			 adapter->product_info.fw_version[1] >> 8,
+			 adapter->product_info.fw_version[1] >> 4,
 			 adapter->product_info.fw_version[1] & 0x0f,
-			 adapter->product_info.fw_version[0] >> 8,
+			 adapter->product_info.fw_version[0] >> 4,
 			 adapter->product_info.fw_version[0] & 0x0f);
 		sprintf (adapter->bios_version, "%c%d%d.%d%d",
 			 adapter->product_info.bios_version[2],
-			 adapter->product_info.bios_version[1] >> 8,
+			 adapter->product_info.bios_version[1] >> 4,
 			 adapter->product_info.bios_version[1] & 0x0f,
-			 adapter->product_info.bios_version[0] >> 8,
+			 adapter->product_info.bios_version[0] >> 4,
 			 adapter->product_info.bios_version[0] & 0x0f);
 	} else {
 		memcpy(adapter->fw_version,

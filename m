Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab2APXuL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 18:50:11 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:50871 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab2APXuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 18:50:08 -0500
Message-ID: <4F14B7AC.9090708@linux.vnet.ibm.com>
Date: Mon, 16 Jan 2012 18:50:04 -0500
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110928 Fedora/3.1.15-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.15
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Subject: Re: [Regression] Commit "tpm: Introduce function to poll for result
 of self test" breaks suspend
References: <201201160022.07176.rjw@sisk.pl> <201201162305.15662.rjw@sisk.pl> <4F14A7F8.8000004@linux.vnet.ibm.com> <201201162350.02165.rjw@sisk.pl>
In-Reply-To: <201201162350.02165.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12011623-4242-0000-0000-000000833CF8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2012 05:50 PM, Rafael J. Wysocki wrote:
> On Monday, January 16, 2012, Stefan Berger wrote:
>> On 01/16/2012 05:05 PM, Rafael J. Wysocki wrote:
> Yes, there are.  Below is the result of grepping tpm in dmesg output (the
> entire dmesg log from that box is attached).
>
> [    5.066807] tpm_tis 00:0a: 1.2 TPM (device-id 0xB, rev-id 16)
> [    7.167236] tpm_tis 00:0a: Adjusting TPM timeout parameters.
> [    7.893190] tpm_tis 00:0a: A TPM error (7) occurred attempting to read a pcr value
> [    7.897202] tpm_tis 00:0a: TPM self test failed
> [    7.907599] tpm_inf_pnp 00:0a: Found TPM with ID IFX0102
> [    7.909745] tpm_inf_pnp 00:0a: TPM found: config base 0x4e, data base 0x680, chip version 0x000b, vendor id 0x15d1 (Infineon), product id 0x000b (SLB 9635 TT 1.2)
> [   96.386200] tpm_inf_pnp 00:0a: saving TPM state
> [   96.407630] tpm_inf_pnp 00:0a: Timeout while clearing FIFO
> [   96.407634] tpm_inf_pnp 00:0a: error while saving TPM state
>
> Thanks,
> Rafael
If possible, I'd like the patch to stick a little longer. Can you try 
the following and tell me whether this solves the problem with the 
suspend/resume.

This patch handles the error codes reading of a PCR may cause when a TPM 
is disabled and/or deactivated. They would not be a reason for the 
tpm_do_selftest function to fail.

Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>

---
  drivers/char/tpm/tpm.c |    9 +++++++++
  drivers/char/tpm/tpm.h |    3 +++
  2 files changed, 12 insertions(+)

Index: linux-2.6/drivers/char/tpm/tpm.c
===================================================================
--- linux-2.6.orig/drivers/char/tpm/tpm.c
+++ linux-2.6/drivers/char/tpm/tpm.c
@@ -846,6 +846,15 @@ int tpm_do_selftest(struct tpm_chip *chi

      do {
          rc = __tpm_pcr_read(chip, 0, digest);
+        if (rc == TPM_ERR_DISABLED || rc == TPM_ERR_DEACTIVATED) {
+            dev_info(chip->dev,
+                 "TPM is disabled/deactivated (0x%X)\n", rc);
+            /* TPM is disabled and/or deactivated; driver can proceed
+             * and TPM does handle commands during suspend/resume
+             */
+            rc = 0;
+            break;
+        }
          if (rc != TPM_WARN_DOING_SELFTEST)
              return rc;
          msleep(delay_msec);
Index: linux-2.6/drivers/char/tpm/tpm.h
===================================================================
--- linux-2.6.orig/drivers/char/tpm/tpm.h
+++ linux-2.6/drivers/char/tpm/tpm.h
@@ -39,6 +39,9 @@ enum tpm_addr {
  };

  #define TPM_WARN_DOING_SELFTEST 0x802
+#define TPM_ERR_DEACTIVATED     0x6
+#define TPM_ERR_DISABLED        0x7
+
  #define TPM_HEADER_SIZE        10
  extern ssize_t tpm_show_pubek(struct device *, struct device_attribute 
*attr,
                  char *);


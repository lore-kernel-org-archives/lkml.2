Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030224Ab2KUVPc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 16:15:32 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:48617 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964856Ab2KUVPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 16:15:30 -0500
Date: Wed, 21 Nov 2012 14:15:29 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
Subject: [PATCH] TPM: Work around buggy TPMs that block during continue self
 test
Message-ID: <20121121211529.GA27696@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've been testing an alternative TPM for our embedded products and
found random kernel boot failures due to time outs after the continue
self test command.

This was happening randomly, and has been *very* hard to track down, but it
looks like with this chip there is some kind of race with the tpm_tis_status()
check of TPM_STS_COMMAND_READY. If things get there 'too fast' then
it sees the chip is ready, or tpm_tis_ready() works. Otherwise it takes
somewhere over 400ms before the chip will return TPM_STS_COMMAND_READY.

Adding some delay after tpm_continue_selftest() makes things reliably
hit the failure path, otherwise it is a crapshot.

The spec says it should be returning TPM_WARN_DOING_SELFTEST, not holding
off on ready..

Boot log during this event looks like this:

tpm_tis 70030000.tpm_tis: 1.2 TPM (device-id 0x3204, rev-id 64)
tpm_tis 70030000.tpm_tis: Issuing TPM_STARTUP
tpm_tis 70030000.tpm_tis: tpm_transmit: tpm_send: error -62
tpm_tis 70030000.tpm_tis: [Hardware Error]: TPM command timed out during continue self test
tpm_tis 70030000.tpm_tis: tpm_transmit: tpm_send: error -62
tpm_tis 70030000.tpm_tis: [Hardware Error]: TPM command timed out during continue self test
tpm_tis 70030000.tpm_tis: tpm_transmit: tpm_send: error -62
tpm_tis 70030000.tpm_tis: [Hardware Error]: TPM command timed out during continue self test
tpm_tis 70030000.tpm_tis: tpm_transmit: tpm_send: error -62
tpm_tis 70030000.tpm_tis: [Hardware Error]: TPM command timed out during continue self test

The other TPM vendor we use doesn't show this wonky behaviour:
tpm_tis 70030000.tpm_tis: 1.2 TPM (device-id 0xFE, rev-id 70)

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 drivers/char/tpm/tpm.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index 454e032..61d62c2 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -857,7 +857,7 @@ int tpm_do_selftest(struct tpm_chip *chip)
 {
 	int rc;
 	unsigned int loops;
-	unsigned int delay_msec = 1000;
+	unsigned int delay_msec = 100;
 	unsigned long duration;
 	struct tpm_cmd_t cmd;
 
@@ -878,6 +878,14 @@ int tpm_do_selftest(struct tpm_chip *chip)
 		cmd.header.in = pcrread_header;
 		cmd.params.pcrread_in.pcr_idx = cpu_to_be32(0);
 		rc = tpm_transmit(chip, (u8 *) &cmd, READ_PCR_RESULT_SIZE);
+		/* Some buggy TPMs will not respond to tpm_tis_ready() for
+		 * around 300ms while the self test is ongoing, keep trying
+		 * until the self test duration expires. */
+		if (rc == -ETIME) {
+			dev_info(chip->dev, HW_ERR "TPM command timed out during continue self test");
+			msleep(delay_msec);
+			continue;
+		}
 
 		if (rc < TPM_HEADER_SIZE)
 			return -EFAULT;
-- 
1.7.5.4


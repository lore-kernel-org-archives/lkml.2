Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab0IES7k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 14:59:40 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:35486 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754754Ab0IES7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 14:59:38 -0400
From: Julia Lawall <julia@diku.dk>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: kernel-janitors@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] drivers/staging/comedi/drivers: Fix unsigned return type
Date: Sun,  5 Sep 2010 21:00:24 +0200
Message-Id: <1283713226-8429-7-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283713226-8429-1-git-send-email-julia@diku.dk>
References: <1283713226-8429-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In each case, the function has an unsigned return type, but returns a
negative constant to indicate an error condition.  For move_block_from_dma,
there is only one call and the return value is dropped, so it need not be
unsigned.  For labpc_eeprom_write, there is only one call and the result is
stored in a signed variable, so again the unsigned return type is not
necessary.

A sematic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@exists@
identifier f;
constant C;
@@

 unsigned f(...)
 { <+...
*  return -C;
 ...+> }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/staging/comedi/drivers/adl_pci9118.c |    2 +-
 drivers/staging/comedi/drivers/ni_labpc.c    |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci9118.c b/drivers/staging/comedi/drivers/adl_pci9118.c
index a2bd4e6..cb2843d 100644
--- a/drivers/staging/comedi/drivers/adl_pci9118.c
+++ b/drivers/staging/comedi/drivers/adl_pci9118.c
@@ -634,7 +634,7 @@ static unsigned int defragment_dma_buffer(struct comedi_device *dev,
 /*
 ==============================================================================
 */
-static unsigned int move_block_from_dma(struct comedi_device *dev,
+static int move_block_from_dma(struct comedi_device *dev,
 					struct comedi_subdevice *s,
 					short *dma_buffer,
 					unsigned int num_samples)
diff --git a/drivers/staging/comedi/drivers/ni_labpc.c b/drivers/staging/comedi/drivers/ni_labpc.c
index 3acf7e6..19f79e8 100644
--- a/drivers/staging/comedi/drivers/ni_labpc.c
+++ b/drivers/staging/comedi/drivers/ni_labpc.c
@@ -250,7 +250,7 @@ static unsigned int labpc_serial_in(struct comedi_device *dev);
 static unsigned int labpc_eeprom_read(struct comedi_device *dev,
 				      unsigned int address);
 static unsigned int labpc_eeprom_read_status(struct comedi_device *dev);
-static unsigned int labpc_eeprom_write(struct comedi_device *dev,
+static int labpc_eeprom_write(struct comedi_device *dev,
 				       unsigned int address,
 				       unsigned int value);
 static void write_caldac(struct comedi_device *dev, unsigned int channel,
@@ -1986,8 +1986,8 @@ static unsigned int labpc_eeprom_read(struct comedi_device *dev,
 	return value;
 }
 
-static unsigned int labpc_eeprom_write(struct comedi_device *dev,
-				       unsigned int address, unsigned int value)
+static int labpc_eeprom_write(struct comedi_device *dev,
+				unsigned int address, unsigned int value)
 {
 	const int write_enable_instruction = 0x6;
 	const int write_instruction = 0x2;


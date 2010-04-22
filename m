Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483Ab0DVTqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:46:15 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:35191 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757471Ab0DVTqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:46:11 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 22 Apr 2010 21:45:23 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [git pull] FireWire fixes
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
In-Reply-To: <tkrat.66ea5df34ac46da2@s5r6.in-berlin.de>
Message-ID: <tkrat.3d2fe2cc743832f1@s5r6.in-berlin.de>
References: <tkrat.671196999e56464f@s5r6.in-berlin.de>
 <tkrat.e3130c87f5d2851a@s5r6.in-berlin.de>
 <tkrat.66ea5df34ac46da2@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive some more IEEE 1394/ FireWire subsystem fixes.
Thanks.

Clemens Ladisch (4):
      firewire: core: fix retries calculation in iso manage_channel()
      firewire: core: fw_iso_resource_manage: return -EBUSY when out of resources
      firewire: ohci: prevent aliasing of locally handled register addresses
      firewire: ohci: wait for local CSR lock access to finish

Stefan Richter (1):
      firewire: cdev: fix cut+paste mistake in disclaimer

 drivers/firewire/core-iso.c        |   14 ++++++++++----
 drivers/firewire/ohci.c            |   23 ++++++++++++++---------
 include/linux/firewire-cdev.h      |    2 +-
 include/linux/firewire-constants.h |    2 +-
 4 files changed, 26 insertions(+), 15 deletions(-)


Full log and diff:

commit e1393667be574807a13bfaf1bb471f5fd1a5287b
Author: Clemens Ladisch <clemens@ladisch.de>
Date:   Mon Apr 12 10:35:44 2010 +0200

    firewire: ohci: wait for local CSR lock access to finish
    
    Add a loop to wait for the controller to finish a locally-initiated CSR
    lock operation.  Google shows some occurrences of the "swap not done
    yet" message which might indicate that some OHCI controllers are not
    fast enough to do the lock/swap in the time needed for one PCI access.
    
    This also correctly handles the case where the lock operation did not
    finish, instead of silently returning an uninitialized value.
    
    Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/ohci.c |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 82fb2e7..6e95f8f 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -1158,7 +1158,7 @@ static void handle_local_lock(struct fw_ohci *ohci,
 			      struct fw_packet *packet, u32 csr)
 {
 	struct fw_packet response;
-	int tcode, length, ext_tcode, sel;
+	int tcode, length, ext_tcode, sel, try;
 	__be32 *payload, lock_old;
 	u32 lock_arg, lock_data;
 
@@ -1185,13 +1185,19 @@ static void handle_local_lock(struct fw_ohci *ohci,
 	reg_write(ohci, OHCI1394_CSRCompareData, lock_arg);
 	reg_write(ohci, OHCI1394_CSRControl, sel);
 
-	if (reg_read(ohci, OHCI1394_CSRControl) & 0x80000000)
-		lock_old = cpu_to_be32(reg_read(ohci, OHCI1394_CSRData));
-	else
-		fw_notify("swap not done yet\n");
+	for (try = 0; try < 20; try++)
+		if (reg_read(ohci, OHCI1394_CSRControl) & 0x80000000) {
+			lock_old = cpu_to_be32(reg_read(ohci,
+							OHCI1394_CSRData));
+			fw_fill_response(&response, packet->header,
+					 RCODE_COMPLETE,
+					 &lock_old, sizeof(lock_old));
+			goto out;
+		}
+
+	fw_error("swap not done (CSR lock timeout)\n");
+	fw_fill_response(&response, packet->header, RCODE_BUSY, NULL, 0);
 
-	fw_fill_response(&response, packet->header,
-			 RCODE_COMPLETE, &lock_old, sizeof(lock_old));
  out:
 	fw_core_handle_response(&ohci->card, &response);
 }

commit 2608203daf5f87311c6e5d36e5de5efcb14aab24
Author: Clemens Ladisch <clemens@ladisch.de>
Date:   Mon Apr 12 10:35:30 2010 +0200

    firewire: ohci: prevent aliasing of locally handled register addresses
    
    We must compute the offset from the CSR register base with the
    full 48 address bits to prevent matching with addresses whose
    lower 32 bits happen to be equal with one of the specially
    handled registers.
    
    Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/ohci.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index e33917b..82fb2e7 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -1198,8 +1198,7 @@ static void handle_local_lock(struct fw_ohci *ohci,
 
 static void handle_local_request(struct context *ctx, struct fw_packet *packet)
 {
-	u64 offset;
-	u32 csr;
+	u64 offset, csr;
 
 	if (ctx == &ctx->ohci->at_request_ctx) {
 		packet->ack = ACK_PENDING;

commit d6372b6e7c6142e6cc2108b3b850584cd7ade106
Author: Clemens Ladisch <clemens@ladisch.de>
Date:   Mon Apr 12 10:35:18 2010 +0200

    firewire: core: fw_iso_resource_manage: return -EBUSY when out of resources
    
    Returning -EIO for all errors would not allow clients to determine if
    the resource allocation process itself failed, or if the resources are
    not available.  (The latter information is needed by CMP to synchronize
    restoring of overlayed connections after a bus reset.)
    
    Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-iso.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/firewire/core-iso.c b/drivers/firewire/core-iso.c
index 34a5137..9198e03 100644
--- a/drivers/firewire/core-iso.c
+++ b/drivers/firewire/core-iso.c
@@ -189,7 +189,7 @@ static int manage_bandwidth(struct fw_card *card, int irm_id, int generation,
 	for (try = 0; try < 5; try++) {
 		new = allocate ? old - bandwidth : old + bandwidth;
 		if (new < 0 || new > BANDWIDTH_AVAILABLE_INITIAL)
-			break;
+			return -EBUSY;
 
 		data[0] = cpu_to_be32(old);
 		data[1] = cpu_to_be32(new);
@@ -217,7 +217,7 @@ static int manage_channel(struct fw_card *card, int irm_id, int generation,
 		u32 channels_mask, u64 offset, bool allocate, __be32 data[2])
 {
 	__be32 c, all, old;
-	int i, retry = 5;
+	int i, ret = -EIO, retry = 5;
 
 	old = all = allocate ? cpu_to_be32(~0) : 0;
 
@@ -225,6 +225,8 @@ static int manage_channel(struct fw_card *card, int irm_id, int generation,
 		if (!(channels_mask & 1 << i))
 			continue;
 
+		ret = -EBUSY;
+
 		c = cpu_to_be32(1 << (31 - i));
 		if ((old & c) != (all & c))
 			continue;
@@ -253,11 +255,13 @@ static int manage_channel(struct fw_card *card, int irm_id, int generation,
 			if (retry) {
 				retry--;
 				i--;
+			} else {
+				ret = -EIO;
 			}
 		}
 	}
 
-	return -EIO;
+	return ret;
 }
 
 static void deallocate_channel(struct fw_card *card, int irm_id,

commit 3a1f0a0e3d871e3d3e08a1429009992151becda8
Author: Clemens Ladisch <clemens@ladisch.de>
Date:   Mon Apr 12 10:35:05 2010 +0200

    firewire: core: fix retries calculation in iso manage_channel()
    
    If there is a permanent error condition when communicating with the IRM,
    after the sixth error, the retry variable will be decremented to -1.
    If, in this case, the bits in channels_mask are not yet exhausted, the
    next channel is retried 2^32 times.
    
    To fix this, check that retry is never decremented beyond zero.
    
    Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-iso.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/firewire/core-iso.c b/drivers/firewire/core-iso.c
index 99c20f1..34a5137 100644
--- a/drivers/firewire/core-iso.c
+++ b/drivers/firewire/core-iso.c
@@ -250,8 +250,10 @@ static int manage_channel(struct fw_card *card, int irm_id, int generation,
 
 			/* 1394-1995 IRM, fall through to retry. */
 		default:
-			if (retry--)
+			if (retry) {
+				retry--;
 				i--;
+			}
 		}
 	}
 

commit a2612cb16d4d8447793609cbdd2a2f4f156c0020
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Thu Apr 15 22:16:04 2010 +0200

    firewire: cdev: fix cut+paste mistake in disclaimer
    
    This was supposed to be generic "authors or copyright holders";
    I mistakenly picked up text from a wrong file.
    
    Reported-by: Daniel K. <dk@uw.no>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 include/linux/firewire-cdev.h      |    2 +-
 include/linux/firewire-constants.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/firewire-cdev.h b/include/linux/firewire-cdev.h
index 81f3b14..68f883b 100644
--- a/include/linux/firewire-cdev.h
+++ b/include/linux/firewire-cdev.h
@@ -17,7 +17,7 @@
  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
- * PRECISION INSIGHT AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
  * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
  * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
  * DEALINGS IN THE SOFTWARE.
diff --git a/include/linux/firewire-constants.h b/include/linux/firewire-constants.h
index 9c63f06..9b4bb5f 100644
--- a/include/linux/firewire-constants.h
+++ b/include/linux/firewire-constants.h
@@ -17,7 +17,7 @@
  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
- * PRECISION INSIGHT AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
  * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
  * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
  * DEALINGS IN THE SOFTWARE.

-- 
Stefan Richter
-=====-==-=- -=-- =-==-
http://arcgraph.de/sr/


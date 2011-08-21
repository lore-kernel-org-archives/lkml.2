Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700Ab1HURcT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 13:32:19 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:54289 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092Ab1HURcQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 13:32:16 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 21 Aug 2011 19:31:55 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: [git pull] FireWire fix
Message-ID: <20110821193155.3b3ccfeb@stein>
In-Reply-To: <20110815160131.063f453d@stein>
References: <20110815160131.063f453d@stein>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the fixes branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git fixes

to receive a quirk handling update to the IEEE 1394 (FireWire) subsystem
for some old first-generation i.LINK enabled camcorders.

This is not a complete solution yet, but a valid improvement on its own
and suitable to be merged this late in the -rc phase.  It is undecided
yet whether the rest of the solution is going to be a more intrusive but
general change to firewire-core transaction layer or a small but less
general adjustment in userspace (libavc1394 and libiec61883).

Stefan Richter (1):
      firewire: core: handle ack_busy when fetching the Config ROM

 drivers/firewire/core-device.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)


commit aaff12039ffd812d0c8bbff50b87b6f1f09bec3e
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sun Aug 7 15:20:18 2011 +0200

    firewire: core: handle ack_busy when fetching the Config ROM
    
    Some older Panasonic made camcorders (Panasonic AG-EZ30 and NV-DX110,
    Grundig Scenos DLC 2000) reject requests with ack_busy_X if a request is
    sent immediately after they sent a response to a prior transaction.
    This causes firewire-core to fail probing of the camcorder with "giving
    up on config rom for node id ...".  Consequently, programs like kino or
    dvgrab are unaware of the presence of a camcorder.
    
    Such transaction failures happen also with the ieee1394 driver stack
    (of the 2.4...2.6 kernel series until 2.6.36 inclusive) but with a lower
    likelihood, such that kino or dvgrab are generally able to use these
    camcorders via the older driver stack.  The cause for firewire-ohci's or
    firewire-core's worse behavior is not yet known.  Gap count optimization
    in firewire-core is not the cause.  Perhaps the slightly higher latency
    of transaction completion in the older stack plays a role.  (ieee1394:
    AR-resp DMA context tasklet -> packet completion ktread -> user process;
    firewire-core: tasklet -> user process.)
    
    This change introduces retries and delays after ack_busy_X into
    firewire-core's Config ROM reader, such that at least firewire-core's
    probing and /dev/fw* creation are successful.  This still leaves the
    problem that userland processes are facing transaction failures.
    gscanbus's built-in retry routines deal with them successfully, but
    neither kino's nor dvgrab's do ever succeed.
    
    But at least DV capture with "dvgrab -noavc -card 0" works now.  Live
    video preview in kino works too, but not actual capture.
    
    One way to prevent Configuration ROM reading failures in application
    programs is to modify libraw1394 to synthesize read responses by means
    of firewire-core's Configuration ROM cache.  This would only leave
    CMP and FCP transaction failures as a potential problem source for
    applications.
    
    Reported-and-tested-by: Thomas Seilund <tps@netmaster.dk>
    Reported-and-tested-by: René Fritz <rene@colorcube.de>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/core-device.c b/drivers/firewire/core-device.c
index 95a4714..9f661e0 100644
--- a/drivers/firewire/core-device.c
+++ b/drivers/firewire/core-device.c
@@ -455,15 +455,20 @@ static struct device_attribute fw_device_attributes[] = {
 static int read_rom(struct fw_device *device,
 		    int generation, int index, u32 *data)
 {
-	int rcode;
+	u64 offset = (CSR_REGISTER_BASE | CSR_CONFIG_ROM) + index * 4;
+	int i, rcode;
 
 	/* device->node_id, accessed below, must not be older than generation */
 	smp_rmb();
 
-	rcode = fw_run_transaction(device->card, TCODE_READ_QUADLET_REQUEST,
-			device->node_id, generation, device->max_speed,
-			(CSR_REGISTER_BASE | CSR_CONFIG_ROM) + index * 4,
-			data, 4);
+	for (i = 10; i < 100; i += 10) {
+		rcode = fw_run_transaction(device->card,
+				TCODE_READ_QUADLET_REQUEST, device->node_id,
+				generation, device->max_speed, offset, data, 4);
+		if (rcode != RCODE_BUSY)
+			break;
+		msleep(i);
+	}
 	be32_to_cpus(data);
 
 	return rcode;

-- 
Stefan Richter
-=====-==-== =--- =-=-=
http://arcgraph.de/sr/

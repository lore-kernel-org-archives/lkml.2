Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031116Ab2I1TWI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:22:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45270 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030558Ab2I1TEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:04:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <deathsimple@vodafone.de>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: =?UTF-8?q?=5B=20203/262=5D=20drm/radeon=3A=20make=2064bit=20fences=20more=20robust=20v3?=
Date: Fri, 28 Sep 2012 11:52:12 -0700
Message-Id: <20120928183022.069383134@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <deathsimple@vodafone.de>

commit f492c171a38d77fc13a8998a0721f2da50835224 upstream.

Only increase the higher 32bits if we really detect a wrap around.

v2: instead of increasing the higher 32bits just use the higher
    32bits from the last emitted fence.
v3: also use last emitted fence value as upper limit.

The intention of this patch is to make fences as robust as
they where before introducing 64bit fences. This is
necessary because on older systems it looks like the fence
value gets corrupted on initialization.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=51344

Should also fix:
https://bugs.freedesktop.org/show_bug.cgi?id=54129
https://bugs.freedesktop.org/show_bug.cgi?id=54662
https://bugzilla.redhat.com/show_bug.cgi?id=846505
https://bugzilla.redhat.com/show_bug.cgi?id=845639

3.5 needs a separate patch due to changes in the
fence code.  Will send that out separately.

Signed-off-by: Christian König <deathsimple@vodafone.de>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/gpu/drm/radeon/radeon_fence.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_fence.c
+++ b/drivers/gpu/drm/radeon/radeon_fence.c
@@ -75,7 +75,7 @@ int radeon_fence_emit(struct radeon_devi
 
 void radeon_fence_process(struct radeon_device *rdev, int ring)
 {
-	uint64_t seq, last_seq;
+	uint64_t seq, last_seq, last_emitted;
 	unsigned count_loop = 0;
 	bool wake = false;
 
@@ -102,13 +102,15 @@ void radeon_fence_process(struct radeon_
 	 */
 	last_seq = atomic64_read(&rdev->fence_drv[ring].last_seq);
 	do {
+		last_emitted = rdev->fence_drv[ring].seq;
 		seq = radeon_fence_read(rdev, ring);
 		seq |= last_seq & 0xffffffff00000000LL;
 		if (seq < last_seq) {
-			seq += 0x100000000LL;
+			seq &= 0xffffffff;
+			seq |= last_emitted & 0xffffffff00000000LL;
 		}
 
-		if (seq == last_seq) {
+		if (seq <= last_seq || seq > last_emitted) {
 			break;
 		}
 		/* If we loop over we don't want to return without



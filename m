Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab0JEPVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 11:21:17 -0400
Received: from smtp207.alice.it ([82.57.200.103]:47372 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754157Ab0JEPVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 11:21:13 -0400
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-input@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>, Jiri Kosina <jkosina@suse.cz>,
        Alan Ott <alan@signal11.us>, Oliver Neukum <oliver@neukum.name>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH 2/2] HID: hidraw, fix a NULL pointer dereference in hidraw_write
Date: Tue,  5 Oct 2010 17:20:17 +0200
Message-Id: <1286292017-6746-3-git-send-email-ospite@studenti.unina.it>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <alpine.LNX.2.00.1010041548580.29535@pobox.suse.cz>
References: <alpine.LNX.2.00.1010041548580.29535@pobox.suse.cz>
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+ ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
IP: [<ffffffffa0f0a625>] hidraw_write+0x3b/0x116 [hid]
[...]

This is reproducible by disconnecting the device while userspace writes
to dev node in a loop and doesn't check return values in order to exit
the loop, like in the following test program:

int main(int argc, char *argv[])
{
	int fd = -1;
	unsigned char report[2] = {0x01, 0x00};
	int ret;

	if (argc != 2) {
		fprintf(stderr, "usage: %s </dev/hidrawX>\n", argv[0]);
		exit(1);
	}

	fd = open(argv[1], O_RDWR);
	if (fd < 0) {
		perror("hidraw open");
		exit(1);
	}

	while (1) {
		ret = write(fd, report, sizeof(report));
		printf("ret: %d\n", ret);
	}

	close(fd);
	exit(0);
}

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---
 drivers/hid/hidraw.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index 9eaf6ae..a3866b5 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -109,6 +109,12 @@ static ssize_t hidraw_write(struct file *file, const char __user *buffer, size_t
 	int ret = 0;
 
 	mutex_lock(&minors_lock);
+
+	if (!hidraw_table[minor]) {
+		ret = -ENODEV;
+		goto out;
+	}
+
 	dev = hidraw_table[minor]->hid;
 
 	if (!dev->hid_output_raw_report) {
-- 
1.7.1


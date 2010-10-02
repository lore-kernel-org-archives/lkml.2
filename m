Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228Ab0JBLZu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 07:25:50 -0400
Received: from smtp205.alice.it ([82.57.200.101]:45474 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754952Ab0JBLZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 07:25:49 -0400
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-input@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>, Jiri Kosina <jkosina@suse.cz>,
        Alan Ott <alan@signal11.us>, Oliver Neukum <oliver@neukum.name>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] HID: hidraw, fix a NULL pointer dereference in hidraw_ioctl
Date: Sat,  2 Oct 2010 13:25:24 +0200
Message-Id: <1286018724-7484-1-git-send-email-ospite@studenti.unina.it>
X-Mailer: git-send-email 1.7.1
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+ ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
IP: [<ffffffffa02c66b4>] hidraw_ioctl+0xfc/0x32c [hid]
[...]

This is reproducible by disconnecting the device while userspace does ioctl in
a loop and doesn't check return values in order to exit the loop, like in the
following test program:

int main(int argc, char *argv[])
{
	int fd = -1;
	unsigned char name[256];
	int ret;

	if (argc != 2) {
		fprintf(stderr, "usage: %s </dev/hidrawX>\n",
				argv[0]);
		exit(1);
	}

	fd = open(argv[1], O_RDWR);
	if (fd < 0) {
		perror("hidraw open");
		exit(1);
	}

	while (1) {
		ret = ioctl(fd, HIDIOCGRAWNAME(256), name);
		printf("ret: %d name: %s\n", ret, name);
	}

	close(fd);
	exit(0);
}

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---
Should this be applied to older stable kernels too?

Alan, Jiri,

there is a similar problem when _writing_ to the device, but Alan's
changes in that area are shuffling the code a bit, should I send a patch
[to hidraw_send_report()] on top of Alan's work for that, or a fix for
current mainline [in hidraw_write()] on which Alan should rebase his
work would be better?

The same pattern of unchecked hidraw_table[minor] is also present in
hidraw_get_report but this function is called only after the NULL check
in hidraw_ioctl _for_now_, so that is currently safe.

Thanks,
   Antonio Ospite
   http://ao2.it

 drivers/hid/hidraw.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index 47d70c5..9eaf6ae 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -244,6 +244,10 @@ static long hidraw_ioctl(struct file *file, unsigned int cmd,
 
 	mutex_lock(&minors_lock);
 	dev = hidraw_table[minor];
+	if (!dev) {
+		ret = -ENODEV;
+		goto out;
+	}
 
 	switch (cmd) {
 		case HIDIOCGRDESCSIZE:
@@ -317,6 +321,7 @@ static long hidraw_ioctl(struct file *file, unsigned int cmd,
 
 		ret = -ENOTTY;
 	}
+out:
 	mutex_unlock(&minors_lock);
 	return ret;
 }
-- 
1.7.1


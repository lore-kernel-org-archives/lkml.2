Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab1KEAya (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 20:54:30 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53901 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205Ab1KEAy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 20:54:29 -0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Beregalov <a.beregalov@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>, stable@kernel.org
Subject: [PATCH] hwmon: (w83627ehf): fix broken driver init
Date: Sat,  5 Nov 2011 04:54:10 +0400
Message-Id: <1320454450-738-1-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.7.7.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 2265cef2 (hwmon: (w83627ehf) Properly report PECI and AMD-SI
sensor types) results in kernel panic if data->temp_label was not
initialized.
The problem was found with chip W83627DHG-P.

backtrace:
page_fault()
w83627ehf_probe() 0x8e2

w83627ehf_init_device:
1837:	for (i = 0; i < 3; i++) {
		const char *label = data->temp_label[data->temp_src[i]];

		/* Digital source overrides analog type */
		if (strncmp(label, "PECI", 4) == 0)
			data->temp_type[i] = 6;

	movzbl	128(%r14), %edx	# data->temp_src, tmp737
	movq	144(%r13), %rax	# data_32->temp_label, data_32->temp_label
	movq	$.LC18, %rsi	#,
	movl	%r14d, %r15d	#, i
	subl	%r13d, %r15d	# D.29277, i
0x928	movq	(%rax,%rdx,8), %rcx	#* data_32->temp_label, label
	movl	$4, %edx	#,
	movq	%rcx, %rdi	# label,
	movq	%rcx, -96(%rbp)	#,
	call	strncmp	#

page_fault() is called at 0x928 (0x8e2+0x46).

Add check if data->temp->label was set before use.

Cc: Jean Delvare <khali@linux-fr.org>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: stable@kernel.org
Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 drivers/hwmon/w83627ehf.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/hwmon/w83627ehf.c b/drivers/hwmon/w83627ehf.c
index 483cb26..70f1c73 100644
--- a/drivers/hwmon/w83627ehf.c
+++ b/drivers/hwmon/w83627ehf.c
@@ -1835,14 +1835,15 @@ static inline void __devinit w83627ehf_init_device(struct w83627ehf_data *data,
 		diode = 0x70;
 	}
 	for (i = 0; i < 3; i++) {
-		const char *label = data->temp_label[data->temp_src[i]];
-
-		/* Digital source overrides analog type */
-		if (strncmp(label, "PECI", 4) == 0)
-			data->temp_type[i] = 6;
-		else if (strncmp(label, "AMD", 3) == 0)
-			data->temp_type[i] = 5;
-		else if ((tmp & (0x02 << i)))
+		if (data->temp_label) {
+			const char *label = data->temp_label[data->temp_src[i]];
+
+			/* Digital source overrides analog type */
+			if (strncmp(label, "PECI", 4) == 0)
+				data->temp_type[i] = 6;
+			else if (strncmp(label, "AMD", 3) == 0)
+				data->temp_type[i] = 5;
+		} else if ((tmp & (0x02 << i)))
 			data->temp_type[i] = (diode & (0x10 << i)) ? 1 : 3;
 		else
 			data->temp_type[i] = 4; /* thermistor */
-- 
1.7.7.2


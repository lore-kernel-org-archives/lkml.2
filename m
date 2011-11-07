Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab1KGUw5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 15:52:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36631 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546Ab1KGUwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 15:52:54 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Alessandro Rubini <rubini@cvml.unipv.it>,
        Henrik Rydberg <rydberg@euromail.se>,
        Chase Douglas <chase.douglas@canonical.com>,
        Andrew Skalski <askalski@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/7] Input: ALPS - Move protocol information to Documentation
Date: Mon,  7 Nov 2011 14:52:34 -0600
Message-Id: <1320699160-28492-2-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1320699160-28492-1-git-send-email-seth.forshee@canonical.com>
References: <1320699160-28492-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for new protocol support, move the protocol
information currently documented in alps.c to
Documentation/input/alps.txt, where it can be expanded without
cluttering up the driver.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Acked-by: Chase Douglas <chase.douglas@canonical.com>
---
 Documentation/input/alps.txt |   75 ++++++++++++++++++++++++++++++++++++++++++
 drivers/input/mouse/alps.c   |   37 +--------------------
 2 files changed, 76 insertions(+), 36 deletions(-)
 create mode 100644 Documentation/input/alps.txt

diff --git a/Documentation/input/alps.txt b/Documentation/input/alps.txt
new file mode 100644
index 0000000..ab5478f
--- /dev/null
+++ b/Documentation/input/alps.txt
@@ -0,0 +1,75 @@
+ALPS Touchpad Protocol
+----------------------
+
+Introduction
+------------
+
+Currently the ALPS touchpad driver supports two protocol versions in use by
+ALPS touchpads, the "old" and "new" protocol versions. Fundamentally these
+differ only in the format of their event packets (in reality many features may
+be found on new protocol devices that aren't found on the old protocol
+devices, but these are handled transparently as feature differences rather
+than protocol differences).
+
+Detection
+---------
+
+All ALPS touchpads should respond to the "E6 report" command sequence:
+E8-E6-E6-E6-E9. An ALPS touchpad should respond with either 00-00-0A or
+00-00-64.
+
+If the E6 report is successful, the touchpad model is identified using the "E7
+report" sequence: E8-E7-E7-E7-E9. The response is the model signature and is
+matched against known models in the alps_model_data_array.
+
+Packet Format
+-------------
+
+In the following tables, the following notation us used.
+
+ CAPITALS = stick, miniscules = touchpad
+
+?'s can have different meanings on different models, such as wheel rotation,
+extra buttons, stick buttons on a dualpoint, etc.
+
+PS/2 packet format
+------------------
+
+ byte 0:  0    0 YSGN XSGN    1    M    R    L
+ byte 1: X7   X6   X5   X4   X3   X2   X1   X0
+ byte 2: Y7   Y6   Y5   Y4   Y3   Y2   Y1   Y0
+
+Note that the device never signals overflow condition.
+
+ALPS Absolute Mode - Old Format
+-------------------------------
+
+ byte 0:  1    0    0    0    1   x9   x8   x7
+ byte 1:  0   x6   x5   x4   x3   x2   x1   x0
+ byte 2:  0    ?    ?    l    r    ?  fin  ges
+ byte 3:  0    ?    ?    ?    ?   y9   y8   y7
+ byte 4:  0   y6   y5   y4   y3   y2   y1   y0
+ byte 5:  0   z6   z5   z4   z3   z2   z1   z0
+
+ALPS Absolute Mode - New Format
+-------------------------------
+
+ byte 0:  1    ?    ?    ?    1    ?    ?    ?
+ byte 1:  0   x6   x5   x4   x3   x2   x1   x0
+ byte 2:  0  x10   x9   x8   x7    ?  fin  ges
+ byte 3:  0   y9   y8   y7    1    M    R    L
+ byte 4:  0   y6   y5   y4   y3   y2   y1   y0
+ byte 5:  0   z6   z5   z4   z3   z2   z1   z0
+
+Dualpoint device -- interleaved packet format
+---------------------------------------------
+
+ byte 0:    1    1    0    0    1    1    1    1
+ byte 1:    0   x6   x5   x4   x3   x2   x1   x0
+ byte 2:    0  x10   x9   x8   x7    0  fin  ges
+ byte 3:    0    0 YSGN XSGN    1    1    1    1
+ byte 4:   X7   X6   X5   X4   X3   X2   X1   X0
+ byte 5:   Y7   Y6   Y5   Y4   Y3   Y2   Y1   Y0
+ byte 6:    0   y9   y8   y7    1    m    r    l
+ byte 7:    0   y6   y5   y4   y3   y2   y1   y0
+ byte 8:    0   z6   z5   z4   z3   z2   z1   z0
diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
index 003587c..19d0943 100644
--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -67,42 +67,7 @@ static const struct alps_model_info alps_model_data[] = {
  * isn't valid per PS/2 spec.
  */
 
-/*
- * PS/2 packet format
- *
- * byte 0:  0    0 YSGN XSGN    1    M    R    L
- * byte 1: X7   X6   X5   X4   X3   X2   X1   X0
- * byte 2: Y7   Y6   Y5   Y4   Y3   Y2   Y1   Y0
- *
- * Note that the device never signals overflow condition.
- *
- * ALPS absolute Mode - new format
- *
- * byte 0:  1    ?    ?    ?    1    ?    ?    ?
- * byte 1:  0   x6   x5   x4   x3   x2   x1   x0
- * byte 2:  0  x10   x9   x8   x7    ?  fin  ges
- * byte 3:  0   y9   y8   y7    1    M    R    L
- * byte 4:  0   y6   y5   y4   y3   y2   y1   y0
- * byte 5:  0   z6   z5   z4   z3   z2   z1   z0
- *
- * Dualpoint device -- interleaved packet format
- *
- * byte 0:    1    1    0    0    1    1    1    1
- * byte 1:    0   x6   x5   x4   x3   x2   x1   x0
- * byte 2:    0  x10   x9   x8   x7    0  fin  ges
- * byte 3:    0    0 YSGN XSGN    1    1    1    1
- * byte 4:   X7   X6   X5   X4   X3   X2   X1   X0
- * byte 5:   Y7   Y6   Y5   Y4   Y3   Y2   Y1   Y0
- * byte 6:    0   y9   y8   y7    1    m    r    l
- * byte 7:    0   y6   y5   y4   y3   y2   y1   y0
- * byte 8:    0   z6   z5   z4   z3   z2   z1   z0
- *
- * CAPITALS = stick, miniscules = touchpad
- *
- * ?'s can have different meanings on different models,
- * such as wheel rotation, extra buttons, stick buttons
- * on a dualpoint, etc.
- */
+/* Packet formats are described in Documentation/input/alps.txt */
 
 static bool alps_is_valid_first_byte(const struct alps_model_info *model,
 				     unsigned char data)
-- 
1.7.5.4


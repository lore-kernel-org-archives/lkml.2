Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab2KKMx1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 07:53:27 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62817 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333Ab2KKMwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 07:52:46 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>, Daniel Mack <zonque@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 1/3] staging: line6: replace DEBUG_MESSAGES() with dev_dbg()
Date: Sun, 11 Nov 2012 13:52:24 +0100
Message-Id: <1352638346-32273-2-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1352638346-32273-1-git-send-email-stefanha@gmail.com>
References: <1352638346-32273-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dyndbg feature allows dev_dbg() calls to be enabled/disabled at
runtime and is therefore more convenient than static debug log messages.
Use dev_dbg() instead of the line6-specific DEBUG_MESSAGES() macro.

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/driver.c |  6 ++---
 drivers/staging/line6/pod.c    | 57 ++++++++++++++++--------------------------
 drivers/staging/line6/variax.c | 12 ++++-----
 3 files changed, 28 insertions(+), 47 deletions(-)

diff --git a/drivers/staging/line6/driver.c b/drivers/staging/line6/driver.c
index ac11a3b..571f2ce 100644
--- a/drivers/staging/line6/driver.c
+++ b/drivers/staging/line6/driver.c
@@ -412,10 +412,8 @@ static void line6_data_received(struct urb *urb)
 
 	if (done < urb->actual_length) {
 		line6_midibuf_ignore(mb, done);
-		DEBUG_MESSAGES(dev_err
-			       (line6->ifcdev,
-				"%d %d buffer overflow - message skipped\n",
-				done, urb->actual_length));
+		dev_dbg(line6->ifcdev, "%d %d buffer overflow - message skipped\n",
+			done, urb->actual_length);
 	}
 
 	for (;;) {
diff --git a/drivers/staging/line6/pod.c b/drivers/staging/line6/pod.c
index 9edd053..4a86f7a 100644
--- a/drivers/staging/line6/pod.c
+++ b/drivers/staging/line6/pod.c
@@ -252,25 +252,19 @@ void line6_pod_process_message(struct usb_line6_pod *pod)
 						break;
 
 					default:
-						DEBUG_MESSAGES(dev_err
-							       (pod->
-								line6.ifcdev,
-								"unknown dump code %02X\n",
-								pod->
-								dumpreq.in_progress));
+						dev_dbg(pod->line6.ifcdev,
+							"unknown dump code %02X\n",
+							pod->dumpreq.in_progress);
 					}
 
 					line6_dump_finished(&pod->dumpreq);
 					pod_startup3(pod);
 				} else
-					DEBUG_MESSAGES(dev_err
-						       (pod->line6.ifcdev,
-							"wrong size of channel dump message (%d instead of %d)\n",
-							pod->
-							line6.message_length,
-							(int)
-							sizeof(pod->prog_data) +
-							7));
+					dev_dbg(pod->line6.ifcdev,
+						"wrong size of channel dump message (%d instead of %d)\n",
+						pod->line6.message_length,
+						(int)sizeof(pod->prog_data) +
+						7);
 
 				break;
 
@@ -302,11 +296,9 @@ void line6_pod_process_message(struct usb_line6_pod *pod)
 #undef PROCESS_SYSTEM_PARAM
 
 					default:
-						DEBUG_MESSAGES(dev_err
-							       (pod->
-								line6.ifcdev,
-								"unknown tuner/system response %02X\n",
-								buf[6]));
+						dev_dbg(pod->line6.ifcdev,
+							"unknown tuner/system response %02X\n",
+							buf[6]);
 					}
 
 					break;
@@ -321,25 +313,21 @@ void line6_pod_process_message(struct usb_line6_pod *pod)
 				break;
 
 			case POD_SYSEX_CLIP:
-				DEBUG_MESSAGES(dev_err
-					       (pod->line6.ifcdev,
-						"audio clipped\n"));
+				dev_dbg(pod->line6.ifcdev, "audio clipped\n");
 				pod->clipping.value = 1;
 				wake_up(&pod->clipping.wait);
 				break;
 
 			case POD_SYSEX_STORE:
-				DEBUG_MESSAGES(dev_err
-					       (pod->line6.ifcdev,
-						"message %02X not yet implemented\n",
-						buf[5]));
+				dev_dbg(pod->line6.ifcdev,
+					"message %02X not yet implemented\n",
+					buf[5]);
 				break;
 
 			default:
-				DEBUG_MESSAGES(dev_err
-					       (pod->line6.ifcdev,
-						"unknown sysex message %02X\n",
-						buf[5]));
+				dev_dbg(pod->line6.ifcdev,
+					"unknown sysex message %02X\n",
+					buf[5]);
 			}
 		} else
 		    if (memcmp
@@ -352,9 +340,7 @@ void line6_pod_process_message(struct usb_line6_pod *pod)
 			    buf[10];
 			pod_startup4(pod);
 		} else
-			DEBUG_MESSAGES(dev_err
-				       (pod->line6.ifcdev,
-					"unknown sysex header\n"));
+			dev_dbg(pod->line6.ifcdev, "unknown sysex header\n");
 
 		break;
 
@@ -362,9 +348,8 @@ void line6_pod_process_message(struct usb_line6_pod *pod)
 		break;
 
 	default:
-		DEBUG_MESSAGES(dev_err
-			       (pod->line6.ifcdev,
-				"POD: unknown message %02X\n", buf[0]));
+		dev_dbg(pod->line6.ifcdev, "POD: unknown message %02X\n",
+			buf[0]);
 	}
 }
 
diff --git a/drivers/staging/line6/variax.c b/drivers/staging/line6/variax.c
index 1b85ecc..8df529f 100644
--- a/drivers/staging/line6/variax.c
+++ b/drivers/staging/line6/variax.c
@@ -262,10 +262,9 @@ void line6_variax_process_message(struct usb_line6_variax *variax)
 					     2, VARIAX_DUMP_PASS3);
 				}
 			} else {
-				DEBUG_MESSAGES(dev_err
-					       (variax->line6.ifcdev,
-						"illegal length %d of model data\n",
-						variax->line6.message_length));
+				dev_dbg(variax->line6.ifcdev,
+					"illegal length %d of model data\n",
+					variax->line6.message_length);
 				line6_dump_finished(&variax->dumpreq);
 			}
 		} else if (memcmp(buf + 1, variax_request_bank + 1,
@@ -295,9 +294,8 @@ void line6_variax_process_message(struct usb_line6_variax *variax)
 		break;
 
 	default:
-		DEBUG_MESSAGES(dev_err
-			       (variax->line6.ifcdev,
-				"Variax: unknown message %02X\n", buf[0]));
+		dev_dbg(variax->line6.ifcdev,
+			"Variax: unknown message %02X\n", buf[0]);
 	}
 }
 
-- 
1.7.12.1


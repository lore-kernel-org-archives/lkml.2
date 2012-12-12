Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354Ab2LLPcq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 10:32:46 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:60536 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752276Ab2LLPcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 10:32:43 -0500
X-Authenticated: #787645
X-Provags-ID: V01U2FsdGVkX1+5jsUJDC+5fis7RghxSHCFZznxfPsKcAKJgAD+2L
	SxEKYwmf2VCOHk
Message-ID: <50C8A391.3010900@gmx.net>
Date: Wed, 12 Dec 2012 16:32:33 +0100
From: Witold Szczeponik <Witold.Szczeponik@gmx.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Len Brown <lenb@kernel.org>, Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] PNP: Simplify setting of resources
References: <4460434.rhV1bpKLo5@vostro.rjw.lan> <50C75E65.70802@gmx.net> <7930705.OcvDjiPjJD@vostro.rjw.lan>
In-Reply-To: <7930705.OcvDjiPjJD@vostro.rjw.lan>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch factors out the setting of PNP resources into one function which is 
then reused for all PNP resource types.  This makes the code more concise and 
avoids duplication.  The parameters "type" and "flags" are not used at the
moment but may be used by follow-up patches.  Placeholders for these patches 
can be found in the comment lines that contain the "TBD" marker. 

As the code does not make any changes to the ABI, no regressions are expected.

NB: While at it, support for bus type resources is added. 

The patch is applied against Linux 3.7 as well as linux-pm.git/master 
as of 2012-12-12.


Signed-off-by: Witold Szczeponik <Witold.Szczeponik@gmx.net>
Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>


Index: linux/drivers/pnp/interface.c
===================================================================
--- linux.orig/drivers/pnp/interface.c
+++ linux/drivers/pnp/interface.c
@@ -298,6 +298,39 @@ static ssize_t pnp_show_current_resource
 	return ret;
 }
 
+static char *pnp_get_resource_value(char *buf,
+				    unsigned long type,
+				    resource_size_t *start,
+				    resource_size_t *end,
+				    unsigned long *flags)
+{
+	if (start)
+		*start = 0;
+	if (end)
+		*end = 0;
+	if (flags)
+		*flags = 0;
+
+	/* TBD: allow for disabled resources */
+
+	buf = skip_spaces(buf);
+	if (start) {
+		*start = simple_strtoull(buf, &buf, 0);
+		if (end) {
+			buf = skip_spaces(buf);
+			if (*buf == '-') {
+				buf = skip_spaces(buf + 1);
+				*end = simple_strtoull(buf, &buf, 0);
+			} else
+				*end = *start;
+		}
+	}
+
+	/* TBD: allow for additional flags, e.g., IORESOURCE_WINDOW */
+
+	return buf;
+}
+
 static ssize_t pnp_set_current_resources(struct device *dmdev,
 					 struct device_attribute *attr,
 					 const char *ubuf, size_t count)
@@ -305,7 +338,6 @@ static ssize_t pnp_set_current_resources
 	struct pnp_dev *dev = to_pnp_dev(dmdev);
 	char *buf = (void *)ubuf;
 	int retval = 0;
-	resource_size_t start, end;
 
 	if (dev->status & PNP_ATTACHED) {
 		retval = -EBUSY;
@@ -349,6 +381,10 @@ static ssize_t pnp_set_current_resources
 		goto done;
 	}
 	if (!strnicmp(buf, "set", 3)) {
+		resource_size_t start;
+		resource_size_t end;
+		unsigned long flags;
+
 		if (dev->active)
 			goto done;
 		buf += 3;
@@ -357,42 +393,37 @@ static ssize_t pnp_set_current_resources
 		while (1) {
 			buf = skip_spaces(buf);
 			if (!strnicmp(buf, "io", 2)) {
-				buf = skip_spaces(buf + 2);
-				start = simple_strtoul(buf, &buf, 0);
-				buf = skip_spaces(buf);
-				if (*buf == '-') {
-					buf = skip_spaces(buf + 1);
-					end = simple_strtoul(buf, &buf, 0);
-				} else
-					end = start;
-				pnp_add_io_resource(dev, start, end, 0);
-				continue;
-			}
-			if (!strnicmp(buf, "mem", 3)) {
-				buf = skip_spaces(buf + 3);
-				start = simple_strtoul(buf, &buf, 0);
-				buf = skip_spaces(buf);
-				if (*buf == '-') {
-					buf = skip_spaces(buf + 1);
-					end = simple_strtoul(buf, &buf, 0);
-				} else
-					end = start;
-				pnp_add_mem_resource(dev, start, end, 0);
-				continue;
-			}
-			if (!strnicmp(buf, "irq", 3)) {
-				buf = skip_spaces(buf + 3);
-				start = simple_strtoul(buf, &buf, 0);
-				pnp_add_irq_resource(dev, start, 0);
-				continue;
-			}
-			if (!strnicmp(buf, "dma", 3)) {
-				buf = skip_spaces(buf + 3);
-				start = simple_strtoul(buf, &buf, 0);
-				pnp_add_dma_resource(dev, start, 0);
-				continue;
-			}
-			break;
+				buf = pnp_get_resource_value(buf + 2,
+							     IORESOURCE_IO,
+							     &start, &end,
+							     &flags);
+				pnp_add_io_resource(dev, start, end, flags);
+			} else if (!strnicmp(buf, "mem", 3)) {
+				buf = pnp_get_resource_value(buf + 3,
+							     IORESOURCE_MEM,
+							     &start, &end,
+							     &flags);
+				pnp_add_mem_resource(dev, start, end, flags);
+			} else if (!strnicmp(buf, "irq", 3)) {
+				buf = pnp_get_resource_value(buf + 3,
+							     IORESOURCE_IRQ,
+							     &start, NULL,
+							     &flags);
+				pnp_add_irq_resource(dev, start, flags);
+			} else if (!strnicmp(buf, "dma", 3)) {
+				buf = pnp_get_resource_value(buf + 3,
+							     IORESOURCE_DMA,
+							     &start, NULL,
+							     &flags);
+				pnp_add_dma_resource(dev, start, flags);
+			} else if (!strnicmp(buf, "bus", 3)) {
+				buf = pnp_get_resource_value(buf + 3,
+							     IORESOURCE_BUS,
+							     &start, &end,
+							     NULL);
+				pnp_add_bus_resource(dev, start, end);
+			} else
+				break;
 		}
 		mutex_unlock(&pnp_res_mutex);
 		goto done;


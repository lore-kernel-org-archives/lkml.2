Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063Ab1CVJC2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 05:02:28 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:58107 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab1CVJC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 05:02:26 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmxtMZ80VwmRVV7cZ5
X-RZG-CLASS-ID: mo00
Date: Tue, 22 Mar 2011 10:02:17 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Hank Janssen <hjanssen@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, kys@microsoft.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] hv: update dist release parsing in hv_kvp_daemon
Message-ID: <20110322090217.GA1678@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code to parse the distribution file handles only files with
at least 3 lines. openSuSE has 2 lines and Redhat only one (according to
google).
Update the parser to handle up to three lines properly. Also make the
buffer allocation dynamic and remove a few casts to avoid compiler
warnings.

Signed-off-by: Olaf Hering <olaf@aepfle.de>

---
 drivers/staging/hv/tools/hv_kvp_daemon.c |   90 +++++++++++++++++++------------
 1 file changed, 57 insertions(+), 33 deletions(-)

Index: linux-2.6/drivers/staging/hv/tools/hv_kvp_daemon.c
===================================================================
--- linux-2.6.orig/drivers/staging/hv/tools/hv_kvp_daemon.c
+++ linux-2.6/drivers/staging/hv/tools/hv_kvp_daemon.c
@@ -102,22 +102,22 @@ static char kvp_send_buffer[4096];
 static char kvp_recv_buffer[4096];
 static struct sockaddr_nl addr;
 
-static char os_name[100];
-static char os_major[50];
-static char os_minor[50];
-static char processor_arch[50];
-static char os_build[100];
+static char *os_name = "";
+static char *os_major = "";
+static char *os_minor = "";
+static char *processor_arch;
+static char *os_build;
 static char *lic_version;
+static struct utsname uts_buf;
 
 void kvp_get_os_info(void)
 {
 	FILE	*file;
-	char	*eol;
-	struct utsname buf;
+	char	*p, buf[512];
 
-	uname(&buf);
-	strcpy(os_build, buf.release);
-	strcpy(processor_arch, buf.machine);
+	uname(&uts_buf);
+	os_build = uts_buf.release;
+	processor_arch= uts_buf.machine;
 
 	file = fopen("/etc/SuSE-release", "r");
 	if (file != NULL)
@@ -132,21 +132,46 @@ void kvp_get_os_info(void)
 	/*
 	 * We don't have information about the os.
 	 */
-	strcpy(os_name, "Linux");
-	strcpy(os_major, "0");
-	strcpy(os_minor, "0");
+	os_name = uts_buf.sysname;
 	return;
 
 kvp_osinfo_found:
-	fgets(os_name, 99, file);
-	eol = index(os_name, '\n');
-	*eol = '\0';
-	fgets(os_major, 49, file);
-	eol = index(os_major, '\n');
-	*eol = '\0';
-	fgets(os_minor, 49, file);
-	eol = index(os_minor, '\n');
-	*eol = '\0';
+	/* up to three lines */
+	p = fgets(buf, sizeof(buf), file);
+	if (p) {
+		p = strchr(buf, '\n');
+		if (p)
+			*p = '\0';
+		p = strdup(buf);
+		if (!p)
+			goto done;
+		os_name = p;
+
+		/* second line */
+		p = fgets(buf, sizeof(buf), file);
+		if (p) {
+			p = strchr(buf, '\n');
+			if (p)
+				*p = '\0';
+			p = strdup(buf);
+			if (!p)
+				goto done;
+			os_major = p;
+
+			/* third line */
+			p = fgets(buf, sizeof(buf), file);
+			if (p)  {
+				p = strchr(buf, '\n');
+				if (p)
+					*p = '\0';
+				p = strdup(buf);
+				if (p)
+					os_minor = p;
+			}
+		}
+	}
+
+done:
 	fclose(file);
 	return;
 }
@@ -293,7 +318,7 @@ netlink_send(int fd, struct cn_msg *msg)
 	return sendmsg(fd, &message, 0);
 }
 
-main(void)
+int main(void)
 {
 	int fd, len, sock_opt;
 	int error;
@@ -301,9 +326,10 @@ main(void)
 	struct pollfd pfd;
 	struct nlmsghdr *incoming_msg;
 	struct cn_msg	*incoming_cn_msg;
+	struct hv_ku_msg *hv_msg;
+	char	*p;
 	char	*key_value;
 	char	*key_name;
-	int	 key_index;
 
 	daemon(1, 0);
 	openlog("KVP", 0, LOG_USER);
@@ -373,9 +399,10 @@ main(void)
 			 * Driver is registering with us; stash away the version
 			 * information.
 			 */
-			lic_version = malloc(strlen(incoming_cn_msg->data) + 1);
+			p = (char *)incoming_cn_msg->data;
+			lic_version = malloc(strlen(p) + 1);
 			if (lic_version) {
-				strcpy(lic_version, incoming_cn_msg->data);
+				strcpy(lic_version, p);
 				syslog(LOG_INFO, "KVP LIC Version: %s",
 					lic_version);
 			} else {
@@ -389,14 +416,11 @@ main(void)
 			continue;
 		}
 
-		key_index =
-		((struct hv_ku_msg *)incoming_cn_msg->data)->kvp_index;
-		key_name =
-		((struct hv_ku_msg *)incoming_cn_msg->data)->kvp_key;
-		key_value =
-		((struct hv_ku_msg *)incoming_cn_msg->data)->kvp_value;
+		hv_msg = (struct hv_ku_msg *)incoming_cn_msg->data;
+		key_name = (char *)hv_msg->kvp_key;
+		key_value = (char *)hv_msg->kvp_value;
 
-		switch (key_index) {
+		switch (hv_msg->kvp_index) {
 		case FullyQualifiedDomainName:
 			kvp_get_domain_name(key_value,
 					HV_KVP_EXCHANGE_MAX_VALUE_SIZE);

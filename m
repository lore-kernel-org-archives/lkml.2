Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452Ab2GNUVG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 16:21:06 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:51154
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752346Ab2GNUTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 16:19:54 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        olaf@aepfle.de, apw@canonical.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 13/15] Tools: hv: Implement the KVP verb - KVP_OP_SET_IP_INFO
Date: Sat, 14 Jul 2012 13:34:18 -0700
Message-Id: <1342298060-12662-13-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1342298060-12662-1-git-send-email-kys@microsoft.com>
References: <1342297930-12607-1-git-send-email-kys@microsoft.com>
 <1342298060-12662-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement the KVP verb - KVP_OP_SET_IP_INFO. This operation configures the 
specified interface based on the given configuration. Since configuring
an interface is very distro specific, we invoke an external script to
configure the interface.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 tools/hv/hv_kvp_daemon.c |  324 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 324 insertions(+), 0 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index c510283..c33fc8e 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -41,6 +41,7 @@
 #include <syslog.h>
 #include <sys/stat.h>
 #include <fcntl.h>
+#include <dirent.h>
 
 /*
  * KVP protocol: The user mode component first registers with the
@@ -490,6 +491,105 @@ done:
 	return;
 }
 
+
+/*
+ * Retrieve an interface name corresponding to the specified guid.
+ * If there is a match, the function returns a pointer
+ * to the interface name and if not, a NULL is returned.
+ * If a match is found, the caller is responsible for
+ * freeing the memory.
+ */
+
+static char *kvp_get_if_name(char *guid)
+{
+	DIR *dir;
+	struct dirent *entry;
+	FILE    *file;
+	char    *p, *q, *x;
+	char    *if_name = NULL;
+	char    buf[256];
+	char *kvp_net_dir = "/sys/class/net/";
+	char dev_id[100];
+
+	dir = opendir(kvp_net_dir);
+	if (dir == NULL)
+		return NULL;
+
+	memset(dev_id, 0, sizeof(dev_id));
+	strcat(dev_id, kvp_net_dir);
+	q = dev_id + strlen(kvp_net_dir);
+
+	while ((entry = readdir(dir)) != NULL) {
+		/*
+		 * Set the state for the next pass.
+		 */
+		*q = '\0';
+		strcat(dev_id, entry->d_name);
+		strcat(dev_id, "/device/device_id");
+
+		file = fopen(dev_id, "r");
+		if (file == NULL)
+			continue;
+
+		p = fgets(buf, sizeof(buf), file);
+		if (p) {
+			x = strchr(p, '\n');
+			if (x)
+				*x = '\0';
+
+			if (!strcmp(p, guid)) {
+				/*
+				 * Found the guid match; return the interface
+				 * name. The caller will free the memory.
+				 */
+				if_name = strdup(entry->d_name);
+				break;
+			}
+		}
+		fclose(file);
+	}
+
+	closedir(dir);
+	return if_name;
+}
+
+/*
+ * Retrieve the MAC address given the interface name.
+ */
+
+static char *kvp_if_name_to_mac(char *if_name)
+{
+	FILE    *file;
+	char    *p, *x;
+	char    buf[256];
+	char addr_file[100];
+	int i;
+	char *mac_addr = NULL;
+
+	memset(addr_file, 0, sizeof(addr_file));
+	strcat(addr_file, "/sys/class/net/");
+	strcat(addr_file, if_name);
+	strcat(addr_file, "/address");
+
+	file = fopen(addr_file, "r");
+	if (file == NULL)
+		return NULL;
+
+	p = fgets(buf, sizeof(buf), file);
+	if (p) {
+		x = strchr(p, '\n');
+		if (x)
+			*x = '\0';
+		for (i = 0; i < strlen(p); i++)
+			p[i] = toupper(p[i]);
+		mac_addr = strdup(p);
+	}
+
+	fclose(file);
+	return mac_addr;
+}
+
+
 static void kvp_process_ipconfig_file(char *cmd,
 					char *config_buf, int len,
 					int element_size, int offset)
@@ -799,6 +899,207 @@ getaddr_done:
 }
 
 
+int parse_ip_val_buffer(char *in_buf, int *offset, char *out_buf, int out_len)
+{
+	char *x;
+	char *start;
+
+	/*
+	 * in_buf has sequence of characters that are seperated by
+	 * the character ';'. The last sequence is terminated by ';'.
+	 */
+	start = in_buf + *offset;
+
+	x = strchr(start, ';');
+	if (x) {
+		*x = 0;
+		if ((x - start) <= out_len) {
+			strcpy(out_buf, start);
+			strcat(out_buf, "\n");
+			*offset = (x - start) + 1;
+			return 1;
+		}
+	}
+	return 0;
+}
+
+
+static int kvp_set_ip_info(char *if_name, struct hv_kvp_ipaddr_value *new_val)
+{
+	int error = 0;
+	char if_file[50];
+	FILE *file;
+	char addr[INET6_ADDRSTRLEN];
+	int i;
+	char str[256];
+	char sub_str[10];
+	int offset;
+	char cmd[512];
+	char *mac_addr;
+
+	/*
+	 * Set the configuration for the specified interface with
+	 * the information provided. Since there is no standard
+	 * way to configure an interface, we will have an external
+	 * script that does the job of configuring the interface and
+	 * flushing the configuration.
+	 *
+	 * The parameters passed to this external script are:
+	 * 1. A configuration file that has the specified configuration.
+	 *
+	 * We will embed the name of the interface in the configuration
+	 * file: ifcfg-ethx (where ethx is the interface name).
+	 *
+	 * Here is the format of the ip configuration file:
+	 *
+	 * HWADDR=macaddr
+	 * BOOTPROTO=dhcp (dhcp enabled for the interface)
+	 * IPADDR_x=ipaddr
+	 * NETMASK_x=netmask
+	 * GATEWAY_x=gateway
+	 * DNSx=dns
+	 */
+
+	memset(if_file, 0, sizeof(if_file));
+	strcat(if_file, "/var/opt/hyperv/ifcfg-");
+	strcat(if_file, if_name);
+
+	file = fopen(if_file, "w");
+
+	if (file == NULL)
+		return 1;
+
+	/*
+	 * First write out the MAC address.
+	 */
+
+	mac_addr = kvp_if_name_to_mac(if_name);
+	if (mac_addr == NULL) {
+		error = 1;
+		goto setval_error;
+	}
+
+	memset(str, 0, sizeof(str));
+	strcat(str, "HWADDR=");
+	strcat(str, mac_addr);
+	strcat(str, "\n");
+	error = fputs(str, file);
+	if (error == EOF)
+		goto setval_error;
+
+	if (new_val->dhcp_enabled) {
+		error = fputs("BOOTPROTO=dhcp\n", file);
+		if (error == EOF)
+			goto setval_error;
+
+		/*
+		 * We are done!.
+		 */
+		goto setval_done;
+	}
+
+	/*
+	 * Write the configuration for ipaddress, netmask, gateway and
+	 * name servers.
+	 */
+	i = 0;
+	offset = 0;
+	memset(addr, 0, sizeof(addr));
+	memset(str, 0, sizeof(str));
+
+	while (parse_ip_val_buffer((char *)new_val->ip_addr, &offset, addr,
+					(MAX_IP_ADDR_SIZE * 2))) {
+		memset(sub_str, 0, sizeof(sub_str));
+		strcat(str, "IPADDR");
+		if (i != 0)
+			sprintf(sub_str, "_%d", i);
+		strcat(str, sub_str);
+		i++;
+		strcat(str, "=");
+		strcat(str, addr);
+
+		error = fputs(str, file);
+		if (error == EOF)
+			goto setval_error;
+	}
+
+	i = 0;
+	offset = 0;
+	memset(addr, 0, sizeof(addr));
+	memset(str, 0, sizeof(str));
+
+	while (parse_ip_val_buffer((char *)new_val->sub_net, &offset, addr,
+					(MAX_IP_ADDR_SIZE * 2))) {
+		memset(sub_str, 0, sizeof(sub_str));
+		sprintf(str, "NETMAK");
+		if (i != 0)
+			sprintf(sub_str, "_%d", i);
+		strcat(str, sub_str);
+		i++;
+		strcat(str, "=");
+		strcat(str, addr);
+		error = fputs(str, file);
+		if (error == EOF)
+			goto setval_error;
+	}
+
+	i = 0;
+	offset = 0;
+	memset(addr, 0, sizeof(addr));
+	memset(str, 0, sizeof(str));
+
+	while (parse_ip_val_buffer((char *)new_val->gate_way, &offset, addr,
+					(MAX_IP_ADDR_SIZE * 2))) {
+		memset(sub_str, 0, sizeof(sub_str));
+		sprintf(str, "GATEWAY");
+		if (i != 0)
+			sprintf(sub_str, "_%d", i);
+		strcat(str, sub_str);
+		i++;
+		strcat(str, "=");
+		strcat(str, addr);
+		error = fputs(str, file);
+		if (error == EOF)
+			goto setval_error;
+	}
+
+	i = 1;
+	offset = 0;
+	memset(addr, 0, sizeof(addr));
+	memset(str, 0, sizeof(str));
+
+	while (parse_ip_val_buffer((char *)new_val->dns_addr, &offset, addr,
+					(MAX_IP_ADDR_SIZE * 2))) {
+		sprintf(str, "DNS%d=", i++);
+		strcat(str, addr);
+		error = fputs(str, file);
+		if (error == EOF)
+			goto setval_error;
+	}
+
+
+setval_done:
+	free(mac_addr);
+	fclose(file);
+
+	/*
+	 * Now that we have populated the configuration file,
+	 * invoke the external script to do its magic.
+	 */
+
+	memset(cmd, 0, 512);
+	strcat(cmd, "/sbin/hv_set_ifconfig ");
+	strcat(cmd, if_file);
+	system(cmd);
+	return 0;
+
+setval_error:
+	free(mac_addr);
+	fclose(file);
+	return error;
+}
+
+
 static int
 kvp_get_domain_name(char *buffer, int length)
 {
@@ -868,6 +1169,8 @@ int main(void)
 	char	*key_name;
 	int	op;
 	int	pool;
+	char	*if_name;
+	struct hv_kvp_ipaddr_value *kvp_ip_val;
 
 	daemon(1, 0);
 	openlog("KVP", 0, LOG_USER);
@@ -969,6 +1272,27 @@ int main(void)
 			}
 			continue;
 
+		case KVP_OP_SET_IP_INFO:
+			kvp_ip_val = &hv_msg->body.kvp_ip_val;
+			if_name = kvp_get_if_name(
+					(char *)kvp_ip_val->adapter_id);
+			if (if_name == NULL) {
+				/*
+				 * We could not map the guid to an
+				 * interface name; return error.
+				 */
+				*((int *)(&hv_msg->kvp_hdr.operation)) =
+					HV_ERROR_DEVICE_NOT_CONNECTED;
+				break;
+			}
+			error = kvp_set_ip_info(if_name, kvp_ip_val);
+			if (error)
+				*((int *)(&hv_msg->kvp_hdr.operation)) =
+					HV_ERROR_DEVICE_NOT_CONNECTED;
+
+			free(if_name);
+			break;
+
 		case KVP_OP_SET:
 			if (kvp_key_add_or_modify(pool,
 					hv_msg->body.kvp_set.data.key,
-- 
1.7.4.1


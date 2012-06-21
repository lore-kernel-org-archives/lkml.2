Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760472Ab2FUVZt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 17:25:49 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:40832
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760432Ab2FUVZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 17:25:28 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        ohering@suse.com, apw@canonical.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 13/13] Tools: hv: Implement the KVP verb - KVP_OP_SET_IP_INFO
Date: Thu, 21 Jun 2012 14:31:45 -0700
Message-Id: <1340314305-27126-13-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1340314305-27126-1-git-send-email-kys@microsoft.com>
References: <1340314200-27078-1-git-send-email-kys@microsoft.com>
 <1340314305-27126-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement the KVP_OP_SET_IP_INFO verb. This operation sets the IP information
on the specified interface.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 tools/hv/hv_kvp_daemon.c |  198 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 198 insertions(+), 0 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 569f4d7..8eefdb5 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -847,6 +847,183 @@ getaddr_done:
 	return error;
 }
 
+int parse_ip_val_buffer(char *in_buf, int *offset, char *out_buf, int out_len)
+{
+	int end;
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
+static int kvp_set_ip_info(char *if_name, struct hv_kvp_ipaddr_value *new_val)
+{
+	int error = 0;
+	char if_path[256];
+	char if_tmp_path[256];
+	FILE *file;
+	char addr[INET6_ADDRSTRLEN];
+	int i;
+	char cmd[256];
+	char str[256];
+	int offset;
+
+	/*
+	 * Set the specified info in the appropriate config file
+	 * for the specified interface and flush the settings.
+	 * Currently we support distributions that maintain
+	 * network configuration information in file:
+	 * /etc/sysconfig/network-scripts/icfg-ifname
+	 */
+	memset(if_path, 0, sizeof(if_path));
+	strcat(if_path, "/etc/sysconfig/network-scripts/ifcfg-");
+	strcat(if_path, if_name);
+
+	memset(if_tmp_path, 0, sizeof(if_tmp_path));
+	strcat(if_tmp_path, "/var/opt/hyperv/.kvp_ifcfg-");
+	strcat(if_tmp_path, if_name);
+
+	file = fopen(if_path, "r");
+	if (file == NULL) {
+		/*
+		 * This system maintains the interface configuration
+		 * information in a different location. Need to add
+		 * code to deal with that. For now fail the operation.
+		 */
+		return 1;
+	}
+
+	fclose(file);
+	/*
+	 * The host gives us complete configuration information for the
+	 * interface; just overwrite the current info.
+	 * To deal with intermediate failues, first write a temp file.
+	 */
+
+	file = fopen(if_tmp_path, "w");
+
+	if (file == NULL)
+		return 1;
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
+		sprintf(str, "IPADDR_%d=", i++);
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
+	while (parse_ip_val_buffer((char *)new_val->sub_net, &offset, addr,
+					(MAX_IP_ADDR_SIZE * 2))) {
+		sprintf(str, "NETMAK_%d=", i++);
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
+		sprintf(str, "GATEWAY_%d=", i++);
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
+	while (parse_ip_val_buffer((char *)new_val->dns_addr, &offset, addr,
+					(MAX_IP_ADDR_SIZE * 2))) {
+		sprintf(str, "DNS%d=", i++);
+		strcat(str, addr);
+		error = fputs(str, file);
+		if (error == EOF)
+			goto setval_error;
+	}
+
+	error = fputs("ONBOOT=yes\n", file);
+	if (error == EOF)
+		goto setval_error;
+
+	error = fputs("PEERDNS=yes\n", file);
+	if (error == EOF)
+		goto setval_error;
+
+setval_done:
+	/*
+	 * Now move the config file to the final location.
+	 */
+	fclose(file);
+	memset(cmd, 0, sizeof(cmd));
+	strcat(cmd, "mv ");
+	strcat(cmd, if_tmp_path);
+	strcat(cmd, "  ");
+	strcat(cmd, if_path);
+	system(cmd);
+
+	/*
+	 * Now restart the network to flush the parameters.
+	 */
+	memset(cmd, 0, sizeof(cmd));
+	strcat(cmd, "service network restart");
+	system(cmd);
+	return 0;
+
+setval_error:
+	fclose(file);
+	return error;
+}
 
 static int
 kvp_get_domain_name(char *buffer, int length)
@@ -1048,6 +1225,27 @@ int main(void)
 			free(if_name);
 			break;
 
+		case KVP_OP_SET_IP_INFO:
+			kvp_ip_val = &hv_msg->body.kvp_ip_val;
+			if_name = kvp_get_if_name(
+						(char *)kvp_ip_val->adapter_id,
+						MAX_ADAPTER_ID_SIZE);
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
 		case KVP_OP_SET:
 			if (kvp_key_add_or_modify(hv_msg->kvp_hdr.pool,
 					hv_msg->body.kvp_set.data.key,
-- 
1.7.4.1


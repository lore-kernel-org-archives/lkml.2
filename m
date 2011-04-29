Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758816Ab1D2No7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 09:44:59 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:52386 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758714Ab1D2Noy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 09:44:54 -0400
X-Sasl-enc: UiW14lN4z5/Of+fpHKene0IBfEbt+bt+R/W/HqnsjWHF 1304084693
From: Roberto Sassu <roberto.sassu@polito.it>
To: linux-security-module@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        dhowells@redhat.com, jmorris@namei.org, zohar@linux.vnet.ibm.com,
        safford@watson.ibm.com, tyhicks@linux.vnet.ibm.com,
        kirkland@canonical.com, ecryptfs-devel@lists.launchpad.net,
        casey@schaufler-ca.com, eparis@redhat.com, sds@tycho.nsa.gov,
        selinux@tycho.nsa.gov, viro@zeniv.linux.org.uk,
        john.johansen@canonical.com, apparmor@lists.ubuntu.com,
        Roberto Sassu <roberto.sassu@polito.it>
Subject: [RFC][PATCH 4/4] eCryptfs: added ima_file_check() call to ecryptfs_init_lower_file()
Date: Fri, 29 Apr 2011 15:41:52 +0200
Message-Id: <1304084515-22132-5-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1304084515-22132-1-git-send-email-roberto.sassu@polito.it>
References: <1304084515-22132-1-git-send-email-roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----A13AD2382956B50A3D121D2124961C9B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------A13AD2382956B50A3D121D2124961C9B

This patch adds the call to the ima_file_check() function in the eCryptfs
code in order to measure inodes opened in the lower filesystem.

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
---
 Documentation/filesystems/ecryptfs-security.txt |   98 +++++++++++++++++++++++
 fs/ecryptfs/main.c                              |    5 +
 2 files changed, 103 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/filesystems/ecryptfs-security.txt

diff --git a/Documentation/filesystems/ecryptfs-security.txt b/Documentation/filesystems/ecryptfs-security.txt
new file mode 100644
index 0000000..f923553
--- /dev/null
+++ b/Documentation/filesystems/ecryptfs-security.txt
@@ -0,0 +1,98 @@
+			ECryptfs security considerations
+
+ECryptfs belongs to the class of stacked filesystems, which present an
+interface where data flow, also called upper layer, perform some transformations
+on them and store the result in another filesystem, called lower layer.
+
+Access control is performed on both the upper and the lower layer and depends
+on how the security attributes are assigned to inodes. Since eCryptfs does not
+store extended attributes by itself but relies on the underlying filesystem to
+perform this task, security attributes are the same for both the upper and the
+lower inodes. However, in the SELinux's case, the security policy can be
+configured to assign to upper inodes a static label while lower inodes are
+initialized with the label stored in their extended attributes.
+
+When a process opens an eCryptfs file, the access control mechanism first
+verifies if the request can be satisfied by checking the process's credentials,
+the security attribute of the upper inode and the operation type.
+
+Then, internally, eCryptfs opens the correspondent inode in the lower filesystem
+by providing its own credentials and obtains a file descriptor which is shared
+between processes that concurrently access the upper inode. The credentials
+provided by eCryptfs are the initial credentials built by the function
+prepare_kernel_cred(), which grant root privileges.
+
+Each eCryptfs filesystem may have assigned its own label, in order to identify
+or restrict the actions it can perform, by overriding the initial credentials
+with this additional mount parameter:
+
+ecryptfs_security_ctx="system_u:system_r:ecryptfs_agent_t:s0" (SELinux)
+
+or:
+
+ecryptfs_security_ctx="mylabel" (SMACK)
+
+
+In SELinux, a policy must be defined for the type specified, which contains the
+declaration and the set of required rules. In particular, the type must be
+allowed to access files and directories in the underlying filesystem and shared
+file descriptors must be usable by accessing processes. Below in this file there
+is a sample policy for the type 'ecryptfs_agent_t'.
+
+Further, the process which mounts the eCryptfs filesystem overriding the initial
+credentials requires this permission:
+
+allow unconfined_mount_t ecryptfs_agent_t: kernel_service use_as_override;
+
+
+where 'unconfined_mount_t' is the domain assigned to the mount program executed
+from a root shell.
+
+Before using the mounted filesystem it is possible to specify a policy for IMA,
+in order to measure accessed files. This command must be specified from a root
+shell:
+
+(SELinux)
+echo "measure fowner_type=ecryptfs_agent_t" > /sys/kernel/security/ima/policy
+
+(SMACK)
+echo "measure fowner_user=mylabel" > /sys/kernel/security/ima/policy
+
+
+It is possible to see measurements collected by executing:
+
+cat /sys/kernel/security/ima/ascii_runtime_measurements
+
+
+The following is the source of a SELinux policy module that contains the policy
+for the type 'ecryptfs_agent_t'.
+
+
+------- ecryptfs_agent.te -------
+
+policy_module(ecryptfs_agent, 1.0.0)
+
+gen_require(`
+        attribute file_type;
+        attribute domain;
+        type unconfined_mount_t;
+')
+
+type ecryptfs_agent_t;
+allow ecryptfs_agent_t file_type: file manage_file_perms;
+allow ecryptfs_agent_t file_type: dir manage_dir_perms;
+allow unconfined_mount_t ecryptfs_agent_t: kernel_service use_as_override;
+allow domain ecryptfs_agent_t: fd use;
+role system_r types ecryptfs_agent_t;
+
+---------------------------------
+
+
+Compile the module (instructions for Fedora 14):
+
+make -f /usr/share/selinux/devel/Makefile ecryptfs_agent.pp
+
+
+Load the module:
+
+semodule -i ecryptfs_agent.pp
diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index 075634b..8ac7885 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -37,6 +37,7 @@
 #include <linux/fs_stack.h>
 #include <linux/slab.h>
 #include <linux/magic.h>
+#include <linux/ima.h>
 #include "ecryptfs_kernel.h"
 
 /**
@@ -141,7 +142,11 @@ static int ecryptfs_init_lower_file(struct dentry *dentry,
 		       "for lower_dentry [0x%p] and lower_mnt [0x%p]; "
 		       "rc = [%d]\n", lower_dentry, lower_mnt, rc);
 		(*lower_file) = NULL;
+		goto out;
 	}
+	rc = ima_file_check((*lower_file), IS_RDONLY(lower_dentry->d_inode) ?
+			    MAY_READ : MAY_READ | MAY_WRITE);
+out:
 	return rc;
 }
 
-- 
1.7.4.4


------A13AD2382956B50A3D121D2124961C9B
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"

MIIICQYJKoZIhvcNAQcCoIIH+jCCB/YCAQExCzAJBgUrDgMCGgUAMAsGCSqGSIb3
DQEHAaCCBWQwggVgMIIESKADAgECAgICuzANBgkqhkiG9w0BAQUFADBlMQswCQYD
VQQGEwJJVDEeMBwGA1UEChMVUG9saXRlY25pY28gZGkgVG9yaW5vMTYwNAYDVQQD
Ey1Qb2xpdGVjbmljbyBkaSBUb3Jpbm8gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkw
HhcNMTAxMjIwMTExOTU0WhcNMTUxMjMxMjM1OTU5WjBfMQswCQYDVQQGEwJJVDEe
MBwGA1UEChMVUG9saXRlY25pY28gZGkgVG9yaW5vMRcwFQYDVQQDEw5Sb2JlcnRv
ICBTYXNzdTEXMBUGCgmSJomT8ixkAQETB2QwMjEzMDUwggEiMA0GCSqGSIb3DQEB
AQUAA4IBDwAwggEKAoIBAQDS6p4SaJdmmJHJu9On9ZohhBFE2GgYiY7YtRnhhQJA
NfOtHEhSbpUMaSOfq/Pna6ipR5nAFrlM8cOGcSHZdxrPcgzeJU7F2v1fl2ThvFOc
TIkcC1aAJGQUuCaCXDlQt+KFecJWTrRZnalMHZueO+J6cgHcvR1CQz5e88dSzo3Q
XZy0w/hxGL9Ht9velqsl48ohBk2rs/svAOCp6GfqT1Yxwx1p87d3ViTrmuZB4/X+
da39nJqmo6AZ/y3Zg+r91BgNcfsHVqFT0JTcG6qRIaeqTtqVYpYl+rH1rZzYCakD
yQyys66sBvaXyaiMr0M+SpyH+LaGz5bDn5Odq16FYEq7AgMBAAGjggIeMIICGjAO
BgNVHQ8BAf8EBAMCA/gwJwYDVR0lBCAwHgYIKwYBBQUHAwIGCCsGAQUFBwMDBggr
BgEFBQcDBDAiBgNVHREEGzAZgRdyb2JlcnRvLnNhc3N1QHBvbGl0by5pdDAMBgNV
HRMBAf8EAjAAMB0GA1UdDgQWBBQgKbXSXn+j769x0tsZQ9pSOzIIdDAfBgNVHSME
GDAWgBTNm1tbnup2IcQQaOjSLTfbHy/I5DCBywYDVR0gBIHDMIHAMD4GCisGAQQB
qQcBAQIwMDAuBggrBgEFBQcCARYiaHR0cDovL3d3dy5ldXJvcGtpLm9yZy9jYS9j
cHMvMS4yLzBEBgorBgEEAakHAgECMDYwNAYIKwYBBQUHAgEWKGh0dHA6Ly93d3cu
aXRhbHkuZXVyb3BraS5vcmcvY2EvY3BzLzEuMi8wOAYKKwYBBAGVYgECAjAqMCgG
CCsGAQUFBwIBFhxodHRwOi8vY2EucG9saXRvLml0L2Nwcy8yLjIvMGYGCCsGAQUF
BwEBBFowWDAhBggrBgEFBQcwAYYVaHR0cDovL29jc3AucG9saXRvLml0MDMGCCsG
AQUFBzAChidodHRwOi8vY2EucG9saXRvLml0L2NlcnRzL3BvbGl0b19jYS5jZXIw
NwYDVR0fBDAwLjAsoCqgKIYmaHR0cDovL2NhLnBvbGl0by5pdC9jcmwvcG9saXRv
X2NybC5jcmwwDQYJKoZIhvcNAQEFBQADggEBADMe0aHcBJXV6pMJPVVSt1Vazd8Y
LuTLO45Igs9Sb2LuaO6pvcDGvq9dEJnBhP1B+zBAK6WEA1PWb66xC4QXaJnlGZTX
S3XeBivHWm6BNOH2kNeU0HBeGZCV/n5r70TPxkEAcc7u8YY2i6CiMM428YhZK8Zj
oN9D3QNIRf4HZgh0FTbf8eL/XvBbK/oPC+Rew+Qql6M3DHnaS1q2SKUwwO/4VXA4
JsOdatFI68AMXH0Xx9UIcjRi+kvsyvwHlc0Z8AoAtfRMoIl4zFF4Qaowec2UunBK
YlqPpFTtU9czuoEP12A86nqSVsoNok2mZOeYa9IdIjeE2rfdKx6k3YNRg08xggJt
MIICaQIBATBrMGUxCzAJBgNVBAYTAklUMR4wHAYDVQQKExVQb2xpdGVjbmljbyBk
aSBUb3Jpbm8xNjA0BgNVBAMTLVBvbGl0ZWNuaWNvIGRpIFRvcmlubyBDZXJ0aWZp
Y2F0aW9uIEF1dGhvcml0eQICArswCQYFKw4DAhoFAKCB2DAYBgkqhkiG9w0BCQMx
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMTA0MjkxMzQyMzhaMCMGCSqG
SIb3DQEJBDEWBBQxblpziwas4Y0YyMFv2s4Pfo+Q4DB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQBojenvE/miXoswIeM/Squ5lJv0
8QowfPLqm17KYF/wS8xBsj+934WBPHNGiT+DQ0vWBu1Ftpt4Ixe/qdGLjUYb3wsr
ajxeBNvF3b1rd8ob0/srATAJcDms50a9KGn7u/D4wN51KiYugbjz9y+/ldu/wozE
DSTxxIiCdRLJ0rwkSavpKymL1AHZq5XSzP0rY12EFFt1oa6jTfnfm81godhfjR2r
YY8F+OQ9oI3UOlIELm7A56HEU4jBf56Ud0ZDLBVRTdkVdpQlSz7fZsc4Yj9gY5BP
sv17VzNVTcWXG+h4CRSa7KEFQ9m/VlojPOj2I9cqxYiBXdf4MpkmE+LKWYT5

------A13AD2382956B50A3D121D2124961C9B--



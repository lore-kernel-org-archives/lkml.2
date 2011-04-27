Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343Ab1D0MgP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 08:36:15 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:43172 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932299Ab1D0MgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 08:36:13 -0400
X-Sasl-enc: tNLguPep+UYUIi/jUrm0BJh7id2AMP4YJ/f8sGF/AJMp 1303907772
From: Roberto Sassu <roberto.sassu@polito.it>
To: linux-security-module@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        dhowells@redhat.com, jmorris@namei.org, zohar@linux.vnet.ibm.com,
        safford@watson.ibm.com, tyhicks@linux.vnet.ibm.com,
        kirkland@canonical.com, ecryptfs-devel@lists.launchpad.net,
        casey@schaufler-ca.com, eparis@redhat.com, sds@tycho.nsa.gov,
        selinux@tycho.nsa.gov, viro@zeniv.linux.org.uk,
        Roberto Sassu <roberto.sassu@polito.it>
Subject: [RFC][PATCH 0/7] File descriptor labeling
Date: Wed, 27 Apr 2011 14:34:08 +0200
Message-Id: <1303907657-18366-1-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----6CCC17D75421E202643CE78C142AF137"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------6CCC17D75421E202643CE78C142AF137

File descriptor labeling issue

Actually SELinux and SMACK assign to file descriptors the same label of the
opening process and use it in LSM hooks security_file_permission(),
security_file_fcntl() and others to verify if the 'current' process has the
rights to perform the requested operation.

Using the credentials of the 'current' process may be not appropriate in
case a file descriptor is opened by a kernel service (i.e. a filesystem)
and made shared among user processes. For instance, in a system with
SELinux and eCryptfs, if the process A opens an encrypted file, eCryptfs
obtains a file descriptor to access the correspondent inode in the lower
filesystem, labeled with the A's label.

If the process B accesses the same encrypted file, it needs the 'use'
permission on the A's label other than permissions for the lower inode.
However, if B is the first accessing process, A needs the 'use' permission
on the B's label.

The solution proposed is to modify those kernel services that deal with
file descriptors to provide their set of credentials to dentry_open(), so
that obtained objects are labeled with a unique label. In this way, in the
above example, if eCryptfs provides its credentials with the label C to
dentry_open(), all user processes need the 'use' permission only on C.



File descriptor labeling and IMA

The above proposal suggests to use the file descriptor label as a new
criteria in the IMA policy to determine if a file must be measured. It will
be possible to measure all files opened by a kernel service by simply
writing a rule where the file descriptor label given as a value matches the
one provided by the same service together with other credentials to the
function dentry_open().

In the above example, if eCryptfs provides its credentials with the label C
to dentry_open(), it is possible to measure all inodes opened in the lower
filesystem by specifying a rule like:

fowner_type=C


The benefits of this new criteria will be greater with the integration of
EVM and the IMA appraisal feature in the kernel. ECryptfs can be used in
conjunction with these components to verify the integrity of the content
and extended attributes of encrypted files.

Roberto Sassu


Roberto Sassu (7):
  fs: initialize file->f_cred with credentials provided
  selinux: label new file descriptors using file->f_cred
  smack: assign the label set in file->f_cred to new file descriptors
  smack: fix label check in smack_kernel_act_as()
  smack: import the security label in smack_secctx_to_secid()
  security: new LSM hook security_file_getsecid()
  ima: added new LSM conditions in the policy

 Documentation/ABI/testing/ima_policy |    7 ++++-
 fs/file_table.c                      |    5 +--
 fs/internal.h                        |    2 +-
 fs/namei.c                           |    2 +-
 fs/open.c                            |    2 +-
 include/linux/security.h             |   12 +++++++++
 security/capability.c                |    6 ++++
 security/integrity/ima/ima.h         |    4 +-
 security/integrity/ima/ima_api.c     |    4 +-
 security/integrity/ima/ima_main.c    |    4 +-
 security/integrity/ima/ima_policy.c  |   45 +++++++++++++++++++++++++++++----
 security/security.c                  |    6 ++++
 security/selinux/hooks.c             |    9 ++++++-
 security/smack/smack_lsm.c           |   23 +++++++++++++++--
 14 files changed, 108 insertions(+), 23 deletions(-)

-- 
1.7.4.4


------6CCC17D75421E202643CE78C142AF137
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMTA0MjcxMjM0MTdaMCMGCSqG
SIb3DQEJBDEWBBTRptNqNdkGfAAxKfUCE/vbdzJlvzB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQC6xoeoAFo29+CG3Ok26bdu5Kfg
mqDdIQkrhKkxMLGia/24TaXsgy2WWufB4GRKURwqtUPHk/uFEorVTwIhse3SBg6U
xi2v+rsVLRw3XoL3FrfRpApIZxeLA9VYHGcNjaW40xcap2UTur7CJUnYoeKJWBO6
0vm7rAO1BktOGyZUb9ocG4QjYawkA7wJZkS+JXwa+Sdn8GLoLY/esg0I5BgdmkrJ
Pt4DxTDps/OEjBK1G/tsADzJYSTgNEvDPcWyQipDx15NZx9DJImQw4kHvOJOLizV
kyiTZgO/K/wYlL1/vUJV/qRRs1tcXumv9kpuyP46lRXLiYZyvEJ/2xy3V5Es

------6CCC17D75421E202643CE78C142AF137--



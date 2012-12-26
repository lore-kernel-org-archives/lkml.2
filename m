Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803Ab2LZAl1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 19:41:27 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:42918 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab2LZAlZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 19:41:25 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk.kim@samsung.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Date: Tue, 25 Dec 2012 16:41:16 -0800
Message-ID: <87obhh63wz.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-AID: U2FsdGVkX19CF47bfl3AdTn/7AzjZYHf0RAodQSKpEw=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.5 XMGappySubj_01 Very gappy subject
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linux Containers <containers@lists.linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [PATCH review] f2fs: Don't assign e_id in f2fs_acl_from_disk
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


With user namespaces enabled building f2fs fails with:

 CC      fs/f2fs/acl.o
fs/f2fs/acl.c: In function ‘f2fs_acl_from_disk’:
fs/f2fs/acl.c:85:21: error: ‘struct posix_acl_entry’ has no member named ‘e_id’
make[2]: *** [fs/f2fs/acl.o] Error 1
make[2]: Target `__build' not remade because of errors.

e_id is a backwards compatibility field only used for file systems
that haven't been converted to use kuids and kgids.  When the posix
acl tag field is neither ACL_USER nor ACL_GROUP assigning e_id is
unnecessary.  Remove the assignment so f2fs will build with user
namespaces enabled.

Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Namjae Jeon <namjae.jeon@samsung.com>
Cc: Amit Sahrawat <a.sahrawat@samsung.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---

Barring other feedback I will push this change to Linus with my other
namespace bug fixes in the next day or two.

 fs/f2fs/acl.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/f2fs/acl.c b/fs/f2fs/acl.c
index fed74d1..e95b949 100644
--- a/fs/f2fs/acl.c
+++ b/fs/f2fs/acl.c
@@ -82,7 +82,6 @@ static struct posix_acl *f2fs_acl_from_disk(const char *value, size_t size)
 		case ACL_GROUP_OBJ:
 		case ACL_MASK:
 		case ACL_OTHER:
-			acl->a_entries[i].e_id = ACL_UNDEFINED_ID;
 			entry = (struct f2fs_acl_entry *)((char *)entry +
 					sizeof(struct f2fs_acl_entry_short));
 			break;
-- 
1.7.5.4


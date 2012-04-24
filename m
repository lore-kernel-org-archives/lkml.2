Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab2DXLxj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 07:53:39 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:56080 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab2DXLxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 07:53:38 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Arnaud Lacombe <lacombar@gmail.com>, linux-kbuild@vger.kernel.org
References: <m1aa22rllb.fsf@fess.ebiederm.org> <4F96705C.5030901@suse.cz>
Date: Tue, 24 Apr 2012 04:57:39 -0700
In-Reply-To: <4F96705C.5030901@suse.cz> (Michal Marek's message of "Tue, 24
	Apr 2012 11:20:28 +0200")
Message-ID: <m1aa21nxzg.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/7pxRGe98Bx2kOq6wgln+C1J0qwojAmts=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0002]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 SUBJ_OBFU_PUNCT_FEW Possible punctuation-obfuscated Subject: header
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Michal Marek <mmarek@suse.cz>
X-Spam-Relay-Country: 
Subject: [PATCH] kbuild: Add error handling to KCONFIG_ALL_CONFIG
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


- Only try to read the file specified if KCONFIG_ALL_CONFIG is set to
  something other than the empty string.

- Don't use stat to check the name passed to conf_read_simple so that
  zconf_fopen can find the file in the current directory or in SRCTREE
  removing a extremely confusing failure mode, where KCONFIG_ALL_CONFIG
  was not interpreted with respect to the directory make was called in.

- If conf_read_simple fails complain clearly and stop processing.
  Allowing the simple discovery and debugging of command line typos.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 scripts/kconfig/conf.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index 28910ea..af6a2db 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -579,8 +579,13 @@ int main(int ac, char **av)
 	case alldefconfig:
 	case randconfig:
 		name = getenv("KCONFIG_ALLCONFIG");
-		if (name && !stat(name, &tmpstat)) {
-			conf_read_simple(name, S_DEF_USER);
+		if (name && name[0] != '\0') {
+			if (conf_read_simple(name, S_DEF_USER)) {
+				fprintf(stderr,
+					_("*** Can't read seed configuration \"%s\"!\n"),
+					name);
+				exit(1);
+			}
 			break;
 		}
 		switch (input_mode) {
-- 
1.7.2.5


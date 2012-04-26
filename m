Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab2DZIrc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 04:47:32 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:60118 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006Ab2DZIr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 04:47:29 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Arnaud Lacombe <lacombar@gmail.com>, linux-kbuild@vger.kernel.org
References: <m1aa22rllb.fsf@fess.ebiederm.org> <4F96705C.5030901@suse.cz>
	<m1aa21nxzg.fsf_-_@fess.ebiederm.org>
	<20120424123305.GA30068@sepie.suse.cz>
	<m1k415mgrv.fsf@fess.ebiederm.org> <4F96AC7F.6080603@suse.cz>
Date: Thu, 26 Apr 2012 01:51:32 -0700
In-Reply-To: <4F96AC7F.6080603@suse.cz> (Michal Marek's message of "Tue, 24
	Apr 2012 15:37:03 +0200")
Message-ID: <m1wr52dgff.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18XPXNQ+2nIJ8nm6eBRnobmC7pcDXM21MM=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0052]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
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
  something other than the empty string or "1".

- Don't use stat to check the name passed to conf_read_simple so that
  zconf_fopen can find the file in the current directory or in SRCTREE
  removing a extremely source of confusing failure, where KCONFIG_ALL_CONFIG
  was not interpreted with respect to the directory make was called in.

- If conf_read_simple fails complain clearly and stop processing.
  Allowing the simple debugging of typos.

- Clearly document the behavior so it is clear to users which
  values are treated as flags and which values are treated as
  filenames.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 Documentation/kbuild/kconfig.txt |   18 +++++++++---------
 scripts/kconfig/conf.c           |   20 ++++++++++++++------
 2 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/Documentation/kbuild/kconfig.txt b/Documentation/kbuild/kconfig.txt
index 9d5f2a9..a09f1a6 100644
--- a/Documentation/kbuild/kconfig.txt
+++ b/Documentation/kbuild/kconfig.txt
@@ -53,15 +53,15 @@ KCONFIG_ALLCONFIG
 --------------------------------------------------
 (partially based on lkml email from/by Rob Landley, re: miniconfig)
 --------------------------------------------------
-The allyesconfig/allmodconfig/allnoconfig/randconfig variants can
-also use the environment variable KCONFIG_ALLCONFIG as a flag or a
-filename that contains config symbols that the user requires to be
-set to a specific value.  If KCONFIG_ALLCONFIG is used without a
-filename, "make *config" checks for a file named
-"all{yes/mod/no/def/random}.config" (corresponding to the *config command
-that was used) for symbol values that are to be forced.  If this file
-is not found, it checks for a file named "all.config" to contain forced
-values.
+The allyesconfig/allmodconfig/allnoconfig/randconfig variants can also
+use the environment variable KCONFIG_ALLCONFIG as a flag or a filename
+that contains config symbols that the user requires to be set to a
+specific value.  If KCONFIG_ALLCONFIG is used without a filename where
+KCONFIG_ALLCONFIG == "" or KCONFIG_ALLCONFIG == "1", "make *config"
+checks for a file named "all{yes/mod/no/def/random}.config"
+(corresponding to the *config command that was used) for symbol values
+that are to be forced.  If this file is not found, it checks for a
+file named "all.config" to contain forced values.
 
 This enables you to create "miniature" config (miniconfig) or custom
 config files containing just the config symbols that you are interested
diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index f208f90..0fdda91 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -574,8 +574,13 @@ int main(int ac, char **av)
 	case alldefconfig:
 	case randconfig:
 		name = getenv("KCONFIG_ALLCONFIG");
-		if (name && !stat(name, &tmpstat)) {
-			conf_read_simple(name, S_DEF_USER);
+		if (name && (strcmp(name, "") != 0) && (strcmp(name, "1") != 0)) {
+			if (conf_read_simple(name, S_DEF_USER)) {
+				fprintf(stderr,
+					_("*** Can't read seed configuration \"%s\"!\n"),
+					name);
+				exit(1);
+			}
 			break;
 		}
 		switch (input_mode) {
@@ -586,10 +591,13 @@ int main(int ac, char **av)
 		case randconfig:	name = "allrandom.config"; break;
 		default: break;
 		}
-		if (!stat(name, &tmpstat))
-			conf_read_simple(name, S_DEF_USER);
-		else if (!stat("all.config", &tmpstat))
-			conf_read_simple("all.config", S_DEF_USER);
+		if (conf_read_simple(name, S_DEF_USER) &&
+		    conf_read_simple("all.config", S_DEF_USER)) {
+			fprintf(stderr,
+				_("*** KCONFIG_ALLCONFIG set, but no \"%s\" or \"all.config\" file found\n"),
+				name);
+			exit(1);
+		}
 		break;
 	default:
 		break;
-- 
1.7.2.5


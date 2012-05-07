Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604Ab2EGMdf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 08:33:35 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:43771 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756268Ab2EGMdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 08:33:33 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Michal Marek <mmarek@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
References: <20120507170319.03aa2fe980a39669c393a956@canb.auug.org.au>
Date: Mon, 07 May 2012 05:37:45 -0700
In-Reply-To: <20120507170319.03aa2fe980a39669c393a956@canb.auug.org.au>
	(Stephen Rothwell's message of "Mon, 7 May 2012 17:03:19 +1000")
Message-ID: <m11umwjheu.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19U4RvqI1rYgOfosifXvDYoLcpHEkitQTY=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.1 XMSubLong Long Subject
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
	*  0.0 SUBJ_OBFU_PUNCT_FEW Possible punctuation-obfuscated Subject: header
	*  0.3 SUBJ_OBFU_PUNCT_MANY Punctuation-obfuscated Subject: header
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Michal Marek <mmarek@suse.cz>
X-Spam-Relay-Country: **
Subject: [PATCH] kbuild: all{no,yes,mod,def,rand}config only read files when instructed to.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Prevent subtle surprises to both people working on the kconfig code
and people using make allnoconfig allyesconfig allmoconfig and
randconfig by only attempting to read a config file if
KCONFIG_ALLCONFIG is set.

Common sense suggests attempting to read the extra config files does
not make sense unless requested.  The documentation says the code
won't attempt to read the extra config files unless requested.
Current usage does not appear to include people depending on the code
reading the config files without the variable being set So do the
simple thing and stop reading config files when passed
all{no,yes,mod,def,rand}config unless KCONFIG_ALLCONFIG environment
variable is set.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 scripts/kconfig/conf.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index 0fdda91..0dc4a2c 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -574,7 +574,9 @@ int main(int ac, char **av)
 	case alldefconfig:
 	case randconfig:
 		name = getenv("KCONFIG_ALLCONFIG");
-		if (name && (strcmp(name, "") != 0) && (strcmp(name, "1") != 0)) {
+		if (!name)
+			break;
+		if ((strcmp(name, "") != 0) && (strcmp(name, "1") != 0)) {
 			if (conf_read_simple(name, S_DEF_USER)) {
 				fprintf(stderr,
 					_("*** Can't read seed configuration \"%s\"!\n"),
-- 
1.7.2.5


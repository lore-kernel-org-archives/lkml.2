Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942Ab2JZEZc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 00:25:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27343 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab2JZEZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 00:25:31 -0400
X-Authority-Analysis: v=2.0 cv=YP4dOG6x c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=6EHwltjqrmcA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=9SJgPcLngHIA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=JMh8EZCU8l2f5zGLIEYA:9 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1351225529.8467.51.camel@gandalf.local.home>
Subject: [GIT PULL][PATCH] ktest: Fix ktest confusion with
 CONFIG_MODULES_USE_ELF_RELA
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 26 Oct 2012 00:25:29 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull the latest ktest-v3.7-rc2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-ktest.git
ktest-v3.7-rc2

Head SHA1: 0979976ee53697f4308578c56abedb9766fea231


Steven Rostedt (1):
      ktest: Fix ktest confusion with CONFIG_MODULES_USE_ELF_RELA

----
 tools/testing/ktest/ktest.pl |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)
---------------------------
commit 8bc5e4ea3ea0e24142db2dc941233eab2a223ed4
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Fri Oct 26 00:10:32 2012 -0400

    ktest: Fix ktest confusion with CONFIG_MODULES_USE_ELF_RELA
    
    In order to decide if ktest should bother installing modules on the
    target box, it checks if the config file has CONFIG_MODULES=y. But it
    also checks if the '=y' part exists. It only will install modules if the
    config exists and is set with '=y'. But as the regex that was used
    tests:
    
      /^CONFIG_MODULES(=y)?/
    
    this will also match:
    
      CONFIG_MODULES_USE_ELF_RELA
    
    as the '=y' part was optional and it did not test the rest of the line.
    When this happens, ktest will stop checking the rest of the configs but
    it will also think that no modules are needed to be installed. What it
    should do is only jump out of the loop if it actually found a
    CONFIG_MODULES that is set to true.
    
    Otherwise, ktest wont install the necessary modules needed for proper
    booting of the test target.
    
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index b51d787..c7ba761 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1740,8 +1740,10 @@ sub install {
     open(IN, "$output_config") or dodie("Can't read config file");
     while (<IN>) {
 	if (/CONFIG_MODULES(=y)?/) {
-	    $install_mods = 1 if (defined($1));
-	    last;
+	    if (defined($1)) {
+		$install_mods = 1;
+		last;
+	    }
 	}
     }
     close(IN);



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759413Ab2AGDPz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 22:15:55 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:59296 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759048Ab2AGDPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 22:15:53 -0500
X-Authority-Analysis: v=2.0 cv=Pb19d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=V1_viwL_ZtQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=VwQbUJbxAAAA:8 a=zAyngx5bAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=oahLyXdTmXPj0hkWdv4A:9 a=PUjeQqilurYA:10 a=A71SCvCayfUA:10 a=9g6PTisfegMA:10 a=MSl-tDqOz04A:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1325906151.7642.20.camel@gandalf.stny.rr.com>
Subject: [PATCH][GIT PULL] recordmcount: Fix handling of elf64 big-endian
 objects
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, David Daney <david.daney@cavium.com>,
        stable <stable@kernel.org>
Date: Fri, 06 Jan 2012 22:15:51 -0500
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/urgent

Head SHA1: 2e885057b7f75035f0b85e02f737891482815a81


David Daney (1):
      recordmcount: Fix handling of elf64 big-endian objects

----
 scripts/recordmcount.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
---------------------------
commit 2e885057b7f75035f0b85e02f737891482815a81
Author: David Daney <david.daney@cavium.com>
Date:   Mon Dec 19 17:42:42 2011 -0800

    recordmcount: Fix handling of elf64 big-endian objects.
    
    In ELF64, the sh_flags field is 64-bits wide.  recordmcount was
    erroneously treating it as a 32-bit wide field.  For little endian
    objects this works because the flags of interest (SHF_EXECINSTR)
    reside in the lower 32 bits of the word, and you get the same result
    with either a 32-bit or 64-bit read.  Big endian objects on the
    other hand do not work at all with this error.
    
    The fix:  Correctly treat sh_flags as 64-bits wide in elf64 objects.
    
    The symptom I observed was that my
    __start_mcount_loc..__stop_mcount_loc was empty even though ftrace
    function tracing was enabled.
    
    Link: http://lkml.kernel.org/r/1324345362-12230-1-git-send-email-ddaney.cavm@gmail.com
    
    Cc: stable@kernel.org # 3.0+
    Signed-off-by: David Daney <david.daney@cavium.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/scripts/recordmcount.h b/scripts/recordmcount.h
index f40a6af6..54e35c1 100644
--- a/scripts/recordmcount.h
+++ b/scripts/recordmcount.h
@@ -462,7 +462,7 @@ __has_rel_mcount(Elf_Shdr const *const relhdr,  /* is SHT_REL or SHT_RELA */
 		succeed_file();
 	}
 	if (w(txthdr->sh_type) != SHT_PROGBITS ||
-	    !(w(txthdr->sh_flags) & SHF_EXECINSTR))
+	    !(_w(txthdr->sh_flags) & SHF_EXECINSTR))
 		return NULL;
 	return txtname;
 }



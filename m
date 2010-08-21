Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751638Ab0HUVHP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 17:07:15 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41759 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab0HUVHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 17:07:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:content-transfer-encoding:user-agent;
        b=xNFVZwXBlGZ8WSFrr4Cn6yhaMs9p+aAOQaAS37Tjm6QnvKdqdUqpTi/YURWeNzA3eF
         N31T2Tp6Xyo9AcZb8w3p7JfuobBs3ZwqKc2jA89HQWorcLCc86jMxIWihZf4PghD/9l9
         kAWi2Z5CoJYSiPSqJKO5sOcoRf5DdGKU0TEOw=
Date: Sun, 22 Aug 2010 01:07:11 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: perf compilation fails on Ubuntu's gcc 4.3.3
Message-ID: <20100821210711.GE5746@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is what I got today trying to compile perf on my
Ubuntu system

 >    CC util/ui/util.o
 > cc1: warnings being treated as errors
 > util/ui/util.c: In function ‘ui__dialog_yesno’:
 > util/ui/util.c:108: error: not protecting function: no buffer at least 8 bytes long
 > make: *** [util/ui/util.o] Error 1

An ugly hack like

diff --git a/tools/perf/util/ui/util.c b/tools/perf/util/ui/util.c
index 9706d9d..4ef6a86 100644
--- a/tools/perf/util/ui/util.c
+++ b/tools/perf/util/ui/util.c
@@ -107,6 +107,7 @@ out_destroy_form:
 bool ui__dialog_yesno(const char *msg)
 {
        /* newtWinChoice should really be accepting const char pointers... */
-       char yes[] = "Yes", no[] = "No";
-       return newtWinChoice(NULL, yes, no, (char *)msg) == 1;
+       const char *yes = "Yes";
+       const char *no = "No";
+       return newtWinChoice(NULL, (char *)yes, (char *)no, (char *)msg) == 1;
 }

did trick for me. But the issue origin is

EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstack-protector

What is the best way to deal with it?

 | cyrill@lenovo perf $ gcc --version
 | gcc (Ubuntu 4.3.3-5ubuntu4) 4.3.3
 | Copyright (C) 2008 Free Software Foundation, Inc.
 | This is free software; see the source for copying conditions.  There is NO
 | warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

	-- Cyrill

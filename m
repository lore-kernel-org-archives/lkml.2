Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450Ab2BMJ7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 04:59:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48504 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333Ab2BMJ7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 04:59:19 -0500
Message-ID: <4F38DEF0.8010202@redhat.com>
Date: Mon, 13 Feb 2012 10:59:12 +0100
From: Harald Hoyer <harald@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
CC: initramfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roberto Sassu <roberto.sassu@polito.it>
Subject: Re: dracut: ordering of modules
References: <1328886121.2472.19.camel@falcor>
In-Reply-To: <1328886121.2472.19.camel@falcor>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 10.02.2012 16:01, schrieb Mimi Zohar:
> Hi Harald,
> 
> Originally, 98integrity/ima-policy-load.sh didn't start executing before
> 98selinux/selinux-loadpolicy.sh finished, but unfortunately it now does.
> 
> inst_hook pre-pivot 50 "$moddir/selinux-loadpolicy.sh"
> inst_hook pre-pivot 62 "$moddir/ima-policy-load.sh"
> 
> As the IMA policy could be dependent on LSM runtime info, this is a
> problem.
> 
> [   10.040574] type=1805 audit(1328865524.387:2): action="dont_measure" fsmagic="0x9fa0" res=0
> [   10.040663] type=1805 audit(1328865524.387:3): action="dont_appraise" fsmagic="0x9fa0" res=0
> [   10.040729] type=1805 audit(1328865524.387:4): action="dont_measure" fsmagic="0x62656572" res=0
> [   10.040792] type=1805 audit(1328865524.387:5): action="dont_appraise" fsmagic="0x62656572" res=0
> [   10.040857] type=1805 audit(1328865524.387:6): action="dont_measure" fsmagic="0x64626720" res=0
> [   10.040921] type=1805 audit(1328865524.387:7): action="dont_appraise" fsmagic="0x64626720" res=0
> [   10.040985] type=1805 audit(1328865524.387:8): action="dont_measure" fsmagic="0x01021994" res=0
> [   10.041047] type=1805 audit(1328865524.387:9): action="dont_appraise" fsmagic="0x01021994" res=0
> [   10.041113] type=1805 audit(1328865524.387:10): action="dont_measure" fsmagic="0x73636673" res=0
> [   10.041177] type=1805 audit(1328865524.387:11): action="dont_appraise" fsmagic="0x73636673" res=0
> [   11.898956] SELinux:  Completing initialization.
> 
> I've tried adding a depend for selinux, but it doesn't seem to resolve
> the problem, nor does delaying 98integrity to later.  Any suggestions
> would be appreciated.
> 
> thanks,
> 
> Mimi
> 

In Fedora the selinux dracut module is disabled by default. You have to enable
it manually.

echo 'add_dracutmodules+=" selinux "' >> /etc/dracut.conf.d/99-my.conf

although, this also should do the thing:

$ git diff modules.d/98integrity/module-setup.sh
diff --git a/modules.d/98integrity/module-setup.sh
b/modules.d/98integrity/module-setup.sh
index 7d5771c..ff1b4aa 100755
--- a/modules.d/98integrity/module-setup.sh
+++ b/modules.d/98integrity/module-setup.sh
@@ -7,7 +7,7 @@ check() {
 }

 depends() {
-    echo masterkey securityfs
+    echo masterkey securityfs selinux
     return 0
 }






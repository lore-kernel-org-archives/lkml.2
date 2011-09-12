Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913Ab1ILXP7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 19:15:59 -0400
Received: from claw.goop.org ([74.207.240.146]:34487 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755668Ab1ILXP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 19:15:58 -0400
Message-ID: <4E6E92AB.5050504@goop.org>
Date: Mon, 12 Sep 2011 16:15:55 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Avi Kivity <avi@redhat.com>
Subject: [GIT PULL] Little bugfix to prevent recursion with tracing timestamps
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Hi Linus,

When starting a PV kernel under Xen with full boot-time trace testing
enabled, it crashes due to infinite recursion.  In principle it could
happen at other times too (when just using preempt tracing perhaps?). 
This fixes it.

BTW, I think this same problem also affects KVM.

Erm, I'm not sure how to authenticate this github as being really from
me; I'm signing the mail with my long-standing pgp key in the hope that
it helps...  Also, the patch is self-evident.

Thanks,
    J

The following changes since commit b6fd41e29dea9c6753b1843a77e50433e6123bcb:

  Linux 3.1-rc6 (2011-09-12 14:02:02 -0700)

are available in the git repository at:
  git://github.com/jsgf/linux-xen.git upstream/bugfix

Jeremy Fitzhardinge (1):
      xen: use non-tracing preempt in xen_clocksource_read()

 arch/x86/xen/time.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 5158c50..163b467 100644
- --- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -168,9 +168,10 @@ cycle_t xen_clocksource_read(void)
         struct pvclock_vcpu_time_info *src;
     cycle_t ret;
 
- -    src = &get_cpu_var(xen_vcpu)->time;
+    preempt_disable_notrace();
+    src = &__get_cpu_var(xen_vcpu)->time;
     ret = pvclock_clocksource_read(src);
- -    put_cpu_var(xen_vcpu);
+    preempt_enable_notrace();
     return ret;
 }
 
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEkBAEBCAAGBQJObpKlAAoJEAUkni6MUg7HKoYIPjZxR2owmacxLomFAY+3wc0d
qgRorBOqTrfs5gF/JmW/I77UnJyqPymhPHn9Mbd5fuxjTLLVmS8UfZvRcz6Rjejy
oePhizOqWfEtB8wg1BsOtQ+YxsWIPwphkotedfOwcYczq8CwRKO09EuqA/YsxOcr
C20XES5weBck+5KDWNBkprzuPUzo3zZbqFlBEWSTYk9mbQ2ZcEPDxKEUJqzcuQ81
2ue3iCv5XU8jupWrf8W+os1Js1ivgsq4ntH7F7hOv4KShtj7AB9xL5/6oUEwKG59
wTFyZ5Smz3DFfe3tTDBUb06qy/aTj1Lqig/KcR966EhHkjNnloMwn/FGowwkQzT8
JJcReYgXAQ==
=5H3T
-----END PGP SIGNATURE-----


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216Ab0J0QY3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 12:24:29 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:41064 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753135Ab0J0QY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 12:24:26 -0400
Content-Type: multipart/mixed; boundary="========GMX226591288196662947996"
Date: Wed, 27 Oct 2010 18:24:22 +0200
From: "Alexander Stohr" <Alexander.Stohr@gmx.de>
Message-ID: <20101027162422.226590@gmx.net>
MIME-Version: 1.0
Subject: [patch] fix for module building without "." in PATH
To: linux-kernel@vger.kernel.org
X-Authenticated: #15156664
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1/hIRF+wqzhsQ018G2DExih0JJveL+88vLdqNZTsj
 4thW/Km/dOSty1+OQk9w0wglMeDeE7wkHlQQ== 
X-GMX-UID: DmDxebgVeWUoV9AklHVzlmcxU3U4Nw+g
X-FuHaFi: 0.69999999999999996
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--========GMX226591288196662947996
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Hello,

when trying to build a kernel module remotely from the main sources
i run into a problem in a setup where the local directory was not part
of the path variable in the calling shell. this lead to the situation
that tools like fixdep worked fine whilst modpost steadily did not run
in a very silent fashion even if execv returned -1 (seen with strace).

i had two not that similar processor and linux systems to my hands
where one just ran fine for the given build duty and the other was
not at all capable of doing the job. the faulty had GNU make 3.81 on it.

the things went stranger the more i tried to reproduce the problem.
in a makefile sandbox a relative path like test/tool worked always nice
whilst in the kbuild environment scripts/mod/modpost always silently failed.

my next best answer to the subject was this:
-> completing the tool path using an absolute path prefix

asking which is the right path drove me to the insight
that it could be either the objtree or srctree that is desired.
my decision was a short shell invocation that determines
if the existing objtree does offer that build tool
and if not a fallback to the srctree is performed.

i think that best reflects the normal use case
where the object tree contains target build specific programs and data
whilst its a good idea to share all shareable tools via the srctree.

see the attached patch - its only one "-" and two "+" lines big.

it might be systematically helpful e.g. for distributions that are
building several different sets of binaries from the very same source
and its probably nice to have for smaller sized embedded platforms.

regards, Alex.


appendix

what else can that case teach us?

there are many more tools i have not adressed as they did not choke.
as this single case showed dot-less and dotted relative paths might
not always work in cases where PATH is missing the dot in its listing.

current state of root problem tracking and understanding:

i did not catch the reasons why those relative path without a leading dot
was inoperable in my setup for that changed makefile - the chain of
makefiles leading up to the failure seemed a bit lengthy so i simply
abstained from digging into more details. at least i was not able to
track down any sort of switches in make or the set of shells had to
my hand (bash, busybox) impacting on relative paths with/without dots.

guesswork:

maybe it has something to do with platform specific "empty path" variables (explicitely beeing a posix platform "feature") or make's path handling.

-- 
Neu: GMX De-Mail - Einfach wie E-Mail, sicher wie ein Brief!  
Jetzt De-Mail-Adresse reservieren: http://portal.gmx.net/de/go/demail

--========GMX226591288196662947996
Content-Type: text/x-patch;
 charset="iso-8859-15";
 name="linux-next-20101027-abspath-modpost.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename="linux-next-20101027-abspath-modpost.patch"

diff -Nru orig/scripts/Makefile.modpost new/scripts/Makefile.modpost
--- orig/scripts/Makefile.modpost	2010-10-27 16:41:01.000000000 +0200
+++ new/scripts/Makefile.modpost	2010-10-27 17:23:22.000000000 +0200
@@ -72,7 +72,8 @@
 
 # Step 2), invoke modpost
 #  Includes step 3,4
-modpost = scripts/mod/modpost                    \
+tooltree = $(shell if [ -e $(objtree)/scripts/mod/modpost ]; then echo $(objtree); else echo $(srctree); fi)
+modpost = $(tooltree)/scripts/mod/modpost        \
  $(if $(CONFIG_MODVERSIONS),-m)                  \
  $(if $(CONFIG_MODULE_SRCVERSION_ALL),-a,)       \
  $(if $(KBUILD_EXTMOD),-i,-o) $(kernelsymfile)   \

--========GMX226591288196662947996--

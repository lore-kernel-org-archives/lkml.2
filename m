Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934863Ab1ETIW5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 04:22:57 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61982 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934688Ab1ETIWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 04:22:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=Qimp69jeytcWAVcGMnq/KSjcURQFvnEj/NUwV7Ut+s7/4gRTSrPMrP0QDWq3VGxoBD
         e3PqR0fYq1l2dO299xfTkRBIKbCYik0A5E6ewCOXf+bU+my9l0RAOQfgGkvzvAG/dc74
         ZYAfxDcCidLIpt295AkG7GPXaEq2HWJj5KUR8=
MIME-Version: 1.0
Date: Fri, 20 May 2011 11:22:54 +0300
Message-ID: <BANLkTi=G4PdT8v35VD9AkH0Vgj_YuOfxaw@mail.gmail.com>
Subject: Re: [PATCH v4 2/6] x86-64: Remove unnecessary barrier in vread_tsc
From: Janne Blomqvist <blomqvist.janne@gmail.com>
To: luto@mit.edu, hpa@zytor.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

for some further micro-optimization of clock_gettime(), one could
consider using "rdtscp" instead of "mfence;rdtsc" on AMD platforms.
With the patch at the bottom of the mail to linux-clock-tests.git
(Andy: feel free to commit it to the upstream repo) I get on an
Opteron 2435 (6-core, 2.6 GHz):

$ ./timing_test 100 mfence_rdtsc CLOCK_MONOTONIC
100000000 loops in 3.96236s = 39.62 nsec / loop

$ ./timing_test 100 rdtscp CLOCK_MONOTONIC
100000000 loops in 2.87859s = 28.79 nsec / loop

(best of 5 runs for each test)

For comparison, on a Xeon X3450 (Nehalem 2.67 GHz) I get:

$ ./timing_test 100 lfence_rdtsc CLOCK_MONOTONIC
100000000 loops in 0.95337s = 9.53 nsec / loop

$ ./timing_test 100 rdtscp CLOCK_MONOTONIC
100000000 loops in 1.02148s = 10.21 nsec / loop

(same as above, best of 5 runs for each test)

So on Intel "lfence;rdtsc" seems slightly faster than "rdtscp".


diff --git a/timing_test.cc b/timing_test.cc
index 136a731..3a40d41 100644
--- a/timing_test.cc
+++ b/timing_test.cc
@@ -33,8 +33,12 @@ int main(int argc, char **argv)
                printf("\nClocks are:\n");
                describe_clock("CLOCK_REALTIME", CLOCK_REALTIME);
                describe_clock("CLOCK_MONOTONIC", CLOCK_MONOTONIC);
+#ifdef CLOCK_REALTIME_COARSE
                describe_clock("CLOCK_REALTIME_COARSE", CLOCK_REALTIME_COARSE);
+#endif
+#ifdef CLOCK_MONOTONIC_COARSE
                describe_clock("CLOCK_MONOTONIC_COARSE",
CLOCK_MONOTONIC_COARSE);
+#endif
                return 1;
        }

@@ -73,6 +77,11 @@ int main(int argc, char **argv)
                        asm volatile ("");
                        asm volatile ("lfence;rdtsc;lfence" : "=a"
(a), "=d" (d));
                }
+       } else if (!strcmp(mode, "mfence_rdtsc")) {
+               for (size_t i = 0; i < loops; ++i) {
+                       unsigned int a, d;
+                       asm volatile ("mfence;rdtsc" : "=a" (a), "=d" (d));
+               }
        } else if (!strcmp(mode, "mfence_rdtsc_mfence")) {
                for (size_t i = 0; i < loops; ++i) {
                        unsigned int a, d;


-- 
Janne Blomqvist

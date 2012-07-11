Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903Ab2GKPxH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 11:53:07 -0400
Received: from plainfield.sei.cmu.edu ([192.58.107.45]:50343 "EHLO
	plainfield.sei.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932734Ab2GKPxF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 11:53:05 -0400
X-Greylist: delayed 773 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Jul 2012 11:53:04 EDT
From: "Jonathan M. Foote" <jmfoote@cert.org>
To: Denys Vlasenko <vda.linux@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. J. Lu" <hjl.tools@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>
CC: Oleg Nesterov <oleg@redhat.com>, Denys Vlasenko <dvlasenk@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>
Date: Wed, 11 Jul 2012 11:40:01 -0400
Subject: RE: [PATCH] Extend core dump note section to contain file names of
 mapped files
Thread-Topic: [PATCH] Extend core dump note section to contain file names of
 mapped files
Thread-Index: Ac1fUP/3xyoRDZUtR6WYCGC79yCAswAKeFlQ
Message-ID: <A32A045574615B4FAB96C4952BA5768BB8FABF1289@EXCHANGE.sei.cmu.edu>
References: <CAK1hOcNWo2mV2nKmVEuzKzEs7pCveFCBFWrYSrMbj4Y7M8zQ6Q@mail.gmail.com>
In-Reply-To: <CAK1hOcNWo2mV2nKmVEuzKzEs7pCveFCBFWrYSrMbj4Y7M8zQ6Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

For what it's worth several security teams that use the CERT Triage Tools have requested a feature (post-mortem analysis of core files) that will be supported by this functionality. This feature in the CERT Triage Tools would be more complete if siginfo was included in the core files as well, but this is a good start.

Jon

-----Original Message-----
From: Denys Vlasenko [mailto:vda.linux@gmail.com] 
Sent: Wednesday, July 11, 2012 6:36 AM
To: linux-kernel@vger.kernel.org; Jonathan M. Foote; H. J. Lu; Ingo Molnar; H. Peter Anvin; Andi Kleen
Cc: Oleg Nesterov; Denys Vlasenko; Jan Kratochvil
Subject: [PATCH] Extend core dump note section to contain file names of mapped files

Hi,

Resending the patch after a while.
Jonathan, developer of CERT Triage Tools, expressed the need to have this information, CCing him.

But before looking at the attached patch, we need a ruling.

In the last review it was proposed to maybe generate this information in the form of ASCII text, a-la /proc/PID/maps.

This actually is a good idea, but regretfully, it come a few decades too late, the rest of core file auxiliary information is traditionally encoded in binary structures.

Please, can someone with authority in this area decide whether we want to be unorthodox and use ASCII encoding for the whole thing, or not?

If the decision will be to use ASCII, I will need to rework the patch.

Otherwise, please take a look at attached patch which implements creation of a new note in binary format and let me know what do you think of it.

Original patch and description follows

* * * * * * * * * * * * * * * * * * * *

While working with core dump analysis, it struck me how much PITA is caused merely by the fact that names of loaded binary and libraries are not known.

gdb retrieves loaded library names by examining dynamic loader's data stored in the core dump's data segments. It uses intimate knowledge how and where dynamic loader keeps the list of loaded libraries. (Meaning that it will break if non-standard loader is used).

And, as Jan explained to me, it depends on knowing where the linked list of libraries starts, which requires knowing binary which was running. IIRC there is no easy and reasonably foolproof way to determine binary's name. (Looking at argv[0] on stack is not reasonably foolproof).

Which is *ridiculous*. We *know* the list of mapped files at core dump generation time.

I propose to save this information in core dump, as a new note in note segment.

This note has the following format:

long count     // how many files are mapped
long page_size // units for file_ofs
array of [COUNT] elements of
   long start
   long end
   long file_ofs
followed by COUNT filenames in ASCII: "FILE1" NUL "FILE2" NUL...
The attached patch implements this.

Since list of mapped files can be large (/proc/`pidof firefox`/maps on my machine right now is 38k), I allocate the space for note via vmalloc, and also have a sanity limit of 4 megabytes.
(Maybe we should make it smaller?)
Oleg suggested using a linked list of smaller structures instead of using a potentially large contiguous block, and I tried it, but resulting code was significantly more ugly (for my taste).

The patch is run-tested.

For testing, I sent ABRT signal to a running /usr/bin/md5sum.

"readelf -aW core" shows the new note as:

Notes at offset 0x00000274 with length 0x00000990:
 Owner                 Data size       Description
 CORE                 0x00000090       NT_PRSTATUS (prstatus structure)
 CORE                 0x0000007c       NT_PRPSINFO (prpsinfo structure)
 CORE                 0x000000a0       NT_AUXV (auxiliary vector)
 CORE                 0x00000168       Unknown note type: (0x46494c45)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^new note^^^^^^^^^^ In hex format:
                                               05 00 00 00  |................|
00000460  68 01 00 00 45 4c 49 46  46 49 4c 45 00 00 00 00  |h...ELIFCORE....|
00000470  0b 00 00 00 00 10 00 00  00 80 17 00 00 f0 31 00  |..............1.|
00000480  00 00 00 00 00 f0 31 00  00 00 32 00 a7 01 00 00  |......1...2.....|
00000490  00 00 32 00 00 20 32 00  a7 01 00 00 00 20 32 00  |..2.. 2...... 2.|
000004a0  00 30 32 00 a9 01 00 00  00 50 69 00 00 60 6b 00  |.02......Pi..`k.|
000004b0  00 00 00 00 00 60 6b 00  00 70 6b 00 20 00 00 00  |.....`k..pk. ...|
000004c0  00 70 6b 00 00 80 6b 00  21 00 00 00 00 80 04 08  |.pk...k.!.......|
000004d0  00 00 05 08 00 00 00 00  00 00 05 08 00 10 05 08  |................|
000004e0  07 00 00 00 00 10 05 08  00 20 05 08 08 00 00 00  |......... ......|
000004f0  00 20 52 b7 00 20 72 b7  00 00 00 00 2f 6c 69 62  |. R.. r...../lib|
00000500  2f 6c 69 62 63 2d 32 2e  31 34 2e 39 30 2e 73 6f  |/libc-2.14.90.so|
00000510  00 2f 6c 69 62 2f 6c 69  62 63 2d 32 2e 31 34 2e  |./lib/libc-2.14.|
00000520  39 30 2e 73 6f 00 2f 6c  69 62 2f 6c 69 62 63 2d  |90.so./lib/libc-|
00000530  32 2e 31 34 2e 39 30 2e  73 6f 00 2f 6c 69 62 2f  |2.14.90.so./lib/|
00000540  6c 69 62 63 2d 32 2e 31  34 2e 39 30 2e 73 6f 00  |libc-2.14.90.so.|
00000550  2f 6c 69 62 2f 6c 64 2d  32 2e 31 34 2e 39 30 2e  |/lib/ld-2.14.90.|
00000560  73 6f 00 2f 6c 69 62 2f  6c 64 2d 32 2e 31 34 2e  |so./lib/ld-2.14.|
00000570  39 30 2e 73 6f 00 2f 6c  69 62 2f 6c 64 2d 32 2e  |90.so./lib/ld-2.|
00000580  31 34 2e 39 30 2e 73 6f  00 2f 75 73 72 2f 62 69  |14.90.so./usr/bi|
00000590  6e 2f 6d 64 35 73 75 6d  00 2f 75 73 72 2f 62 69  |n/md5sum./usr/bi|
000005a0  6e 2f 6d 64 35 73 75 6d  00 2f 75 73 72 2f 62 69  |n/md5sum./usr/bi|
000005b0  6e 2f 6d 64 35 73 75 6d  00 2f 75 73 72 2f 6c 69  |n/md5sum./usr/li|
000005c0  62 2f 6c 6f 63 61 6c 65  2f 6c 6f 63 61 6c 65 2d  |b/locale/locale-|
000005d0  61 72 63 68 69 76 65 00                           |archive.

--
vda

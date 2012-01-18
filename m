Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255Ab2ARBhD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 20:37:03 -0500
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:56760
	"EHLO AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754422Ab2ARBhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 20:37:01 -0500
X-SpamScore: -6
X-BigFish: PS-6(zz1432Nzz1202hzzz2fhc1ahc1bh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:207.46.4.139;KIP:(null);UIP:(null);IPV:NLI;H:SN2PRD0602HT004.namprd06.prod.outlook.com;RD:none;EFVD:NLI
Message-ID: <4F16221F.6060304@ixiacom.com>
Date: Tue, 17 Jan 2012 17:36:31 -0800
From: Earl Chew <echew@ixiacom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Advice for 32 bit compatibility problem with pread(2) on x86_64
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [216.23.154.50]
X-MS-Exchange-CrossPremises-AuthSource: SN2PRD0602HT004.namprd06.prod.outlook.com
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 06
X-MS-Exchange-CrossPremises-Processed-By-Journaling: Journal Agent
X-OrganizationHeadersPreserved: SN2PRD0602HT004.namprd06.prod.outlook.com
X-OriginatorOrg: ixiacom.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pread(2) in 32 bit mode (x86_64) seems to leave the file in a crummy state
causing the next pread(2) to fail.

I'd like a hint as to where to look for the root cause.

I'm running:

	Linux ixbu-lnxbld-vm 2.6.32-33-generic #72-Ubuntu SMP Fri Jul 29 21:07:13 UTC 2011 x86_64 GNU/Linux

Here is the test program (use syscall() to try give glibc an alibi):

> #include <fcntl.h>
> #include <sys/syscall.h>
> 
> 
> int main()
> {
>     char buf[8192];
>     int fd = open("/proc/self/maps", O_RDONLY);
> 
>     syscall(SYS_pread64, fd, buf, 8192, 0, 0);
>     syscall(SYS_pread64, fd, buf, 8192, 0, 0);
> 
>     return 0;
> }

Compiling with -m32 and running with strace(), the 2nd pread() return zero !

> open("/proc/self/maps", O_RDONLY)       = 3
> pread64(3, "08048000-08049000 r-xp 00000000 "..., 8192, 0) = 1189
> pread64(3, "", 8192, 0)                 = 0

Compiling for 64 bit I get the expected:

> open("/proc/self/maps", O_RDONLY)       = 3
> pread(3, "00400000-00401000 r-xp 00000000 "..., 8192, 0) = 1332
> pread(3, "00400000-00401000 r-xp 00000000 "..., 8192, 0) = 1332

Huh ?

Earl



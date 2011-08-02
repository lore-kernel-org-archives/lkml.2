Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab1HBQaB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 12:30:01 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:59222 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557Ab1HBQ34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 12:29:56 -0400
Message-ID: <4E382602.6050308@grupopie.com>
Date: Tue, 02 Aug 2011 17:29:54 +0100
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, "'Ben Dooks'" <ben-linux@fluff.org>
Subject: Re: Question about "Inconsistent kallsyms data"
References: <02ae01cc4d91$aed71670$0c854350$%kim@samsung.com> <20110729100241.GB25640@n2100.arm.linux.org.uk> <2563791.8cBqodrk1o@flatron> <1514384.7oMe1aulyC@flatron>
In-Reply-To: <1514384.7oMe1aulyC@flatron>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz Figa wrote:
> On Friday 29 of July 2011 at 12:58:32, Tomasz Figa wrote:
>>[...]
>> I will try to bisect the case with s3c6400 defconfig.
> 
> I have no idea why, but I cannot reproduce the issue anymore, even after make 
> distclean or starting with a clean tree. A build system bug?
> 
> I do not know much technical details about the kernel build system, but might 
> it be a concurrency issue (I use make -j5 for building with 5 jobs)?

Usually this is caused by symbols moving slightly between kernel compiles.

This is an explanation of the process I wrote a while ago in a different
thread at LKML:

> Now as for CONFIG_KALLSYMS_EXTRA_PASS: to build the kallsyms table, the
> build process first links a kernel image with an empty kallsyms table
> and use that to fetch information for all the symbols.
> 
> It then uses that information to build the table with the right size,
> and links it again. If everything goes ok, this new version as all the
> symbols in the correct places and the final table can be built with the
> correct addresses.
> 
> The final linking should produce the same result as only the data on the
> kallsyms table changed, but not its size.
> 
> However, there have been bugs in the past with section alignments and
> symbol reordering for symbols with the same address, etc., etc. that
> make this final table not have the exact same size, and the build fails
> with an inconsistent kallsyms data message. At this point, the user can
> turn on the CONFIG_KALLSYMS_EXTRA_PASS and temporarily solve the problem
> while the developers find the correct fix. Without this option, in this
> situation the kernel would simply fail the compilation.
> 
> All this has been stable for a while and this option hasn't been needed
> recently (AFAIK), but if there is some bug in some new binutils or
> something, the option might be needed again.

To check inconsistencies, the Makefile compares ".tmp_System.map" and
"System.map" for differences.

On a normal build they should be identical, but if this fails with
"Inconsistent kallsyms data" you could try comparing the two files to
check which symbols are causing trouble.

-- 
Paulo Marques - www.grupopie.com

"All generalizations are false."

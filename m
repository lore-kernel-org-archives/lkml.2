Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758752Ab1EMKWK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 06:22:10 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:39831
	"EHLO CH1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758027Ab1EMKWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 06:22:07 -0400
X-SpamScore: -13
X-BigFish: VPS-13(zz1433M1432N98dKzz1202hzzz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LL4Q4L-02-B01-02
X-M-MSG: 
Date: Fri, 13 May 2011 12:21:54 +0200
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: Chuck Ebbert <cebbert@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Boris Ostrovsky <ostr@amd64.org>,
        "Petkov, Borislav" <Borislav.Petkov@amd.com>
Subject: Re: [PATCH] cpu, AMD: Fix another bug in the new errata checking code
Message-ID: <20110513102154.GB9270@escobedo.osrc.amd.com>
References: <20110512195938.1728ab52@katamari>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110512195938.1728ab52@katamari>
Organization: Advanced Micro Devices GmbH, Einsteinring 24, 85609 Dornach b.
 Muenchen; Geschaeftsfuehrer: Andrew Bowd, Alberto Bozzo; Sitz: Dornach,
 Gemeinde Aschheim, Landkreis Muenchen; Registergericht Muenchen, HRB Nr.
 43632
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 07:59:38PM -0400, Chuck Ebbert wrote:
> Fix a bug that causes CPU hangs due to missing timer interrupts,
> introduced by these three patches:
> 
> (1) commit d78d671db478eb8b14c78501c0cee1cc7baf6967
>     "x86, cpu: AMD errata checking framework"
> 
> (2) commit 9d8888c2a214aece2494a49e699a097c2ba9498b
>     "x86, cpu: Clean up AMD erratum 400 workaround"
> 
> (3) commit b87cf80af3ba4b4c008b4face3c68d604e1715c6
>     "x86, AMD: Set ARAT feature on AMD processors"
> 
> Patch (1) introduced a new framework that allowed checking for errata
> using AMD's OSVW (OS visible workaround) feature combined with
> explicit lists of models. It checked OSVW first, and completely
> relied on that if it was present and usable.

Thats how it is specified to work.

> Patch (2) switched the checking for erratum 400 to use the new
> framework. But the original code checked for an explicit model range
> first, then used OSVW if the CPU was not within that range. Patch (2)
> also inexplicably added a second model range (for Family 10h) that
> was never in the original code.

The original code checked just for family 0x10, and thats what the new
code does: define a model range that covers all of family 0x10.
 
> Then patch (3) used the new erratum 400 checks to decide whether
> to enable the ARAT feature (always running APIC timer.) However,
> this causes notebooks using the Sempron processor (Family 10h
> Model 6 Stepping 2) to enable ARAT when they shouldn't because the
> explicit check for that model gets skipped.
> 
> The fix is to check the model list first, then use OSVW if the CPU
> is not in that list.

No, that is wrong. The whole point of OSVW is to check it first. The
model ranges are only to be used for older systems that either don't
have OSVW or don't know about a particular erratum yet.

The revision guide states that family 0x10 model 6 stepping 2 has E400.
So I would expect that OSVW length is >= 2 and that OSVW status has bit
1 set, or that OSVW length is < 2. This indicates that the workaround is
necessary, without any need to check the family-model-stepping ranges.

It would also be correct if the BIOS disabled C1E and cleared the
corresponding OSVW status bit. Anything else would probably be a very
nasty BIOS bug.

Could you send me the contents of MSRs 0xc0010140, 0xc0010141 and
0xc0010055?


Hans


-- 
%SYSTEM-F-ANARCHISM, The operating system has been overthrown


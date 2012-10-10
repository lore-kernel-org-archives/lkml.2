Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab2JJLIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 07:08:11 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:55680 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab2JJLID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 07:08:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: [Xen-devel] [PATCH 5/9] ARM: Xen: fix initial build problems:
Date: Wed, 10 Oct 2012 11:07:40 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1349796183-30648-1-git-send-email-arnd@arndb.de> <201210091819.34310.arnd@arndb.de> <1349862394.10070.23.camel@zakaz.uk.xensource.com>
In-Reply-To: <1349862394.10070.23.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201210101107.40898.arnd@arndb.de>
X-Provags-ID: V02:K0:aaiV5dVQme201i7ln3ZS3TKPHIZFk2TY4DQ7q5W6pMg
 tex9gueECDJL0or+GmpLToK6q8vSlf46K9XWZ4GEhNegs1eXFB
 offodrAEcv1iGNbLWChNzaCjtvls/pW3lfcCr8xwOzSiS4WE6g
 XYahKidD6XQeKBDzRI/Qaq+9jeobKXNCpglcC8dVS5Zo78QMlN
 MqK2ClDSmUdj8DV2ZJSVRaWmYKVQxuHWHyHoAhSV+09bf+unWZ
 /TvMhLpVsKf1Yeu1m2CRpl1knooJdJwvJeo0j6alV1HT8TE+tb
 2e11Ap0QZ6v2/Dh4tCdPYGVG9BZV712Wd19b2jCkautIEbkKOl
 nA2HhLb9fv+gnG01oDFk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 October 2012, Ian Campbell wrote:
> > * implement your own cmpxchg wrapper that may be implemented using a spinlock
> >   rather than cmpxchg if ARMv6 is enabled.
> 
> Even if ARMv6 is enabled the grant table code will never be running on
> one so so it might be ok to just have our own wrapper which
> unconditionally uses the v7 instruction? That might upset gas though.

Yes, that would be possible. You can tell gas to ignore the instruction
set in this case. If you do this, you can implement the update functions
more efficiently using direct ldrexh/strexh in assembler to avoid doing
two nested loops. I assume that you don't need the v1 grant table
code on ARM anyway, so the only code you need to look at is

        while (!((flags = *pflags) & GTF_transfer_committed)) {
                if (sync_cmpxchg(pflags, flags, 0) == flags)
                        return 0;
                cpu_relax();
        }

which should transform nicely into a few lines of inline assembly.

	Arnd

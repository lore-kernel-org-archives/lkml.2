Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab0IUGh6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 02:37:58 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:48197
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752251Ab0IUGh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 02:37:56 -0400
X-SpamScore: -15
X-BigFish: VPS-15(zz1432Nzz1202hzz8275bh15d4Rz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L933QL-02-H7N-02
X-M-MSG: 
Date: Tue, 21 Sep 2010 08:37:40 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Huang Ying <ying.huang@intel.com>
CC: "Richter, Robert" <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Doug Thompson <norsk5@yahoo.com>,
        edac-devel <linux-edac@vger.kernel.org>
Subject: Re: [RFC 3/6] x86, NMI, Rename memory parity error to PCI SERR
 error
Message-ID: <20100921063740.GA14394@aftab>
References: <1284087065-32722-3-git-send-email-ying.huang@intel.com>
 <20100913010248.GH21909@erda.amd.com>
 <1284343326.3269.70.camel@yhuang-dev.sh.intel.com>
 <20100916081806.GV13563@erda.amd.com>
 <1284682105.32373.11.camel@yhuang-dev>
 <20100917091454.GL13563@erda.amd.com>
 <1284855635.32373.298.camel@yhuang-dev>
 <20100920080010.GM13563@erda.amd.com>
 <20100920125929.GA5349@kryptos.osrc.amd.com>
 <1285028548.21059.43.camel@yhuang-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1285028548.21059.43.camel@yhuang-dev>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Ying <ying.huang@intel.com>
Date: Mon, Sep 20, 2010 at 08:22:28PM -0400

(Forgot to add edac-devel to Cc)

> > What is more, there are a bunch of edac drivers using the PCI SERR nmi
> > as a means to check for PCI errors so we shouldn't be removing it now,
> > should we?
> 
> After checking the source, I found in mem_parity_error (will renamed to
> pci_serr_error), edac_atomic_assert_error() is called, which increase
> edac_err_assert, edac_err_assert is used in
> edac_mc_assert_error_check_and_clear(), which is used in
> edac_mc_workq_function for memory error only, not for PCI errors.

Yes, I suppose the edac part in the mem_parity_error() was originally
meant for memory parity errors. Now, I understand your incentive of
changing that to handle PCI SERR errors but by axing the edac part,
you're practically disabling the mci->edac_check() call for edac
drivers using NMIs for error reporting (I don't know how many do that,
btw...) and almost every edac driver defines that function pointer to a
driver-specific error checking function.

So if there are no more IBM PC-AT machines running Linux out, I
think we can rip out the whole code around edac_err_assert and thus
remove the edac_mc_assert_error_check_and_clear() part from the
edac_mc_workq_function() which would make all edac drivers solely poll
for mem errors.

What do the others think, Doug?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632


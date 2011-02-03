Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239Ab1BCP7z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 10:59:55 -0500
Received: from ud10.udmedia.de ([194.117.254.50]:35769 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab1BCP7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 10:59:54 -0500
Date: Thu, 3 Feb 2011 16:59:52 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Borislav Petkov <bp@amd64.org>
Cc: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        Doug Thompson <dougthompson@xmission.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [EDAC-AMD64] Display correct RAM sizes in ganged mode on F10 CPUs
Message-ID: <20110203155951.GA1594@gentoo.trippels.de>
References: <20110129211531.GA1874@gentoo.trippels.de>
 <20110201185114.GD8418@aftab>
 <20110201192752.GA1589@gentoo.trippels.de>
 <20110203151721.GD24755@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110203151721.GD24755@aftab>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.02.03 at 16:17 +0100, Borislav Petkov wrote:
> On Tue, Feb 01, 2011 at 02:27:52PM -0500, Markus Trippelsdorf wrote:
> > On 2011.02.01 at 19:51 +0100, Borislav Petkov wrote:
> > > On Sat, Jan 29, 2011 at 04:15:31PM -0500, Markus Trippelsdorf wrote:
> > > > The EDAC_AMD64 module displays only half the actual memory size, when
> > > > RAM is running in ganged mode on F10 CPUs. Fix this by moving the the
> > > > conversion factor check out of the if block, where it is never reached.
> > > >
> > > > With this patch:
> > > >
> > > > Unganged:
> > > >  amd64: DRAM ECC enabled.
> > > >  EDAC amd64: F10h detected (node 0).
> > > >  EDAC amd64: using x4 syndromes.
> > > >  EDAC MC: DCT0 chip selects:
> > > >  kernel: EDAC amd64: MC: 0:  1024MB 1:  1024MB
> > > >  kernel: EDAC amd64: MC: 2:  1024MB 3:  1024MB
> > > >  kernel: EDAC amd64: MC: 4:     0MB 5:     0MB
> > > >  kernel: EDAC amd64: MC: 6:     0MB 7:     0MB
> > > >  kernel: EDAC MC: DCT1 chip selects:
> > > >  kernel: EDAC amd64: MC: 0:  1024MB 1:  1024MB
> > > >  kernel: EDAC amd64: MC: 2:  1024MB 3:  1024MB
> > > >  kernel: EDAC amd64: MC: 4:     0MB 5:     0MB
> > > >  kernel: EDAC amd64: MC: 6:     0MB 7:     0MB
> > > >  kernel: EDAC amd64: MCT channel count: 2
> 
> Ok, you've found a bug but it has to be fixed differently. See, the
> above reporting scheme actually doesn't change based on whether we're
> ganged or not. In your case, for example, you have 4 2GB dual-ranked
> DIMMs and they should always be shown as above, DCT0 has 2 DIMMs, with
> chip selects 0 and 1 (aka ranks) being DIMM0 and chip selects 2 and 3
> being DIMM2. You have the same config on the other channel, i.e. DCT1.
> 
> Now, when we're running ganged, you still have the same physical
> configuration with the only difference that we read from the two DCTs in
> parallel. Thus, we want to print the above structure independent from
> the ganged setting.
> 
> Here's a fix, it should correct the reporting on your machine.

Hm, that doesn't work:

EDAC amd64: F10h detected (node 0).
EDAC MC: DCT0 chip selects:
EDAC amd64: MC: 0:  1024MB 1:  1024MB
EDAC amd64: MC: 2:  1024MB 3:  1024MB
EDAC amd64: MC: 4:     0MB 5:     0MB
EDAC amd64: MC: 6:     0MB 7:     0MB
EDAC MC: DCT1 chip selects:
EDAC amd64: MC: 0:     0MB 1:     0MB
EDAC amd64: MC: 2:     0MB 3:     0MB
EDAC amd64: MC: 4:     0MB 5:     0MB
EDAC amd64: MC: 6:     0MB 7:     0MB
EDAC amd64: using x4 syndromes.

-- 
Markus

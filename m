Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab2DWQAF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 12:00:05 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:39123 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab2DWQAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 12:00:03 -0400
Date: Mon, 23 Apr 2012 17:59:57 +0200
From: Borislav Petkov <bp@amd64.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: "Liu, Jinsong" <jinsong.liu@intel.com>, tony.luck@intel.com,
        x86@kernel.org, linux-edac@vger.kernel.org,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Xen-devel] [PATCH 1/3] Add mcelog support for xen platform
Message-ID: <20120423155957.GA6147@aftab.osrc.amd.com>
References: <DE8DF0795D48FD4CA783C40EC8292335154EFC@SHSMSX101.ccr.corp.intel.com>
 <20120421041454.GA29704@phenom.dumpdata.com>
 <20120421104502.GB17005@aftab.osrc.amd.com>
 <20120423021827.GA13840@phenom.dumpdata.com>
 <20120423060921.GA29378@aftab.osrc.amd.com>
 <20120423150657.GA24481@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120423150657.GA24481@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 11:06:57AM -0400, Konrad Rzeszutek Wilk wrote:
> > > This driver is not that much different from the APEI bridge to MCE code -
> > > it just that instead of reading APEI blob data it reads it from an hypercall.
> > 
> > Let me ask you this: is APEI a virtualization solution of some sort?
> > 
> > No, it is the old windoze RAS crap but I guess Linux has to support it
> > now too through BIOS. And x86 vendors will have to support it too.
> > 
> > So it is piece of the firmware we'd have to deal with too.
> > 
> > Now xen is a whole another deal - it is purely a piece of software.
> 
> Perfect. Software is more elastic than hardware - so the Xen ABI
> for the MCE can be changed then to reflect the new format if required.

And this "elastic" piece of software is yet another thing I have to deal
with when working on MCE which is strictly doing _hardware_ support. And
I don't want to do that - if you hook in the mce_log() interface, you're
practically becoming yet another user of it which I have to account for
when doing changes to the core MCE code.

[..]

> Delegate testing to sub-maintainers. In this case that would be me and
> Liu.

Ok, just purely hypothetically, what happens if there's no one to update
this code anymore? What if Oracle or Citrix or whoever it is, is not
interested in maintaining xen anymore, or those drivers or whatever?
I'm stuck with users of this which I can't shake off because there's no
upstream development. Oh, and then there's the distros which already
have their installs and they'd never update their setup because it works
and why touch it... and so on and so on...

[..]

> > The problem is xen growing stuff everywhere in arch/x86/ and this way,
> > maybe even unwillingly, crippling development of hardware-related
> > features. I know you're willing to help and I know you mean it well, but
> > there's always some other problem in practice.
> 
> I am not sure I see why we cannot fix the practical problems as they pop
> up?

See above.

[..]

> > hook into arch/x86/ instead of doing your own stuff?
> 
> I think what you are suggesting is to _not_ reuse existing APIs. That
> seems counter-intuive to general software development. There are
> exceptions of course - when the existing API needs to change a lot
> (or needs to be thrown out), and there is this one little driver that
> keeps on using the old interface and can't change - at that point I can
> see the purpose of forking it. But until then - using existing APIs is
> the way to go.

I just love it when guys left and right start teaching me about stuff,
it's like I even begged for it...

You're not reusing the existing API because mce_log is not an API to
anything - it is an internal x86 MCE logging thing to put a struct mce
into a static ring buffer.

The API is /dev/mcelog and there you should interface, not hook into
internal stuff and cripple it from developing any further.

[snip more senseless drivel]

> > Now, with your own buffer solution, nothing breaks and all is happy,
> > a win-win, if you wish. I think this is much simpler and easier a
> > solution.
> 
> Not sure what you mean by 'own buffer solution'. Are you talking about
> using the trace_mce_record or the ras_printk instead of the mce_log?
> I would think that is the job of the MCE decoders?

No, I mean to copy the mce_log() code along with the functions that
create the char device /dev/mcelog - mce_chrdev_*.

Btw, you'd probably be done with it if you'd taken the time to do that
instead of arguing your cause.

> Please keep in mind that this driver is not trying to decode anything -

I know that.

> it just lifting raw events, massaging them a bit, and sending them
> downstream. Similar to how the APEI does it.

Please stop talking about APEI - I told you why it doesn't apply here in
a previous mail.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

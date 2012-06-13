Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab2FMOBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 10:01:21 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:47075 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753849Ab2FMOBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 10:01:18 -0400
X-Sasl-enc: 7a1mY5NYxTzU+72mYin24wQhBGu0r9Cm+r7o7q4wHaIR 1339596077
Date: Wed, 13 Jun 2012 11:01:14 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@amd64.org>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, mingo@elte.hu, ming.m.lin@intel.com,
        "Yu, Fenghua" <fenghua.yu@intel.com>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on
 SandyBridge
Message-ID: <20120613140114.GD26012@khazad-dum.debian.net>
References: <20120607071531.GA4849@quad>
 <4FD78BE6.4060207@zytor.com>
 <20120612190720.GA11137@aftab.osrc.amd.com>
 <1339529614.31548.104.camel@twins>
 <20120612194900.GC11137@aftab.osrc.amd.com>
 <4FD7A687.3040500@zytor.com>
 <20120612203730.GE11137@aftab.osrc.amd.com>
 <4FD7A99F.8030007@zytor.com>
 <1339591173.8980.23.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339591173.8980.23.camel@twins>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jun 2012, Peter Zijlstra wrote:
> On Tue, 2012-06-12 at 13:42 -0700, H. Peter Anvin wrote:
> > And yes, I would prefer a single sysfs file,
> > or better yet a plain old device node. 
> 
> So how about we rip out all this sysfs crap and go back to
> MICROCODE_OLD_INTERFACE ? Afaict that's relatively sane.

Please teach it to handle partial writes kernel side, so that we can just
use "cat" in userspace instead of special tools (or nasty hacks using 'dd'),
then.  And it would be a bit annoying for userspace to figure out whether it
wants Intel or AMD or <whatever vendor> microcode...

IMHO, if we fix the firmware interface to the microcode core, it can do a
lot better than MICROCODE_OLD_INTERFACE, and it can integrate very well with
userspace.

"Fixing" the microcode firmware interface (i.e. making it optimal from
userspace's PoV) is not a complex endeavour:

1. Add the per-system sysfs node, and drop the per-core nodes for
firmware updates.  I understand this _will_ be done anyway because the
current status-quo is dangerous.

2. Add a cache layer, so that microcode files are fetched only once per
file per update cycle, no matter how many cores [optional, but quite
welcome as it speeds up the boot]

3. Change the Intel firmware naming convention to a constant name,
instead of the variable naming scheme currently used.  This can be done
in a backwards compatible way, by attempting to load the variable named
firmware file if the first attempt fails.

4. Declare proper MODULE_FIRMWARE() and auto-load information.

With all that, all we'd have to do in the distros would be to ship binary
processor microcode the very same way we already deal with firmware for
everything else.


BTW, I've uploaded to Debian a tool that can actually manipulate the Intel
microcode container well enough to help Debian do some release
management[1], and helps the user have tailored, per-system reduced
microcode files.   The code is probably crap as far as LKML standards for C
code go, but if there's general interest, I can make the upstream git tree
public in gitorious or something.  Full source currently available in the
".orig.tar.bz2" file of the Debian source package:

http://packages.qa.debian.org/i/iucode-tool.html
http://cdn.debian.net/debian/pool/contrib/i/iucode-tool/
http://cdn.debian.net/debian/pool/contrib/i/iucode-tool/iucode-tool_0.8.orig.tar.bz2

[1] Maybe Intel could actually consider making it easier to the general
Linux distro and Linux admin/power user, and provide a proper chagelog along
with its microcode dumps?  AMD does it, and it *really* helps...  A timeline
of the microcodes shipped by Intel paints an EXTREMELY confusing picture.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

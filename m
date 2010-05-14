Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268Ab0ENIW0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 04:22:26 -0400
Received: from smtp.nokia.com ([192.100.105.134]:48053 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758233Ab0ENIWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 04:22:22 -0400
Date: Fri, 14 May 2010 11:24:03 +0300
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: ext Andrew Morton <akpm@linux-foundation.org>
Cc: "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       Linux-OMAP <linux-omap@vger.kernel.org>,
       Russell King <linux@arm.linux.org.uk>,
       ext Tony Lindgren <tony@atomide.com>,
       ext Kevin Hilman <khilman@deeprootsystems.com>,
       "De-Schrijver Peter (Nokia-D/Helsinki)" 
	<Peter.De-Schrijver@nokia.com>,
       "santosh.shilimkar@ti.com" <santosh.shilimkar@ti.com>,
       Ambresh <a0393775@ti.com>,
       "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>,
       "Hogander Jouni (Nokia-D/Tampere)" <jouni.hogander@nokia.com>,
       Paul Mundt <lethal@linux-sh.org>, ext Nishanth Menon <nm@ti.com>
Subject: Re: [PATCHv5 0/3] Introduce the /proc/socinfo and use it to export
 OMAP data
Message-ID: <20100514082403.GA4329@besouro.research.nokia.com>
Reply-To: eduardo.valentin@nokia.com
References: <1273587331-24604-1-git-send-email-eduardo.valentin@nokia.com>
 <20100512152424.803ea807.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100512152424.803ea807.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 14 May 2010 08:19:37.0831 (UTC) FILETIME=[318CBF70:01CAF33E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrew,

On Thu, May 13, 2010 at 12:24:24AM +0200, Andrew Morton wrote:
> On Tue, 11 May 2010 17:15:28 +0300
> Eduardo Valentin <eduardo.valentin@nokia.com> wrote:
> 
> > Here is the version 5 of the change to export OMAP data to userspace
> > (name, revision, id code, production id and die id).
> > 
> > Basically, this version is still attempting to create a new file under /proc.
> > It is the /proc/socinfo, which should be used to export bits which are SoC specific
> > (not CPU related, nor machine related).
> > 
> > So, differences between previous version are:
> > - merged patch 02/04 with 03/04 to avoid compilation breakages.
> > - simplified the seq_file usage by using the single_open and single_release functions
> > - exported a function to register a seq_operation .show callback
> > - adapted the changes accordingly
> > 
> > As usual, comments are welcome.
> 
> This changelog would be rather more useful if it was to show us some
> sample output from /proc/socinfo, perhaps accompanied with an
> explanation for people who aren't familar with this area of the kernel.

Indeed. So, after applying this series, one example of output would be,
in case of OMAP3:

/ # cat /proc/socinfo
SoC     : OMAP3430 ES3.1
IDCODE  : 4b7ae02f
Pr. ID  : 00000000 00000000 000000cc cafeb7ae

These ids can be used, for instance, to track down silicon specific issues.

> 
> I'd have thought that sysfs was an appropriate place for this info. 
> Perhaps under /sys/devices/platform?  Or /sys/devices/system?  Peter's
> original patch didn't tell us where in the hierarchy the file was
> placed, nor why it was placed there, not what its contents look like. 
> But crappy changelogs are the norm :(

IIRC, originally, Peter's patch was creating /sys/power/idcode. The content
was very similar:


Nokia-N900:~# cat /sys/power/idcode 
IDCODE: 4b7ae02f
Production ID: 00000000 00000000 000000cc cafeb7ae
Die ID: 05018019 04033312 00000000 54500024


> 
> The objections stated in this email:
> http://www.mail-archive.com/linux-omap@vger.kernel.org/msg17630.html
> appear to still apply to this version of the patches?

Yeah, it is not applied on all IDs actually. At some point, the complain has changed.
More recently, Tony complained about Die ID:
http://marc.info/?l=linux-omap&m=127230649306842&w=2

And that's what is in patch 03/03 of this series. So, there are two things:
1. A separated config option to have DIE ID code in
2. User also have to explicitly pass the omap3_die_id kernel parameter.
Just like the "serialnumber" parameter for x86's.

Once the user has a kernel with CONFIG_OMAP3_EXPORT_DIE_ID and boots it with omap3_die_id parameter,
the first output I posted above would also include die id:

/ # cat /proc/socinfo 
SoC     : OMAP3430 ES3.1
IDCODE  : 4b7ae02f
Pr. ID  : 00000000 00000000 000000cc cafeb7ae
Die ID	: 05018019 04033312 00000000 54500024


> 
> Kevin didn't explain why he said "Please export these via debugfs". 
> Tony didn't clearly explain why he said "I don't think we want to
> export unique chip identifiers by default".
> 
> 
> 
> So apart from having certain opinions regarding communication skills
> and wondering why people cc me on stuff without vaguely providing
> enough info for me to understand what they're thinking, I don't know
> what to make of it all :(

Yeah, I agree here that there are some piece of info missing here and there.
Anyways, I believe the main point here is what is the best place to export these bits.

Originally was under sysfs (maybe not the correct place: /sys/power/idcode). Then I suggested
to move it to /proc/cpuinfo, which has been denied because these bits do not belong to CPU.
Then, it has been suggested to be under /proc/socinfo, which is the current version.
Now, I think your suggestion is to move back to sysfs, but under sys/devices/platform or /sys/devices/system, right ?



Thanks for your comments,

--
Eduardo Valentin

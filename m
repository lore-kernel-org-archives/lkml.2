Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990Ab0EQSW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 14:22:27 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:52347 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759Ab0EQSWZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 14:22:25 -0400
Date: Mon, 17 May 2010 11:21:51 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Will Drewry <wad@chromium.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, agk@redhat.com,
       snitzer@redhat.com
Subject: Re: [RFC PATCH v2 2/2] init: boot to device-mapper targets without
 an  initr*
Message-Id: <20100517112151.b1a56a4f.randy.dunlap@oracle.com>
In-Reply-To: <AANLkTimRJAOO6frxyr3M-cL8UCxYZfU4FN1TBJn3sd4c@mail.gmail.com>
References: <20100514035347.GA20636@redhat.com>
	<1273887701-2152-2-git-send-email-wad@chromium.org>
	<20100517094724.48632380.randy.dunlap@oracle.com>
	<AANLkTimRJAOO6frxyr3M-cL8UCxYZfU4FN1TBJn3sd4c@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090202.4BF18957.014A:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 May 2010 13:13:48 -0500 Will Drewry wrote:

> On Mon, May 17, 2010 at 11:47 AM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > On Fri, 14 May 2010 20:41:41 -0500 Will Drewry wrote:
> >
> >> Add a dm= kernel parameter modeled after the md= parameter from
> >> do_mounts_md.  It allows for device-mapper targets to be configured at
> >> boot time for use early in the boot process (as the root device or
> >> otherwise).
> >
> > dm=<blah>
> > documentation needs to be added to Documentation/kernel-parameters.txt and/or
> > Documentation/md.txt.
> 
> Absolutely -- I've appended a proposed version below which I'll include in the
> next round.  I'm not a lkml veteran, so if it makes sense to resend
> the full patchset
> again with it, I can.  Otherwise, I'll wait for comments on the code too.

OK, thanks for the doc update.  One typo noted below.


> >> The format is dm="name uuid ro,table line 1,table line 2,...".  The
> >> parser expects the comma to be safe to use as a newline substitute but,
> >> otherwise, uses the normal separator of space.  Some attempt has been
> >> made to make it forgiving of additional spaces (using skip_spaces()).
> >
> > This "space in the arg string" has been tested, right?
> 
> Works for me so far.  I've tested this on a user mode linux instance and
> a real x86 machine with the dm-linear target and a custom dm target
> (which I'll be
> mailing to dm-devel@ for feedback later this week).
> 
> > It seems a bit odd to me.  Most kernel parameter strings that I am familiar with
> > use punctuation for separating parameter parts.
> 
> Yup - I agree. My first cut I used commas with an empty ,, delimiter as a new
> line.  Then I ran across this in the source:
> 
> kernel/params.c
> 76 /* You can use " around spaces, but can't escape ". */
> 77 /* Hyphens and underscores equivalent in parameter names. */
> 78 static char *next_arg(char *args, char **param, char **val)
> 
> I will need to cross-check all the known dm targets to make sure that
> they don't expect quoted internal strings.  In my first look, I didn't see any.
> 
> However, I'm perfectly content with either approach so if there's a preference,
> I'll rework it to make it happen.  This approach just maps more cleanly to the
> existing experience of configuring a mapped device.
> 
> thanks!
> will
> 
> 
> documentation: dm= parameter documentation
> 
> Add documentation for early mapped device creation without an initial rd.
> 
> Signed-off-by: Will Drewry <wad@chromium.org>
> ---
>  Documentation/device-mapper/boot.txt |   36 ++++++++++++++++++++++++++++++++++
>  Documentation/kernel-parameters.txt  |    4 +++
>  2 files changed, 40 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/device-mapper/boot.txt
> 
> diff --git a/Documentation/device-mapper/boot.txt
> b/Documentation/device-mapper/boot.txt
> new file mode 100644
> index 0000000..00fb557
> --- /dev/null
> +++ b/Documentation/device-mapper/boot.txt
> @@ -0,0 +1,36 @@
> +Boot time creation of mapped devices
> +===================================
> +
> +You can boot directly to a dm device using the following kernel command
> +line:
> +
> +dm="<name> <uuid> <ro>,table line 1,...,table line n"
> +
> +name = the name to associated with the device

                      associate

> +	 after boot, udev, if used, will use that name to label
> +	 the device node.
> +uuid = may be 'none' or the UUID desired for the device.
> +ro = may be 0 or 1.  If non-zero, the device and device table will be
> +	marked read-only.
> +
> +Each table line may be as normal when using the dmsetup tool except for
> +two variations:
> +1. Any use of commas will be interpreted as a newline
> +2. Quotation marks cannot be escaped and cannot be used without
> +   terminating the dm= argument.
> +
> +Unless renamed by udev, the device node created will be dm-0 as the
> +first minor number for the device-mapper is used during early creation.
> +
> +Example
> +=======
> +
> +- Booting to a linear array made up of user-mode linux block devices:
> +
> +  dm="lroot none 0, 0 4096 linear 98:16 0, 4096 4096 linear 98:32 0" \
> +  root=/dev/dm-0
> +
> +Will boot to a rw dm-linear target of 8192 sectors split across two
> +block devices identified by their major:minor numbers.  After boot, udev
> +will rename this target to /dev/mapper/lroot (depending on the rules).
> +No uuid was assigned.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

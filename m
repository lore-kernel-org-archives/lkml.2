Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909Ab2GRUHh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 16:07:37 -0400
Received: from longford.logfs.org ([213.229.74.203]:53934 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352Ab2GRUHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 16:07:33 -0400
Date: Wed, 18 Jul 2012 14:53:35 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>, Steve Hodgson <steve@purestorage.com>
Subject: Re: [PATCH] add blockconsole version 1.1
Message-ID: <20120718185335.GA1771@logfs.org>
References: <20120424205946.GH20610@logfs.org>
 <x49zka0j5bk.fsf@segfault.boston.devel.redhat.com>
 <20120425132513.GA23492@logfs.org>
 <x49vcknkdvn.fsf@segfault.boston.devel.redhat.com>
 <20120712174633.GA7248@logfs.org>
 <20120713130336.GC10298@x1.osrc.amd.com>
 <20120713162009.GA10268@logfs.org>
 <20120716124614.GA19497@x1.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120716124614.GA19497@x1.osrc.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 July 2012 14:46:15 +0200, Borislav Petkov wrote:
> On Fri, Jul 13, 2012 at 12:20:09PM -0400, Jörn Engel wrote:
> 
> > +CANDIDATES=`lsscsi |sed 's|.*/dev|/dev|'`
> 
> You probably want to check lsscsi presence on the system, wasn't
> installed by default on my debian testing image, for example. See diff
> at the end of this mail.

Ack.

> > +	echo "Usage: mkblockconsole <dev>"
> 
> 	echo "Usage: $0 <dev>"
> 
> in case the name of the script changes.

Ack.

> > +#define BLOCKCONSOLE_MAGIC_OLD	"\nLinux blockconsole version 1.0\n"
> 
> blockconsole is not yet upstream, you probably want to get rid of the
> _OLD handling completely?

Agreed.

> > +	struct kref kref;
> 
> Another build failure missing
> 
> #include <linux/kref.h>

Ack.

> With the include added, it builds fine. Then I took an usb stick and I
> did:
> 
> $ ./mkblockconsole /dev/sdc
> 
> <reboot>

You can also run hdparm -z <dev> instead.  Or replug the device.  Main
danger of hdparm is that running the command twice will cause two
instances of blockconsole to use the same device.  Not sure how to
solve that problem - or if.

> So why is that first megabyte full of zeros there?

It gives you some scratch space to store information in.  How useful
that actually is may be a matter of opinion.  But independent of that,
you will find large amounts of zeroes all over.  Every time you
reboot, the new blockconsole will start writing at a megabyte-aligned
offset and whatever remains of the last megabyte should be zero-filled
as well.  Vim treats this as a single line, which makes it only mildly
annoying to me.

> Other than that, it works like a charm and I like the idea that no
> kernel cmdline args are needed.
> 
> Also, you might want to add a step-by-step fast howto to the docs with
> concrete steps like the above so that people can try this out faster.

I will try to find a quiet moment for that.  If you happened to beat
me to it, you certainly won't hear any complaints.

> --
> diff --git a/Documentation/block/blockconsole/bcon_tail b/Documentation/block/blockconsole/bcon_tail
> index 950bfd1..e415b6f 100755
> --- a/Documentation/block/blockconsole/bcon_tail
> +++ b/Documentation/block/blockconsole/bcon_tail
> @@ -4,6 +4,12 @@ TAIL_LEN=16
>  TEMPLATE=/tmp/bcon_template
>  BUF=/tmp/bcon_buf
>  
> +if [ -z "$(which lsscsi)" ];
> +then
> +	echo "You need to install the lsscsi package on your distro."
> +	exit 1
> +fi
> +
>  end_of_log() {
>  	DEV=$1
>  	UUID=`head -c40 $DEV|tail -c8`
> diff --git a/Documentation/block/blockconsole/mkblockconsole b/Documentation/block/blockconsole/mkblockconsole
> index d9514e7..05c4ad8 100755
> --- a/Documentation/block/blockconsole/mkblockconsole
> +++ b/Documentation/block/blockconsole/mkblockconsole
> @@ -1,7 +1,7 @@
>  #!/bin/sh
>  
>  if [ ! $# -eq 1 ]; then
> -	echo "Usage: mkblockconsole <dev>"
> +	echo "Usage: $0 <dev>"
>  	exit 1
>  elif mount|fgrep -q $1; then
>  	echo Device appears to be mounted - aborting
> diff --git a/drivers/block/blockconsole.c b/drivers/block/blockconsole.c
> index d13203f..b4e995d 100644
> --- a/drivers/block/blockconsole.c
> +++ b/drivers/block/blockconsole.c
> @@ -9,6 +9,7 @@
>  #include <linux/slab.h>
>  #include <linux/string.h>
>  #include <linux/workqueue.h>
> +#include <linux/kref.h>
>  
>  #define BLOCKCONSOLE_MAGIC_OLD	"\nLinux blockconsole version 1.0\n"
>  #define BLOCKCONSOLE_MAGIC	"\nLinux blockconsole version 1.1\n"

Acked-by: Joern Engel <joern@logfs.org>

Thanks for the testing and the patch!  I will fold it in and resend
when I deal with the other two details.

Jörn

--
It does not matter how slowly you go, so long as you do not stop.
-- Confucius
